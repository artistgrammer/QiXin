
#import "ProjectAppDelegate.h"
#import "HomeContainerViewController.h"
#import "BaseNavigationController.h"
#import <CrashReporter/CrashReporter.h>
#import "WXWDebugLogOutput.h"
#import "UIDevice+Hardware.h"
#import "WXWDBConnection.h"
#import "SplashViewController.h"
#import "WXWImageManager.h"
#import "CommonUtils.h"
#import "FileUtils.h"
#import "AppManager.h"
#import "ProjectAPI.h"
#import "GlobalConstants.h"
#import "CrashMethod.h"
#import "WXApi.h"
#import "LogUploader.h"
#import "ProjectDBManager.h"
#import "MobClick.h"

#import "CurrentLoginViewController.h"
#import "ModelEngineVoip.h"
#import "VoipIncomingViewController.h"

#import "Reachability.h"

//#import "PushListener.h"
#import "PushNotifyServer.h"

NSString *const UIApplicationDidReceivedRomateNotificationNotification = @"UIApplicationDidReceivedRomateNotificationNotification";

@interface ProjectAppDelegate () <SplashViewControllerDelegate,
 CurrentLoginVCDelegate, WXApiDelegate>

@property (nonatomic, retain) BaseNavigationController *homeNC;
@property (nonatomic, retain) SplashViewController *splashVC;
@property (nonatomic, assign) CurrentLoginViewController *userLoginVC;
@property (nonatomic, retain) BaseNavigationController *splashNav;
@property (nonatomic, retain) BaseNavigationController *loginNav;
@property (nonatomic, assign) BOOL isEndsplahsed;

@property (nonatomic, retain) UITabBarController *tabBarViewController;
@end

@implementation ProjectAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize loginNav = _loginNav;
@synthesize userLoginVC = _userLoginVC;
@synthesize modelEngineVoip;

#pragma mark - properties

- (void)dealloc {
    self.modelEngineVoip = nil;
    
    [super dealloc];
}

- (SplashViewController *)splashVC {
    if (nil == _splashVC) {
        _splashVC = [[[SplashViewController alloc] init] autorelease];
        _splashVC.delegate = self;
    }
    return _splashVC;
}

- (BaseNavigationController *)splashNav {
    if (nil == _splashNav) {
        _splashNav = [[BaseNavigationController alloc] initWithRootViewController:self.splashVC];
    }
    return _splashNav;
}

- (HomeContainerViewController *)homepageContainer {
    if (nil == _homepageContainer) {
        _homepageContainer = [[HomeContainerViewController alloc] initHomepageWithMOC:self.managedObjectContext];
    }
    
    return _homepageContainer;
}

- (BaseNavigationController *)homeNC {
    if (nil == _homeNC) {
        _homeNC = [[BaseNavigationController alloc] initWithRootViewController:self.homepageContainer];
    }
    
    self.window.rootViewController = _homepageContainer;
    return _homeNC;
}

#pragma mark - prepare app

- (void)applyCurrentLanguage {
    [WXWSystemInfoManager instance].currentLanguageCode = [WXWCommonUtils fetchIntegerValueFromLocal:SYSTEM_LANGUAGE_LOCAL_KEY];
    
    if ([WXWSystemInfoManager instance].currentLanguageCode == NO_TY) {
        [WXWCommonUtils getLocalLanguage];
    }else {
        [WXWCommonUtils getDBLanguage];
    }
}

- (void)prepareDB {
    [WXWDBConnection prepareBizDB];
}

- (void)prepareApp {
    [self prepareCrashReporter];
    
    [self loadNessesaryResource];
    
    _startup = YES;
    
    if (![IPHONE_SIMULATOR isEqualToString:[WXWCommonUtils deviceModel]]) {
        [self registerNotify];
    }
    
    [self applyCurrentLanguage];
    
    // register call back method for MOC save notification
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:sel_registerName("handleSaveNotification:")
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.managedObjectContext];
    
    [self prepareDB];
    
    // register app to WeChat
    [WXApi registerApp:WX_API_KEY];
    
    // get Device System
    [WXWCommonUtils parserDeviceSystemInfo];
}

#pragma mark - view navigation
- (void)switchViews:(BaseNavigationController *)toBeDisplayedNav {
    
    CATransition *viewFadein = [CATransition animation];
    viewFadein.duration = 0.3f;
    viewFadein.type = kCATransitionFade;
    
    [self.window.layer addAnimation:viewFadein forKey:nil];
    
    if (_premiereNav) {
        _premiereNav.view.hidden = YES;
        [_premiereNav.view removeFromSuperview];
    }
    
    toBeDisplayedNav.view.hidden = NO;
    
    [self.window setRootViewController:toBeDisplayedNav];
   
    _premiereNav = toBeDisplayedNav;
    
}

- (void)clearHomepageViewController {
    
    [self.homepageContainer cancelConnectionAndImageLoading];
    self.homepageContainer = nil;
    self.homeNC = nil;
}

- (void)clearSplashViewIfNeeded {
    
    if (_splashVC) {
        _splashVC = nil;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
}

- (void)goHomePage {
    
    [self clearSplashViewIfNeeded];
    
    [self switchViews:self.homeNC];
}

- (void)logout
{
    if (_userLoginVC) {
        
        [self clearLogin];
        _userLoginVC = [[CurrentLoginViewController alloc] initWithMOC:self.homepageContainer.MOC
                                                           parentVC:self.homepageContainer];
        
        _userLoginVC.delegate = self;
        _userLoginVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [self.window setRootViewController:_userLoginVC];
        
        NSArray *array = [NSArray arrayWithObjects:@"ChatGroupModel", nil];
        [[ProjectDBManager instance] deleteEntity:array MOC:_managedObjectContext];
    }
    
//    [[PushListener defaultListener] removeObserver];
}

#pragma mark - push notification
- (void)registerNotify
{
    //    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                           UIRemoteNotificationTypeSound |
                                                                           UIRemoteNotificationTypeAlert)];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DLog(@"My token is: %@", deviceToken);
    [AppManager instance].deviceToken = [NSString stringWithFormat:@"%@", deviceToken];
    [AppManager instance].deviceToken = [[AppManager instance].deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    [AppManager instance].deviceToken = [[AppManager instance].deviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    [AppManager instance].deviceToken = [[AppManager instance].deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self endSplash];
}

-(void)endSplash
{
    if (!self.isEndsplahsed) {
       
#if APP_TYPE == APP_TYPE_EMBA
    
    if (![IPHONE_SIMULATOR isEqualToString:[WXWCommonUtils deviceModel]]) {
        
        [self endSplash:nil];
    }
    
#endif
        self.isEndsplahsed = YES;
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    
    [self endSplash];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceivedRomateNotificationNotification
                                                        object:self
                                                      userInfo:userInfo];
}

#pragma mark - system call back methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // prepare meta data and cache
    [self prepareApp];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = self.splashVC;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [WXApi registerApp:WEIXIN_APP_ID];
    
    [self performSelector:@selector(endSplash) withObject:nil afterDelay:2.f];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.modelEngineVoip stopUdpTest];
    [self.modelEngineVoip stopCurRecording];
    self.modelEngineVoip.appIsActive = NO;
    
    NSLog(@"application will resign active");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"application will enter background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    // clear UIWebView cache
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // clear image cache
    [[WXWImageManager instance] clearImageCacheForHandleMemoryWarning];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    self.modelEngineVoip.appIsActive = YES;
    
    application.applicationIconBadgeNumber = 0;
    
    /*
    PushNotifyServer *pushNotifyServer = [[[PushNotifyServer alloc] init] autorelease];
    [NSThread detachNewThreadSelector:@selector(triggerNotify)
                             toTarget:pushNotifyServer
                           withObject:nil];
    */
    
    LogUploader *log = [[[LogUploader alloc] init] autorelease];
    [NSThread detachNewThreadSelector:@selector(triggerUpload)
                             toTarget:log
                           withObject:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:self];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
    
    [[WXWImageManager instance].imageCache clearAllCachedAndLocalImages];
    
    [WXWDBConnection closeDB];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSManagedObjectContextDidSaveNotification
                                                  object:self.managedObjectContext];
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSString *callID = [notification.userInfo objectForKey:KEY_CALLID];
    NSString *type = [notification.userInfo objectForKey:KEY_TYPE];
    NSString *call = [notification.userInfo objectForKey:KEY_CALL_TYPE];
    NSString *caller = [notification.userInfo objectForKey:KEY_CALLNUMBER];
    NSInteger calltype = call.integerValue;
    
    if ([type isEqualToString:@"comingCall"])
    {
        UIApplication *uiapp = [UIApplication sharedApplication];
        NSArray *localNotiArray = [uiapp scheduledLocalNotifications];
        for (UILocalNotification *notification in localNotiArray)
        {
            NSDictionary *dic = [notification userInfo];
            NSString *value = [dic objectForKey:KEY_TYPE];
            if ([value isEqualToString:@"comingCall"] || [value isEqualToString:@"releaseCall"])
            {
                [uiapp cancelLocalNotification:notification];
            }
        }
        if (self.modelEngineVoip.UIDelegate && [self.modelEngineVoip.UIDelegate respondsToSelector:@selector(incomingCallID:caller:phone:name:callStatus:callType:)])
        {
            [self.modelEngineVoip.UIDelegate incomingCallID:callID caller:caller phone:[notification.userInfo objectForKey:KEY_CALLERPHONE] name:[notification.userInfo objectForKey:KEY_CALLERNAME] callStatus:IncomingCallStatus_accepting callType:calltype];
        }
    }
}

- (void)addressbookChangeCallback:(NSNotification *)_notification
{
    globalcontactsChanged = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contactsChanged" object:nil userInfo:nil];
}

#pragma mark - rewrite
-(BOOL)application:(UIApplication*)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack
- (void)handleSaveNotification:(NSNotification *)aNotification {
    [self.managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                                withObject:aNotification
                                             waitUntilDone:YES];
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Project" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ProductFramework.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:storeURL error:nil];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void) makeWorkingDir
{
	[FileUtils mkdir:[CommonMethod getLocalDownloadFolder]];
	[FileUtils  mkdir:[CommonMethod getLocalImageFolder]];
}

- (void)loadNessesaryResource
{
    [self makeWorkingDir];
    [[AppManager instance] prepareData];
    [[ProjectAPI getInstance] setCommon:[AppManager instance].common];
}

- (BOOL)isNeedShowRegisterView
{
    return TRUE;
}

- (void)clearSplash
{
    
    [_splashVC.view removeFromSuperview];
    _splashVC = nil;
    
}

- (void)clearLogin
{
    [_userLoginVC.view removeFromSuperview];
    _userLoginVC = nil;
}

- (void)closeSplash:(SplashViewController *)vc
{
    
}

- (void)endSplash:(SplashViewController *)vc
{
    if ([self isNeedShowRegisterView]) {
        if (!_userLoginVC) {
            
            _userLoginVC = [[CurrentLoginViewController alloc] initWithMOC:self.homepageContainer.MOC
                                                               parentVC:self.homepageContainer];
            _userLoginVC.view.hidden = YES;
            _userLoginVC.delegate = self;
            [_userLoginVC autoLogin];
        }
    } else {
        [self loginSuccessfull:_userLoginVC];
    }
}

-(void)closeSplash
{
    [self logout];
}

- (BOOL)loginSuccessfull:(CurrentLoginViewController *)vc
{
    [self goHomePage];
    
    //添加推送监听
//    [[PushListener defaultListener] addObserver];
    
    //上传crash文件
//    [CrashMethod uploadCrashReportWithThread:[NSString stringWithFormat:@"%@_%@", [AppManager instance].userId, [AppManager instance].userName]];
    
    return YES;
}

//
// Called to handle a pending crash report.
//
- (void)handleCrashReport {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSData *crashData;
    NSError *error;
    
    // Try loading the crash report
    crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
    if (crashData == nil) {
        NSLog(@"Could not load crash report: %@", error);
        goto finish;
    }
    
    // We could send the report from here, but we'll just print out
    // some debugging info instead
    PLCrashReport *report = [[[PLCrashReport alloc] initWithData: crashData error: &error] autorelease];
    if (report == nil) {
        NSLog(@"Could not parse crash report");
        goto finish;
    }
    
    NSLog(@"Crashed on %@", report.systemInfo.timestamp);
    NSLog(@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name,
          report.signalInfo.code, report.signalInfo.address);
finish:
    return;
}

- (void)prepareCrashReporter {
    
    // Enable the Crash Reporter
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSError *error;
    
    /* Check if we previously crashed */
    if ([crashReporter hasPendingCrashReport])
        [self handleCrashReport];
    
    /* Enable the Crash Reporter */
    if (![crashReporter enableCrashReporterAndReturnError: &error])
        NSLog(@"Warning: Could not enable crash reporter: %@", error);
}

#pragma mark - debug log
- (void)printLog:(NSString*)log
{
    NSLog(@"Debug %@",log); //用于xcode日志输出
}

@end
