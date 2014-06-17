
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "ChatDetailViewController.h"
#import "ChatListViewController.h"
#import "CustomeAlertView.h"
#import "ChatGroupDetailViewController.h"
#import "WXWAsyncConnectorFacade.h"
#import "ChatDetailCell.h"
#import "ProjectAppDelegate.h"
#import "ProjectDBManager.h"
#import "ChatScrollViewController.h"
#import "HPGrowingTextView.h"
#import "MapViewController.h"
#import "SettingViewController.h"
#import "ChatAddGroupViewController.h"
#import "UserDetailViewController.h"

#define TAG_DELSUCCESSFUL         0xEE
#define TAG_DELFAILURE            0xEF
#define BOTTOM_BAR_HEIGHT         44
#define KEYBOARD_HEIGHT           216.0f
//默认时间间隔
#define DEFAULT_TIME_DIST         4 * 60

#define EXPRESSION_SCROLL_VIEW_TAG 102

typedef enum
{
    ICHAT_OTHER_TAG = 1,
    ICHAT_FACE_TAG,
} ExpressionType;

@interface ChatDetailViewController () <UITextFieldDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, HPGrowingTextViewDelegate, ECClickableElementDelegate, ChatMenuViewDelegate,MapViewDelegate> {
    
    UserBaseInfo *_userBaseInfo;
    UIView *_micView;
    UIImageView *_micStepImageView;
    NSTimer *_showStepMicTimer;//录音step
    NSTimer *_showStepPlayMicTimer;//播放step
    int _stepIndex;//录音stepIndex
    int _stepPlayIndex;//播放stepIndex
    
    enum CHAT_TYPE chatType;
    
    UIImageView *_bottomChatView;
    
    double _lastMessageTime;
    double _middleMessageTime;
    
    int _lastTextCellClicked;
    int _tabHeight;
    int _tabHeightTemp;
    
    BOOL keyboardIsShowing;
    CGFloat contentOffsetY;
    
    int _groupIsDeleted;
    
    NSInteger _sendingMessageCount;
    
    //voice使用
    int sendType;//发送类型，首次创建会话还是以前的会话
    BOOL isPlaying;
    BOOL isRecording;
    BOOL isOutside;
    int  recordState;
    UIButton *voiceBtn;
    BOOL isLoud;
    
    BOOL isChunk;
    //voice end
    
    BOOL isSavedToAlbum;
    
    UIScrollView *pageScroll;
    UIPageControl *pageCtrl;
   
    int attachType;
    
    BOOL _backType;
    
    int bottomeChatViewBaseY;
    int bottomeChatViewCurrentY;
    int bottomeChatViewCurrentH;
    
}

@property (nonatomic, retain) NSString *chatTitle;
@property (nonatomic, retain) ChatMenuView *chatMenuView;
@property (nonatomic, retain) HPGrowingTextView *chatContentTextView;

//voice使用
@property (nonatomic, assign) NSInteger curPlayVoiceRowIndex;
@property (nonatomic, retain) NSString *curPlayVoiceMsgId;
@property (nonatomic, retain) NSString *curRecordVoiceMsgId;
@property (nonatomic, retain) NSString *curRecordVoiceName;//当前录音文件名
@property (nonatomic, retain) UIImageView * curImg;
@property (nonatomic, retain) UIImageView * ivPopImg;
@property (nonatomic, retain) NSArray* imgArray;
@property (nonatomic, retain) NSTimer* recordTimer;
//voice end

@property (nonatomic, retain) NSString *sendPath;
@property (nonatomic, retain) NSString *curImageFile;

#pragma mark - 接收 [人或群组]
@property (nonatomic, retain) NSString *receiver;
@property (nonatomic, retain) NSArray *chatArray;

@property (nonatomic, retain) UIView *expressionView;

// Location
@property (nonatomic, retain) NSMutableDictionary *locationDic;

//聊天界面异常退出,设定一个标识,只有返回按钮是不再登陆
- (void)notifierNetworkStatus:(NSNotification*)notification;

@end

@implementation ChatDetailViewController {
    
    UIBarButtonItem *_rightButton;
    BOOL _isFromCreate;
    
    ChatGroupModel *_chatGroupData;
    
    int userCount;
    
    BOOL needReLoad;
}

@synthesize chatTitle;

- (id)initWithData:(NSString *)receiverId title:(NSString*)title MOC:(NSManagedObjectContext *)MOC backType:(BOOL)backType
{
    
    if (self = [self initWithData:receiverId title:title MOC:MOC]) {
        _backType = backType;
    }
    
    return self;
}

- (id)initWithData:(NSString *)receiverId title:(NSString*)title MOC:(NSManagedObjectContext *)MOC
{
    if ((self = [super initWithMOC:MOC needRefreshHeaderView:NO needRefreshFooterView:NO])) {
        
        _backType = NO;
        
        self.receiver = receiverId;
        if ([receiverId hasPrefix:@"g"]) {
            chatType = CHAT_TYPE_GROUP;
        } else {
            chatType = CHAT_TYPE_PRIVATE;
        }

        self.chatTitle = title;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getGroupInfo:self.receiver];
    
    if (_backType) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(pressedBackbut:)];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    _isFaceChoose = NO;
    
    [self initLisentingKeyboard];
    self.view.userInteractionEnabled = YES;
    [CommonMethod viewAddGuestureRecognizer:self.view withTarget:self withSEL:@selector(viewTapped:)];
    
    [self adjustTableView];
    
    [self initRightNavButton];
    
    [self initBottomChatView];
    
    [self initMicView];
    
    [self.view addSubview:[self setMenuView]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifierNetworkStatus:)
                                                 name:NOTIFY_NETWORK_STATUS
                                               object:nil];
    
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification"
                                               object:nil];
}

- (void)adjustTableView
{
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - BOTTOM_BAR_HEIGHT);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.userInteractionEnabled = YES;
    [CommonMethod viewAddGuestureRecognizer:self.tableView withTarget:self withSEL:@selector(chatDetailTapped:)];
}

- (void)addTapAction {
    
    UILongPressGestureRecognizer *pLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(goSettingVC)];
    pLongPress.minimumPressDuration = 2;
    pLongPress.numberOfTapsRequired = 4;
    [self.tableView addGestureRecognizer:pLongPress];
}

- (void)goSettingVC {

    SettingViewController *settingVC = [[[SettingViewController alloc] init] autorelease];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (needReLoad) {
        [self getGroupInfo:self.receiver];
        if (_chatGroupData && _chatGroupData.groupName.length > 0) {
            self.chatTitle = _chatGroupData.groupName;
        }
    }
    
    if (userCount > 1) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ (%d)", self.chatTitle, userCount];
    } else {
        self.navigationItem.title = [NSString stringWithFormat:@"%@", self.chatTitle];
    }
    
    //用于设置消息返回的代理
    [self.modelEngineVoip setModalEngineDelegate:self];
    [self.modelEngineVoip.imDBAccess updateUnreadStateOfSessionId:self.receiver];
    
    _lastMessageTime = 0;
    
    [self refreshChatMsgList];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [self stopRecMsg];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_rightButton release];
    
    [_micView release];
    [_micStepImageView release];
    [_chatContentTextView release];
    
    self.curImageFile = nil;
    self.curPlayVoiceMsgId = nil;
    self.curRecordVoiceMsgId = nil;
    self.curRecordVoiceName = nil;
    self.curImg = nil;
    
    [_bottomChatView release];
    
    [super dealloc];
}

- (void)initRightNavButton
{
    //---------------------------------
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.frame = CGRectMake(0, 0, 29.3f, 20);
    [rightButton addTarget: self action: @selector(rightNavButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    userCount = 0;
    if (_chatGroupData != nil) {
        userCount = [_chatGroupData.userCount intValue];
    } else {
        ProjectAppDelegate *delegate = (ProjectAppDelegate *)APP_DELEGATE;
        userCount = [delegate.modelEngineVoip.imDBAccess getGroupMemberCount:self.receiver];
    }
    
    if (userCount > 2) {
        [rightButton setBackgroundImage:[UIImage imageNamed:@"chatGroupTwo.png"] forState:UIControlStateNormal];
    } else {
        [rightButton setBackgroundImage:[UIImage imageNamed:@"chatGroupOne.png"] forState:UIControlStateNormal];
    }
    
    _rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [_rightButton setStyle:UIBarButtonItemStylePlain];
    self.navigationItem.rightBarButtonItem = _rightButton;
    
}

- (void)notifierNetworkStatus:(NSNotification *)notification {
    
    if (notification.userInfo != nil) {
        static NetworkConnectionStatus oldStatus = NetworkConnectionStatusOn;
        NetworkConnectionStatus status = [[notification.userInfo objectForKey:@"status"] integerValue];
        
        
        NSString *naviStr = [NSString stringWithFormat:@"%@ (%d)",self.chatTitle, userCount];
        switch (status) {
            case NetworkConnectionStatusOff:
                naviStr = @"未连接";
                break;
            case NetworkConnectionStatusLoading:
            case NetworkConnectionStatusDoing:
                naviStr = @"正在连接...";
                break;
            case NetworkConnectionStatusOn:
            case NetworkConnectionStatusDone:
                naviStr = [NSString stringWithFormat:@"%@ (%d)",self.chatTitle, userCount];
                break;
            default:
                break;
        }
        oldStatus = status;
        
        self.navigationItem.title = [NSString stringWithFormat:@"%@", naviStr];
    }
}

#pragma mark - add group button click
- (void)addGroupButtonClicked:(id)sender
{
    [self loadJoinChatGroup:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

#pragma mark - nav bar clicked
- (void)rightNavButtonClicked:(id)sender
{
   
    if (chatType == CHAT_TYPE_PRIVATE) {
        UserObject *userObject = [[ProjectDBManager instance] getUserInfoByVoipIdFromDB:self.receiver];
        UserDetailViewController *vc =
        [[[UserDetailViewController alloc] initWithMOC:_MOC userObject:userObject showBottom:YES] autorelease];
        
        [CommonMethod pushViewController:vc withAnimated:YES];
    } else if (chatType == CHAT_TYPE_GROUP) {
    
        ChatGroupDetailViewController *vc = [[[ChatGroupDetailViewController alloc] initWithMOC:_MOC parentVC:self.parentVC groupBindId:self.receiver] autorelease];
        
        [CommonMethod pushViewController:vc withAnimated:YES];
        
        needReLoad = YES;
    }
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        if (indexPath.row == self.chatArray.count) {
            return [self drawFooterCell];
        } else {
            int row = indexPath.row;
            
            IMMessageObj *msg = self.chatArray[row];
            NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier_%d", row];
            
            DLog(@"sendUser:%@", msg.sender);
            
            ChatDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                
                cell = [[[ChatDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   ccpVoipMsg:msg
                                              reuseIdentifier:CellIdentifier
                                       imageClickableDelegate:self
                                                          row:row
                                                     showTime:NO] autorelease];
                cell.backgroundColor = TRANSPARENT_COLOR;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (msg.msgtype == EMessageType_Voice) {
                    [cell setPlayedIcon];
                }
            }
            
            if (row == 0) {
                [cell drawChat:msg row:row showTime:YES];
            } else {
                [cell drawChat:msg row:row showTime:[self showMessageTime:msg dist:DEFAULT_TIME_DIST]];
            }
            
            if (isRecording && row == [self.chatArray count] - 1) {
                [cell updateTimer:msg];
            }
            
            return cell;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        
    }
}

- (BOOL)showMessageTime:(IMMessageObj *)message dist:(long)timeDist
{
    if (_middleMessageTime == 0)
        _middleMessageTime = [CommonMethod getChatTimeAutoMatchTimeInterval:message.dateCreated];
    
    double msgCreateDate = [CommonMethod getChatTimeAutoMatchTimeInterval:message.dateCreated];
    if (msgCreateDate - _lastMessageTime > timeDist  ) {
        _lastMessageTime = msgCreateDate;
        return YES;
    } else if (msgCreateDate < _middleMessageTime && _lastMessageTime - msgCreateDate > timeDist) {
        _lastMessageTime = msgCreateDate;
        return YES;
    }
    return NO;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self.chatArray count]) {
        return 60;
    }
    
    int row = indexPath.row;
    CGFloat height = [ChatDetailCell calculateHeightForMsg:self.chatArray[row]];
    return height+25;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.chatArray count]) {
        return;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)switchMode:(id)sender{
    
    if (_isTextMode) {
        _customToolbar.items = _voiceModeItems;
        ((UIBarButtonItem *)_customToolbar.items[0]).title = LocaleStringForKey(NSICchatTextMode, nil);
    } else {
        _customToolbar.items = _textModeItems;
        ((UIBarButtonItem *)_customToolbar.items[0]).title = LocaleStringForKey(NSICchatRecordMode, nil);
    }
    
    _isTextMode = !_isTextMode;
}

- (void)pictureBtnClicked:(id)sender {
    
    if (_groupIsDeleted) {
        [self showGroupIsDeleted];
    } else {
        NSLog(@"picture Btn Clicked:sender:%@", [AppManager instance].userId);
        
        UIActionSheet *sheet = [[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:LocaleStringForKey(NSCancelTitle, nil) destructiveButtonTitle:nil otherButtonTitles:LocaleStringForKey(NSTakePhotoTitle, nil), LocaleStringForKey(NSChooseExistingPhotoTitle, nil), nil] autorelease];
        sheet.tag = 1;
        [sheet showInView:self.view];
    }
}

- (void)manageFriendBtnClicked:(id)sender {
}

- (void)showPrivateDialogTo:(NSString *)userID {
}

- (void)back:(id)sender
{
    
    if (!_isFromCreate) {
        [self backToMainView];
    }else{
        [self backToListView];
    }
}

-(void)backToMainView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backToListView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - keyboard
- (void)initLisentingKeyboard
{
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideNotify:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    //    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //    if (version >= 5.0) {
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //    }
#endif
}

- (void)backToHomepage:(id)sender {
    [super backToHomepage:sender];
}

- (void)openProfile:(NSString*)userId userType:(NSString*)userType
{    
    UserObject *userObject = [[ProjectDBManager instance] getUserInfoByVoipIdFromDB:userId];
    UserDetailViewController *vc =
    [[[UserDetailViewController alloc] initWithMOC:_MOC userObject:userObject] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
    
    needReLoad = NO;
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {

//    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
        case -1:
        {
            _noNeedDisplayEmptyMsg = YES;
            [super connectDone:result
                           url:url
                   contentType:contentType];
            return;
        }
            
        case SUBMIT_JOING_CHAT_GROUP_TY:
        {
            NSInteger ret = [JSONParser parserResponseJsonData:result
                                                          type:contentType
                                                           MOC:_MOC
                                             connectorDelegate:self
                                                           url:url
                                                       paramID:0];
            
            if(ret == SUCCESS_CODE) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(@"您已申请加入该群组", nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
                
            }
            else if(ret == GROUP_REJECT_JOIN) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatJoinGroupStep1Msg, nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            }
            else if(ret == GROUP_APPLY_JOINED) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatJoinGroupStep2Msg, nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            } else {
                
                [WXWUIUtils showNotificationOnTopWithMsg:[NSString stringWithFormat:@"错误代码:%d", ret]
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            }
            
            [super connectDone:result url:url contentType:contentType closeAsyncLoadingView:YES];
        }
            
            return;
            
        default:
            break;
    }
    
    [super connectDone:result
                   url:url
           contentType:contentType];
}

- (void)connectCancelled:(NSString *)url
             contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error
                  url:(NSString *)url
          contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
    
    [super connectDone:nil url:url contentType:contentType closeAsyncLoadingView:YES];
}

#pragma mark - cell delegate

- (void)openImage:(UIImage *)image
{
    ChatScrollViewController *vc = [[[ChatScrollViewController alloc] initWithMOC:_MOC parentVC:self.parentVC withImages:[NSArray arrayWithObject:image]] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
    
    needReLoad = NO;
}

- (UIImage *)adjustImage:(CGSize)size withBigImage:(UIImage *)bigImage withSmallImage:(UIImage *)smallImage
{
    UIGraphicsBeginImageContext(size);
    
    [bigImage  drawInRect:CGRectMake(0,0,size.width, size.height)];
    [smallImage  drawInRect:CGRectMake(size.width*0.3,(size.height - smallImage.size.height) / 2.0f,smallImage.size.width, smallImage.size.height)];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)initBottomAddGroupView
{
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - BOTTOM_BAR_HEIGHT , SCREEN_WIDTH, BOTTOM_BAR_HEIGHT)] autorelease];
    view.backgroundColor = COLOR_WITH_IMAGE_NAME(@"communication_bottom_background.png");
    
    UIButton *addGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addGroupButton setBackgroundImage:[self adjustImage:CGSizeMake( view.frame.size.width, view.frame.size.height) withBigImage:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_add_to_group.png") withSmallImage:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_add_to_group_icon.png")]  forState:UIControlStateNormal];
    addGroupButton.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [addGroupButton setTitle:@"加入群组" forState:UIControlStateNormal];
    [addGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addGroupButton addTarget:self action:@selector(addGroupButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:addGroupButton];
    
    //------------------
    UIImage *image = IMAGE_WITH_IMAGE_NAME(@"communication_bottom_add_to_group.png");
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(addGroupButton.frame.origin.x / 2 - image.size.width, 0, image.size.width, image.size.height)];
    icon.image = image;
    
    [addGroupButton addSubview:icon];
    [icon release];
    //------------
    [self.view addSubview:view];
}

- (void)initBottomChatView
{
    bottomeChatViewBaseY = self.view.frame.size.height - 64 - BOTTOM_BAR_HEIGHT;
    _bottomChatView = [[UIImageView alloc] initWithFrame:CGRectMake(0, bottomeChatViewBaseY, SCREEN_WIDTH, BOTTOM_BAR_HEIGHT)];
    [_bottomChatView setUserInteractionEnabled:YES];
    [_bottomChatView setImage:[[UIImage imageNamed:@"Communicate_tab_background.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:25]];

    [_bottomChatView addSubview:[self setVoiceBtn]];
    [_bottomChatView addSubview:[self setContentView]];
    [_bottomChatView addSubview:[self setChangeModeBtn]];
    [self setExpressionBtn:_bottomChatView];
    
    [self.view addSubview:_bottomChatView];
}

- (HPGrowingTextView *)setContentView
{
    float wGap = 3.5f;
    float sGap = 8.5f;
    
    UIImage *txtImg = [UIImage imageNamed:@"Communicate_tab_txtInput.png"];
    float txtWidth = txtImg.size.width - 3;
    float txtHeight= txtImg.size.height;
    
    CGRect textRect = CGRectMake(wGap + 29 + sGap, (BOTTOM_BAR_HEIGHT - txtHeight)/2 - 2, txtWidth, txtHeight);
    _chatContentTextView = [[HPGrowingTextView alloc] initWithFrame:textRect];
    _chatContentTextView.layer.masksToBounds = YES;
    _chatContentTextView.layer.cornerRadius = 5.0f;
    _chatContentTextView.layer.borderWidth = 0.5f;
    _chatContentTextView.layer.borderColor = [UIColor colorWithHexString:@"0xbebeba"].CGColor;
    _chatContentTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 0);
    _chatContentTextView.backgroundColor = [UIColor whiteColor];
    _chatContentTextView.delegate = self;
    _chatContentTextView.minNumberOfLines = 1;
    _chatContentTextView.maxNumberOfLines = 4;
    _chatContentTextView.returnKeyType = UIReturnKeySend;
    _chatContentTextView.placeholder = @"请输入信息";
    _chatContentTextView.textColor = [UIColor blackColor];
    _chatContentTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_chatContentTextView setFont:FONT_SYSTEM_SIZE(16)];
    
    return _chatContentTextView;
}

-  (UIButton *)setChangeModeBtn
{
    float wGap = 3.5f;
    UIImage *img = [UIImage imageNamed:@"Communicate_tab_voice.png"];
    float width = img.size.width;
    float height = img.size.height;
    
    _changeModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_changeModeButton setBackgroundColor:[UIColor clearColor]];
    [_changeModeButton setFrame:CGRectMake(wGap,(BOTTOM_BAR_HEIGHT - height)/2,width,height)];
    [_changeModeButton setBackgroundImage:img forState:UIControlStateNormal];
    [_changeModeButton addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventTouchUpInside];
    return _changeModeButton;
}

- (UIButton *)setVoiceBtn
{
    
    float wGap = 3.5f;
    float sGap = 8.5f;
    UIImage *voiceImg = [UIImage imageNamed:@"Communicate_tab_speak.png"];
    float voiceWidth = voiceImg.size.width - 3;
    float voiceHeight = voiceImg.size.height;
    
    _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voiceButton setFrame:CGRectMake(wGap + 29 + sGap, (_bottomChatView.frame.size.height - voiceHeight)/2, voiceWidth, voiceHeight)];
    [_voiceButton setBackgroundImage:voiceImg forState:UIControlStateNormal];
    
    [_voiceButton addTarget:self action:@selector(voiceButtonDown:) forControlEvents:UIControlEventTouchDown];
    [_voiceButton addTarget:self action:@selector(voiceButtonUp:) forControlEvents:UIControlEventTouchUpInside];
    [_voiceButton addTarget:self action:@selector(voiceButtonUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    [_voiceButton setHidden:YES];
    
    return _voiceButton;
}

- (void)setExpressionBtn:(UIView *)parentView
{
    float wGap = 3.5f;
    float xGap = 6.5f;
    
    UIImage *otherImg = [UIImage imageNamed:@"Communicate_tab_more.png"];
    UIImage *faceImg = [UIImage imageNamed:@"Communicate_tab_face.png"];
    
    NSArray *imgArr = [[[NSArray alloc]initWithObjects:otherImg,faceImg, nil] autorelease];
    float width = otherImg.size.width;
    float height = otherImg.size.height;
    
    UIButton *btn = nil;
    
    for (int i = 1; i< 3; i++ )
    {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTag:i];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setFrame:CGRectMake(SCREEN_WIDTH - wGap - width*i - xGap*(i - 1), (_bottomChatView.frame.size.height - height)/2, width, height)];
        [btn setBackgroundImage:[imgArr objectAtIndex:i - 1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(expressionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [parentView addSubview:btn];
    }
}

- (ChatMenuView *)setMenuView
{
    _chatMenuView = [[ChatMenuView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, KEYBOARD_HEIGHT)];
    _chatMenuView.menuViewDelegate = self;
    return _chatMenuView;
}

- (void)initMicView
{
    
    int height = 72;
    int width = 72;
    int startX = (SCREEN_WIDTH - width ) / 2.0f;
    int startY = (SCREEN_HEIGHT - width) / 2.0f - 50;

    _micView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    [_micView setBackgroundColor:COLOR_WITH_IMAGE_NAME(@"communication_mic_background.png")];
    
    _micStepImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [_micView addSubview:_micStepImageView];
    
    [self.view addSubview:_micView];
    [_micView setHidden:YES];
}

- (void)startShowMicView
{
    _stepIndex = 0;
    _showStepMicTimer = [NSTimer scheduledTimerWithTimeInterval: 0.2
                                                         target: self
                                                       selector: @selector(startShowMicStepViewTimerCallback:)
                                                       userInfo: nil
                                                        repeats: YES];
    
    [_micView setHidden:NO];
}

- (void)stopShowMicView
{
    [_showStepMicTimer invalidate];
    _showStepMicTimer = nil;
    
    [_micView setHidden:YES];
}

//音量检测
- (void)startShowMicStepViewTimerCallback:(NSTimer *)timer
{
    NSString *imageName = [NSString stringWithFormat:@"communication_mic_%d.png", ++_stepIndex % 4];
    [_micStepImageView setImage:IMAGE_WITH_IMAGE_NAME(imageName)];
}

#pragma mark - Click Button

- (void)showGallery {
    
    isSavedToAlbum = NO;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = NO;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showCamera {
    
    isSavedToAlbum = YES;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
        imagePicker.mediaTypes = temp_MediaTypes;
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        [self showGallery];
    }
}

- (void)sendButtonClicked:(id)sender
{
    if (_groupIsDeleted) {
        [self showGroupIsDeleted];
    } else {
        
        NSLog(@"sendButtonClicked:sender:%@", [AppManager instance].userId);
        
        if (_chatContentTextView.text.length < 1)
        {
            return;
        }
        
        [self sendTxtMsg];
        
        [self refreshChatMsgList];
    }
}

- (void)changeMode:(id)sender
{
    if ([_voiceButton isHidden]) {
        
        [self showTalkState];
    } else {
        
        [self showTextState];
    }
}

- (void)showTalkState {
    
    [_voiceButton setHidden:NO];
    [_changeModeButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"Communicate_tab_keyboard.png") forState:UIControlStateNormal];
    [_changeModeButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"Communicate_tab_keyboard.png") forState:UIControlStateHighlighted];
    
    _isFaceChoose = NO;
    [self hideExpressionView];
    [_chatContentTextView setHidden:YES];
    [_chatContentTextView resignFirstResponder];
    
    UIButton *motiveButton =  (UIButton *)[_bottomChatView viewWithTag:ICHAT_FACE_TAG];
    [motiveButton setImage:[UIImage imageNamed:@"Communicate_tab_face.png"] forState:UIControlStateNormal];
    [_bottomChatView reloadInputViews];
    _isFaceChoose = NO;
    
    // 回复初始高度
    bottomeChatViewCurrentY = _bottomChatView.frame.origin.y;
    bottomeChatViewCurrentH = _bottomChatView.frame.size.height;
    _tabHeightTemp = _tabHeight;
    
    if (bottomeChatViewCurrentY != bottomeChatViewBaseY) {
        _tabHeight = 44;
        _bottomChatView.frame = CGRectMake(0, bottomeChatViewBaseY, SCREEN_WIDTH, BOTTOM_BAR_HEIGHT);
    }
}

- (void)showTextState {
    
    if (_tabHeightTemp > 0) {
        _tabHeight = _tabHeightTemp;
    }
    [_voiceButton setHidden:YES];
    
    [_changeModeButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"Communicate_tab_voice.png") forState:UIControlStateNormal];
    [_changeModeButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"Communicate_tab_voice.png") forState:UIControlStateHighlighted];
    
    [_chatContentTextView setHidden:NO];
    [_chatContentTextView becomeFirstResponder];
    
    UIButton *motiveButton =  (UIButton *)[_bottomChatView viewWithTag:ICHAT_FACE_TAG];
    [motiveButton setImage:[UIImage imageNamed:@"Communicate_tab_face.png"] forState:UIControlStateNormal];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    contentOffsetY = scrollView.contentOffset.y;
    
    if (scrollView == self.tableView)
    {
        [self closeLogicActionView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == EXPRESSION_SCROLL_VIEW_TAG)
    {
        //更新UIPageControl的当前页
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.frame;
        [pageCtrl setCurrentPage:offset.x / bounds.size.width];
    }
}

- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = pageScroll.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [pageScroll scrollRectToVisible:rect animated:YES];
}

#pragma mark - gesture delegate
- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    [_chatContentTextView resignFirstResponder];
}

-(void)chatDetailTapped:(UISwipeGestureRecognizer *)recognizer
{
    // TODO 调用摄像头 设置背景
    
    [self closeLogicActionView];
}

- (void)closeLogicActionView {
    [_chatContentTextView resignFirstResponder];
    [self hideExpressionView];
    _isOtherFuntion = NO;
    [self autoMovekeyBoard:0.0f withDuration:0.3f];
}

#pragma mark - HPGrowingTextView delegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	CGRect r = _bottomChatView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	_bottomChatView.frame = r;
    _tabHeight = _bottomChatView.frame.size.height;
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height += diff;
    self.tableView.frame = tableFrame;
    
    if (self.chatArray.count>0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.chatArray.count-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.length == 1) {
        return YES;
    }
    
    NSInteger textLength = _chatContentTextView.text.length;
    
    NSInteger replaceLength = [text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if ( (textLength + replaceLength) >= 1001)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"内容最多为1000字节" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
        [av release];
        return NO;
    }
    
    if ([text isEqualToString:@"\n"])
    {
        [self sendButtonClicked:nil];
        return NO;
    }
    
    return YES;
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self sendButtonClicked:nil];
    return YES;
}


#pragma mark - keyboard show or hidden
- (void)autoMovekeyBoard:(CGFloat)height withDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        
      int bottomTabHeight = _tabHeight > BOTTOM_BAR_HEIGHT ? _tabHeight:BOTTOM_BAR_HEIGHT;
        
      _bottomChatView.frame = CGRectMake(0.0f, (self.view.frame.size.height - height - bottomTabHeight), SCREEN_WIDTH, bottomTabHeight);
    
        //Other Funtion View
        if (_isOtherFuntion) {
            [_chatMenuView setFrame:CGRectMake(0, SCREEN_HEIGHT - KEYBOARD_HEIGHT - 64, SCREEN_WIDTH, KEYBOARD_HEIGHT)];
            [self.view bringSubviewToFront:_chatMenuView];
        } else {
            [_chatMenuView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, KEYBOARD_HEIGHT)];
        }
        
        // Face View
        
        // Chat TableView
        if (height == 0.f) {
            self.tableView.frame = CGRectMake(0.f, height, self.tableView.frame.size.width, (SCREEN_HEIGHT - ITEM_BASE_BOTTOM_VIEW_HEIGHT - SYS_STATUS_BAR_HEIGHT - bottomTabHeight));
        } else {
            if ([self msgListViewCanScrollWithMatchHeight:height]) {
                self.tableView.frame = CGRectMake(0.f, -height, self.tableView.frame.size.width, (SCREEN_HEIGHT - ITEM_BASE_BOTTOM_VIEW_HEIGHT - SYS_STATUS_BAR_HEIGHT - bottomTabHeight));
            }
        }
    } completion:^(BOOL finished) {
        _isOtherFuntion = NO;
    }];
}

#pragma mark - Responding to keyboard events

- (void)keyboardShowNotify:(NSNotification *)notification {
    keyboardIsShowing = YES;

    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self autoMovekeyBoard:keyboardRect.size.height withDuration:animationDuration];
}

- (void)keyboardHideNotify:(NSNotification *)notification {
    keyboardIsShowing = NO;
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self autoMovekeyBoard:0.f withDuration:animationDuration];
}

- (void)hideKeyboard {
    
    //[self.inputToolbar.textView resignFirstResponder];
    //keyboardIsVisible = NO;
    //[self moveInputBarWithKeyboardHeight:0.0 withDuration:0.0];
}

#pragma mark - load data

- (void)loadJoinChatGroup:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];

    [specialDict setObject:self.receiver forKey:KEY_API_PARAM_GROUP_ID];
    [specialDict setObject:[NSString stringWithFormat:@"%@", [AppManager instance].userId ] forKey:KEY_API_PARAM_USERIDLIST];
    
    //------------------------------
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_JOIN_CHAT_GROUP];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:SUBMIT_JOING_CHAT_GROUP_TY];
    
    [connFacade post:url data:[requestDict JSONData]];
}

- (void)loadSubmitPrivateLetter:(LoadTriggerType)triggerType forNew:(BOOL)forNew type:(enum FRIEND_TYPE)type
{
    _currentType = SUBMIT_PRIVETE_LETTER_TY;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    //    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    //    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:_friendID forKey:KEY_API_PARAM_USERID];
    [specialDict setObject:NUMBER(type) forKey:KEY_API_PARAM_TYPE];
    
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_SUBMIT_PRIVATE_LETTER];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:urlString
                                                              contentType:_currentType];
    
    [connFacade post:urlString data:[requestDict JSONData]];
    
}


#pragma mark - load more messsge

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    
}

- (void)configureMOCFetchConditions {
}

- (void)hideKeyboardWhenResponding {
    [_chatContentTextView resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    DLog(@"%f",contentOffsetY);
    if ((contentOffsetY - scrollView.contentOffset.y) > 5.0f && contentOffsetY != 1286.f) {   // 向下拖拽
        if (keyboardIsShowing) {
            [self hideKeyboardWhenResponding];
        }
    }
}

-(void)showGroupIsDeleted {
    [[[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"群组已删除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease] show];
}

#pragma mark - msgListView can scroll

- (BOOL)msgListViewCanScrollWithMatchHeight:(CGFloat)height {
    
    int chatCount = [self.chatArray count];
    if (chatCount > 0) {
        
        CGFloat minScrollHeight = 0.f;
        
        for (int i = 0; i < chatCount; i++) {
            ChatDetailCell *cell = (ChatDetailCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            minScrollHeight += cell.frame.size.height;
        }
        
        if (minScrollHeight > (self.view.frame.size.height - height)) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - extend tool element click
- (void)expressionBtnClick:(UIButton *)btn
{
    switch (btn.tag)
    {
        case ICHAT_OTHER_TAG:
        {
            NSLog(@"choose other funtion...");
            
            _isOtherFuntion = YES;
            
            if ([_chatContentTextView isFirstResponder])
            {
                [_chatContentTextView resignFirstResponder];
            }
            [self autoMovekeyBoard:KEYBOARD_HEIGHT withDuration:0.3f];
        }
            break;
        case ICHAT_FACE_TAG:
        {
            NSLog(@"choose face...");
            [self showTextState];
            
            if (_isFaceChoose)
            {
                _isFaceChoose = NO;
                [btn setImage:[UIImage imageNamed:@"Communicate_tab_face.png"] forState:UIControlStateNormal];
                
                [_chatContentTextView becomeFirstResponder];
            }
            else
            {
                _isFaceChoose = YES;
                [btn setImage:[UIImage imageNamed:@"Communicate_tab_keyboard.png"] forState:UIControlStateNormal];
                if ([_chatContentTextView isFirstResponder])
                {
                    [_chatContentTextView resignFirstResponder];
                }
                
                [self showExpressionView];
                [self autoMovekeyBoard:KEYBOARD_HEIGHT withDuration:0.3f];
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    UIButton *motiveButton =  (UIButton *)[_bottomChatView viewWithTag:ICHAT_FACE_TAG];
    if (_isFaceChoose) {
        [motiveButton setImage:[UIImage imageNamed:@"Communicate_tab_face.png"] forState:UIControlStateNormal];
        [_bottomChatView reloadInputViews];
    }
    
    return YES;
}

#pragma mark - ChatMenuViewDelegate method

- (void)chatMenuClick:(int)index
{
    switch (index)
    {
        case CHAT_PHOTOLIB_TAG:
        {
            attachType = EMessageAttachType_IMAGE;
            NSLog(@"Photo Lib...");
            [self showGallery];
        }
            break;
            
        case CHAT_CAMERA_TAG:
        {
            attachType = EMessageAttachType_IMAGE;
            NSLog(@"Camera");
            [self showCamera];
        }
            break;
            
        case CHAT_LOCATION_TAG:
        {
            attachType = EMessageAttachType_LOCATION;
            NSLog(@"Location...");
            MapViewController *mapView = [[MapViewController alloc]initWithMOC:_MOC parentVC:self.parentVC ];
            mapView.mapViewDelegate = self;
            [mapView resetAnnitations:nil enterType:MAP_CURRENTLOCATION_TYPE];
            [CommonMethod pushViewController:mapView withAnimated:YES];
            
            needReLoad = NO;
        }
            break;
            
        case CHAT_DOCUMENT_TAG:
        {
            attachType = EMessageAttachType_OTHER;
            NSLog(@"Document....");
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - ModelEngineUIDelegate method
- (void)responseMessageStatus:(EMessageStatusResult)event callNumber:(NSString *)callNumber data:(NSString *)data
{
    switch (event)
	{
        case EMessageStatus_Received:
        {
            [self refreshChatMsgList];
        }
            break;
        case EMessageStatus_Send:
        {
        }
            break;
        case EMessageStatus_SendFailed:
        {
        }
            break;
        default:
            break;
    }
}

- (void)responseDownLoadMediaMessageStatus:(CloopenReason *)event
{
    switch (event.reason)
	{
        case 0:
        {
            [self refreshChatMsgList];
        }
            break;
        default:
            break;
    }
}

- (void)onSendInstanceMessageWithReason: (CloopenReason *) reason andMsg:(InstanceMsg*) data
{
    if (reason.reason == ERROR_FILE)
    {
        [self popPromptViewWithMsg:@"发送的文件过大，不能发送超过限制大小的文件！"];
        return;
    }
    else if (reason.reason == 170014)
    {
        [self popPromptViewWithMsg:@"语音过短，发送失败！"];
        return;
    }
    else if (reason.reason == 170016)//用户取消上传
    {
        return;
    }
    else if (reason.reason == 110138 )
    {
        [self popPromptViewWithMsg:@"你已经被管理员禁言！"];
    }
    else if (reason.reason == 121002)//计费鉴权失败,余额不足
    {
        [self popPromptViewWithMsg:@"计费鉴权失败,余额不足！"];
        return;
    }
    else if (reason.reason == 112037)
    {
        [self popPromptViewWithMsg:@"群组用户被禁言！"];
        return;
    }
    else if (reason.reason == 170022)
    {
        [self popPromptViewWithMsg:@"发送文本过长！"];
        return;
    }
    //    else if (reason != 0 )
    //    {
    //        return;
    //    }
    
    if ([data isKindOfClass:[IMAttachedMsg class]])
    {
        IMAttachedMsg *msg = (IMAttachedMsg*)data;
        BOOL isExist = [self.modelEngineVoip.imDBAccess isMessageExistOfMsgid:msg.msgId];
        if (isExist)
        {
            
            NSInteger imstate = EMessageState_SendFailed;
            if (reason.reason == 0)
                imstate = EMessageState_SendSuccess;
            
            [self.modelEngineVoip.imDBAccess updateimState:imstate OfmsgId:msg.msgId];
        } else {
            
            IMMessageObj *imMsg = [[IMMessageObj alloc] init];
            imMsg.filePath = msg.fileUrl;
            imMsg.sessionId = self.receiver;
            imMsg.fileExt = msg.ext;
            if (reason.reason == 0)
                imMsg.imState = EMessageState_SendSuccess;
            else
                imMsg.imState = EMessageState_SendFailed;
            
            if ([msg.ext isEqualToString:@"amr"])
            {
                imMsg.msgid = self.curRecordVoiceMsgId;
                imMsg.msgtype = EMessageType_Voice;
                imMsg.duration = [self.modelEngineVoip getVoiceDuration:msg.fileUrl];
            } else {
                imMsg.msgtype = EMessageType_File;
            }
            imMsg.isRead = EReadState_IsRead;
            imMsg.dateCreated = msg.dateCreated;
            NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:kDATE_TIME_FORMAT];
            NSString *curTimeStr = [dateformatter stringFromDate:[NSDate date]];
            [dateformatter release];
            imMsg.curDate = curTimeStr;
            imMsg.sender = [AppManager instance].userChatId;
            [self.modelEngineVoip.imDBAccess insertIMMessage:imMsg];
            [imMsg release];
        }
        
        [self refreshChatMsgList];
    } else if ([data isKindOfClass:[IMTextMsg class]]) {
        //报告发送状态
        IMTextMsg *msg = (IMTextMsg*)data;
        NSInteger status = [msg.status integerValue];
        NSInteger imStatus = 0;
        if (status == -1)
        {
            imStatus = EMessageState_SendFailed;
        }
        else if(status == 0)
        {
            imStatus = EMessageState_SendSuccess;
        }
        else if(status == 1)
        {
            imStatus = EMessageState_Send_OtherReceived;
        }
        NSLog(@"reason=%d,状态报告=%d", reason.reason, status);
        [self.modelEngineVoip.imDBAccess updateimState:imStatus OfmsgId:msg.msgId];
        [self refreshChatMsgList];
    }
}

#pragma mark - Click Elements
- (void)voiceBtnClicked:(id)sender {
    
    if (isRecording)
    {
        return;
    }
    
    [self stopAnimation];
    self.curImg = nil;
    UIView *contentview = [sender superview];
    self.curImg = (UIImageView*)[contentview viewWithTag:1005];
    
    UIView *cell = [contentview superview];
    while (![cell isKindOfClass:[UITableViewCell class]]) {
        cell = [cell superview];
    };
    
    [(ChatDetailCell *)cell updateBubbleVoiceImage];
    
    self.curPlayVoiceRowIndex = [self.tableView indexPathForCell:(UITableViewCell*)cell].row;
    
    IMMessageObj *msg = self.chatArray[self.curPlayVoiceRowIndex];
    
    NSString *strFileName = msg.filePath;
    if (isPlaying && [msg.msgid isEqualToString:self.curPlayVoiceMsgId])
    {
        [self stopRecMsg];
        return;
    }
    self.curPlayVoiceMsgId = msg.msgid;
    [self playRecMsg:strFileName];
    
    [self.modelEngineVoip.imDBAccess updateUnreadVoiceStateOfSessionId:self.receiver msgId:msg.msgid];
}

//停止放音
-(void)stopRecMsg
{
    isPlaying = NO;
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
    [self.curImg stopAnimating];
    [self.modelEngineVoip stopVoiceMsg];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
}

//停止播放语音的动画效果
-(void)stopAnimation
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    if (self.curImg)
    {
        [self.curImg stopAnimating];
    }
}

//根据传入的文件名播放语音
-(void)playRecMsg:(NSString*)fileName
{
    isPlaying = YES;
    [self.curImg startAnimating];
    [self.modelEngineVoip enableLoudsSpeaker:isLoud];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
//    if (isLoud)
//    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    } else {
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    }
    [self.modelEngineVoip playVoiceMsg:fileName];
}

#pragma mark - VoipModelEngine Delegate

-(void)responseFinishedPlaying
{
    isPlaying = NO;
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [self stopAnimation];
}

//录音超时
-(void)responseRecordingTimeOut:(int)ms
{
    recordState = ERecordState_Origin;
    isRecording = NO;
    [self popPromptViewWithMsg:[NSString stringWithFormat:@"语音超时，已达到最大时长%d秒，即将自动进行发送", ms/1000]];
    [self stop];
}

- (void)loudSperker
{
    isLoud = !isLoud;
    if (isLoud)
    {
        //扬声器
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    else
    {
        //听筒
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
}

// Click Attach
- (void)attachButtonClicked:(id)sender {
    UIButton *btn = (id)sender;
    
    if (btn.tag < [self.chatArray count]) {
        
        IMMessageObj *msg = self.chatArray[btn.tag];
        
        if (msg != nil) {
            
            int msgAttachType = EMessageAttachType_IMAGE;
            NSMutableDictionary *msgDict = nil;
            
            if (msg.userData != nil) {
                msgDict = [msg.userData objectFromJSONString];
                msgAttachType = [[msgDict objectForKey:TRANS_ATTACH_TYPE] intValue];
            }
            
            switch (msgAttachType) {
                case EMessageAttachType_IMAGE:
                {
                    if ([CommonMethod isExist:msg.filePath]) {
                        UIImage *image = [[[UIImage alloc]initWithContentsOfFile:msg.filePath] autorelease];
                        
                        [self openImage:image];
                    }
                }
                    break;
                
                case EMessageAttachType_LOCATION:
                {
                    NSLog(@"EMessageAttachType LOCATION");
                    
                    MapViewController *mapVC = [[[MapViewController alloc]initWithMOC:_MOC parentVC:self.parentVC] autorelease];
                    [mapVC resetAnnitations:[msgDict objectForKey:TRANS_ATTACH_SPECIAL_DATA] enterType:MAP_SENDLOCATION_TYPE];
                    [CommonMethod pushViewController:mapVC withAnimated:YES];
                    
                    needReLoad = NO;
                }
                    break;
                    
                case EMessageAttachType_OTHER:
                {
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

#pragma mark - Gene Elements
// 表情
-(void)putExpress:(id)sender
{
	
	UIButton *button_tag = (UIButton *)sender;
	_chatContentTextView.text =  [_chatContentTextView.text stringByAppendingString:
                      [CommonTools getExpressionStrById:button_tag.tag]];
}

- (void)backspaceText:(id)sender
{
    if (_chatContentTextView.text.length > 0)
    {
        _chatContentTextView.text = [_chatContentTextView.text substringToIndex:_chatContentTextView.text.length-1];
    }
}

- (void)creatExpressionView
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320.0f, 216.0f)];
    self.expressionView = view;
    [self.view addSubview:view];
    [view release];
    
    NSInteger pageCount = 7;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    scrollView.tag = EXPRESSION_SCROLL_VIEW_TAG;
    pageScroll = scrollView;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*pageCount, scrollView.frame.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor colorWithRed:209.0f/255.0f green:212.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
    
    int row = 4;
    int column = 7;
    int number = 0;
    for (int p=0; p<pageCount; p++)
    {
        NSInteger page_X = p*scrollView.frame.size.width;
        for (int j=0; j<row; j++)
        {
            NSInteger row_y = 15+50*j;
            for (int i=0; i<column; i++)
            {
                NSInteger column_x = 20+40*i;
                if (number > 170)
                {
                    break;
                }
                
                if (j!=row-1 || i!=column-1)
                {
                    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(page_X+column_x, row_y, 40.0f, 40.0f)];
                    btn.tag = number;
                    btn.backgroundColor = [UIColor clearColor];
                    btn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
                    [btn setTitle:[CommonTools getExpressionStrById:number] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(putExpress:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:btn];
                    [btn release];
                    number++;
                }
            }
        }
        
        UIButton* delBtn = [[UIButton alloc] initWithFrame:CGRectMake(page_X+260.0f, 165.0f, 40.0f, 40.0f)];
        delBtn.backgroundColor = [UIColor clearColor];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"aio_face_delete_pressed.png"] forState:UIControlStateHighlighted];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"aio_face_delete.png"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(backspaceText:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:delBtn];
        [delBtn release];
    }
    
    [self.expressionView addSubview:scrollView];
    [scrollView release];
    
    UIPageControl *pageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.expressionView.frame.size.height-20.0f, 320.0f, 20.0f)];
    pageView.numberOfPages = pageCount;
    pageView.currentPage = 0;
    [pageView addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    pageCtrl = pageView;
    [self.expressionView addSubview:pageView];
    [pageView release];
}

- (void)showExpressionView
{
    if (self.expressionView == nil)
    {
        [self creatExpressionView];
    }
    
    CGRect expressionFrame = self.expressionView.frame;
    expressionFrame.origin.y = self.view.bounds.size.height - expressionFrame.size.height;
    
    //animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    //set views with new info
    self.expressionView.frame = expressionFrame;
    
    //commit animations
    [UIView commitAnimations];
    
    [self autoScrollTableBottom];
}

- (void)hideExpressionView
{
    if (self.expressionView == nil) {
        return;
    }
    
    CGRect expressionFrame = self.expressionView.frame;
    expressionFrame.origin.y = self.view.bounds.size.height;
    
    //animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    
    //set view with new info
    self.expressionView.frame = expressionFrame;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - BOTTOM_BAR_HEIGHT);
    
    //commit animations
    [UIView commitAnimations];
}

//开始录音
- (void)voiceButtonDown:(id)sender {
    
    [self stopRecMsg];
    
    if (recordState != ERecordState_Origin)
    {
        return;
    }
    
    recordState = ERecordState_Start;
    if (self.recordTimer)
    {
        [self.recordTimer invalidate];
        self.recordTimer = nil;
    }
    
    if (_groupIsDeleted) {
        [self showGroupIsDeleted];
    } else {
        [self startShowMicView];
        isRecording = YES;
        
        self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(startRecording) userInfo:nil repeats:NO];
    }
}

- (void)startRecording
{
    if (recordState != ERecordState_Start)
    {
        return;
    }

    recordState = ERecordState_Recording;
    self.curRecordVoiceName = [self createFileName];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:self.curRecordVoiceName];
    self.sendPath = filePath;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [self.modelEngineVoip startVoiceRecordingWithReceiver:self.receiver andPath:filePath andChunked:isChunk andUserdata:@"cloopen"];
}

- (void)stopRecordVoice:(id)sender
{
    [self stopShowMicView];
    
    if (recordState != ERecordState_Recording)
    {
        recordState = ERecordState_Origin;
        return;
    }
    
    isRecording = NO;
    [self stop];
    recordState = ERecordState_Origin;
}

- (void)voiceButtonUp:(id)sender {
    //多录制2秒
    [self performSelector:@selector(stopRecordVoice:) withObject:nil afterDelay:0.8f];
}

//调用底层的停止录音
-(void)stop
{
    [self.modelEngineVoip stopCurRecording];
    if (!isChunk)
    {
        [self performSelector:@selector(sendVoiceMsg) withObject:nil afterDelay:.5];
    }
}

//录音取消
-(void)voiceButtonUpOutside
{
    if (recordState != ERecordState_Recording)
    {
        recordState = ERecordState_Origin;
        return;
    }

    [self stopShowMicView];
    isRecording = NO;
    if (isChunk)
    {
        [self.modelEngineVoip cancelVoiceRecording];
    }
    else
    {
        [self.modelEngineVoip stopCurRecording];
    }
    recordState = ERecordState_Origin;
}

//根据一定规则生成文件不重复的文件名
- (NSString *)createFileName
{
    static int seedNum = 0;
    if(seedNum >= 1000)
        seedNum = 0;
    seedNum++;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDATE_TIME_FORMAT];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    NSString *file = [NSString stringWithFormat:@"tmp%@%03d.amr", currentDateStr, seedNum];
    return file;
}

// Gene Image
- (NSString*)saveToDocment:(UIImage*)image
{
	NSDate *date=[NSDate date];
	NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSInteger unitFlags=NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
	NSDateComponents *component=[calendar components:unitFlags fromDate:date];
    [calendar release];
    
	int year=[component year];
	int month=[component month];
	int day=[component day];
	int h=[component hour];
	int m=[component minute];
	int s=[component second];
	NSString *fileName=[NSString stringWithFormat:@"%d-%d-%d_%d:%d:%d.jpg",year,month,day,h,m,s];
	NSString *filePath=[NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    //图片按0.5的质量压缩－》转换为NSData
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
	[imageData writeToFile:filePath atomically:YES];
    return filePath;
}

#pragma mark - UIActionSheet method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (actionSheet.tag) {
        case 1:
            switch (buttonIndex) {
                case 0:
                    [self showCamera];
                    break;
                case 1:
                    [self showGallery];
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (buttonIndex) {
                case 0:
                    [self showPrivateDialogTo:_currentClickUserID];
                    break;
                default:
                    break;
            }
            break;
        case 4:
            switch (buttonIndex) {
                case 0:
//                    [self addFriend:_currentClickUserID];
                    break;
                case 1:
                    [self showPrivateDialogTo:_currentClickUserID];
                    break;
                default:
                    break;
            }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate method
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"image Picker Controller Did Cancel");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    @try
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        UIImage *imageSource = [info objectForKey:UIImagePickerControllerOriginalImage];
        if ( isSavedToAlbum )
        {
            UIImageWriteToSavedPhotosAlbum(imageSource, nil, nil, nil);
        }
        
        self.curImageFile = [self saveToDocment:imageSource];
        self.imagePicker = nil;
        
        [self sendAttachedFile];
        
        [self refreshChatMsgList];
    }
    @catch (NSException *exception)
    {
        [self popPromptViewWithMsg:@"发送附件失败，请稍后再试！"];
    }
    @finally {
        [self autoScrollTableBottom];
    }
}

- (void)popPromptViewWithMsg:(NSString*)msg
{
    [WXWUIUtils showNotificationOnTopWithMsg:msg
                                     msgType:SUCCESS_TY
                          belowNavigationBar:YES];
}

#pragma mark - MapView Delegate

- (void)sendLocationWithImage:(UIImage *)image withLocationData:(NSMutableDictionary *)aLocationDic
{
    self.locationDic = aLocationDic;
    self.curImageFile = [self saveToDocment:image];
    attachType = EMessageAttachType_LOCATION;
    
    [self sendAttachedFile];
    
    [self refreshChatMsgList];
}

#pragma mark - Send Elements
// Send Text
- (void)sendTxtMsg {
    // CCPVoip
    NSString *msgTxt = _chatContentTextView.text;
    
    IMMessageObj *msg = [[IMMessageObj alloc] init];
    msg.content = msgTxt;
    msg.sessionId = self.receiver;
    msg.msgtype = EMessageType_Text;
    msg.isRead = EReadState_IsRead;
    msg.imState = EMessageState_Sending;
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:kDATE_TIME_FORMAT];
    NSString *curTimeStr = [dateformatter stringFromDate:[NSDate date]];
    [dateformatter release];
    msg.curDate = curTimeStr;
    
    /*
    NSMutableDictionary *userDataDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *senderDict = [NSMutableDictionary dictionary];
    [senderDict setObject:[AppManager instance].userName forKey:TRANS_SEND_NAME];
    [senderDict setObject:[AppManager instance].userId forKey:TRANS_SEND_NAMEID];
    [senderDict setObject:[AppManager instance].userImageUrl forKey:TRANS_SEND_IMAGE];
    [userDataDict setObject:senderDict forKey:TRANS_SENDER_DATA];
    msg.userData = [userDataDict JSONString];
    */
    
    msg.userData = nil;
    
    NSString *cid = [self.modelEngineVoip sendInstanceMessage:self.receiver andText:msgTxt andAttached:nil andUserdata:msg.userData];
    if (cid.length > 0)
    {
        msg.msgid = cid;
        msg.sender = [AppManager instance].userChatId;
        msg.dateCreated = curTimeStr;
        [self.modelEngineVoip.imDBAccess insertIMMessage:msg];
    }
    [msg release];
    
    _chatContentTextView.text = @"";
}

// Send Voice
- (void)sendVoiceMsg {
    
//    NSMutableDictionary *userDataDict = [NSMutableDictionary dictionary];
//    NSMutableDictionary *senderDict = [NSMutableDictionary dictionary];
//    [senderDict setObject:[AppManager instance].userName forKey:TRANS_SEND_NAME];
//    [senderDict setObject:[AppManager instance].userId forKey:TRANS_SEND_NAMEID];
//    [senderDict setObject:[AppManager instance].userImageUrl forKey:TRANS_SEND_IMAGE];
//    [userDataDict setObject:senderDict forKey:TRANS_SENDER_DATA];
    
    self.curRecordVoiceMsgId = [self.modelEngineVoip sendInstanceMessage:self.receiver andText:nil andAttached:self.sendPath andUserdata:nil];
}

// Send File
- (void)sendAttachedFile {
    
    IMMessageObj *msg = [[IMMessageObj alloc] init];
    msg.filePath = self.curImageFile;
    msg.sessionId = self.receiver;
    msg.imState = EMessageState_Sending;
    msg.msgtype = EMessageType_File;
    msg.isRead = EReadState_IsRead;
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:kDATE_TIME_FORMAT];
    NSString *curTimeStr = [dateformatter stringFromDate:[NSDate date]];
    [dateformatter release];
    msg.curDate = curTimeStr;
    
    // user Data Dict
    NSMutableDictionary *userDataDict = [NSMutableDictionary dictionary];
    
//    NSMutableDictionary *senderDict = [NSMutableDictionary dictionary];
//    [senderDict setObject:[AppManager instance].userName forKey:TRANS_SEND_NAME];
//    [senderDict setObject:[AppManager instance].userId forKey:TRANS_SEND_NAMEID];
//    [senderDict setObject:[AppManager instance].userImageUrl forKey:TRANS_SEND_IMAGE];
//    [userDataDict setObject:senderDict forKey:TRANS_SENDER_DATA];
    
    [userDataDict setObject:[NSString stringWithFormat:@"%d", attachType] forKey:TRANS_ATTACH_TYPE];
    
    switch (attachType) {
        case EMessageAttachType_IMAGE:
        {
            UIImage *curImage = [UIImage imageWithContentsOfFile:self.curImageFile];
            NSMutableDictionary *imageDict = [NSMutableDictionary dictionary];
            [imageDict setObject:[NSString stringWithFormat:@"%f", curImage.size.width] forKey:TRANS_IMAGE_WIDTH];
            [imageDict setObject:[NSString stringWithFormat:@"%f", curImage.size.height] forKey:TRANS_IMAGE_HEIGHT];
            [userDataDict setObject:imageDict forKey:TRANS_ATTACH_SPECIAL_DATA];
        }
            break;
        
        case EMessageAttachType_LOCATION:
        {
            [userDataDict setObject:self.locationDic forKey:TRANS_ATTACH_SPECIAL_DATA];
        }
            break;
          
        case EMessageAttachType_OTHER:
        {
            [userDataDict setObject:@"" forKey:TRANS_ATTACH_SPECIAL_DATA];
        }
            break;
            
        default:
            break;
    }
    
    msg.userData = [userDataDict JSONString];
    
    NSString *cid = [self.modelEngineVoip sendInstanceMessage:self.receiver andText:nil andAttached:self.curImageFile andUserdata:msg.userData];
    if (cid.length > 0) {
        msg.msgid = cid;
        msg.sender = [AppManager instance].userChatId;
        msg.dateCreated = curTimeStr;
        [self.modelEngineVoip.imDBAccess insertIMMessage:msg];
    }
    [msg release];
    
    self.curImageFile = @"";
}

#pragma mark - Refresh Chat Msg List
- (void)refreshChatMsgList {
    
    self.chatArray = [self.modelEngineVoip.imDBAccess getMessageOfSessionId:self.receiver];
    [self.tableView reloadData];
    
    [self autoScrollTableBottom];
}

- (void)autoScrollTableBottom
{
    
    NSUInteger count = [self.tableView numberOfRowsInSection:0];
    if(count == 0)
    {
        return;
    }
    
    self.tableView.alpha = 1;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1
                                                              inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
//    [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height-15, self.tableView.contentSize.width, 10) animated:YES];
}

//处理监听触发事件
- (void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)pressedBackbut:(id)send
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)getGroupInfo:(NSString *)groupBindId
{
    self.entityName = @"ChatGroupModel";
    self.descriptors = [NSMutableArray array];
    self.predicate = [NSPredicate predicateWithFormat:@"groupBindId == %@",groupBindId];
    
    NSSortDescriptor *dateDesc = [[[NSSortDescriptor alloc] initWithKey:@"displayIndex" ascending:YES] autorelease];
    [self.descriptors addObject:dateDesc];
    
    self.fetchedRC = [WXWCoreDataUtils fetchObject:_MOC
                          fetchedResultsController:self.fetchedRC
                                        entityName:self.entityName
                                sectionNameKeyPath:self.sectionNameKeyPath
                                   sortDescriptors:self.descriptors
                                         predicate:self.predicate];
    NSError *error = nil;
    
    if (![self.fetchedRC performFetch:&error]) {
        NSAssert1(0, @"Unhandled error performing fetch: %@", [error localizedDescription]);
    }
    
    if (self.fetchedRC.fetchedObjects.count) {
        _chatGroupData = [self.fetchedRC.fetchedObjects objectAtIndex:0];
    }
    
}

@end