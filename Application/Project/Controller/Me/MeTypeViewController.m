
#import "MeTypeViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CommonMethod.h"
#import "MoreViewController.h"
#import "MeViewController.h"
#import "AppManager.h"
#import "WXApi.h"
#import "CommonUtils.h"
#import "UIImageView+WebCache.h"
#import "HomeContainerViewController.h"
#import "MeSettingController.h"
#import "MeStoreController.h"
#import "IdentityAuthViewController.h"
#import "MeTypeTableViewCell.h"
#import "VPImageCropperViewController.h"
#import "ChangePWDViewController.h"
#import "FeedQuestionViewController.h"
#import "UserDetailEditViewController.h"
#import "UserObject.h"

#define kTableSectionHeight 17.5f
#define kTableHeadHeight    72.5f
#define kTableFootheight    (kTableSectionHeight + kMeTypeCellHeight)

typedef enum : NSUInteger {
    Me_Section0_Type,
    Me_Section1_Type,
    Me_Section2_Type,
    Me_Section3_Type
} MeSectionType;

enum Section2_Section_Type
{
    Seprate_Img_Type = 102,
    UserName_lbl_Type,
    Vision_lbl_Type,
};

enum sheetType
{
    Camera_Sheet_Type,
    Share_Sheet_Type,
    Logout_Sheet_Type,
};

enum Head_Control_Type
{
    Head_userImg_Type = 301,
    Head_name_Type,
    Head_title_Type,
    Head_detail_Type,
};

@interface MeTypeViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>

@property (nonatomic, retain) UITableView *m_meTableView;
@property (nonatomic, retain) UIImageView *m_userImgView;
@property (nonatomic, retain) UIImageView *m_headView;

@end

@implementation MeTypeViewController
{
    UserObject *userInfo;
}

@synthesize m_meTableView;
@synthesize m_userImgView;
@synthesize m_headView;

- (void)dealloc
{
    RELEASE_OBJ(m_meTableView);
    RELEASE_OBJ(m_userImgView);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    
    [super dealloc];
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

- (void)viewWillAppear:(BOOL)animated
{
    userInfo = [[ProjectDBManager instance] getUserInfoByUserIdFromDB:[AppManager instance].userId];
    [self.m_meTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:[self createMeTypeTable]];
    
    //监听主题切换的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Create Control

- (UITableView *)createMeTypeTable
{
    CGRect tableFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 48);
    self.m_meTableView = [[[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped] autorelease];
    [m_meTableView setBackgroundColor:COLOR(219, 219, 219)];
    [m_meTableView setDataSource:self];
    [m_meTableView setDelegate:self];
    [m_meTableView setShowsHorizontalScrollIndicator:NO];
    [m_meTableView setShowsVerticalScrollIndicator:NO];
    [m_meTableView setSeparatorInset:UIEdgeInsetsMake(0, 11, 0, 0)];
    [m_meTableView setSeparatorColor:HEX_COLOR(@"0xc1c0c5")];
//    [m_meTableView setSectionFooterHeight:12.0];//设置section之间的间距
    [m_meTableView setMultipleTouchEnabled:NO];
    
    return m_meTableView;
}

- (NSMutableDictionary *)setTitleDictionary
{
    NSMutableArray *section0Array = [[[NSMutableArray alloc]initWithObjects:@"积分", @"等级", nil] autorelease];
    NSMutableArray *section1Array = [[[NSMutableArray alloc]initWithObjects:@"反馈", nil] autorelease];
    NSMutableArray *section2Array = [[[NSMutableArray alloc]initWithObjects:@"版本", nil] autorelease];
    NSMutableArray *section3Array = [[[NSMutableArray alloc]initWithObjects:@"设置", nil] autorelease];
    
    NSMutableDictionary *titleDic = [[[NSMutableDictionary alloc]initWithCapacity:0] autorelease];
    [titleDic setObject:section0Array forKey:[NSNumber numberWithInt:10]];
    [titleDic setObject:section1Array forKey:[NSNumber numberWithInt:11]];
    [titleDic setObject:section2Array forKey:[NSNumber numberWithInt:12]];
    [titleDic setObject:section3Array forKey:[NSNumber numberWithInt:13]];
    return titleDic;
}

- (NSMutableDictionary *)setValueDictionary
{
    NSMutableArray *section0Array = [[[NSMutableArray alloc]initWithObjects:@"168", @"Level 3", nil] autorelease];
    NSMutableArray *section1Array = [[[NSMutableArray alloc]initWithObjects:@"", nil] autorelease];
    NSMutableArray *section2Array = [[[NSMutableArray alloc]initWithObjects:VERSION, nil] autorelease];
    NSMutableArray *section3Array = [[[NSMutableArray alloc]initWithObjects:@"", nil] autorelease];
    
    NSMutableDictionary *titleDic = [[[NSMutableDictionary alloc]initWithCapacity:0] autorelease];
    [titleDic setObject:section0Array forKey:[NSNumber numberWithInt:10]];
    [titleDic setObject:section1Array forKey:[NSNumber numberWithInt:11]];
    [titleDic setObject:section2Array forKey:[NSNumber numberWithInt:12]];
    [titleDic setObject:section3Array forKey:[NSNumber numberWithInt:13]];
    return titleDic;
}

- (NSMutableDictionary *)setImageDictionary
{
    NSMutableArray *section0Array = [[[NSMutableArray alloc]initWithObjects:@"me_point", @"me_level", nil] autorelease];
    NSMutableArray *section1Array = [[[NSMutableArray alloc]initWithObjects:@"me_feedback", nil] autorelease];
    NSMutableArray *section2Array = [[[NSMutableArray alloc]initWithObjects:@"me_update", nil] autorelease];
    NSMutableArray *section3Array = [[[NSMutableArray alloc]initWithObjects:@"me_setting", nil] autorelease];
    
    NSMutableDictionary *imageDic = [[[NSMutableDictionary alloc]initWithCapacity:0] autorelease];
    [imageDic setObject:section0Array forKey:[NSNumber numberWithInt:10]];
    [imageDic setObject:section1Array forKey:[NSNumber numberWithInt:11]];
    [imageDic setObject:section2Array forKey:[NSNumber numberWithInt:12]];
    [imageDic setObject:section3Array forKey:[NSNumber numberWithInt:13]];
    return imageDic;
}

- (UILabel *)createUserIDLbl
{
    float heightGap = 93.5f;
    float lblHeight = 16.0f;
    float lblWidth = 160.0f;
    
    CGRect userRect = CGRectMake((SCREEN_WIDTH - lblWidth)/2, heightGap, lblWidth, lblHeight);
    UILabel *userName = [InformationDefault createLblWithFrame:userRect withTextColor:[UIColor whiteColor] withFont:[UIFont boldSystemFontOfSize:15] withTag:UserName_lbl_Type];
    [userName setTextAlignment:NSTextAlignmentCenter];
    [userName setText:@"Vivien"];
    return userName;
}

- (UILabel *)createVisionLbl
{
    float lblHeght = 11.0f;
    UIColor *lblColor = [UIColor colorWithHexString:@"0xb1b1b1"];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    CGRect lblFrame = CGRectMake(0, (kTableFootheight - lblHeght)/2 + 60, SCREEN_WIDTH, lblHeght);
    UILabel *visionLbl = [InformationDefault createLblWithFrame:lblFrame withTextColor:lblColor withFont:font withTag:Vision_lbl_Type];
    [visionLbl setTextAlignment:NSTextAlignmentCenter];
    [visionLbl setText:[NSString stringWithFormat:@"版本号：1.0"]];
    
    return visionLbl;
}

- (UIButton *)createLogoutBtn
{
    UIButton *logoutBtn = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMeTypeCellHeight)] autorelease];
    [logoutBtn setBackgroundColor:TRANSPARENT_COLOR];
    [logoutBtn.titleLabel setFont:FONT_SYSTEM_SIZE(15)];
    [logoutBtn setTitleColor:HEX_COLOR(@"0x333333") forState:UIControlStateNormal];
    [logoutBtn setTitleColor:HEX_COLOR(@"0x666666") forState:UIControlStateSelected];
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    
    return logoutBtn;
}

- (UIImageView *)setUserMsgView
{
    CGRect headRect = CGRectMake(0, 0, SCREEN_WIDTH, kTableHeadHeight);
    self.m_headView = [[[UIImageView alloc] initWithFrame:headRect] autorelease];
    [m_headView setBackgroundColor:[UIColor whiteColor]];
    [m_headView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileClick)] autorelease];
    [m_headView addGestureRecognizer:tapGesture];
    return m_headView;
}

- (void)setTableHeadView
{
    
    CGRect userRect =  CGRectMake(14, 11, 46.5, 46.5);
    self.m_userImgView = [[UIImageView alloc] initWithFrame:userRect];
    [self.m_userImgView setImageWithURL:[NSURL URLWithString:userInfo.userImageUrl] placeholderImage:[UIImage imageNamed:@"groupCellDefaultHeader.png"]];
    [self.m_headView addSubview:self.m_userImgView];
    
    CGRect userNameRect = CGRectMake(69.5, 17, 223, 16);
    UILabel *userNameLbl = [InformationDefault createLblWithFrame:userNameRect withTextColor:HEX_COLOR(@"0x666666") withFont:[UIFont fontWithName:@"Thonburi" size:17] withTag:Head_name_Type];
    [self.m_headView addSubview:userNameLbl];
    
    CGRect titleRect = CGRectMake(69.5, 40, 223, 14);
    UILabel *titleLbl = [InformationDefault createLblWithFrame:titleRect withTextColor:HEX_COLOR(@"0x999999") withFont:[UIFont fontWithName:@"Thonburi" size:13] withTag:Head_title_Type];
    [self.m_headView addSubview:titleLbl];
    
}

- (void)setUserDetailImg
{
    UIImage *nextImg = [UIImage imageNamed:@"me_detail"];
   
    UIImageView  *moreUserMsgImg = [InformationDefault createImgViewWithFrame:CGRectMake(287, 20, 35, 35) withImage:nextImg withColor:[UIColor clearColor] withTag:Head_detail_Type];
    
    [self.m_headView addSubview:moreUserMsgImg];
}

- (void)setUserMessage:(NSDictionary *)dic
{
    UILabel *userNameLbl = (UILabel *)[self.m_headView viewWithTag:Head_name_Type];
    UILabel *userTitleLbl = (UILabel *)[self.m_headView viewWithTag:Head_title_Type];
    
    [userNameLbl setText:[AppManager instance].userName];
    [userTitleLbl setText:[AppManager instance].userTitle];
}

#pragma mark - Action Click
- (void)profileClick
{
    UserObject *userObject = [[ProjectDBManager instance] getUserInfoByUserIdFromDB:[AppManager instance].userId];
    UserDetailEditViewController *vc =
    [[[UserDetailEditViewController alloc] initWithMOC:_MOC userObject:userObject] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)cameraClick
{
    [self editPortrait];
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == Me_Section0_Type)
    {
        return 2;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == Me_Section0_Type)
    {
        return kTableHeadHeight + kTableSectionHeight;
    }
    
    return kTableSectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMeTypeCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == Me_Section0_Type)
    {
        UIView *headView = [[[UIView alloc] init] autorelease];
        [headView setBackgroundColor:[UIColor clearColor]];
        [headView addSubview:[self setUserMsgView]];
        [self setTableHeadView];
        [self setUserDetailImg];
        [self setUserMessage:nil];
        return headView;
    } else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == Me_Section3_Type)
    {
        return kTableFootheight;
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section == Me_Section3_Type)
    {
        UIView *footBGView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTableFootheight)] autorelease];
        [footBGView setBackgroundColor:TRANSPARENT_COLOR];
        
        UIView *footView = [[[UIView alloc] initWithFrame:CGRectMake(0, kTableSectionHeight, SCREEN_WIDTH, kMeTypeCellHeight)] autorelease];
        [footView setBackgroundColor:[UIColor whiteColor]];
        
        [footView addSubview:[self createLogoutBtn]];
//        [footView addSubview:[self createVisionLbl]];
        
        [footBGView addSubview:footView];
        return footBGView;
    } else {
        return nil;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"MeTypeCell";
    MeTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (nil == cell)
    {
        cell = [[[MeTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:kCellIdentifier] autorelease];
    }
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    [cell setCellText:[[[self setTitleDictionary] objectForKey:[NSNumber numberWithInt:indexPath.section + 10]] objectAtIndex:indexPath.row]];
    [cell setCellTextVal:[[[self setValueDictionary] objectForKey:[NSNumber numberWithInt:indexPath.section + 10]] objectAtIndex:indexPath.row]];
    UIImage *img = [UIImage imageNamed:[[[self setImageDictionary] objectForKey:[NSNumber numberWithInt:indexPath.section + 10]] objectAtIndex:indexPath.row]];
    [cell setCellIcon:img];
    
    [cell setBadgeData:nil isHidden:YES];
    
    // cell detail icon
    UIImage *nextImg = [UIImage imageNamed:@"me_detail"];
    UIImageView *moreUserMsgImg = [InformationDefault createImgViewWithFrame:CGRectMake(287, 10, 35, 35) withImage:nextImg withColor:[UIColor clearColor] withTag:Head_detail_Type];
    [cell.contentView addSubview:moreUserMsgImg];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case Me_Section0_Type:
        {
            [self showCommingAlert];
            
            /*
            IdentityAuthViewController *myInfo = [[[IdentityAuthViewController alloc] initWithMOC:_MOC parentVC:nil viewHeight:0] autorelease];
            [CommonMethod pushViewController:myInfo withAnimated:YES];
             */
        }
            break;
       
        case Me_Section1_Type:
        {
            FeedQuestionViewController *feed = [[[FeedQuestionViewController alloc] init] autorelease];
            [CommonMethod pushViewController:feed withAnimated:YES];
        }
            break;
            
         case Me_Section2_Type:
        {
            [self showCommingAlert];
        }
            break;
        
         case Me_Section3_Type:
        {
            MeSettingController *settingVC = [[[MeSettingController alloc] initWithMOC:_MOC parentVC:self.parentVC] autorelease];
            [CommonMethod pushViewController:settingVC withAnimated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - share app
- (void)shareAndInvite {
    UIActionSheet *shareSheet = [[[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil] autorelease];
    
    [shareSheet addButtonWithTitle:LocaleStringForKey(NSShareBySMSTitle, nil)];
    [shareSheet addButtonWithTitle:LocaleStringForKey(NSShareByWeixinTitle, nil)];
    [shareSheet addButtonWithTitle:LocaleStringForKey(NSCancelTitle, nil)];
    shareSheet.cancelButtonIndex = [shareSheet numberOfButtons] - 1;
    [shareSheet setTag:Share_Sheet_Type];
    
//    [self.view addSubview:shareSheet];
//    [shareSheet showInView:self.view];
    [shareSheet showInView:[UIApplication sharedApplication].keyWindow];
}

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
        [self.parentVC.navigationController presentViewController:controller animated:YES completion:nil];
    }
}

- (void)shareByWeiXin
{
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
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag)
    {
        case Camera_Sheet_Type:
        {
            if (buttonIndex == 0)
            {
                [self enterCameraForUser];
            } else if (buttonIndex == 1) {
                
                [self enterPhotoLibraryForUser];
            } else {
                return;
            }
        }
            break;
            
        case Share_Sheet_Type:
        {
            if (buttonIndex == 0)
            {
                [self shareBySMS];
            } else if (buttonIndex == 1) {
                
                [self shareByWeiXin];
            } else {
                return;
            }
        }
            
        case Logout_Sheet_Type:
        {
            if (buttonIndex == 0)
            {
                [self doLogout];
            } else {
                return;
            }

        }
            
        default:
            break;
    }
}

#pragma mark - ImagePickerView

- (void)editPortrait
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet setTag:Camera_Sheet_Type];
    
    [choiceSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!m_userImgView) {
       
        CGFloat width = 73.0f; CGFloat height = width;
        CGFloat xGap = (SCREEN_WIDTH - width)/2;
        CGFloat yGap = 13.0f;
        self.m_userImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(xGap, yGap, width, height)]autorelease];
        [m_userImgView.layer setCornerRadius:(m_userImgView.frame.size.height/2)];
        [m_userImgView.layer setMasksToBounds:YES];
        [m_userImgView setContentMode:UIViewContentModeScaleAspectFill];
        [m_userImgView setClipsToBounds:YES];
        m_userImgView.layer.shadowColor = [UIColor blackColor].CGColor;
        m_userImgView.layer.shadowOffset = CGSizeMake(4, 4);
        m_userImgView.layer.shadowOpacity = 0.5;
        m_userImgView.layer.shadowRadius = 2.0;
        m_userImgView.layer.borderColor = [[UIColor blackColor] CGColor];
        m_userImgView.layer.borderWidth = 2.0f;
        m_userImgView.userInteractionEnabled = YES;
        m_userImgView.backgroundColor = [UIColor blackColor];
        
//        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
//        [m_userImgView addGestureRecognizer:portraitTap];
    }
    return self.m_userImgView;
}

- (void)themeNotification:(id)sender
{
    HomeContainerViewController *homeContainerVC = (HomeContainerViewController *)self.parentVC;
    [homeContainerVC refreshTabItems];
}

- (void)changeTabShowState:(BOOL)isShow {
    HomeContainerViewController *homeContainerVC = (HomeContainerViewController *)self.parentVC;
    [homeContainerVC changeTabView:isShow];
}

#pragma mark - logout
- (void)logoutClick
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"确认退出", nil];
    [choiceSheet setTag:Logout_Sheet_Type];
    
    [choiceSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)doLogout
{
    NSLog(@"LOG OUT CLICK....");
    [[AppManager instance].userDefaults rememberUsername:[[AppManager instance].userDefaults usernameRemembered] andPassword:@"" customerName:@""];
    
    [((ProjectAppDelegate *)APP_DELEGATE) logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    HomeContainerViewController *homeVC = (HomeContainerViewController *)self.parentVC;
    [homeVC selectFirstTabBar];
    [homeVC modifyFromTabBarFlag];
}

@end
