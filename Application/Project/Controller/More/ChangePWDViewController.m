
#import "ChangePWDViewController.h"
#import "ContentView.h"
#import "CommonHeader.h"
#import "NSString+JITIOSLib.h"

#define KEY_OLD_PWD  @"oldPwd"
#define KEY_NEW_PWD  @"newPwd"
#define KEY_RNEW_PWD @"renewPwd"

#define BUTTON_WIDTH   153.f
#define BUTTON_HEIGHT  48.f

@interface ChangePWDViewController ()<UITextFieldDelegate>

@property (nonatomic, retain) NSArray *labelTitles;
@property (nonatomic, retain) NSMutableArray *textFields;
@property (nonatomic, retain) UITextField *currentTextField;
@property (nonatomic, retain) NSMutableDictionary *passDic;

@end

@implementation ChangePWDViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC {
    self = [super initWithMOC:MOC];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    [_textFields release];
    RELEASE_OBJ(_currentTextField);
    [_passDic release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = LocaleStringForKey(@"修改密码", nil);
    [self initNavButton];
    [self initData];
    [self initSubViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    _textFields = [[NSMutableArray alloc] init];
    _labelTitles = @[@"旧密码", @"新密码", @"确认密码"];
    _passDic = [[NSMutableDictionary alloc] init];
}

- (void)initSubViews {
    
    ContentView *background = [[ContentView alloc] initWithFrame:CGRectMake(0, 17.5f, self.view.frame.size.width, 140)];

    [self.view addSubview:background];
    
    float labelHeght = 45.0f;
    
    for (int i = 0; i < self.labelTitles.count; i++) {
        
        CGSize labelSize = [WXWCommonUtils sizeForText:self.labelTitles[i]
                                                  font:FONT_SYSTEM_SIZE(17)
                                            attributes:@{NSFontAttributeName : FONT_SYSTEM_SIZE(17)}];
        int width = 80;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 25 + i * labelHeght, width, labelSize.height)];
        label.text = self.labelTitles[i];
        label.textColor = [UIColor colorWithHexString:@"0x37332f"];
        label.textAlignment = UITextAlignmentLeft;
        [self.view addSubview:label];
        [label release];
        
        if (i < self.labelTitles.count - 1) {
            
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(background.frame.origin.x, label.frame.origin.y + ( labelHeght +  label.frame.size.height) / 2.0f, background.frame.size.width, 0.5)];
            lineLabel.backgroundColor = [UIColor colorWithHexString:@"0xcccccc"];
            
            [self.view addSubview:lineLabel];
            [lineLabel release];
        }
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y, self.view.frame.size.width - (40 + label.frame.size.width), label.frame.size.height)];
        textField.delegate = self;
        textField.tag = i;
        textField.borderStyle = UITextBorderStyleNone;
        [textField setSecureTextEntry:YES];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = LocaleStringForKey(@"请输入", nil);
        
        [self.view addSubview:textField];
        [self.textFields addObject:textField];
        [textField release];
    }
    
    [background release];
}

- (BOOL)isNull:(NSString *)string {
    return [[NSNull null] isEqual:string] || [string isEqualToString:@""];
}

- (void)commitChange:(UIButton *)sender {
    [self.currentTextField resignFirstResponder];
    UITextField *old = self.textFields[0];
    UITextField *new = self.textFields[1];
    UITextField *rnew = self.textFields[2];
    
    if (![new.text isEqualToString:rnew.text] && (![self isNull:new.text] && ![self isNull:rnew.text])) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您两次输入的密码不一致，请重新输入"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    } else if ([self isNull:old.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"请输入您的原始密码"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        
    } else if ([self isNull:new.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"请输入您的新密码"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        
    }else if ([old.text isEqualToString:new.text] && [self isNull:rnew.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您输入的新密码和原始密码相同，请重新输入"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        
    } else if ([self isNull:rnew.text] && ![self isNull:new.text] && ![self isNull:old.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"请再次输入您的新密码"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        
    } else if ([[[AppManager instance].userDefaults passwordRemembered] isEqualToString:[CommonMethod hashStringAsMD5:old.text]] && [self isNull:new.text] && [self isNull:rnew.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您输入的原始密码有误"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        
    }else {
        [self commitNewPwd];
    }
}

- (void)commitNewPwd {
    
    NSMutableDictionary *specialDict = [NSMutableDictionary dictionary];
    [specialDict setValue:[[self.passDic objectForKey:KEY_OLD_PWD] MD5String] forKey:@"SourcePWD"];
    [specialDict setValue:[[self.passDic objectForKey:KEY_NEW_PWD] MD5String] forKey:@"NewPWD"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@%@", VALUE_API_PREFIX, API_SERVICE_USER, API_MODIFY_USER_PSWD];
    NSString *url = [ProjectAPI getURL:urlStr specialDict:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:SUBMIT_NEW_PWD_TY];
    [connFacade fetchGets:url];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case SUBMIT_NEW_PWD_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                [WXWUIUtils showNotificationOnTopWithMsg:@"修改成功！"
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES animationEnded:^{
                                          [self back:nil];
                                      }];
                
            } else if (ret == PASSWORD_OLD_ERR_CODE) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"原始密码不正确"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
                [alert release];
            } else {
                [WXWUIUtils showNotificationOnTopWithMsg:@"修改失败！"
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES animationEnded:^{
                                          //                                          [self back:nil];
                                      }];
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

#pragma mark - textfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentTextField = textField;
    DLog(@"%d",self.currentTextField.tag);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    switch (textField.tag) {
        case 0:
            [self.passDic setObject:textField.text forKey:KEY_OLD_PWD];
            break;
            
        case 1:
            [self.passDic setObject:textField.text forKey:KEY_NEW_PWD];
            break;
            
        case 2:
            [self.passDic setObject:textField.text forKey:KEY_RNEW_PWD];
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.currentTextField resignFirstResponder];
}

- (void)initNavButton
{
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc]
                                initWithTitle:@"保存"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(commitChange:)];
    self.navigationItem.rightBarButtonItem = btnSave;
    [btnSave release];
}

@end
