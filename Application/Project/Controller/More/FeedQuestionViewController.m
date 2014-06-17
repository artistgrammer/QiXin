//
//  FeedQuestionViewController.m
//  Project
//
//  Created by XXX on 13-10-15.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "FeedQuestionViewController.h"
#import "EditViewController.h"
#import "FeedEdit.h"
#import "ProjectAPI.h"
#import "CommonHeader.h"
#import "AppManager.h"
#import "JSONKit.h"
#import "JSONParser.h"
#import "CustomizedAlertAnimation.h"
#import "WXWCustomeAlertView.h"

#define CONTENT_VIEW_WIDTH  300.f
#define CONTENT_VIEW_HEIGHT 171.f

#define COMMIT_BUTTON_WIDTH  304.f
#define COMMIT_BUTTON_HEIGHT 50.f

@interface FeedQuestionViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,UITextFieldDelegate> {
    UITextView *contentTextView;
    UITextField *phoneField;
    UITextField *mailField;
    
    UITableView *feedTable;
    
    UIButton *commitButton;
    UIView *footerView;
    
    NSArray *titleArr;
}

@end

@implementation FeedQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    [self initData];
    [self initViews];
    [self initControls];
    [self initLisentingKeyboard];
    
    self.navigationItem.title = @"问题反馈";
    
    [CommonMethod viewAddGuestureRecognizer:self.view withTarget:self withSEL:@selector(viewTapped:)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [feedTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [feedTable release];
    [contentTextView release];
    [titleArr release];
    [super dealloc];
}

- (void)initData {
    titleArr = [[NSArray alloc] initWithObjects:@"电话", @"邮箱", nil];
}

- (void)initViews {
    
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    footerView.backgroundColor = TRANSPARENT_COLOR;
    
//    commitButton.center = footerView.center;
//    [footerView addSubview:commitButton];
    
    int startX= 12;
    feedTable = [[UITableView alloc] initWithFrame:CGRectMake(startX, ITEM_BASE_TOP_VIEW_HEIGHT, self.view.frame.size.width - 2*startX, CONTENT_VIEW_HEIGHT + 40) style:UITableViewStyleGrouped];
    feedTable.backgroundColor = TRANSPARENT_COLOR;
    feedTable.backgroundView = nil;
    feedTable.delegate = self;
    feedTable.scrollEnabled = NO;
    feedTable.dataSource = self;
    feedTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    feedTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:feedTable];
}

- (void)initControls
{
    int marginX = 10;
    int startX = marginX+5;
    int distY = 5;
    int width = self.view.frame.size.width - 2*startX;
    UILabel *contLabel = [[[UILabel alloc] initWithFrame:CGRectMake(startX, feedTable.frame.size.height + feedTable.frame.origin.y + distY, width, 40)] autorelease];
    contLabel.text = @"请留下您的联系方式，我们将尽快回复您的反馈！";
    contLabel.numberOfLines = 0;
    contLabel.font = FONT_SYSTEM_SIZE(12);
    contLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    [contLabel sizeToFit];
    contLabel.backgroundColor = TRANSPARENT_COLOR;
    //[self.view addSubview:contLabel];
    
    UILabel *phoneLabel = [[[UILabel alloc] initWithFrame:CGRectMake(2*startX, contLabel.frame.origin.y + contLabel.frame.size.height + 3*distY, width, 40)] autorelease];
    phoneLabel.font = FONT_SYSTEM_SIZE(16);
    phoneLabel.text = @"电话";
    phoneLabel.textColor = [UIColor blackColor];
    phoneLabel.textAlignment = UITextAlignmentLeft;
    phoneLabel.numberOfLines = 0;
    [phoneLabel sizeToFit];
    phoneLabel.backgroundColor = TRANSPARENT_COLOR;
    
    //[self.view addSubview:phoneLabel];
   
    
    
    
    UILabel *mailLabel = [[[UILabel alloc] initWithFrame:CGRectMake(2*startX, phoneLabel.frame.origin.y + phoneLabel.frame.size.height + 3*distY, width, 40)] autorelease];
    mailLabel.font = FONT_SYSTEM_SIZE(16);
    mailLabel.text = @"邮箱";
    mailLabel.textColor = [UIColor blackColor];
    mailLabel.textAlignment = UITextAlignmentLeft;
    mailLabel.numberOfLines = 0;
    [mailLabel sizeToFit];
    mailLabel.backgroundColor = TRANSPARENT_COLOR;
    
    //[self.view addSubview:mailLabel];
    
    startX = phoneLabel.frame.origin.x + phoneLabel.frame.size.width + 5;
    int height = 30;
    int startY = (phoneLabel.frame.size.height - height) / 2.0f + phoneLabel.frame.origin.y;
    phoneField = [[UITextField alloc] initWithFrame:CGRectMake(startX, startY, self.view.frame.size.width - startX - 2*marginX, height)];
    phoneField.placeholder = @"请输入电话";
    phoneField.font = FONT_SYSTEM_SIZE(16);
    phoneField.delegate = self;
    phoneField.textAlignment = UITextAlignmentLeft;
    phoneField.backgroundColor = TRANSPARENT_COLOR;
    phoneField.textColor = [UIColor colorWithHexString:@"0x999999"];
    [phoneField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    
    phoneField.leftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)] autorelease];
    phoneField.leftView.userInteractionEnabled = NO;
    phoneField.leftViewMode = UITextFieldViewModeAlways;
    
    if ([CommonMethod is7System]) {
        phoneField.tintColor = [UIColor lightGrayColor];
    }
    
   // [self.view addSubview:phoneField];
    
    //---------------------
    
    startY = (mailLabel.frame.size.height - height) / 2.0f + mailLabel.frame.origin.y;
    mailField = [[UITextField alloc] initWithFrame:CGRectMake(startX, startY, self.view.frame.size.width - startX - 2*marginX, height)];
    mailField.placeholder = @"请输入邮箱";
    mailField.font = FONT_SYSTEM_SIZE(16);
    mailField.textAlignment = UITextAlignmentLeft;
    mailField.backgroundColor = TRANSPARENT_COLOR;
    mailField.delegate = self;
    mailField.textColor = [UIColor colorWithHexString:@"0x999999"];
    [mailField setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    mailField.leftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)] autorelease];
    mailField.leftView.userInteractionEnabled = NO;
    mailField.leftViewMode = UITextFieldViewModeAlways;
    if ([CommonMethod is7System]) {
        mailField.tintColor = [UIColor lightGrayColor];
    }
    
    //[self.view addSubview:mailField];
    
    
    UIView *background = [[[UIView alloc] initWithFrame:CGRectMake(1.5*marginX, phoneField.frame.origin.y - 5, self.view.frame.size.width - 3*marginX, 10 + mailField.frame.size.height + mailField.frame.origin.y - phoneField.frame.origin.y)] autorelease];
    
    background.backgroundColor = [UIColor whiteColor];
    background.layer.cornerRadius = 4.f;
//    background.layer.masksToBounds = YES;
    background.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    background.layer.shadowOffset = CGSizeMake(0, 0);
    background.layer.shadowOpacity = 0.4;
    background.layer.shadowRadius = 1.f;
    
   // [self.view addSubview:background];
   // [self.view sendSubviewToBack:background];
   
    
    UILabel *lineLabel = [[[UILabel alloc] initWithFrame:CGRectMake(background.frame.origin.x, background.frame.origin.y + background.frame.size.height / 2.0f, background.frame.size.width, 1)] autorelease];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"0xbcbcbc"];
    
    //[self.view addSubview:lineLabel];
    
    commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(background.frame.origin.x - 2, background.frame.origin.y /* + background.frame.size.height + 20*/, background.frame.size.width + 4, COMMIT_BUTTON_HEIGHT);
    [commitButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"button_commit.png") forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton.titleLabel setTextColor:[UIColor whiteColor]];
    [commitButton.titleLabel setFont:FONT_SYSTEM_SIZE(18)];
    
    [self.view addSubview:commitButton];
}

#pragma mark - button action

- (void)commit:(UIButton *)sender {
    DLog(@"%@", contentTextView.text );
    [self submitFeedback:TRIGGERED_BY_AUTOLOAD  forNew:YES];
}

#pragma mark - textview delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.text = nil;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = nil;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CONTENT_VIEW_HEIGHT;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return footerView.frame.size.height;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return footerView;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"请留下您的联系方式，我们将尽快回复您的反馈！";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"feed_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        cell.backgroundView = [[[UIImageView alloc] initWithImage:IMAGE_WITH_IMAGE_NAME(@"bg_3.png")] autorelease];
        cell.backgroundColor = TRANSPARENT_COLOR;
        contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(16, 16, CONTENT_VIEW_WIDTH - 32, CONTENT_VIEW_HEIGHT - 32)];
        contentTextView.font = FONT_SYSTEM_SIZE(15);
        contentTextView.delegate = self;
        contentTextView.returnKeyType = UIReturnKeyDone;
        contentTextView.textColor = [UIColor colorWithHexString:@"0x999999"];
        contentTextView.text = @"请填写您的建议和意见！";
//        contentTextView.backgroundColor = TRANSPARENT_COLOR;
        if ([CommonMethod is7System]) {
            contentTextView.tintColor = [UIColor lightGrayColor];
        }
        
        [cell.contentView addSubview:contentTextView];
        
    }else {
        cell.textLabel.text = titleArr[indexPath.row];
        if (indexPath.row == 0) {
            if ([[FeedEdit shared].phone isEqualToString:@""] || ![FeedEdit shared].phone) {
                cell.detailTextLabel.text = @"请输入";
            }else {
                cell.detailTextLabel.text = [FeedEdit shared].phone;
            }
        }else  {
            if ([[FeedEdit shared].email isEqualToString:@""] || ![FeedEdit shared].email) {
                cell.detailTextLabel.text = @"请输入";
            }else {
                cell.detailTextLabel.text = [FeedEdit shared].email;
            }
        }
        
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        cell.detailTextLabel.font = FONT_SYSTEM_SIZE(15);
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        EditViewController *edit = [[[EditViewController alloc] init] autorelease];
        edit.isPhone = indexPath.row == 0 ? YES : NO;
        [CommonMethod pushViewController:edit withAnimated:YES];
    }
}

- (void)submitFeedback:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    _currentType = SUBMIT_FEEDBACK_TY;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setObject:contentTextView.text   forKey:KEY_API_PARAM_FEEDBACK];

    NSMutableDictionary *requestDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_USER_DEL,API_NAME_USER_FEEDBACK];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:urlString
                                                              contentType:_currentType];
    [connFacade post:urlString data:[requestDict JSONData]];
    
}


#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case SUBMIT_FEEDBACK_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                [CommonMethod showAlert:self title:@"温馨提示" tip:@"您的问题反馈我们已经收到，我们将尽快联系您！"];
            }
            
        } break;
            
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
    
    [super connectFailed:error url:url contentType:contentType];
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    [contentTextView resignFirstResponder];
    [phoneField resignFirstResponder];
    [mailField resignFirstResponder];
}
#pragma mark -- text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)initLisentingKeyboard
{
    //çå¬é®çé«åº¦çåæ¢
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // é®çé«åº¦ååéç¥ï¼ios5.0æ°å¢ç
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
        
        if (![contentTextView isFirstResponder]) {
            
        int height = 50;
        float hh = (h == 0?-3*height:height);
        CGRect rect = self.view.frame;
        rect.origin.y -= hh;
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

-(void)showCustomizedAlertAnimationIsOverWithUIView:(UIView *)v
{
    
}

-(void)dismissCustomizedAlertAnimationIsOverWithUIView:(UIView *)v type:(AlertDoneType)type
{
    
}


- (void)CustomeAlertViewDismiss:(WXWCustomeAlertView *) alertView
{
    [alertView release];
}
@end
