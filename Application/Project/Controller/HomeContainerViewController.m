
#import "HomeContainerViewController.h"
#import "InformationViewController.h"
#import "ChatListViewController.h"
#import "CircleMarketingViewController.h"
#import "MeViewController.h"
#import "GlobalConstants.h"
#import "TextPool.h"
#import "CommonHeader.h"
#import "CommonWebViewController.h"
#import "AddressListViewController.h"
#import "AppManager.h"
#import "TabBarView.h"
#import "MeTypeViewController.h"
#import "BJHomePageViewController.h"

@interface HomeContainerViewController () <TabDelegate>
{
    bool isFromTabBar;
    
    CGFloat _tabbarOriginalY;
    
//    NSManagedObjectContext *_MOC;
}

@property (nonatomic, retain) TabBarView *tabBar;
@property (nonatomic, retain) UIWindow *statusBarBackground;
@property (nonatomic, retain) RootViewController *currentVC;

@property (nonatomic, retain) InformationViewController *infoVC;
@property (nonatomic, retain) BJHomePageViewController *bjHomePageVC;
@property (nonatomic, retain) ChatListViewController *chatVC;
@property (nonatomic, retain) CircleMarketingViewController *eventVC;
@property (nonatomic, retain) MeViewController *meVC;
@property (nonatomic, retain) CommonWebViewController *activityVC;
@property (nonatomic, retain) AddressListViewController *addressVC;
@property (nonatomic, retain) MeTypeViewController *meTypeVC;

//@property (nonatomic, retain) NSManagedObjectContext *MOC;

@end

@implementation HomeContainerViewController
//@synthesize MOC;

#pragma mark - init views
- (void)initTabBar {
    if (CURRENT_OS_VERSION >= IOS7) {
        _tabbarOriginalY = SCREEN_HEIGHT - HOMEPAGE_TAB_HEIGHT;
    } else {
        _tabbarOriginalY = SCREEN_HEIGHT - HOMEPAGE_TAB_HEIGHT - self.navigationController.navigationBar.frame.size.height;
    }
    
    self.tabBar = [[[TabBarView alloc] initWithFrame:CGRectMake(0, _tabbarOriginalY, SCREEN_WIDTH, HOMEPAGE_TAB_HEIGHT) delegate:self] autorelease];
    [self.view addSubview:self.tabBar];
}

- (void)initNavigationBarTitle {
    //    self.navigationItem.title = LocaleStringForKey(NSAppTitle, nil);
}

- (CGFloat)contentHeight {
    
    float backVal = self.view.frame.size.height - HOMEPAGE_TAB_HEIGHT;
    NSLog(@"backVal ==================== %0.f", backVal);
    
    return backVal;
}

#pragma mark - life cycle methods
- (id)initHomepageWithMOC:(NSManagedObjectContext *)MOC
{
    self = [super initWithMOCWithoutBackButton:MOC];
    if (self) {
        [CommonMethod getInstance].navigationRootViewController = self;
    }
    return self;
}

- (void)dealloc {
    
    self.tabBar = nil;
    
    self.currentVC = nil;
    
    self.statusBarBackground = nil;
    
    [_infoVC release];
    [_chatVC release];
    [_eventVC release];
    [_meVC release];
    [_activityVC release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    isFromTabBar = YES;
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    [self initTabBar];
    
    [self initNavigationBarTitle];
    
    [self selectFirstTabBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modifyFromTabBar)
                                                 name:INFO_VIEW_REFREASH_NOTIFY
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self doShowOrHideNaviBar];
    
    if (self.currentVC) {
        [WXWCommonUtils checkAndExecuteSelectorWithName:@"play" byTarget:self.currentVC];
        
        if (CURRENT_OS_VERSION >= IOS7) {
            if ([self.currentVC isKindOfClass:[InformationViewController class]]) {
                //                [self hideNavigationBarForiOS7];
            } else {
                self.statusBarBackground.backgroundColor = [UIColor whiteColor];
                [self.statusBarBackground setHidden:NO];
            }
        }
        
        [self.currentVC viewWillAppear:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.currentVC) {
        [WXWCommonUtils checkAndExecuteSelectorWithName:@"stopPlay" byTarget:self.currentVC];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - clear current vc
- (void)clearCurrentVC {
    [self.currentVC cancelConnectionAndImageLoading];
    [self.currentVC cancelLocation];
    
    if (self.currentVC.view) {
        [self.currentVC.view removeFromSuperview];
    }
    
    self.currentVC = nil;
}

#pragma mark - refresh tab items
- (void)refreshTabItems {
    
    [self.tabBar refreshItems];
    self.tabBar.backgroundColor = [[ThemeManager shareInstance] getColorWithName:@"tabBarBGColor"];
    [self.view bringSubviewToFront:self.tabBar];
    [self.tabBar switchTabHighlightStatus:TAB_BAR_FOURTH_TAG];
}

- (void)modifyFromTabBar
{
    isFromTabBar = NO;
}

#pragma mark - show or hide navi bar
- (void)hiddenNavigationBar {
    [self doShowOrHideNaviBar];
    isFromTabBar = YES;
}

- (void)showNavigationBar {
    [self doShowOrHideNaviBar];
    isFromTabBar = YES;
}

- (void)modifyFromTabBarFlag
{
    isFromTabBar = YES;
}

- (void)adjustTabViewFrame {
    
    int y = SCREEN_HEIGHT - HOMEPAGE_TAB_HEIGHT;
    
    if ([self.currentVC isKindOfClass:[BJHomePageViewController class]]) {
        self.tabBar.frame = CGRectMake(0, y, SCREEN_WIDTH, HOMEPAGE_TAB_HEIGHT);
    } else {
        self.tabBar.frame = CGRectMake(0, y - 64, SCREEN_WIDTH, HOMEPAGE_TAB_HEIGHT);
    }
}

- (void)changeTabView:(BOOL)isShow {
    self.tabBar.hidden = !isShow;
    
    [self showNavigationBar];
}

- (void)doShowOrHideNaviBar {
    
    self.navigationController.navigationBarHidden = NO;
    
    if ([self.currentVC isKindOfClass:[BJHomePageViewController class]])
    {
        self.navigationController.navigationBarHidden = YES;
        if (isFromTabBar) {
            [self.currentVC.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HOMEPAGE_TAB_HEIGHT)];
        }
        
    } else if([self.currentVC isKindOfClass:[ChatListViewController class]]){
        [self.currentVC.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HOMEPAGE_TAB_HEIGHT - 64)];
    } else if([self.currentVC isKindOfClass:[AddressListViewController class]]){
        [self.currentVC.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 4)];
    } else if([self.currentVC isKindOfClass:[MeTypeViewController class]]){
        [self.currentVC.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HOMEPAGE_TAB_HEIGHT - 64)];
    } else {
        [self.currentVC.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    
    [self adjustTabViewFrame];
}

#pragma mark - TabDelegate methods

- (void)removeCurrentView {
    
    [WXWCommonUtils checkAndExecuteSelectorWithName:@"stopPlay" byTarget:self.currentVC];
    
    [self clearCurrentVC];
}

- (void)arrangeCurrentVC:(RootViewController *)vc {
    
    [self removeCurrentView];
    
    self.currentVC = vc;
    
    [self.view addSubview:self.currentVC.view];
    
    NSLog(@" ===== currentVC.view.frame ===== %@", NSStringFromCGRect(self.currentVC.view.frame));
    
    if ([WXWCommonUtils currentOSVersion] < IOS5) {
        [self.currentVC viewWillAppear:YES];
    }
    
    [self doShowOrHideNaviBar];
    
    [self.view bringSubviewToFront:self.tabBar];
}

- (void)refreshBadges {
    [self.tabBar refreshBadges];
}

//首页
- (void)selectFirstTabBar {
    
    if ([self.currentVC isKindOfClass:[BJHomePageViewController class]]) {
        return;
    }
    
    if (!self.bjHomePageVC)
        _bjHomePageVC= [[BJHomePageViewController alloc] initWithNibName:@"BJHomePageViewController" bundle:nil moc:self.MOC];
    [self arrangeCurrentVC:self.bjHomePageVC];
    
    [self.tabBar switchTabHighlightStatus:TAB_BAR_FIRST_TAG];
    
    /*
     if ([self.currentVC isKindOfClass:[InformationViewController class]]) {
     return;
     }
     
     if (!self.infoVC)
     _infoVC = [[InformationViewController alloc] initWithMOC:self.MOC
     viewHeight:[self contentHeight]
     homeContainerVC:self];
     
     [self arrangeCurrentVC:self.infoVC];
     
     [self.tabBar switchTabHighlightStatus:TAB_BAR_FIRST_TAG];
     */
}

//交流
- (void)selectSecondTabBar
{
    if ([self.currentVC isKindOfClass:[ChatListViewController class]]) {
        return;
    }
    
    self.navigationItem.title = LocaleStringForKey(NSMainPageBottomBarCommunicat, nil);
    
    if (!self.chatVC)
        _chatVC = [[ChatListViewController alloc] initWithMOC:_MOC viewHeight:[self contentHeight] parentVC:self];
    [self arrangeCurrentVC:self.chatVC];
}

// 活动
- (void)selectThirdTabBar {
    
    if ([self.currentVC isKindOfClass:[AddressListViewController class]]) {
        return;
    }

    self.navigationItem.title = LocaleStringForKey(NSMainPageTopTraining, nil);
    
    self.addressVC = [[[AddressListViewController alloc] initWithMOC:_MOC parentVC:self offsetHeight:50] autorelease];
    [self arrangeCurrentVC:self.addressVC];
}

//我
- (void)selectFourthTabBar
{
    if ([self.currentVC isKindOfClass:[MeTypeViewController class]]) {
        return;
    }
    
    self.navigationItem.title = LocaleStringForKey(NSMainPageBottomBarMe, nil);
    
    /*
     if (!self.meVC)
     _meVC = [[MeViewController alloc] initWithMOC:_MOC
     parentVC:self];
     [self arrangeCurrentVC:self.meVC];
     */
    
    if (!self.meTypeVC) {
        _meTypeVC = [[MeTypeViewController alloc] initWithMOC:_MOC parentVC:self];
    }
    
    [self arrangeCurrentVC:self.meTypeVC];
}

- (void)selectFifthTabBar
{
}

@end
