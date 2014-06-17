
#import "UserLoginViewController.h"
#import "CommonHeader.h"
#import "AppManager.h"
#import "GlobalConstants.h"
#import "TextPool.h"
#import "GlobalConstants.h"
#import "ProjectAPI.h"
#import "JSONParser.h"
#import "CommonUtils.h"
#import "JSONKit.h"
#import "ProjectDBManager.h"
#import "CircleMarkegingApplyWindow.h"
#import "WXWCustomeAlertView.h"
#import "UnderlinedButton.h"
#import "UIWebViewController.h"

@interface UserLoginViewController () <WXWConnectorDelegate, UITextFieldDelegate, CircleMarkegingApplyWindowDelegate>

@end

@implementation UserLoginViewController {
    UIButton *_registerButton;
    UIButton *_loginButton;
    
    UITextField *_companyName;
    UITextField *_userName;
    UITextField *_userPassword;
    //    TPKeyboardAvoidingScrollView *_tpKeyboardAvoidingScrollView;
    
    BOOL  _isAutoLogin;
}

#pragma mark - life cycle methods
- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC {
    
    self = [super initWithMOC:MOC];{
        
        [CommonMethod getInstance].MOC = _MOC;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = DEFAULT_VIEW_COLOR;
        
        [self initControls:self.view];

        [CommonMethod viewAddGuestureRecognizer:self.view withTarget:self withSEL:@selector(viewTapped:)];
        [CommonMethod viewAddGuestureRecognizer:_loginButton withTarget:self withSEL:@selector(loginButtonTapped:)];
        [CommonMethod viewAddGuestureRecognizer:_registerButton withTarget:self withSEL:@selector(registerButtonTapped:)];
        [self initLisentingKeyboard];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_loginButton setEnabled:YES];
    [super viewDidAppear:animated];
}


- (void)dealloc
{
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initControls:(UIView *)parentView
{
    
    UIImageView *bgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)] autorelease];
    bgView.image = [UIImage imageNamed:(@"login_bg.png")];
    
    CGSize size = [[HardwareInfo getInstance] getScreenSize];
    int width = 106;
    int height = 45;
    int startX = (size.width - width ) / 2.0f;
    int startY = 102;
    
    int inputLogoRegionWidth = 46;
    int inputLogoRegionHeight = 47;
    
//    UIImageView *logiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
//    
//    logiImageView.image = IMAGE_WITH_IMAGE_NAME(@"login_logo.png");
//    startY = 20;
//    logiImageView.frame = CGRectMake((320-140)/2, startY, 140, 140);
//
//    
//    [parentView addSubview:logiImageView];
//    [logiImageView release];
    
    //92-95
    width = 266;
    height = 48;
    startX = (SCREEN_WIDTH - width ) / 2.0f;
    startY += height  + 20;
    
    UIImageView *customImageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    customImageViewLogo.image = IMAGE_WITH_IMAGE_NAME(@"o2o_login_customer");
    
    [parentView addSubview:customImageViewLogo];
    [customImageViewLogo release];
    
    //-----------------------------username input------------------------------------
    startX = customImageViewLogo.frame.origin.x +inputLogoRegionWidth - 5;
    startY = customImageViewLogo.frame.origin.y;
    width = customImageViewLogo.frame.size.width - inputLogoRegionWidth;
    height = inputLogoRegionHeight;
    
    _companyName = [[UITextField alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    _companyName.backgroundColor = [UIColor clearColor];
    _companyName.borderStyle = UITextBorderStyleNone;
    _companyName.placeholder = LocaleStringForKey(NSLoginCustomer, nil);
    [_companyName setClearButtonMode:UITextFieldViewModeWhileEditing];
    _companyName.textAlignment = NSTextAlignmentLeft;
    _companyName.delegate = self;
    _companyName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_companyName setTextColor:[UIColor lightGrayColor]];
    
    _companyName.leftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)] autorelease];
    _companyName.leftView.userInteractionEnabled = NO;
    _companyName.leftViewMode = UITextFieldViewModeAlways;
    
    [parentView addSubview:_companyName];
    
    //92-95
    width = 266;
    height = 48;
    startX = (SCREEN_WIDTH - width ) / 2.0f;
    UIImageView *userNameImageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    userNameImageViewLogo.image = IMAGE_WITH_IMAGE_NAME(@"login_username");
    
    [parentView addSubview:userNameImageViewLogo];
    [userNameImageViewLogo release];
    
    //-----------------------------username input------------------------------------
    startX = userNameImageViewLogo.frame.origin.x +inputLogoRegionWidth - 5;
    startY =userNameImageViewLogo.frame.origin.y;
    width =userNameImageViewLogo.frame.size.width - inputLogoRegionWidth;
    height =inputLogoRegionHeight;
    
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    _userName.backgroundColor = [UIColor clearColor];
    _userName.borderStyle = UITextBorderStyleNone;
    _userName.placeholder = LocaleStringForKey(NSLoginUserName, nil);
    [_userName setClearButtonMode:UITextFieldViewModeWhileEditing];
    _userName.textAlignment = NSTextAlignmentLeft;
    _userName.delegate = self;
    _userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [_userName setFont:FONT_SYSTEM_SIZE(16)];
    [_userName setTextColor:[UIColor lightGrayColor]];

    _userName.leftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)] autorelease];
    _userName.leftView.userInteractionEnabled = NO;
    _userName.leftViewMode = UITextFieldViewModeAlways;
    
    [parentView addSubview:_userName];
    
    //92-95
    width = 266;
    height = 48;
    startX = (SCREEN_WIDTH - width ) / 2.0f;
    startY += userNameImageViewLogo.frame.size.height + 3;
    
    UIImageView *passwordImageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    passwordImageViewLogo.image = IMAGE_WITH_IMAGE_NAME(@"login_password.png");
    
    [parentView addSubview:passwordImageViewLogo];
    [passwordImageViewLogo release];
    
    
    //----------------------password-------------------------------------------
    startX = passwordImageViewLogo.frame.origin.x + inputLogoRegionWidth - 5;
    startY = passwordImageViewLogo.frame.origin.y;
    width  = passwordImageViewLogo.frame.size.width - inputLogoRegionWidth;
    height = inputLogoRegionHeight;
    
    _userPassword = [[UITextField alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    _userPassword.backgroundColor = [UIColor clearColor];
    _userPassword.borderStyle = UITextBorderStyleNone;
    _userPassword.placeholder = LocaleStringForKey(NSLoginPassword, nil);
    [_userPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    _userPassword.secureTextEntry = YES;
    _userPassword.delegate = self;
    _userPassword.textAlignment = NSTextAlignmentLeft;
    _userPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_userName setTextColor:[UIColor lightGrayColor]];
    
    _userPassword.leftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)] autorelease];
    _userPassword.leftView.userInteractionEnabled = NO;
    _userPassword.leftViewMode = UITextFieldViewModeAlways;
    
    [parentView addSubview:_userPassword];
    
    UnderlinedButton *forgetPwdButton = [[UnderlinedButton alloc] initWithFrame:CGRectMake(passwordImageViewLogo.frame.origin.x + passwordImageViewLogo.frame.size.width - 60 - 3, passwordImageViewLogo.frame.origin.y + passwordImageViewLogo.frame.size.height +5, 60, 15)];
    forgetPwdButton.titleLabel.font = FONT_SYSTEM_SIZE(12);
    
    [forgetPwdButton setTitleColor:BASE_INFO_COLOR forState:UIControlStateNormal];
    
    [forgetPwdButton setTitle:LocaleStringForKey(NSLoginPSWDTitle, nil)
                      forState:UIControlStateNormal];
    
    [forgetPwdButton addTarget:self
                         action:@selector(forgetPasswordButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    
    forgetPwdButton.backgroundColor = TRANSPARENT_COLOR;
    [self.view addSubview:forgetPwdButton];
    
    //---------------------login button
    startX = passwordImageViewLogo.frame.origin.x;
    startY = forgetPwdButton.frame.origin.y + forgetPwdButton.frame.size.height + 5 ;
    width = passwordImageViewLogo.frame.size.width;
    height = inputLogoRegionHeight;
    
    // register
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame = CGRectMake(startX, startY, 80, height);
    [_registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_registerButton setTitle:LocaleStringForKey(NSLoginRegister, nil) forState:UIControlStateNormal];
    [_registerButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [_registerButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"login_btn") forState:UIControlStateNormal];
    [_registerButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"login_btn_sel") forState:UIControlStateHighlighted];
    [parentView addSubview:_registerButton];
    
    // login
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = CGRectMake(startX + 80 + 15, startY, 260 - 80 - 10, height);
    [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setTitle:LocaleStringForKey(NSLoginLogin, nil) forState:UIControlStateNormal];
    [_loginButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"login_btn") forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"login_btn_sel") forState:UIControlStateHighlighted];
    [parentView addSubview:_loginButton];

}

- (void)autoLogin
{
    _userName.text = [[AppManager instance].userDefaults usernameRemembered];
    NSString *md5Password = [[AppManager instance].userDefaults passwordRemembered];
    if (_userName.text.length > 0 && md5Password.length > 0) {
        [self startLogin:_userName.text withPassword:md5Password];
        
        [[AppManager instance].userDefaults rememberUsername:[[AppManager instance].userDefaults usernameRemembered] andPassword:[[AppManager instance].userDefaults passwordRemembered] customerName:@""];
        _isAutoLogin = TRUE;
        return;
    }
    
    [self bringToFront];
}

- (void)bringToFront
{
    self.view.hidden = NO;
    ProjectAppDelegate *delegate = (ProjectAppDelegate *)APP_DELEGATE;
    [delegate.window addSubview:self.view];
    [delegate.window bringSubviewToFront:self.view];
}

- (BOOL)checkFields {
    if (0 == _userName.text.length ||
        0 == _userPassword.text.length) {
        ShowAlert(nil, nil, LocaleStringForKey(NSSignInInfoMandatoryMsg, nil), LocaleStringForKey(NSIKnowTitle, nil));
        
        return NO;
    }
    
    return YES;
}

- (void)registerButtonClicked:(id)sender
{
    UIWebViewController *webVC = [[[UIWebViewController alloc] init] autorelease];
    UINavigationController *webViewNav = [[[UINavigationController alloc] initWithRootViewController:webVC] autorelease];
    webViewNav.navigationBar.tintColor = TITLESTYLE_COLOR;
    webVC.strUrl = [NSString stringWithFormat:@"http://112.124.68.147:9004/HtmlApps/html/special/embaunion/new_adduserinfo.html?customerId=%@&openId=123", CUSTOMER_ID];
    webVC.strTitle = @"注册";
    
    [self presentViewController:webViewNav animated:YES completion:nil];
}


- (void)loginButtonClicked:(id)sender
{
    
    if (!_userName.text.length) {
        [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:LocaleStringForKey(NSLoginUserNameEmpty, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
        return;
    }
    if (!_userPassword.text.length) {
        [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:LocaleStringForKey(NSLoginPasswordEmpty, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
        return;
    }
    
    [self startLogin:_userName.text
        withPassword:[CommonMethod hashStringAsMD5:_userPassword.text]];

}

- (void)startLogin:(NSString *)customerName userName:(NSString *)userName password:(NSString *)password {
    [_loginButton setEnabled:NO];
    
    NSDictionary *common = [AppManager instance].common;
    NSMutableDictionary *mCommon = [NSMutableDictionary dictionaryWithDictionary:common];
    
    
    if (![IPHONE_SIMULATOR isEqualToString:[WXWCommonUtils deviceModel]])
        [mCommon setObject:[AppManager instance].deviceToken forKey:@"deviceToken"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_companyName.text forKey:@""];
    
    [dict setValue:_userName.text forKey:@"loginName"];
    //    [dict setValue:[CommonMethod hashStringAsMD5:_userPassword.text] forKey:@"password"];
    [dict setValue:password forKey:@"password"];
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:mCommon forKey:@"common"];
    [requestDict setObject:dict forKey:@"special"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_USER_DEL,API_NAME_USER_SIGN_IN];
    
    
    _currentType = USER_LOGIN_TY;
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:urlString
                                                              contentType:_currentType];
    
    [connFacade post:urlString data:[requestDict JSONData]];
}

- (void) startLogin:(NSString *)userName withPassword:(NSString *)password
{
    
    [_loginButton setEnabled:NO];
    
    NSDictionary *common = [AppManager instance].common;
    NSMutableDictionary *mCommon = [NSMutableDictionary dictionaryWithDictionary:common];
    
    
    if (![IPHONE_SIMULATOR isEqualToString:[WXWCommonUtils deviceModel]])
        [mCommon setObject:[AppManager instance].deviceToken forKey:@"deviceToken"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    
    [dict setValue:_userName.text forKey:@"loginName"];
    //    [dict setValue:[CommonMethod hashStringAsMD5:_userPassword.text] forKey:@"password"];
    [dict setValue:password forKey:@"password"];
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:mCommon forKey:@"common"];
    [requestDict setObject:dict forKey:@"special"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_USER_DEL,API_NAME_USER_SIGN_IN];
    
    
    _currentType = USER_LOGIN_TY;
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:urlString
                                                              contentType:_currentType];
    
    [connFacade post:urlString data:[requestDict JSONData]];
}

- (void)forgetPasswordButtonClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FORGET_PASSWORD_LINK]];
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    [self selfResignFirstResponder];
}


- (void)loginButtonTapped:(UISwipeGestureRecognizer *)recognizer
{
    [self loginButtonClicked:nil];
}

- (void)registerButtonTapped:(UISwipeGestureRecognizer *)recognizer
{
    [self registerButtonClicked:nil];
}


- (void)selfResignFirstResponder
{
    [_companyName resignFirstResponder];
    [_userName resignFirstResponder];
    [_userPassword resignFirstResponder];
}

- (void)initLisentingKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    

#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}

#pragma mark -- keyboard show or hidden
-(void) autoMovekeyBoard: (float) h withDuration:(float)duration{
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        CGRect rect = self.view.frame;
        int height = (rect.origin.y == SYSTEM_STATUS_BAR_HEIGHT ? 60 : 0);
        if (h) {
            rect.origin.y -= height;
            self.view.frame = rect;
        }else{
            
            rect.origin.y = ([CommonMethod is7System] ? 0 : 0);
            self.view.frame = rect;
        }
        
    } completion:^(BOOL finished) {
        // stub
    }];
    
}

#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
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
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self autoMovekeyBoard:keyboardRect.size.height withDuration:animationDuration];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    [self autoMovekeyBoard:0 withDuration:animationDuration];
}

- (void)hideKeyboard {
    
    //[self.inputToolbar.textView resignFirstResponder];
    //keyboardIsVisible = NO;
    //[self moveInputBarWithKeyboardHeight:0.0 withDuration:0.0];
}


#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    //    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
       
        case USER_LOGIN_TY:
        {
            [self selfResignFirstResponder];
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                NSDictionary *resultDict = [result objectFromJSONData];
                NSDictionary *dict = [resultDict objectForKey:@"content"];
                
                NSString *updateURL = [dict objectForKey:@"updateURL"];
                if (!updateURL || [updateURL isEqual:[NSNull null]] || [updateURL isEqual:@"<null>"]) {
                    
                }else{
                    [AppManager instance].updateURL = updateURL;
                    DLog(@"%@", [AppManager instance].updateURL);
                }
                
                
                NSString *isMandatory = [dict objectForKey:@"IsMandatory"];
                if (!isMandatory || [isMandatory isEqual:[NSNull null]] || [isMandatory isEqual:@"<null>"]) {
              
                }else{
                    [AppManager instance].isMandatory = [isMandatory integerValue];
                    DLog(@"%d", [AppManager instance].isMandatory);
                    
                    if ([AppManager instance].isMandatory == 1) {
                        CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
                        [customeAlertView setMessage:@"有版本更新，您必须更新后才可使用。"
                                               title:@"温馨提示"];
                        customeAlertView.applyDelegate = self;
                        [customeAlertView show];
                    }
                }
                
                [[AppManager instance] updateLoginSuccess:dict];
                
                if ([[AppManager instance].isLoginLicall isEqualToString:@"0"]) {
                    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                    [dict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
                    [dict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
                    
                    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_CHAT_GROUP withApiName:API_NAME_SET_USER_LOGIN_LICALL withCommon:[AppManager instance].common  withSpecial:dict];
                    
                    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                                              contentType:SET_USER_LOGIN_LICALL];
                    [connFacade fetchGets:url];
                    
                    return;
                }
                
                if (_isAutoLogin)
                {
                    [[AppManager instance].userDefaults rememberUsername:_userName.text andPassword:[[AppManager instance].userDefaults passwordRemembered] customerName:@""];
                }else{

                    [[AppManager instance].userDefaults rememberUsername:_userName.text andPassword:[CommonMethod hashStringAsMD5:_userPassword.text] customerName:@""];
                }
                
                [self loadDataUserProfile];
                
            } else if (ret == CUSTOMER_NAME_ERR_CODE){
                [self bringToFront];
                [[[[UIAlertView alloc]initWithTitle:LocaleStringForKey(NSCommonError, nil) message:LocaleStringForKey(NSLoginErrorCustomer, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
            }else if (ret == USERNAME_ERR_CODE){
                [self bringToFront];
                [[[[UIAlertView alloc]initWithTitle:LocaleStringForKey(NSCommonError, nil) message:LocaleStringForKey(NSLoginErrorUserName, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
                
            }else if (ret == PASSWORD_ERR_CODE){
                [self bringToFront];
                [[[[UIAlertView alloc]initWithTitle:LocaleStringForKey(NSCommonError, nil) message:LocaleStringForKey(NSLoginErrorPassword, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
                
            }else if (ret == ACCOUNT_INVALID_CODE){
                [self bringToFront];
                [[[[UIAlertView alloc]initWithTitle:LocaleStringForKey(NSCommonError, nil) message:LocaleStringForKey(NSLoginErrorIDIllegal, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
                
            }else if (ret == DB_ERROR_CODE){
                [self bringToFront];
                [[[[UIAlertView alloc]initWithTitle:LocaleStringForKey(NSCommonError, nil) message:LocaleStringForKey(NSLoginErrorDB, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
                
            }else {
                [self bringToFront];
                [[[[UIAlertView alloc]initWithTitle:LocaleStringForKey(NSCommonError, nil) message:LocaleStringForKey(@"", nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
                
            }
            
            break;
        }
            
        case GET_USER_PROFILES: {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDic = [result objectFromJSONData];
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                NSDictionary *contentDict = [resultDic objectForKey:@"content"];
                if (contentDict) {
                    NSArray *userListArr = [contentDict objectForKey:@"userList"];
                    
                    if (![userListArr isEqual:[NSNull null]] && userListArr.count) {
                        for (int i = 0; i < userListArr.count; i++) {
                            NSDictionary *deltaDic = [userListArr objectAtIndex:i];
                            DLog(@"%d", [[deltaDic objectForKey:@"userID"] integerValue]);
                            
                            UserProfile *userProfile =[CommonMethod formatUserProfileWithParm:deltaDic];
                            [[AppManager instance].userDM.userProfiles addObject:userProfile];
                            
                            //保存用户到DB
                            [[ProjectDBManager instance] insertOrUpdateUserInfos:[CommonMethod userBaseInfoWithDictUserProfile:userProfile] timestamp:[timestamp doubleValue]];
                            [[ProjectDBManager instance] upinsertUserProfile:userProfile];
                        }
                    }
                }
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccessful:)]) {
                [self.delegate loginSuccessful:self];
            }
        }
            break;
            
        case SET_USER_LOGIN_LICALL:
            break;
        default:
            break;
    }
    
    [_loginButton setEnabled:YES];
    
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeSplash)]) {
        [self.delegate closeSplash];
    }
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
}

#pragma mark -- text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -- circle marketing delegate
- (void)circleMarkegingApplyWindowCancelDismiss:(CircleMarkegingApplyWindow *) alertView {
    
    [alertView release];
    exit(0);
}

- (void)circleMarkegingApplyWindowDismiss:(CircleMarkegingApplyWindow *)alertView applyList:(NSArray *)applyArray {
    [alertView release];
    
    
    [CommonMethod update:[AppManager instance].updateURL];
    
    exit(0);
}

#pragma mark --  customer alert delegate

- (void)CustomeAlertViewDismiss:(WXWCustomeAlertView *) alertView {
    [alertView release];
}

- (void)loadDataUserProfile
{
    NSMutableDictionary *specialDict = [[NSMutableDictionary alloc]init];
    [specialDict setObject:NUMBER(INVOKETYPE_LOOKUSERINFO) forKey:KEY_API_INVOKETYPE];
    
    [specialDict setObject:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setObject:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    [specialDict setObject:[AppManager instance].userId forKey:API_NAME_USER_SPECIFIELD_USER_ID];
    
    [specialDict setObject:[CommonMethod convertLongTimeToString:0] forKey:KEY_API_PARAM_START_TIME];
    
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_USER_DEL withApiName:API_NAME_USER_PROFILE withCommon:[AppManager instance].common withSpecial:specialDict];
    [specialDict release];
    
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:GET_USER_PROFILES];
    
    [connFacade fetchGets:url];
}
    
@end
