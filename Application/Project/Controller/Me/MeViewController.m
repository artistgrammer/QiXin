//
//  MeViewController.m
//  IPhoneCIO
//
//  Created by Peter on 13-11-27.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "MeViewController.h"
#import "CIOMoreCell.h"
#import "CIOPersonalInfoCell.h"
#import "UserBaseInfo.h"
#import "CommonHeader.h"
#import "AppManager.h"
#import "ProjectDBManager.h"
#import "MyInfoViewController.h"
#import "TextPool.h"
#import "WXApi.h"
#import "CommonUtils.h"
#import "ProjectAppDelegate.h"
#import "HomeContainerViewController.h"
#import "MoreViewController.h"
#import "AuthenticateViewController.h"
#import "WXWLabel.h"
#import "ProjectAPI.h"
#import "JSONParser.h"

#define BUTTON_LOGOUT_WIDTH  305.f
#define BUTTON_LOGOUT_HEIGHT 49.f

#define MORE_CELL_HEIGHT 44.f

enum ME_SECTION_TYPE {
    ME_SECTION_TYPE_HEADER,
    ME_SECTION_TYPE_OTHER,
    ME_SECTION_TYPE_MESSAGE,
    };

//头像section
enum ME_HEADER_CELL {
    ME_HEADER_CELL_HEADER,//
    };

//--私信section
enum ME_MESSAGE_CELL {
    ME_MESSAGE_CELL_PRIVATE,//私信
    };

//--other section
enum ME_OTHER_CELL {
    ME_CELL_AUTHENTICATE,
    ME_CELL_COLLECTION,
    ME_CELL_SHARE_INVITE,
    ME_CELL_SYS_SETTING,
};

enum {
    SHARE_AS_TY,
    TAKE_PHOTO_AS_TY,
};

enum {
	SHARE_SMS_AS_IDX,
	SHARE_WX_AS_IDX,
    SHARE_CANCEL_IDX,
};

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate>
@end

@implementation MeViewController {
    
    NSInteger _asOwnerType;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC {
    
    self = [super initWithMOC:MOC
        needRefreshHeaderView:NO
        needRefreshFooterView:NO];
    
    if (self) {
        self.parentVC = pVC;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setAlpha:1.0f];
    
    // Exit
    CGFloat buttonX = (_tableView.frame.size.width - BUTTON_LOGOUT_WIDTH) / 2.f;
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    logout.frame = CGRectMake(buttonX, 333, BUTTON_LOGOUT_WIDTH, BUTTON_LOGOUT_HEIGHT);
    [logout setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"button_logout.png") forState:UIControlStateNormal];
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    [logout.titleLabel setTextColor:[UIColor whiteColor]];
    [logout.titleLabel setFont:FONT_SYSTEM_SIZE(18)];
    [logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:logout];
    
    // Version
    WXWLabel *versionLabel = [[[WXWLabel alloc] initWithFrame:CGRectMake(buttonX, 333 + BUTTON_LOGOUT_HEIGHT, 300, BUTTON_LOGOUT_HEIGHT) textColor:[UIColor grayColor] shadowColor:TRANSPARENT_COLOR] autorelease];
    versionLabel.font = FONT(12);
    versionLabel.textAlignment = UITextAlignmentCenter;
    versionLabel.text = [NSString stringWithFormat:@"版本 V%@", VERSION];
    [_tableView addSubview:versionLabel];
    
    //监听主题切换的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3-1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case ME_SECTION_TYPE_HEADER: return 1; break;
        case ME_SECTION_TYPE_MESSAGE: return 1; break;
        case ME_SECTION_TYPE_OTHER: return 4; break;
        default:
            return 0;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case ME_SECTION_TYPE_HEADER: return PERSONAL_INFO_CELL_HEIGHT; break;
        case ME_SECTION_TYPE_MESSAGE: return MORE_CELL_HEIGHT; break;
        case ME_SECTION_TYPE_OTHER: return MORE_CELL_HEIGHT; break;
            
        default:
            break;
    }
    return MORE_CELL_HEIGHT;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case ME_SECTION_TYPE_HEADER: return 0;
        case ME_SECTION_TYPE_MESSAGE: return 0;
        case ME_SECTION_TYPE_OTHER: return 20;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    switch (indexPath.section) {
        case ME_SECTION_TYPE_HEADER:
        {
            NSString *identifier = [NSString stringWithFormat:@"CIOPersonalInfoCell"];
            CIOPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                
                UserBaseInfo *baseInfo = [[ProjectDBManager instance] getUserInfoByUserIdFromDB:[AppManager instance].userId];
                cell = [[[CIOPersonalInfoCell alloc] initWithStyle:CellStyle_Header reId:identifier] autorelease];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                cell.accessoryView.backgroundColor=[UIColor blueColor];
                [cell.headerImage updateImage:baseInfo.portraitName withId:[AppManager instance].userId];
                cell.nameLabel.text =[NSString stringWithFormat:@"%@",baseInfo.chName];
            }
            
            return cell;
        }
            break;
            
        case ME_SECTION_TYPE_MESSAGE: {
            NSString *identifier = @"CIOMoreCell";
            CIOMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[[CIOMoreCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"communication_bar_message.png");
            cell.textLabel.text = @"私信";
            
            return cell;
        }
            
        case ME_SECTION_TYPE_OTHER:
        {
            NSString *identifier = @"CIOMoreCell";
            CIOMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[[CIOMoreCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            switch (indexPath.row) {
                case ME_CELL_AUTHENTICATE:
                    cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"me_collect.png");
                    cell.textLabel.text = @"我的认证";
                    
                    WXWLabel *authenticateLabel = [[[WXWLabel alloc] initWithFrame:CGRectMake(235, 14, 95, 18) textColor:HEX_COLOR(@"0x3696e0") shadowColor:TRANSPARENT_COLOR] autorelease];
                    authenticateLabel.textAlignment = UIControlContentVerticalAlignmentCenter;
                    authenticateLabel.text = @"未认证";
                    [cell.contentView addSubview:authenticateLabel];
                    break;
                    
                case ME_CELL_COLLECTION:
                    
                    cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"me_collect.png");
                    cell.textLabel.text = @"收藏";
                    break;
                    
                case ME_CELL_SHARE_INVITE:
                    
                    cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"information_share.png");
                    cell.textLabel.text = @"分享与邀请";
                    break;
                    
                case ME_CELL_SYS_SETTING:
                    
                    cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"me_setting.png");
                    cell.textLabel.text = @"系统设置";
                    break;
                    
                default:
                    break;
            }
            
            return cell;
        }
        default:
            return nil;
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case ME_SECTION_TYPE_HEADER:
        {
            MyInfoViewController *myInfo = [[[MyInfoViewController alloc] initWithMOC:_MOC parentVC:nil viewHeight:0] autorelease];
            [CommonMethod pushViewController:myInfo withAnimated:YES];
        }
            break;
            
        case ME_SECTION_TYPE_MESSAGE:
        {
        }
            break;
            
        case ME_SECTION_TYPE_OTHER:
        {
            switch (indexPath.row) {
                case ME_CELL_AUTHENTICATE:
                {
                    AuthenticateViewController *myInfo = [[[AuthenticateViewController alloc] initWithMOC:_MOC parentVC:nil viewHeight:0] autorelease];
                    [CommonMethod pushViewController:myInfo withAnimated:YES];
                }
                    break;
                    
                case ME_CELL_COLLECTION:
                {
                    [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:@"制作中，敬请期待" delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles:nil] autorelease] show];
                }
                    break;
                    
                case ME_CELL_SHARE_INVITE:
                {
                    [self shareAndInvite];
                }
                    break;
                    
                case ME_CELL_SYS_SETTING:
                    {
                        MoreViewController *myInfo = [[[MoreViewController alloc] initWithMOC:_MOC parentVC:self.parentVC viewHeight:0] autorelease];
                        [CommonMethod pushViewController:myInfo withAnimated:YES];
                    }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)shareAndInvite {
    UIActionSheet *as = [[[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:nil] autorelease];
    
    [as addButtonWithTitle:LocaleStringForKey(NSShareBySMSTitle, nil)];
    [as addButtonWithTitle:LocaleStringForKey(NSShareByWeixinTitle, nil)];
    [as addButtonWithTitle:LocaleStringForKey(NSCancelTitle, nil)];
    as.cancelButtonIndex = [as numberOfButtons] - 1;
    
    [as showInView:self.view];
    
    _asOwnerType = SHARE_AS_TY;
}

#pragma mark - share app
- (void)shareBySMS {
    if (![MFMessageComposeViewController canSendText]) {
        ShowAlert(self,LocaleStringForKey(NSNoteTitle, nil), LocaleStringForKey(NSNoSupportTitle, nil), LocaleStringForKey(NSOKTitle, nil));
        return;
    }
    
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    controller.body = [AppManager instance].recommend;
    controller.recipients = @[NULL_PARAM_VALUE];
    controller.messageComposeDelegate = (id<MFMessageComposeViewControllerDelegate>)self;
    
    if (self.parentVC) {
        [self.parentVC.navigationController presentModalViewController:controller animated:YES];
    }
}

#pragma mark - action sheet delegate method
- (void)actionSheet:(UIActionSheet *)as clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (_asOwnerType) {
       
        case SHARE_AS_TY:
        {
            switch (buttonIndex) {
                case SHARE_SMS_AS_IDX:
                    [self shareBySMS];
                    break;
                    
                case SHARE_WX_AS_IDX:
                    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                        
                        NSString *url = [NSString stringWithFormat:@"http://weixun.co/gohigh_test.html"];
                        
                        BOOL reult = [CommonUtils shareByWeChat:WXSceneSession
                                                          title:LocaleStringForKey(NSAppRecommendTitle, nil)
                                                          image:[CommonMethod getAppIcon]
                                                    description:[AppManager instance].recommend
                                                            url:url];
                        
                        if (reult) {
                            DLog(@"share sucessfully");
                        }
                    } else {
                        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@""
                                                                         message:@"你的iPhone上还没有安装微信,无法使用此功能，使用微信可以方便的把你喜欢的作品分享给好友。"
                                                                        delegate:self
                                                               cancelButtonTitle:@"取消"
                                                               otherButtonTitles:@"免费下载微信", nil];
                        [alView show];
                        [alView release];
                    }
                    break;
                    
                default:
                    break;
            }
            break;
        }
            
        default:
            break;
    }
}

-(void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    [self logout:nil];
}

- (void)logout:(UIButton *)sender {
    [[AppManager instance].userDefaults rememberUsername:[[AppManager instance].userDefaults usernameRemembered] andPassword:@"" customerName:@""];
    
    
    [((ProjectAppDelegate *)APP_DELEGATE) logout];
    
    HomeContainerViewController *homeContainerVC = (HomeContainerViewController *)self.parentVC;
    [homeContainerVC selectFirstTabBar];
}

- (void)themeNotification:(id)sender
{
    HomeContainerViewController *homeContainerVC = (HomeContainerViewController *)self.parentVC;
    [homeContainerVC refreshTabItems];
}

@end


