
#import "MeSettingController.h"
#import "MoreViewController.h"
#import "ChangePWDViewController.h"
#import "HomeContainerViewController.h"
#import "WXWLabel.h"
#import "SkinListViewController.h"
#import "LanguageListViewController.h"
#import "CircleMarkegingApplyWindow.h"
#import "FileUtils.h"

#define SETTING_CELL_HEIGHT  50.0f

typedef enum
{
    Change_Language_Cell_Type,
    Clear_Cache_Cell_Type,
    Change_Skin_Cell_Type,
} MsgSettingCellType;

typedef enum : NSUInteger {
    User_Setting_Section0_Type,
    User_Setting_Section1_Type,
    User_Setting_Section2_Type
} UserSettingSectionType;

enum ALERT_TAG {
    ALERT_TAG_CLEAR_CACHE = 1,
    ALERT_TAG_UPDATE = 2,
};

@interface MeSettingController () <CircleMarkegingApplyWindowDelegate>
{
    UITableView *_setTableView;
}

@property (nonatomic, retain) UITableView *_setTableView;

@end

@implementation MeSettingController
@synthesize _setTableView;


- (void)dealloc
{
    [_setTableView release];
    [super dealloc];
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
{
    
    self = [super initWithMOC:MOC
        needRefreshHeaderView:NO
        needRefreshFooterView:NO];
    
    if (self) {
        self.parentVC = (HomeContainerViewController*)pVC;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xeeeeee"]];
    [self.view addSubview:[self setSettingTable]];
}

- (UITableView *)setSettingTable
{
    self._setTableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped] autorelease];
    [_setTableView setDataSource:self];
    [_setTableView setDelegate:self];
    [_setTableView setAllowsMultipleSelection:NO];
    [_setTableView setSeparatorInset:UIEdgeInsetsMake(0, 18.0, 0, 0)];
    [_setTableView setBackgroundColor:[UIColor clearColor]];
    
    return self._setTableView;
}

- (NSMutableDictionary *)setCellTextData
{

    NSMutableArray *passwordArr = [[[NSMutableArray alloc]initWithObjects:@"密码修改", nil]autorelease];
    NSMutableArray *privacyArr = [[[NSMutableArray alloc]initWithObjects:@"切换语言", @"清空缓存", @"更换皮肤", nil] autorelease];
    NSMutableArray *aboutArr = [[[NSMutableArray alloc]initWithObjects:@"关于企信", nil]autorelease];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:passwordArr forKey:[NSNumber numberWithInt:20]];
    [dataDic setObject:privacyArr forKey:[NSNumber numberWithInt:21]];
    [dataDic setObject:aboutArr forKey:[NSNumber numberWithInt:22]];
    
    return dataDic;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    [view release];
}

#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == User_Setting_Section1_Type)
    {
        return 3-1;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 17.5f;
    
//    if (section == User_Setting_Section0_Type)
//    {
//        return 17.5f;
//    } else {
//        return 0.f;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SETTING_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
    
//    if (section == User_Setting_Section1_Type)
//    {
//        return 100.0f;
//    } else {
//         return 14.0f;
//    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headView = [[[UIView alloc] init] autorelease];
//    [headView setBackgroundColor:[UIColor redColor]];
//    return headView;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *headView = [[[UIView alloc] init] autorelease];
//    [headView setBackgroundColor:[UIColor blueColor]];
//    return headView;
//    
//    /*
//    if (section == User_Setting_Section1_Type)
//    {
//        float gap = 18.0f;
//        float hGap = 29.5f;
//        float btnHeight = 44.0f;
//        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [logoutBtn setBackgroundColor:[UIColor clearColor]];
//        [logoutBtn setBackgroundImage:[UIImage imageNamed:@"Me_logout"] forState:UIControlStateNormal];
//        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//        [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [logoutBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
//        [logoutBtn setBounds:CGRectMake(0, 0, SCREEN_WIDTH - gap*2, btnHeight)];
//        [logoutBtn setCenter:CGPointMake(SCREEN_WIDTH/2, hGap + btnHeight/2)];
//        [logoutBtn addTarget:self action:@selector(logoutClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIView *footView = [[[UIView alloc]init] autorelease];
//        [footView setBackgroundColor:[UIColor clearColor]];
//        [footView addSubview:logoutBtn];
//        
//        return footView;
//    }
//    */
//    return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self drawSettingTableRect:tableView atIndexPath:indexPath];
}

- (UITableViewCell *)drawSettingTableRect:(UITableView *)tableView atIndexPath:(NSIndexPath *)index
{
    static NSString *kCellIdentifier = @"MeSettingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (nil == cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:kCellIdentifier] autorelease];
        
        WXWLabel *cellLabel = [[[WXWLabel alloc] initWithFrame:CGRectMake(16.5f, (SETTING_CELL_HEIGHT-18.0f)/2, 100.0f, 18.0f)
                                                     textColor:[UIColor colorWithHexString:@"0x485156"]
                                                   shadowColor:TRANSPARENT_COLOR
                                                          font:FONT(15)] autorelease];
        [cellLabel setText:[[[self setCellTextData] objectForKey:[NSNumber numberWithInt:index.section + 20]] objectAtIndex:index.row]];
        [cell.contentView addSubview:cellLabel];
    }
    
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section])
    {
        case User_Setting_Section0_Type:
        {
            ChangePWDViewController *vc = [[[ChangePWDViewController alloc] initWithMOC:_MOC] autorelease];
            [CommonMethod pushViewController:vc withAnimated:YES];
        }
            break;
            
        case User_Setting_Section1_Type:
        {
            switch ([indexPath row])
            {
                case Change_Skin_Cell_Type:
                {
                    SkinListViewController *styleVC = [[[SkinListViewController alloc] initSkinList:self.parentVC] autorelease];
                    [CommonMethod pushViewController:styleVC withAnimated:YES];
                }
                    break;
                    
                case Change_Language_Cell_Type:
                {
                    LanguageListViewController *languageVC = [[[LanguageListViewController alloc] initWithParentVC:self.parentVC entrance:self refreshAction:@selector(refreshForLanguageSwitch)] autorelease];
                    
                    BaseNavigationController *languageNC = [[[BaseNavigationController alloc] initWithRootViewController:languageVC] autorelease];
                    [self.parentViewController presentViewController:languageNC animated:YES completion:nil];
                }
                    break;
                    
                case Clear_Cache_Cell_Type:
                {
                    CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
                    [customeAlertView setMessage:@"您确定要清空所有缓存吗？"
                                           title:@"温馨提示"];
                    customeAlertView.tag = ALERT_TAG_CLEAR_CACHE;
                    customeAlertView.applyDelegate = self;
                    [customeAlertView show];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case User_Setting_Section2_Type:
        {
            [self showCommingAlert];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)logoutClick:(id)sender
{
    NSLog(@"LOG OUT CLICK....");
    [[AppManager instance].userDefaults rememberUsername:[[AppManager instance].userDefaults usernameRemembered] andPassword:@"" customerName:@""];
    
    [((ProjectAppDelegate *)APP_DELEGATE) logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    HomeContainerViewController *homeVC = (HomeContainerViewController *)self.parentVC;
    [homeVC selectFirstTabBar];
    [homeVC modifyFromTabBarFlag];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- circle marketing delegate

- (void)circleMarkegingApplyWindowCancelDismiss:(CircleMarkegingApplyWindow *) alertView {
    
    [alertView release];
}

- (void)circleMarkegingApplyWindowDismiss:(CircleMarkegingApplyWindow *)alertView applyList:(NSArray *)applyArray {
    
    [alertView release];
    
    switch (alertView.tag) {
            
        case ALERT_TAG_CLEAR_CACHE:
            [self clearCache];
            break;
            
        case ALERT_TAG_UPDATE:
            [CommonMethod update:[AppManager instance].updateURL];
            break;
            
        default:
            break;
    }
}

- (void)clearCache {
    [self showAsyncLoadingView:@"正在清理..." blockCurrentView:YES];
    
    NSString *imagePath = [CommonMethod getLocalImageFolder];
    NSString *downloadPath = [CommonMethod getLocalDownloadFolder];
    if ([CommonMethod isExist:imagePath]) {
        NSError *err = nil;
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&err];
        
        [FileUtils  mkdir:[CommonMethod getLocalImageFolder]];
    }
    
    if ([CommonMethod isExist:downloadPath]) {
        NSError *err = nil;
        [[NSFileManager defaultManager] removeItemAtPath:downloadPath error:&err];
        [FileUtils mkdir:[CommonMethod getLocalDownloadFolder]];
    }
    
    [[ProjectDBManager instance] dropTables:[CommonMethod tableNames]];
    
    [self clearMessage];
    
    [self closeAsyncLoadingView];
}

- (void)clearMessage
{
    [self displayProgressingView];
    NSArray* arr = [self.modelEngineVoip.imDBAccess getAllFilePath];
    [self.modelEngineVoip deleteFileWithPathArr:arr];
    [self.modelEngineVoip.imDBAccess deleteAllIMMsg];
    
    // 群组也删除
    [self.modelEngineVoip.imDBAccess deleteAllGroupInfo];
    [self dismissProgressingView];
}

- (void)refreshForLanguageSwitch {
    if (_personalEntrance && _refreshAction) {
        [_personalEntrance performSelector:_refreshAction];
    }
    
    self.navigationItem.title = LocaleStringForKey(NSSettingsTitle, nil);
}

@end
