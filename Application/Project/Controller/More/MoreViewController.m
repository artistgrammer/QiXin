//
//  MoreViewController.m
//  Project
//
//  Created by Peter on 13-9-2.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "MoreViewController.h"
#import "UIColor+expanded.h"
#import "MoreCell.h"
#import "ContactUsViewController.h"
#import "DownloadManageViewController.h"
#import "FeedQuestionViewController.h"
#import "MyInfoViewController.h"
#import "WXWCustomeAlertView.h"
#import "GlobalConstants.h"
#import "CommonHeader.h"
#import "AppManager.h"
#import "ProjectAppDelegate.h"
#import "HomeContainerViewController.h"
#import "WXWLabel.h"
#import "CircleMarkegingApplyWindow.h"
#import "PXAlertView.h"
#import "ProjectDBManager.h"
#import "TextPool.h"
#import "ProjectAPI.h"
#import "JSONParser.h"
#import "JSONKit.h"
#import "GlobalConstants.h"
#import "WXWCommonUtils.h"
#import "CommonUtils.h"
#import "FileUtils.h"
#import "SkinListViewController.h"
#import "LanguageListViewController.h"

#define BUTTON_LOGOUT_WIDTH  305.f
#define BUTTON_LOGOUT_HEIGHT 49.f

#define SETTING_CELL_HEIGHT  50.0f

enum ALERT_TAG {
    ALERT_TAG_CLEAR_CACHE = 1,
    ALERT_TAG_UPDATE = 2,
};

enum CELL_ENUM_TYPE {
    CELL_STYLE_TYPE,
    CELL_LANGUAGE_TYPE,
    CELL_CLEAR_TYPE,
    CELL_FEEDBACK_TYPE,
    CELL_UPDATE_TYPE,
    CELL_CONTANT_TYPE,
};

@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate, WXWCustomeAlertViewDelegate, CircleMarkegingApplyWindowDelegate,CircleMarkegingApplyWindowDelegate> {
    UITableView *moreTable;
    NSArray *imageArr;
    NSArray *titleArr;
}

@end

@implementation MoreViewController {
    HomeContainerViewController *_parentVC;
    int _viewHeight;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
       viewHeight:(int)viewHeight{
    
    if (self = [super initWithMOC:MOC]) {
        _parentVC = (HomeContainerViewController *) pVC;
        _viewHeight = viewHeight;
    }
    
    return self;
}

- (void)refreshForLanguageSwitch {
    if (_personalEntrance && _refreshAction) {
        [_personalEntrance performSelector:_refreshAction];
    }
    
    self.navigationItem.title = LocaleStringForKey(NSSettingsTitle, nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"系统设置";
    
    if ([WXWCommonUtils currentOSVersion] < IOS7) {
        self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    }
    
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = [UIColor colorWithPatternImage:IMAGE_WITH_NAME(@"background.png")];
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    [self initData];
    
    [self addMoreTable];
}

- (void)dealloc {
    [imageArr release];
    [titleArr release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {

    imageArr = [[NSArray alloc] initWithObjects:@"release_cache.png", @"release_cache.png",@"release_cache.png", @"feed.png", @"newVersion.png", @"contact_us.png", nil];
    titleArr = [[NSArray alloc] initWithObjects:@"切换主题",@"当前语言",@"清空缓存", @"问题反馈", @"版本更新", @"联系我们", nil];
}

- (void)addMoreTable {
    int startX = 0;
    if ([WXWCommonUtils currentOSVersion] >= IOS7) {
        startX = 10;
    }
    moreTable = [[UITableView alloc] initWithFrame:CGRectMake(startX, ITEM_BASE_TOP_VIEW_HEIGHT, self.view.frame.size.width - 2*startX, self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - HOMEPAGE_TAB_HEIGHT - SYS_STATUS_BAR_HEIGHT) style:UITableViewStyleGrouped];
    moreTable.backgroundColor = TRANSPARENT_COLOR;
    moreTable.backgroundView = nil;
    moreTable.delegate = self;
    moreTable.dataSource = self;
    moreTable.showsVerticalScrollIndicator = NO;
    //    moreTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.view addSubview:moreTable];
}

- (void)logout:(UIButton *)sender {
    [[AppManager instance].userDefaults rememberUsername:[[AppManager instance].userDefaults usernameRemembered] andPassword:@"" customerName:@""];
    
    
    [((ProjectAppDelegate *)APP_DELEGATE) logout];
    [_parentVC selectFirstTabBar];
    
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

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
            
#if APP_TYPE == APP_TYPE_EMBA
        case 0:
        {
            return 5;
        }
            break;
            
#elif APP_TYPE == APP_TYPE_CIO //CIO
        case 0: return 1; break;
        case 1: return 3; break;
            
#elif APP_TYPE == APP_TYPE_O2O //O2O
        case 0: return 2; break;
        case 1: return 4; break;
#else
        case 0: return 2; break;
        case 1: return 3; break;
            
#endif //if APP_TYPE
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SETTING_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 120.f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
        
        CGFloat buttonX = (tableView.frame.size.width - BUTTON_LOGOUT_WIDTH) / 2.f;
        UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
        logout.frame = CGRectMake(buttonX, 33, BUTTON_LOGOUT_WIDTH, BUTTON_LOGOUT_HEIGHT);
        [logout setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"button_logout.png") forState:UIControlStateNormal];
        [logout setTitle:@"退出登录" forState:UIControlStateNormal];
        [logout.titleLabel setTextColor:[UIColor whiteColor]];
        [logout.titleLabel setFont:FONT_SYSTEM_SIZE(18)];
        [logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:logout];
        
        //--------------------------
        CGRect rect = logout.frame;
        rect.origin.y += rect.size.height;
        
        UILabel *version = [[WXWLabel alloc] initWithFrame:rect textColor:[UIColor colorWithHexString:@"0x333333"] shadowColor:TRANSPARENT_COLOR font:FONT_SYSTEM_SIZE(14)];
        [version setText: [NSString stringWithFormat:@"version:%@",VERSION]];
        version.textAlignment = NSTextAlignmentCenter;
        
        [view addSubview:version];
        [version release];
        
        return view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"more_cell";
    
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[MoreCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        cell.imageView.image = IMAGE_WITH_IMAGE_NAME(imageArr[indexPath.row]);
        cell.textLabel.text = titleArr[indexPath.row];
    }else {
        
#if  APP_TYPE == APP_TYPE_CIO //CIO
        cell.imageView.image = IMAGE_WITH_IMAGE_NAME(imageArr[indexPath.row + 3]);
        cell.textLabel.text = titleArr[indexPath.row + 3];
#elif  APP_TYPE == APP_TYPE_O2O //O2O
        cell.imageView.image = IMAGE_WITH_IMAGE_NAME(imageArr[indexPath.row + 2]);
        cell.textLabel.text = titleArr[indexPath.row + 2];
#else
        cell.imageView.image = IMAGE_WITH_IMAGE_NAME(imageArr[indexPath.row + 2]);
        cell.textLabel.text = titleArr[indexPath.row + 2];
        
#endif //if APP_TYPE
        
        switch (indexPath.row ) {
                
            case CELL_UPDATE_TYPE://版本更新
                if ([AppManager instance].updateURL && ![[AppManager instance].updateURL isEqualToString:@""]) {
                    [cell showRedDot:TRUE];
                }
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    switch (indexPath.row) {
            
        case CELL_STYLE_TYPE:
        {
            SkinListViewController *styleVC = [[[SkinListViewController alloc] initSkinList:_parentVC] autorelease];
            [CommonMethod pushViewController:styleVC withAnimated:YES];
        }
            break;
        
        case CELL_LANGUAGE_TYPE:
        {
            LanguageListViewController *languageVC = [[[LanguageListViewController alloc] initWithParentVC:_parentVC entrance:self refreshAction:@selector(refreshForLanguageSwitch)] autorelease];
            
            BaseNavigationController *languageNC = [[[BaseNavigationController alloc] initWithRootViewController:languageVC] autorelease];
            [self.parentViewController presentViewController:languageNC animated:YES completion:nil];
        }
            break;
            
        case CELL_CLEAR_TYPE:
        {
            CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
            [customeAlertView setMessage:@"您确定要清空所有缓存吗？"
                                   title:@"温馨提示"];
            customeAlertView.tag = ALERT_TAG_CLEAR_CACHE;
            customeAlertView.applyDelegate = self;
            [customeAlertView show];
        }
            break;
            
        case CELL_FEEDBACK_TYPE:
        {
            FeedQuestionViewController *feed = [[[FeedQuestionViewController alloc] init] autorelease];
            [CommonMethod pushViewController:feed withAnimated:YES];
        }
            break;
            
        case CELL_UPDATE_TYPE:
        {
            if ([AppManager instance].updateURL && ![[AppManager instance].updateURL isEqualToString:@""]) {
                
                [CommonMethod update:[AppManager instance].updateURL];
                
            } else {
                [self loadVersion:TRIGGERED_BY_AUTOLOAD forNew:YES];
            }
        }
            break;
            
        case CELL_CONTANT_TYPE:
        {
            ContactUsViewController *contactUs = [[[ContactUsViewController alloc] init] autorelease];
            [CommonMethod pushViewController:contactUs withAnimated:YES];
        }
            break;
            
        default:
            break;
    }
    //    }
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

#pragma mark --  customer alert delegate

- (void)CustomeAlertViewDismiss:(WXWCustomeAlertView *) alertView {
    [alertView release];
}

//--


- (void)loadVersion:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_COMMON withApiName:API_NAME_GET_VERSION withCommon:commonDict withSpecial:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:LOAD_UPDATE_VERSION_TY];
    [connFacade fetchGets:url];
}



#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    switch (contentType) {
        case LOAD_UPDATE_VERSION_TY:
        {
            
            NSDictionary *resultDic = [result objectFromJSONData];
            NSDictionary *contentDic = OBJ_FROM_DIC(resultDic, @"content");
            //            NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
            NSString *code = OBJ_FROM_DIC(resultDic, RET_CODE_NAME);
            
            if ([code isEqualToString:@"200"]) {
                CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
                [customeAlertView setMessage:@"目前已是最新版本!!"
                                       title:@"更新提示"];
                customeAlertView.tag=ALERT_TAG_UPDATE;
                customeAlertView.applyDelegate = self;
                [customeAlertView show];
            } else if ([code isEqualToString:@"220"]) {
#if APP_TYPE != APP_TYPE_O2O
                [AppManager instance].updateURL = OBJ_FROM_DIC(contentDic, @"updateUrl");
                
                CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
                [customeAlertView setMessage:@"有新版本发布， 需要更新吗？"
                                       title:@"温馨提示"];
                customeAlertView.applyDelegate = self;
                customeAlertView.tag=ALERT_TAG_UPDATE;
                [customeAlertView show];
#endif
            }
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    [super connectDone:result
                   url:url
           contentType:contentType];
    
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
}

@end
