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

#import "VideoConfNameViewController.h"
#import "VideoConfViewController.h"

@interface VideoConfNameViewController ()
{
    UITextField *nameTextField;
}
@end

@implementation VideoConfNameViewController
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
    self.title = @"创建视频会议房间";
    self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    
    NSString* fileStr = Nil;
    CGRect range;
    if (IPHONE5)
    {
        fileStr = @"videoConfBg_1136.png";
        range = CGRectMake(0, 0, 320, 576);
    }
    else
    {
        fileStr = @"videoConfBg.png";
        range = CGRectMake(0, 0, 320, 480);
    }
    
    UIImage* imBg = [UIImage imageNamed:fileStr];
    UIImageView* ivBg = [[UIImageView alloc] initWithImage:imBg];
    ivBg.frame = range;
    [self.view addSubview:ivBg];
    [ivBg release];

    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:[CommonTools navigationBackItemBtnInitWithTarget:self action:@selector(popToPreView)]];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    [leftBarItem release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(11.0f, 5.0f, 200.0f, 18.0f)];
    label.text = @"房间名称:";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    [label release];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"videoConfPortrait.png"]];
    imageview.center = CGPointMake(33.0f, 52.0f);
    [self.view addSubview:imageview];
    [imageview release];
    
    UITextField *name = [[UITextField alloc] initWithFrame:CGRectMake(55.0f, 30.0f, 320.0f-66.0f, 44.0f)];
    name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    name.keyboardAppearance = UIKeyboardAppearanceAlert;
    name.background = [UIImage imageNamed:@"videoConfInput.png"];
    name.delegate = self;
    name.textColor = [UIColor whiteColor];
    name.placeholder = @"请输入房间名称";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        [name setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    nameTextField = name;
    name.textColor = [UIColor whiteColor];
    [name becomeFirstResponder];
    [self.view addSubview:name];
    [name release];
    
    UIButton* btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(0, 79, 320, 30);
    UIImage* img = [UIImage imageNamed:@"choose_on.png"];
    btn.tag = 1;
    [btn setImage: img forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTitle:@"创建人退出时自动解散(单击选择)" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnChoose:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createBtn.frame = CGRectMake(11.0f, 115.0f, 298.0f, 44.0f);
    [createBtn setImage:[UIImage imageNamed:@"videoConfCreate2.png"] forState:UIControlStateNormal];
    [createBtn setImage:[UIImage imageNamed:@"videoConfCreate2_on.png"] forState:UIControlStateHighlighted];
    [createBtn addTarget:self action:@selector(createVideoConference:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.background = [UIImage imageNamed:@"videoConfInput_on.png"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.background = [UIImage imageNamed:@"videoConfInput.png"];
}
#pragma mark - private method
- (void)createVideoConference:(id)sender
{
    [nameTextField resignFirstResponder];
    if (nameTextField.text.length > 0 )
    {
        VideoConfViewController *VideoConfview = [[VideoConfViewController alloc] init];
        VideoConfview.navigationItem.hidesBackButton = YES;
        VideoConfview.curVideoConfId = nil;
        VideoConfview.Confname = nameTextField.text;
        VideoConfview.backView = self.backView;
        VideoConfview.isCreator = YES;
        VideoConfview.isAutoClose = isAutoClose;
        [self.navigationController pushViewController:VideoConfview animated:YES];
        [VideoConfview createConf];
        [VideoConfview release];
    }
    else
    {
        UIAlertView *alertView=nil;
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入创建会议名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }

}



@end
