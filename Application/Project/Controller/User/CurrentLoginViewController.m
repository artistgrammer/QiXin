
#import "CurrentLoginViewController.h"
#import "CommonHeader.h"
#import "CircleMarkegingApplyWindow.h"
#import "WXWCustomeAlertView.h"
#import "UnderlinedButton.h"
#import "UIWebViewController.h"

typedef enum {
    EMAIL_INFO_TYPE = 30,
    PASSWORD_INFO_TYPE,
    COMPANY_INFO_TYPE,
    
    COMPANY_TYPE,
    AUTOLOGIN_TYPE,
    LOGIN_TYPE,
} Login_Element_Type;

@interface CurrentLoginViewController () <WXWConnectorDelegate,UITextFieldDelegate, CircleMarkegingApplyWindowDelegate, SelectViewDelegate>
{
    UITextField *_companyField;
    UITextField *_nameField;
    UITextField *_passwordField;
    
    BOOL _isAutoLogin;
}

@property (nonatomic, retain) UITextField *_companyField;
@property (nonatomic, retain) UITextField *_nameField;
@property (nonatomic, retain) UITextField *_passwordField;

@end

@implementation CurrentLoginViewController
@synthesize _companyField;
@synthesize _nameField;
@synthesize _passwordField;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC {
    
    self = [super initWithMOC:MOC];{
        
        [CommonMethod getInstance].MOC = _MOC;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkIsAutoLogin];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // BG View
    UIImageView *bgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)] autorelease];
    bgView.image = IMAGE_WITH_IMAGE_NAME(@"login_bg.png");
    [self.view addSubview:bgView];
    
    [self setLoginVCField];
    
//    [self.view addSubview:[self setCompanyBtnType]];
    [self setLoginVCBtn];
}

- (void)checkIsAutoLogin
{
    NSString *emailStr = [[AppManager instance].userDefaults usernameRemembered];
    NSString *pwdStr = [[AppManager instance].userDefaults passwordRemembered];
    
    UIButton *autoBtn = (UIButton *)[self.view viewWithTag:AUTOLOGIN_TYPE];
    
    if ([emailStr length] > 0 && [pwdStr length] > 0)
    {
        _isAutoLogin = YES;
        _nameField.text = emailStr;
        _passwordField.text = pwdStr;
        _companyField.text = [[AppManager instance].userDefaults customerNameRemembered];
        [autoBtn setImage:IMAGE_WITH_IMAGE_NAME(@"login_auto_sel") forState:UIControlStateNormal];
    } else {
        _isAutoLogin = NO;
        [autoBtn setImage:IMAGE_WITH_IMAGE_NAME(@"login_auto_unsel") forState:UIControlStateNormal];
    }
}

#pragma mark - Set Login Control

- (void)setLoginVCField
{
    float hGap = 162.5f;
    float wGap = 38.0f;
    float sGap = 11.0f;
    float txtHeight = 38.0f;
    
    NSMutableArray *placeArr = [[[NSMutableArray alloc] initWithObjects:@"邮箱", @"密码", @"公司", nil] autorelease];
    
    for (int i = 0; i < 2; i++)
    {
        UITextField *textField = [[[UITextField alloc] init] autorelease];
        [textField setBackgroundColor:TRANSPARENT_COLOR];
        [textField setTag:i + 30];
        [textField setPlaceholder:[placeArr objectAtIndex:i]];
        [textField setFont:FONT_SYSTEM_SIZE(15)];

        textField.frame = CGRectMake(60.5, 251.5 + (54.5*i), 229.5, 42);
        [textField setBorderStyle:UITextBorderStyleNone];
        [textField setReturnKeyType:UIReturnKeyDefault];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setKeyboardType:UIKeyboardTypeEmailAddress];
        
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        if (i == 1) {
            [textField setSecureTextEntry:YES];
        }
        
        // bg view
        UIImageView *bgView = [[[UIImageView alloc] init] autorelease];
        [bgView setImage:IMAGE_WITH_IMAGE_NAME(@"login_field_bg")];
        bgView.frame = CGRectMake(25, 251.5 + (54.5*i), 270, 42);
        
        if (i == 0) {
            
            UIImageView *textIconView = [[[UIImageView alloc] initWithFrame:CGRectMake(6.f, 9, 24, 24)] autorelease];
            [textIconView setImage:IMAGE_WITH_IMAGE_NAME(@"login_user")];
            [bgView addSubview:textIconView];
        } else if (i == 1) {
            
            UIImageView *textIconView = [[[UIImageView alloc] initWithFrame:CGRectMake(6.f, 9, 24, 24)] autorelease];
            [textIconView setImage:IMAGE_WITH_IMAGE_NAME(@"login_pswd")];
            [bgView addSubview:textIconView];
        }
        
        [self.view addSubview:textField];
        [self.view insertSubview:bgView belowSubview:textField];
    }
    
    self._nameField =     (UITextField *)[self.view viewWithTag:EMAIL_INFO_TYPE];
    self._passwordField = (UITextField *)[self.view viewWithTag:PASSWORD_INFO_TYPE];
    self._companyField =  (UITextField *)[self.view viewWithTag:COMPANY_INFO_TYPE];
    
    [_companyField setFrame:CGRectMake(wGap + sGap, hGap, SCREEN_WIDTH - wGap*3 + 2, txtHeight)];
    
    self._nameField.text = [[AppManager instance].userDefaults usernameRemembered];
}


- (UIButton *)setCompanyBtnType
{
    float hGap = 162.5f;
    float wGap = 36.0f;
    
    UIImage *img = IMAGE_WITH_IMAGE_NAME(@"login_company");
    UIButton *companyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [companyBtn setBackgroundColor:[UIColor clearColor]];
    [companyBtn setTag:COMPANY_TYPE];
    [companyBtn setImage:img forState:UIControlStateNormal];
    [companyBtn setBounds:CGRectMake(0, 0, wGap, wGap)];
    [companyBtn setCenter:CGPointMake(SCREEN_WIDTH - (wGap + wGap/2),hGap + wGap/2)];
    [companyBtn addTarget:self action:@selector(companyClick:) forControlEvents:UIControlEventTouchUpInside];
    return companyBtn;
}

- (void)setLoginVCBtn
{
    
    UIView *autoView = [[[UIView alloc] initWithFrame:CGRectMake(76, 375, 215.5, 22)] autorelease];
    
    // auto btn
    UIButton *autoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [autoBtn setBackgroundColor:[UIColor clearColor]];
    [autoBtn setTag:AUTOLOGIN_TYPE];
    [autoBtn setImage:IMAGE_WITH_IMAGE_NAME(@"login_auto_unsel") forState:UIControlStateNormal];
    [autoBtn setFrame:CGRectMake(0, 0, 22, 22)];
    [autoBtn addTarget:self action:@selector(autoLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [autoView addSubview:autoBtn];
    
    // auto label
    WXWLabel *autoLabel = [[WXWLabel alloc] initWithFrame:CGRectMake(35, 0, 180.5, 22) textColor:HEX_COLOR(@"0x999999") shadowColor:TRANSPARENT_COLOR];
    autoLabel.text = @"自动登录";
    autoLabel.font = FONT_SYSTEM_SIZE(14);
//    autoLabel.textAlignment = NSTextAlignmentCenter;
    [autoView addSubview:autoLabel];
    
    [self.view addSubview:autoView];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundColor:[UIColor clearColor]];
    [loginBtn setTag:LOGIN_TYPE];
    [loginBtn setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"login_btn") forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"login_btn_sel") forState:UIControlStateHighlighted];
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [loginBtn setFrame:CGRectMake(25, 440, 270, 40)];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)autoLoginClick:(id)sender
{
    UIButton *autoBtn = (UIButton *)sender;
    
    if (!_isAutoLogin)
    {
        _isAutoLogin = YES;
        [autoBtn setImage:IMAGE_WITH_IMAGE_NAME(@"login_auto_sel") forState:UIControlStateNormal];
    } else {
        _isAutoLogin = NO;
        [autoBtn setImage:IMAGE_WITH_IMAGE_NAME(@"login_auto_unsel") forState:UIControlStateNormal];
    }
}

- (void) loginBtnClick:(id)sender
{
    if ([self checkInputMessage])
    {
        [self startLogin:_nameField.text
            withPassword:[CommonMethod hashStringAsMD5:_passwordField.text]];
    }
}

- (BOOL)checkInputMessage
{
    if (!_nameField.text.length) {
        [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:LocaleStringForKey(NSLoginUserNameEmpty, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
        return NO;
    }
    
    if (!_passwordField.text.length) {
        [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:LocaleStringForKey(NSLoginPasswordEmpty, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
        return NO;
    }
    
//    if (!_companyField.text.length) {
//        [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:@"请选择角色" delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
//        return NO;
//    }
    
    return YES;
}

- (void)autoLogin
{
    
    _nameField.text = [[AppManager instance].userDefaults usernameRemembered];
    NSString *md5Password = [[AppManager instance].userDefaults passwordRemembered];
    _passwordField.text = md5Password;
    _companyField.text = [[AppManager instance].userDefaults customerNameRemembered];
    
    if (_nameField.text.length > 0 && md5Password.length > 0) {
        [self startLogin:_nameField.text withPassword:[CommonMethod hashStringAsMD5:md5Password]];
        
        [[AppManager instance].userDefaults rememberUsername:[[AppManager instance].userDefaults usernameRemembered] andPassword:[[AppManager instance].userDefaults passwordRemembered] customerName:_companyField.text];
        _isAutoLogin = YES;
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
    if (0 == _nameField.text.length ||
        0 == _passwordField.text.length) {
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

- (void)startLogin:(NSString *)userName withPassword:(NSString *)password
{
    
    NSMutableDictionary *specialDict = [NSMutableDictionary dictionary];
    [specialDict setValue:_nameField.text forKey:@"Email"];
    [specialDict setValue:password forKey:@"Password"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@%@", VALUE_API_PREFIX, API_SERVICE_USER, API_USER_LOGIN];
    NSString *url = [ProjectAPI getURL:urlStr specialDict:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:USER_LOGIN_TY];
    
    [connFacade fetchGets:url];
}

- (void)forgetPasswordButtonClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FORGET_PASSWORD_LINK]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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

#pragma mark - keyboard show or hidden
-(void)autoMovekeyBoard:(float)h withDuration:(float)duration{
    
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
            [self.view endEditing:YES];
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                NSDictionary *resultDict = [result objectFromJSONData];
                NSDictionary *dict = [resultDict objectForKey:@"Data"];
                
                NSString *updateURL = [dict objectForKey:@"updateURL"];
                if (!updateURL || [updateURL isEqual:[NSNull null]] || [updateURL isEqual:@"<null>"]) {
                    
                } else {
                    [AppManager instance].updateURL = updateURL;
                    DLog(@"%@", [AppManager instance].updateURL);
                }
                
                
                NSString *isMandatory = [dict objectForKey:@"IsMandatory"];
                if (!isMandatory || [isMandatory isEqual:[NSNull null]] || [isMandatory isEqual:@"<null>"]) {
                    
                } else {
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
                
                if (_isAutoLogin)
                {
                    [[AppManager instance].userDefaults rememberUsername:_nameField.text andPassword:_passwordField.text customerName:_passwordField.text];
                } else {
                    [[AppManager instance].userDefaults rememberUsername:nil andPassword:[CommonMethod hashStringAsMD5:_passwordField.text] customerName:_passwordField.text];
                }
                
                
                NSDictionary *userDic = OBJ_FROM_DIC(dict, @"UserInfo");
                
                // 绑定聊天服务器
                [AppManager instance].userChatId = [userDic objectForKey:@"VoipAccount"];
                [AppManager instance].userChatPwd = [userDic objectForKey:@"VoipPwd"];
                [AppManager instance].userChatAccountId = [userDic objectForKey:@"SubAccountSid"];
                [AppManager instance].userChatToken = [userDic objectForKey:@"SubToken"];
                
                // 初始化Voip SDK
                ProjectAppDelegate *delegate = (ProjectAppDelegate *)APP_DELEGATE;
                delegate.modelEngineVoip = [ModelEngineVoip getInstance];
                
                // 参数赋值
                NSString *serverIp = @"sandboxapp.cloopen.com";
                int serverPort = 8883;
                
                [delegate.modelEngineVoip connectToCCP:serverIp onPort:serverPort withAccount:[AppManager instance].userChatId withPsw:[AppManager instance].userChatPwd withAccountSid:[AppManager instance].userChatAccountId withAuthToken:[AppManager instance].userChatToken];
                
                // AppManage
                [AppManager instance].userId = [userDic objectForKey:@"UserID"];
                [AppManager instance].userName = [userDic objectForKey:@"UserName"];
                [AppManager instance].userImageUrl = [userDic objectForKey:@"HighImageUrl"];
                [AppManager instance].userTitle = [userDic objectForKey:@"JobFunc"];
                [AppManager instance].userDept = [userDic objectForKey:@"Dept"];
                
                // Save
                UserObject *userObject = [[[UserObject alloc] init] autorelease];
                userObject.userId = STRING_VALUE_FROM_DIC(userDic, @"UserID");
                userObject.chatId = STRING_VALUE_FROM_DIC(userDic, @"VoipAccount");
                userObject.userTitle = STRING_VALUE_FROM_DIC(userDic, @"JobFunc");
                userObject.userRole = STRING_VALUE_FROM_DIC(userDic, @"RoleName");
                userObject.userDept = STRING_VALUE_FROM_DIC(userDic, @"Dept");
                userObject.userCode = STRING_VALUE_FROM_DIC(userDic, @"user_code");
                userObject.userName = STRING_VALUE_FROM_DIC(userDic, @"UserName");
                userObject.userNameEn = STRING_VALUE_FROM_DIC(userDic, @"user_name_en");
                userObject.userEmail = STRING_VALUE_FROM_DIC(userDic, @"UserEmail");
                userObject.userTel = STRING_VALUE_FROM_DIC(userDic, @"UserTelephone");
                userObject.userImageUrl = STRING_VALUE_FROM_DIC(userDic, @"HighImageUrl");
                userObject.userGender = INT_VALUE_FROM_DIC(userDic, @"UserGender");
                userObject.isFriend = 0;
                userObject.isDelete = INT_VALUE_FROM_DIC(userDic, @"user_status")-1;
                userObject.superName = STRING_VALUE_FROM_DIC(userDic, @"SuperiorName");
                userObject.userBirthDay = STRING_VALUE_FROM_DIC(userDic, @"UserBirthday");
                userObject.userCellphone = STRING_VALUE_FROM_DIC(userDic, @"UserCellphone");
                
                [[ProjectDBManager instance] insertOrUpdateUserInfos:userObject];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccessfull:)]) {
                    [self.delegate loginSuccessfull:self];
                }
                
//                [self loadDataUserProfile];
                
            } else {
                
                NSDictionary *resultDict = [result objectFromJSONData];
                NSString *msg = [resultDict objectForKey:@"Message"];
                
                [self bringToFront];
                [[[[UIAlertView alloc]initWithTitle:LocaleStringForKey(NSNoteTitle, nil) message:msg delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
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
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccessfull:)]) {
                [self.delegate loginSuccessfull:self];
            }
        }
            break;
            
        default:
            break;
    }
    
//    [_loginButton setEnabled:YES];
    
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

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - circle marketing delegate
- (void)circleMarkegingApplyWindowCancelDismiss:(CircleMarkegingApplyWindow *) alertView {
    
    [alertView release];
    exit(0);
}

- (void)circleMarkegingApplyWindowDismiss:(CircleMarkegingApplyWindow *)alertView applyList:(NSArray *)applyArray {
    [alertView release];
    
    [CommonMethod update:[AppManager instance].updateURL];
    
    exit(0);
}

#pragma mark - customer alert delegate

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Company Action

- (void)companyClick:(id)sender
{
    NSLog(@"COMPANY  SELECT  CLICK");
    [self.view endEditing:YES];
    
    NSMutableArray *dataArr = [NSMutableArray array];
    [dataArr addObject:@"宝洁"];
    [dataArr addObject:@"复星"];
    
    float  hGap = 200.5f;
    float  wGap = 38.0f;
    float  height = 200.0f;
    CGRect selectFrame = CGRectMake(wGap, hGap, SCREEN_WIDTH - wGap*2, height);
    
    _selectView = [[SelectView alloc] initWithData:dataArr Frame:selectFrame TipIcon:nil Delegate:self canScroll:YES];
    [_selectView showView];
}

- (void)selectWithData:(NSString *)name withIndex:(int)index
{
    // 保存角色信息到本地
    //    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kChatUserRoleName];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_companyField setText:name];
}

@end
