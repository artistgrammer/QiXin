
#import "ChatListViewController.h"
#import "ChatDetailViewController.h"
#import "CommunicatViewCell.h"
#import "ChatAddGroupViewController.h"
#import "SearchUserByWebViewController.h"
#import "CommonMethod.h"
#import "ChatGroupDetailViewController.h"
#import "AddressListViewController.h"
#import "ChatListCell.h"
#import "SelectView.h"

#define TAG_TABLEVIEW_MYJOINGROUP   300
#define TAG_TABLEVIEW_PUBLICGROUP   301

#define EVENT_LIST_CELL_HEIGHT          96.f
#define kSearchBarHeight                44.0f

typedef enum {
    COMMUNICAT_GROUP_TYPE,
    COMMUNICAT_ADDNEW_TYPE,
    COMMUNICAT_LISTEN_TYPE,
} CommunicatTypes;

@interface ChatListViewController () <CommunicatViewCellDelegate, UISearchBarDelegate, SelectViewDelegate, ChatGroupDetailViewControllerDelegate,ChatAddGroupViewControllerDelegate, ChatListCellDelegate>

@property (nonatomic, assign) NSMutableArray *groupInfoArray;

@property (nonatomic, retain) UIImageView *titleImgView;
@property (nonatomic, retain) NSMutableArray *chatMsgArray;
@property (nonatomic, retain) ChatListCell *currentCell;

@property (nonatomic, assign) BOOL m_isFromHomePage;
@property (nonatomic, retain) UISearchBar *m_searchBar;
@property (nonatomic, retain) UIView *m_searchBGView;
@property (nonatomic, retain) SelectView *_selectView;
@property (nonatomic, retain) UITableView *_chatListTable;

@end

@implementation ChatListViewController {
    
    UIBarButtonItem *_leftButton;
    UIBarButtonItem *_rightButton;
    UIBarButtonItem *_privateButton;
    
    NSMutableDictionary *_groupIdDict;
    BOOL _isFirstLoad;
}

@synthesize m_isFromHomePage;
@synthesize m_searchBar;
@synthesize m_searchBGView;
@synthesize _selectView;
@synthesize _chatListTable;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
       viewHeight:(CGFloat)viewHeight
         parentVC:(RootViewController *)pVC {
    
    self = [super initWithMOC:MOC
        needRefreshHeaderView:NO
        needRefreshFooterView:NO];
    
    if (self) {
        
        _viewHeight = viewHeight;
        self.parentVC = pVC;
    }
    
    return self;
}

- (void)dealloc
{
    
    self.titleImgView = nil;
    self.chatMsgArray = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)adjustTableLayout {
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width,
                                 _viewHeight);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


- (UITableView *)createListTable
{
    CGRect tableRect = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - 64);
    _chatListTable = [[UITableView alloc]initWithFrame:tableRect style:UITableViewStyleGrouped];
    [_chatListTable setBackgroundColor:[UIColor clearColor]];
    [_chatListTable setDelegate:self];
    [_chatListTable setDataSource:self];
    [_chatListTable setSeparatorInset:UIEdgeInsetsMake(0, 11, 0, 0)];
    [_chatListTable setShowsHorizontalScrollIndicator:NO];
    [_chatListTable setShowsVerticalScrollIndicator:NO];
    [_chatListTable setTableHeaderView:self.m_searchBar];
    
    [CommonMethod viewAddGuestureRecognizer:_chatListTable withTarget:self withSEL:@selector(chatListTapped:)];
    
    return _chatListTable;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"交流";
    
    [self.view addSubview:[self createSearchBar]];
    
    [self adjustTableLayout];
    [self.view addSubview:[self createListTable]];
    
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    [self.m_searchBar addSubview:[self setVoiceBtn]];
    
    if ([WXWCommonUtils currentOSVersion] < IOS7)
    {
        self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    }
    
    _isFirstLoad = YES;
    _groupIdDict = [[NSMutableDictionary alloc] init];
    
    // notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteSuccessfulGroupFromNewCreate:)
                                                 name:COMMUNICAT_VIEW_CONTROLLER_DELETE_GROUP
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(quiteSuccessfulGroupFromNewCreate:)
                                                 name:COMMUNICAT_VIEW_CONTROLLER_QUIT_CHAT_GROUP
                                               object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self initNavButton];
    
    [self.modelEngineVoip setModalEngineDelegate:self];
    [self.modelEngineVoip queryGroupWithAsker:self.modelEngineVoip.voipAccount];
    
//    [self loadGroupData];
}

- (void)viewDidAppear:(BOOL)animated
{
    _currentCell = nil;
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _currentCell = nil;
    [super viewWillDisappear:animated];
    [self hiddenNavButton];
}

- (void)loadGroupData
{

    NSMutableDictionary *specialDict = [NSMutableDictionary dictionary];
    [specialDict setValue:@"" forKey:@"GroupName"];
    [specialDict setValue:@"" forKey:@"ChatGroupID"];
    [specialDict setValue:[NSString stringWithFormat:@"%d", pageIndex++] forKey:@"PageIndex"];
    [specialDict setValue:MAX_DATA_SIZE forKey:@"PageSize"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@%@", VALUE_API_PREFIX, API_SERVICE_GROUP, API_GROUP_GET_LIST];
    NSString *url = [ProjectAPI getURL:urlStr specialDict:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:CHAT_GROUP_LIST_TY];
    [connFacade fetchGets:url];
}

- (UISearchBar *)createSearchBar
{
    CGRect searchRect = CGRectMake(0, 0, SCREEN_WIDTH, kSearchBarHeight);
    self.m_searchBar = [[[UISearchBar alloc] initWithFrame:searchRect] autorelease];
    [m_searchBar setDelegate:self];
    [m_searchBar setBarStyle:UIBarStyleDefault];
    [m_searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    [m_searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [m_searchBar setPlaceholder:@"搜索"];
    [m_searchBar setKeyboardType:UIKeyboardTypeDefault];
    
    return self.m_searchBar;
}

- (UIButton *)setVoiceBtn
{
    float wGap = 16.0f;
    UIImage *image = [UIImage imageNamed:@"Address_voice"];
    float imgWidth = image.size.width + wGap;
    float imgHeight = image.size.height;
    
    UIButton *voiceBtn = [[UIButton alloc]init];
    [voiceBtn setBackgroundColor:[UIColor clearColor]];
    [voiceBtn setTag:222];
    [voiceBtn setAdjustsImageWhenHighlighted:NO];
    [voiceBtn setImage:image forState:UIControlStateNormal];
    [voiceBtn setBounds:CGRectMake(0,0 , imgWidth, imgHeight)];
    [voiceBtn setCenter:CGPointMake(SCREEN_WIDTH - wGap - (imgWidth - wGap)/2, kSearchBarHeight/2)];
    [voiceBtn addTarget:self action:@selector(voiceSearchClick) forControlEvents:UIControlEventTouchUpInside];
    
    return voiceBtn;
}

- (void)keyBoardHidden
{
    if ([m_searchBar isFirstResponder])
    {
        [m_searchBar resignFirstResponder];
        return;
    }
}

- (void)voiceSearchClick
{
    NSLog(@"voice  Click.....");
}

- (void)initNavButton
{
#if APP_TYPE != APP_TYPE_EMBA
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    [leftButton addTarget:self action:@selector(leftNavButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    [leftButton setBackgroundImage:[UIImage imageNamed:@"communication_bar_search.png"] forState:UIControlStateNormal];
    
    _leftButton=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [leftButton release];
    
    [_leftButton setStyle:UIBarButtonItemStyleDone];
    
    self.parentVC.navigationItem.leftBarButtonItem = _leftButton;
#endif
    
    //---------------------------------
    UIImage *img = [UIImage imageNamed:@"chatListAdd.png"];
    float width = img.size.width;
    float height = img.size.width;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.frame = CGRectMake(0, 0, width, height);
    [rightButton addTarget:self action: @selector(rightNavButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    [rightButton setBackgroundImage:img forState:UIControlStateNormal];
    _rightButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [rightButton release];
    [_rightButton setStyle:UIBarButtonItemStyleDone];

#if APP_TYPE != APP_TYPE_EMBA
    UIButton *rightPrivateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightPrivateButton.frame = CGRectMake(0, 0, 27, 27);
    [rightPrivateButton addTarget: self action: @selector(rightMessageNavButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    [rightPrivateButton setBackgroundImage:[UIImage imageNamed:@"communication_bar_message.png"] forState:UIControlStateNormal];
    
    _privateButton=[[UIBarButtonItem alloc]initWithCustomView:rightPrivateButton];
    [rightPrivateButton release];
    
    [_privateButton setStyle:UIBarButtonItemStyleDone];
#endif
    
#if APP_TYPE == APP_TYPE_EMBA
    self.parentVC.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects: _rightButton,nil];
#else
    self.parentVC.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects: _rightButton, _privateButton,nil];
#endif
    
}

- (void)hiddenNavButton
{
    self.parentVC.navigationItem.leftBarButtonItem = nil;
    self.parentVC.navigationItem.rightBarButtonItems = nil;
}

- (void)configureMOCFetchConditions {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UISearchBarDelegate method

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (m_searchBGView)
    {
         [self.m_searchBGView removeFromSuperview];
    }
    
    self.m_searchBGView = [[[UIView alloc] initWithFrame:CGRectMake(0, kSearchBarHeight, self.view.frame.size.width, self.view.frame.size.height - kSearchBarHeight)] autorelease];
    self.m_searchBGView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(cancelSearch:)] autorelease];
    [self.m_searchBGView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.m_searchBGView];
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.m_searchBGView.alpha = 0.8f;
                     }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //监控所有输入的text
    NSLog(@"search.text === %@, searchText === %@",searchBar.text,searchText);
    
    UIButton *voiceBtn = (UIButton *)[self.m_searchBar viewWithTag:222];
    if ([searchText length] > 0)
    {
        [voiceBtn setHidden:YES];
        [voiceBtn setAlpha:0.0f];
    }
    else
    {
        [voiceBtn setHidden:NO];
        [voiceBtn setAlpha:1.0f];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //监控当前输入的字符，过滤不可用字符
    NSLog(@"text == %@",text);
    UIButton *voiceBtn = (UIButton *)[self.m_searchBar viewWithTag:222];
    if (text.length > 0)
    {
        [voiceBtn setHidden:YES];
        [voiceBtn setAlpha:0.0f];
    }
    
    return YES;
}

- (void)cancelSearch:(UITapGestureRecognizer *)tapGesture
{
    [self disableSearchStatus];
    [self loadAllChatMsg];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self disableSearchStatus];
    
    if (self.chatMsgArray && [self.chatMsgArray count] > 0) {
        [self.chatMsgArray removeAllObjects];
    }
    
    @try {
        NSMutableArray *tempChatMsgArray = (NSMutableArray*)[self.modelEngineVoip.imDBAccess getIMListArrayByContent:searchBar.text];
        
        if (tempChatMsgArray && [tempChatMsgArray count] > 0)
        {
            self.chatMsgArray = [NSMutableArray array];
            for (IMConversation *msg in tempChatMsgArray) {
                if (![msg.contact isEqualToString:@"系统通知"]) {
                    //            if ([_groupIdDict objectForKey:msg.contact]) {
                    [self.chatMsgArray addObject:msg];
                }
            }
            
            [self removeEmptyMessageIfNeeded];
            self._chatListTable.alpha = 1;
            [self._chatListTable reloadData];
        } else {
            self._chatListTable.alpha = 0;
            [self displayEmptyMessage];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        
    }
    
}

- (void)disableSearchStatus
{
    
    if (self.m_searchBGView.alpha > 0.0f && m_searchBar.isFirstResponder) {
        [UIView animateWithDuration:0.2f
                         animations:^{
                             self.m_searchBGView.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             [self.m_searchBGView removeFromSuperview];
                         }];
        
        [m_searchBar resignFirstResponder];
    }
}

-(void)delayRefreshTableView
{
//    [self refreshTable];
    
    [_chatListTable setAlpha:1.0f];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
        case CHAT_GROUP_LIST_TY:
        {
        }
            break;
            
        default:
            break;
    }
    
//    [self performSelector:@selector(delayRefreshTableView) withObject:nil afterDelay:0.1f];
    
    _noNeedDisplayEmptyMsg = YES;
    
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
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [self.chatMsgArray count];
}

- (ChatListCell *)drawChatListCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ChatListCell";
    ChatListCell *cell = (ChatListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        NSMutableArray *leftUtilityButtons = nil;
        NSMutableArray *rightUtilityButtons = [[[NSMutableArray alloc]init] autorelease];
        [rightUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0] title:@"More"];
        [rightUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:@"Delete"];
        
        cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier height:kCommunicat_Cell_Height leftUtilityButtons:leftUtilityButtons rightUtilityButtons:nil/*rightUtilityButtons*/];
        cell.delegate = self;
        
        cell.contentView.backgroundColor = VIEW_BACKGROUND_COLOR_WHITE;
    }
    
    IMConversation *msg = [self.chatMsgArray objectAtIndex:indexPath.row];
    [cell updateCellInfo:msg];
    
    return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.chatMsgArray count]) {
        return [self drawFooterCell];
    } else {
        return [self drawChatListCell:tableView indexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.chatMsgArray count]) {
        return;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return (kCommunicat_Cell_Height + COMMUNICATION_GROUP_BRIEF_VIEW_BOTTOM_HEIGHT);
}

- (void)startToChat:(CommunicatViewCell *)cell chatName:(NSString*)chatName chatId:(NSString*)chatId
{

    ChatDetailViewController *vc = [[[ChatDetailViewController alloc] initWithData:chatId title:chatName MOC:_MOC] autorelease];
    
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)leftNavButtonClicked:(id)sender
{
    SearchUserByWebViewController *userSearchController = [[[SearchUserByWebViewController alloc] init] autorelease];
    [CommonMethod pushViewController:userSearchController withAnimated:YES];
}

- (void)rightNavButtonClicked:(id)sender
{
    ChatAddGroupViewController *addGroupVC =  [[[ChatAddGroupViewController alloc] initWithMOC:_MOC parentVC:self.parentVC type:CHAT_GROUP_TYPE_INFO_CREATE] autorelease];
    addGroupVC.delegate = self;
    [CommonMethod pushViewController:addGroupVC withAnimated:YES];

    /*
    float hGap = 12.5 + 64.0f;
    float wGap = 7.5f;
    float width = 114.0f;
    float height = 149.0f;
    float sGap = 10.0f;
    
    NSMutableArray *dataArr = [[[NSMutableArray alloc]initWithObjects:@"发起群聊", @"添加朋友", @"听简模式", nil]autorelease];
    NSMutableArray *tipArr = [[[NSMutableArray alloc]initWithObjects:@"Communicate_group_icon", @"Communicate_addNew_icon", @"Communicate_listenType", nil] autorelease];
    
    CGRect rect = CGRectMake(SCREEN_WIDTH - wGap - width, hGap, width, height);
    _selectView = [[SelectView alloc]initWithData:dataArr Frame:rect TipIcon:tipArr Delegate:self canScroll:NO];
    [_selectView showView];
    
    [_selectView setBackView:[UIImage imageNamed:@"Communicate_more_Bg"]];
    [_selectView._tableView setFrame:CGRectMake(0, sGap, width, height - sGap )];
     */
}

- (void)selectWithData:(NSString *)data withIndex:(int)index
{
    switch (index)
    {
        case COMMUNICAT_GROUP_TYPE:
        {
           
            ChatAddGroupViewController *addGroupVC =  [[[ChatAddGroupViewController alloc] initWithMOC:_MOC parentVC:self.parentVC type:CHAT_GROUP_TYPE_INFO_CREATE] autorelease];
            addGroupVC.delegate = self;
            [CommonMethod pushViewController:addGroupVC withAnimated:YES];
        }
            break;
            
        case COMMUNICAT_ADDNEW_TYPE:
        {
        }
            break;
            
        case COMMUNICAT_LISTEN_TYPE:
        {
        }
            break;
            
        default:
            break;
    }
}

- (void)rightMessageNavButtonClicked:(id)sender
{
}

#pragma mark - ChatListCellDelegate method
- (BOOL)notifyScroll:(ChatListCell *)cell
{
    if (_currentCell == nil) {
        _currentCell = cell;
        
        return YES;
    } else {
        [_currentCell resetCellState];
        _currentCell = nil;
        [_chatListTable reloadData];
        
        return NO;
    }
    return NO;
}

- (void)insertTableRowsViewCell:(ChatListCell *)cell index:(NSInteger)index
{
    // Insert Row
//    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    ChatListCell *cells = (ChatListCell *)[self._chatListTable cellForRowAtIndexPath:cellIndexPath];
//    
//    NSIndexPath *firstIndexpath = [_chatListTable indexPathForCell:cells];
//    
//    if (firstIndexpath) {
//    
//        [self._chatListTable insertRowsAtIndexPaths:@[firstIndexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
}

- (void)swippableTableViewCell:(ChatListCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swippableTableViewCell:(ChatListCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    
    switch (index)
    {
        case 0:
            NSLog(@"More button was pressed");
            break;
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self._chatListTable indexPathForCell:cell];
            
            [self.chatMsgArray removeObjectAtIndex:cellIndexPath.row];
            [self._chatListTable deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            // TODO 退出群组
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - ChatGroupDetailViewControllerDelegate
- (void)deleteSuccessfulGroupFromNewCreate:(NSNotification *)note
{
}

- (void)quiteSuccessfulGroupFromNewCreate:(NSNotification *)note
{
}

- (void)deleteSuccessfulGroup:(int)groupId
{
}

- (void)removeUserFromGroup:(IMGroupInfo *)dataModal userId:(int)userId
{
    
}

#pragma mark - private method
- (void)creatNewGroup
{
//    CreateGroupViewController *view = [[CreateGroupViewController alloc] init];
//    view.backView = self;
//    [self.navigationController pushViewController:view animated:YES];
//    [view release];
}

- (void)displayMyJoinGroups:(id)sender
{
    self.titleImgView.image = [UIImage imageNamed:@"title_button_01.png"];
    UIView* tmpview = [self.view viewWithTag:TAG_TABLEVIEW_MYJOINGROUP];
    [self.view bringSubviewToFront:tmpview];
}

- (void)displayPublicGroups:(id)sender
{
    self.titleImgView.image = [UIImage imageNamed:@"title_button_02.png"];
    UIView* tmpview = [self.view viewWithTag:TAG_TABLEVIEW_PUBLICGROUP];
    [self.view bringSubviewToFront:tmpview];
}

#pragma mark - ModelEngineUIDelegate method
//查询群组回调
- (void)onGroupQueryGroupWithReason:(CloopenReason*) reason andGroup:(IMGroupInfo*) group
{
}

//获取公共群组回调
-(void)onGroupQueryPublicGroupsWithReason:(CloopenReason*)reason andGroups:(NSArray *)groups
{
    if (reason.reason == 0)
    {
        [self.modelEngineVoip.imDBAccess insertOrUpdateGroupInfos:groups];
    } else {
        [self popPromptViewWithMsg:[NSString stringWithFormat:@"错误码：%d,错误详情：%@",reason.reason,reason.msg]];
    }
}

//查询成员加入的群组
- (void)onMemberQueryGroupWithReason:(CloopenReason*)reason andGroups:(NSArray *)groups
{
    if (reason.reason == 0)
    {
        [self.modelEngineVoip.imDBAccess insertOrUpdateGroupInfos:groups];
    } else {
        [self popPromptViewWithMsg:[NSString stringWithFormat:@"错误码：%d,错误详情：%@",reason.reason,reason.msg]];
    }
    
    if (groups && [groups count] > 0) {
        
        for (IMGroupInfo *imGroup in groups)
        {
            [_groupIdDict setObject:imGroup.groupId forKey:imGroup.groupId];
        }
    }
    
    [self loadAllChatMsg];
}

- (void)responseMessageStatus:(EMessageStatusResult)event callNumber:(NSString *)callNumber data:(NSString *)data
{
    switch (event)
	{
        case EMessageStatus_Received:
        {
//            [self.modelEngineVoip queryGroupWithAsker:self.modelEngineVoip.voipAccount];
//            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
//            NSTimeInterval tmp = [date timeIntervalSince1970]*1000;
//            NSString *timeString = [NSString stringWithFormat:@"%lld", (long long)tmp];//转为字符型
//            [self.modelEngineVoip queryPublicGroupsWithLastUpdateTime:timeString];
            
            [self.modelEngineVoip queryGroupWithAsker:self.modelEngineVoip.voipAccount];
            
//            self.chatMsgArray = (NSMutableArray*)[self.modelEngineVoip.imDBAccess getIMListArray];
//            // TODO 新建群发来的消息的处理
//            [self._chatListTable reloadData];
//            self._chatListTable.alpha = 1;
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
            self.chatMsgArray = (NSMutableArray*)[self.modelEngineVoip.imDBAccess getIMListArray];
            [self._chatListTable reloadData];
        }
            break;
        default:
            break;
    }
}

- (void)responseIMGroupNotice:(NSString*)groupId data:(NSString *)data
{
    NSLog(@"responseIMGroupNotice:groupid=%@,data=%@",groupId,data);
    self.chatMsgArray = (NSMutableArray*)[self.modelEngineVoip.imDBAccess getIMListArray];
    [self._chatListTable reloadData];
}

- (void)chatListTapped:(UISwipeGestureRecognizer *)recognizer
{
    [_currentCell resetCellState];
}

- (void)loadAllChatMsg {
    NSMutableArray *tempChatMsgArray = (NSMutableArray*)[self.modelEngineVoip.imDBAccess getIMListArray];
    
    if (tempChatMsgArray && [tempChatMsgArray count]>0) {
        self.chatMsgArray = [NSMutableArray array];
        for (IMConversation *msg in tempChatMsgArray) {
            if (![msg.contact isEqualToString:@"系统通知"]) {
//            if ([_groupIdDict objectForKey:msg.contact]) {
                [self.chatMsgArray addObject:msg];
            }
        }
        [self removeEmptyMessageIfNeeded];
        [self.modelEngineVoip downloadPreIMMsg];
        self._chatListTable.alpha = 1;
        [self._chatListTable reloadData];
    } else {
        self._chatListTable.alpha = 0;
        [self displayEmptyMessage];
    }
}

@end
