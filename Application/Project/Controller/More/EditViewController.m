//
//  EditViewController.m
//  Project
//
//  Created by XXX on 13-10-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "EditViewController.h"
#import "FeedEdit.h"
#import "GlobalConstants.h"
#import "UIColor+expanded.h"

@interface EditViewController () <UITextFieldDelegate> {
    UITextField *tf;
}

@end

@implementation EditViewController

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
    _titleString = _isPhone ? @"电话编辑" : @"邮箱编辑";
//    _dict = [NSDictionary dictionaryWithObjectsAndKeys:@"",KEY_NAVIGATION_LEFT_BUTTON_ITEM_TITLE, @"", KEY_NAVIGATION_RIGHT_BUTTON_ITEM_TITLE,_titleString,KEY_NAVIGATION_TITLE, VALUE_NAVIGATION_USING_NAVIGATION, KEY_NAVICATION_IS_USING,VALUE_NAVIGATION_USING_LEFT_BUTTON_ITEM, KEY_NAVIGATION_USING_LEFT_BUTTON_ITEM,
//             //VALUE_NAVIGATION_USING_RIGHT_BUTTON_ITEM, KEY_NAVIGATION_USING_RIGHT_BUTTON_ITEM,
//             @"button_back",KEY_NAVIGATION_USING_LEFT_BUTTON_ITEM_IMAGE,
//             @"nav_bg.png", KEY_NAVIGATION_BACKGROUND_IMAGE,
//             nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xe5ddd1"];
    
    [self initEditView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [tf release];
    [super dealloc];
}

- (void)initEditView {
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10 + ITEM_BASE_TOP_VIEW_HEIGHT, 308, 55)];
    bg.image = IMAGE_WITH_NAME(@"bg_2.png");
    bg.userInteractionEnabled = YES;
    
    [self.view addSubview:bg];
    
    tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 300, 45)];
    tf.backgroundColor = TRANSPARENT_COLOR;
    tf.placeholder = @"请输入";
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf.delegate = self;
    [bg addSubview:tf];
    
    [bg release];
}

- (void) leftNavButtonClicked:(id)sender {
    if (_isPhone) {
        [FeedEdit shared].phone = tf.text;
    }else {
        [FeedEdit shared].email = tf.text;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [tf resignFirstResponder];
}

@end
