
#import <QuartzCore/QuartzCore.h>
#import "ChatGroupDetailInfoViewController.h"
#import "CommonHeader.h"
#import "GCPlaceholderTextView.h"

@interface ChatGroupDetailInfoViewController () <UITextViewDelegate, UITextFieldDelegate>

@end

@implementation ChatGroupDetailInfoViewController {
    UIView *_backgroundView;
    UITextView *_contentTextView;
    
    int _marginX;
    int _marginY;
    int _distY;
    
    UITextField *_nameTextField;
    ChatGroupModel *_dataModal;
    
    UIBarButtonItem *_rightButton;
    
    
	UILabel *_characterCountLabel;
    int _macCharacterCount;
}

@synthesize delegate = _delegate;

- (id)initWithDataModal:(ChatGroupModel *)dataModal
{
    if (self = [super init]) {
        
        _dataModal = dataModal;
        
        [self initData];
    }
    
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //    self.view.backgroundColor = [UIColor colorWithHexString:@"e5ddd2"];
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    self.navigationItem.title = self.title;
    [CommonMethod viewAddGuestureRecognizer:self.view withTarget:self withSEL:@selector(viewTapped:)];
    _macCharacterCount = 200;
    
    if ([_dataModal isAdmin])
        [self initNavButton];
}

- (UITextView *)commentView:(CGRect)rect {
    
    GCPlaceholderTextView *textView = [[[GCPlaceholderTextView alloc] initWithFrame:rect] autorelease];
    textView.delegate = self;
    textView.showsHorizontalScrollIndicator = NO;
    textView.backgroundColor = TRANSPARENT_COLOR;
    //    textView.placeholder = @"请输入评论内容，不超过500字。";
    textView.font = FONT_SYSTEM_SIZE(14);
    textView.scrollEnabled = YES;
    //    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    return textView;
}

- (void)initNavButton
{
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc]
                                initWithTitle:@"保存"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(rightNavButtonClicked:)];
    self.navigationItem.rightBarButtonItem = btnSave;
    [btnSave release];
}

/*
 groupId			群组ID
 groupName		群组名称
 groupImage		群组图片
 groupDescription		群组简介
 groupPhone		群组电话
 groupEmail		群组邮箱
 groupWebsite	群组网址
 invitationPublicLevel			添加新成员权限级别（0：非公开，仅管理员可添加；1：公开，成员可添加）
 */
- (void)loadUpdateChatGroup:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    NSMutableDictionary *specialDict = [NSMutableDictionary dictionary];
    
    switch (self.type) {
        case GROUP_PROPERTY_TYPE_NAME:
            if (_contentTextView.text)
                _dataModal.groupName = _contentTextView.text;
            break;
        case GROUP_PROPERTY_BRIEF:
            if (_contentTextView.text)
                _dataModal.groupDescription = _contentTextView.text;
            break;
        case GROUP_PROPERTY_PHONE:
            if (_contentTextView.text)
                _dataModal.groupPhone = _contentTextView.text;
            break;
        case GROUP_PROPERTY_EMAIL:
            if (_contentTextView.text)
                _dataModal.groupEmail = _contentTextView.text;
            break;
        case GROUP_PROPERTY_WEBSITE:
            if (_contentTextView.text)
                _dataModal.groupWebsite = _contentTextView.text;
            break;
        default:
            break;
    }
    
    [specialDict setValue:_dataModal.groupName forKey:@"GroupName"];
    [specialDict setValue:_dataModal.groupDescription forKey:@"Description"];
    [specialDict setValue:_dataModal.groupId forKey:@"ChatGroupID"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@%@", VALUE_API_PREFIX, API_SERVICE_GROUP, API_GROUP_UPDATE];
    NSString *url = [ProjectAPI getURL:urlStr specialDict:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:CHAT_GROUP_UPDATE_TY];
    [connFacade fetchGets:url];
}


- (void)rightNavButtonClicked:(id)sender
{
    [self loadUpdateChatGroup:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

- (void)initData
{
    _marginX = 10;
    _marginY = 10;
    _distY = 10;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    [_nameTextField resignFirstResponder];
}

- (void)updateInfo:(ChatGroupModel *)groupInfo
{
    int startX = 0;
    int startY = _marginY + ITEM_BASE_TOP_VIEW_HEIGHT;
    int width = SCREEN_WIDTH - 2*startX;
    int height = SCREEN_HEIGHT;
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    _backgroundView.layer.cornerRadius = 0.0f;
    _backgroundView.backgroundColor = [UIColor whiteColor];
    
    //------------------------------------------------------
    startY = _marginY;
    width = _backgroundView.frame.size.width - 2*startX;
    height = 40;
    
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    _contentTextView.font = FONT_SYSTEM_SIZE(15);
    _contentTextView.delegate = self;
    _contentTextView.textColor = [UIColor darkGrayColor];
    _contentTextView.text = _dataModal.groupDescription;
    _contentTextView.backgroundColor = TRANSPARENT_COLOR;
    
    [_backgroundView addSubview:_contentTextView];
    
    _characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _contentTextView.frame.origin.y + _contentTextView.frame.size.height - 10, _contentTextView.frame.size.width, 30)];
    [_characterCountLabel setFont:FONT_SYSTEM_SIZE(14)];
    _characterCountLabel.textAlignment = UITextAlignmentRight;
    _characterCountLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    [_backgroundView  addSubview:_characterCountLabel];
    
    if (![_dataModal isAdmin]) {
        _contentTextView.editable = NO;
    }
    
    //------------------------------------------------------
    
    CGRect rect = _backgroundView.frame;
    rect.size.height = _contentTextView.frame.origin.y + _contentTextView.frame.size.height + _distY;
    _backgroundView.frame = rect;
    //------------------------------------------------------
    [self changeTextViewHeight:_contentTextView];
    
    [self.view addSubview:_backgroundView];
    [_backgroundView release];
    
    
    switch (self.type) {
        case GROUP_PROPERTY_TYPE_NAME:
            _contentTextView.text = _dataModal.groupName;
            _macCharacterCount = GROUP_PROPERTY_MAX_COUNT_NAME;
            break;
            
        case GROUP_PROPERTY_BRIEF:
            _contentTextView.text = _dataModal.groupDescription;
            _macCharacterCount = GROUP_PROPERTY_MAX_COUNT_BRIEF;
            break;
            
        case GROUP_PROPERTY_PHONE:
            _contentTextView.text = _dataModal.groupPhone;
            _macCharacterCount = GROUP_PROPERTY_MAX_COUNT_PHONE;
            break;
            
        case GROUP_PROPERTY_EMAIL:
            _contentTextView.text = _dataModal.groupEmail;
            _macCharacterCount = GROUP_PROPERTY_MAX_COUNT_EMAIL;
            break;
            
        case GROUP_PROPERTY_WEBSITE:
            _contentTextView.text = _dataModal.groupWebsite;
            _macCharacterCount = GROUP_PROPERTY_MAX_COUNT_WEBSITE;
            break;
            
        default:
            break;
    }
    
	[_characterCountLabel setText:[NSString stringWithFormat:@"%d/%d",  _contentTextView.text.length,_macCharacterCount]];
    
    [self changeTextViewHeight:_contentTextView];
}

-(void)updateCharacterCount
{
    
    CGRect rect = _characterCountLabel.frame;
    rect.origin.y =_backgroundView.frame.origin.y + _backgroundView.frame.size.height - 10;
    _characterCountLabel.frame = rect;
}

#pragma mark -- text field delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
        case CHAT_GROUP_UPDATE_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            if (ret == SUCCESS_CODE) {
                SAVE_MOC(_MOC);
                
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(@"更新成功", nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
                [self back:nil];
            }
            
            break;
        }
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
}

#pragma mark - uitextview delegate

-(void)changeTextViewHeight:(UITextView *)textView
{
    CGRect frame = textView.frame;
    CGSize size = [textView.text sizeWithFont:textView.font
                            constrainedToSize:CGSizeMake(280, 1000)
                                lineBreakMode:UILineBreakModeTailTruncation];
    frame.size.height = size.height > 1 ? size.height + 20 : 64;
    
    if (frame.size.height < 200) {
        
        textView.frame = frame;
        
        CGRect rect = _backgroundView.frame;
        rect.size.height = textView.frame.origin.y + textView.frame.size.height + _distY;
        _backgroundView.frame = rect;
    }
    
    [self updateCharacterCount];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location < _macCharacterCount) {
        return YES;
    }
    int count = _macCharacterCount - [[textView text] length];
    if (count <= 0)
        return NO;
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    // Update the character count
	int count = _macCharacterCount - [[textView text] length];
    if (count < 0) {
        textView.text = [textView.text substringToIndex:_macCharacterCount];
        count = 0;
    }
	[_characterCountLabel setText:[NSString stringWithFormat:@"%d/%d", _macCharacterCount - count,_macCharacterCount]];
    
    [self changeTextViewHeight:textView];
}

@end
