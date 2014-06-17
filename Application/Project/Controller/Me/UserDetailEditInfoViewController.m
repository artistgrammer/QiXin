
#import <QuartzCore/QuartzCore.h>
#import "UserDetailEditInfoViewController.h"
#import "CommonHeader.h"
#import "GCPlaceholderTextView.h"

@interface UserDetailEditInfoViewController () <UITextViewDelegate, UITextFieldDelegate>

@end

@implementation UserDetailEditInfoViewController {
    
    UIView *_backgroundView;
    UITextView *_contentTextView;
    
    int _marginX;
    int _marginY;
    int _distY;
    
    UITextField *_nameTextField;
    UserObject *_userObject;
    
    UIBarButtonItem *_rightButton;
    
    
	UILabel *_characterCountLabel;
    int _macCharacterCount;
}

@synthesize delegate = _delegate;

- (id)initWithDataModal:(UserObject *)dataModal
{
    if (self = [super init]) {
        
        _userObject = dataModal;
        
        [self initData];
    }
    
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    self.navigationItem.title = self.title;
    [CommonMethod viewAddGuestureRecognizer:self.view withTarget:self withSEL:@selector(viewTapped:)];
    _macCharacterCount = 200;
    
    [self initNavButton];
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

- (void)loadUpdateChatGroup:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    NSMutableDictionary *specialDict = [NSMutableDictionary dictionary];
    
    switch (self.type) {
            
        case USER_PROPERTY_EMAIL:
            if (_contentTextView.text)
                _userObject.userEmail = _contentTextView.text;
            break;
            
        case USER_PROPERTY_PHONE:
            if (_contentTextView.text)
                _userObject.userTel = _contentTextView.text;
            break;

        default:
            break;
    }
    
    [specialDict setValue:_userObject.userEmail forKey:@"UserEmail"];
    [specialDict setValue:_userObject.userTel forKey:@"UserTelephone"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@%@", VALUE_API_PREFIX, API_SERVICE_USER, API_MODIFY_USER_INFO];
    NSString *url = [ProjectAPI getURL:urlStr specialDict:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:CHAT_GROUP_UPDATE_TY];
    [connFacade fetchGets:url];
}


- (void)rightNavButtonClicked:(id)sender
{
    [self loadUpdateChatGroup:TRIGGERED_BY_AUTOLOAD forNew:YES];
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

- (void)initData
{
    _marginX = 0;
    _marginY = 10;
    _distY = 10;

    int startX = _marginX;
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
    _contentTextView.backgroundColor = TRANSPARENT_COLOR;
    
    [_backgroundView addSubview:_contentTextView];
    
    _characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _contentTextView.frame.origin.y + _contentTextView.frame.size.height - 10, _contentTextView.frame.size.width, 30)];
    [_characterCountLabel setFont:FONT_SYSTEM_SIZE(14)];
    _characterCountLabel.textAlignment = UITextAlignmentRight;
    _characterCountLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    [_backgroundView  addSubview:_characterCountLabel];
    //------------------------------------------------------
    
    CGRect rect = _backgroundView.frame;
    rect.size.height = _contentTextView.frame.origin.y + _contentTextView.frame.size.height + _distY;
    _backgroundView.frame = rect;
    //------------------------------------------------------
    [self changeTextViewHeight:_contentTextView];
    
    [self.view addSubview:_backgroundView];
    [_backgroundView release];
    
    switch (self.type) {
        case USER_PROPERTY_PHONE:
            _contentTextView.text = _userObject.userTel;
            _macCharacterCount = GROUP_PROPERTY_MAX_COUNT_PHONE;
            break;
            
        case USER_PROPERTY_EMAIL:
            _contentTextView.text = _userObject.userEmail;
            _macCharacterCount = GROUP_PROPERTY_MAX_COUNT_EMAIL;
            break;
        
        case USER_PROPERTY_TEL:
            _contentTextView.text = _userObject.userCellphone;
            _macCharacterCount = GROUP_PROPERTY_MAX_COUNT_EMAIL;
            break;
            
        default:
            break;
    }
    
	[_characterCountLabel setText:[NSString stringWithFormat:@"%d/%d",  _contentTextView.text.length, _macCharacterCount]];
    
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
                
                [[ProjectDBManager instance] insertOrUpdateUserInfos:_userObject];
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
