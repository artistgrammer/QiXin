/*
 *  Copyright (c) 2013 The CCP project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a Beijing Speedtong Information Technology Co.,Ltd license
 *  that can be found in the LICENSE file in the root of the web site.
 *
 *                    http://www.cloopen.com
 *
 *  An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RoomNameViewController.h"
#import "ChatRoomViewController.h"

#define TAG_ALERTVIEW_ChatroomPwd  9999
#define TAG_ALERTVIEW_ChatroomName 9998

@interface RoomNameViewController ()
{
    
}
@property (nonatomic,retain)UITextField *nameTextField;
@property (nonatomic,retain)UITextField *pwdTextField;
@end

@implementation RoomNameViewController
@synthesize nameTextField;
@synthesize pwdTextField;
@synthesize backView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    isAutoClose = YES;
    self.title = @"创建房间";
    self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR_WHITE;
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:[CommonTools navigationBackItemBtnInitWithTarget:self action:@selector(popToPreView)]];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    [leftBarItem release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 8.0f, 80.0f, 20.0f)];
    label.text = @"房间名称";
    label.textColor = [UIColor grayColor];
    label.backgroundColor = VIEW_BACKGROUND_COLOR_WHITE;
    [self.view addSubview:label];
    [label release];
    
    UITextField *name = [[UITextField alloc] initWithFrame:CGRectMake(90.0f, 3.0f, 210.0f, 35.0f)];
    name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    name.backgroundColor = [UIColor whiteColor];
    name.placeholder = @"请输入房间名";
    self.nameTextField = name;
    self.nameTextField.tag = TAG_ALERTVIEW_ChatroomName;
    self.nameTextField.delegate = self;
    [name becomeFirstResponder];
    [self.view addSubview:name];
    [name release];
    
    UILabel *labelPwd = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 55.0f, 80.0f, 20.0f)];
    labelPwd.text = @"房间密码";
    labelPwd.textColor = [UIColor grayColor];
    labelPwd.backgroundColor = VIEW_BACKGROUND_COLOR_WHITE;
    [self.view addSubview:labelPwd];
    [labelPwd release];
    
    UITextField *pwd = [[UITextField alloc] initWithFrame:CGRectMake(90.0f, 50.0f, 210.0f, 35.0f)];
    pwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    pwd.backgroundColor = [UIColor whiteColor];
    pwd.placeholder = @"请输入1-8位密码（可选）";
    [pwd setSecureTextEntry:YES];
    pwd.keyboardType = UIKeyboardTypeDefault;
    self.pwdTextField = pwd;
    self.pwdTextField.tag = TAG_ALERTVIEW_ChatroomPwd;
    [pwd becomeFirstResponder];
    self.pwdTextField.delegate = self;
    [self.view addSubview:pwd];
    [pwd release];
    
    UIButton* btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(0, 90, 320, 30);
    UIImage* img = [UIImage imageNamed:@"choose_on.png"];
    btn.tag = 1;
    [btn setImage: img forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTitle:@"创建人退出时自动解散(单击选择)" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnChoose:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createBtn.frame = CGRectMake(82.0f, 125.0f, 136.0f, 38.0f);
    createBtn.titleLabel.textColor = [UIColor whiteColor];
    [createBtn setTitle:@"创建" forState:UIControlStateNormal];
    [createBtn setBackgroundImage:[UIImage imageNamed:@"button03_off.png"] forState:UIControlStateNormal];
    [createBtn setBackgroundImage:[UIImage imageNamed:@"button03_on.png"] forState:UIControlStateHighlighted];
    [createBtn addTarget:self action:@selector(createCharRoom:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    
}
-(void)btnChoose:(id)sender
{
    UIButton* btn = sender;
    if (btn.tag == 0)
    {
        btn.tag = 1;
        UIImage* img = [UIImage imageNamed:@"choose_on.png"];
        [btn setImage: img forState:(UIControlStateNormal)];
        isAutoClose = YES;
    }
    else
    {
        btn.tag = 0;
        UIImage* img = [UIImage imageNamed:@"choose.png"];
        [btn setImage: img forState:(UIControlStateNormal)];
        isAutoClose = NO;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1)
    {
        return YES;
    }
    NSMutableString *text = [[textField.text mutableCopy] autorelease];
    [text replaceCharactersInRange:range withString:string];
    if (textField.tag == TAG_ALERTVIEW_ChatroomPwd)
    {
        return [text length] <= 8;
    }
    return [text length] <= 50;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.modelEngineVoip setUIDelegate:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createCharRoom:(id)sender
{
    [nameTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
    if (nameTextField.text.length > 0 )
    {
        //创建并加入
        ChatRoomViewController *chatroomview = [[ChatRoomViewController alloc] init];
        chatroomview.navigationItem.hidesBackButton = YES;
        chatroomview.curChatroomId = nil;
        chatroomview.roomname = nameTextField.text;
        chatroomview.backView = self.backView;
        chatroomview.isCreator = YES;
        [self.navigationController pushViewController:chatroomview animated:YES];
        [chatroomview createChatroomWithChatroomName:nameTextField.text andPassword:pwdTextField.text andSquare:8 andKeywords:@"" inAppId:self.modelEngineVoip.appID andIsAutoClose:isAutoClose];
        [chatroomview release];
    }
    else
    {
        UIAlertView *alertView=nil;
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入创建房间名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    
}

-(void)dealloc
{
    self.nameTextField = nil;
    self.pwdTextField = nil;
    [super dealloc];
}
@end
