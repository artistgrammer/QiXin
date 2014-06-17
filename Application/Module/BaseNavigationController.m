
#import "BaseNavigationController.h"
#import "RootViewController.h"
#import "BaseConstants.h"
#import "UINavigationBar-WXWCategory.h"
#import "DirectionMPMoviePlayerViewController.h"
#import "ThemeLabel.h"

//5.0以下系统自定义UINavigationBar背景
@implementation UINavigationBar(setbackgroud)

- (void)drawRect:(CGRect)rect {
    
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"nav_top_bg_3.5.png"];
    [image drawInRect:rect];
}

@end

@implementation BaseNavigationController

#pragma mark - user action
- (void)back:(id)sender {
    [self popViewControllerAnimated:YES];
}

#pragma mark - lifecycle methods
- (id)initWithRootViewController:(UIViewController *)rootViewController {
    
    self = [super initWithRootViewController:rootViewController];
    
    if (self) {
        self.navigationBar.tintColor = [UIColor whiteColor];
//        self.navigationBar.tintColor = HEX_COLOR(@"daa44a");
        
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
    }
    
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}

- (void)themeNotification:(NSNotification *)notification {
    [self loadThemeImage];
}

- (void)loadThemeImage {
    
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    
    if (version >= 5.0) {
        UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"nav_top_bg_4.png"];
        
        [self.navigationBar setBackgroundImage:image
                                 forBarMetrics:UIBarMetricsDefault];
        
        UIColor *barColor = [[ThemeManager shareInstance] getColorWithName:@"kNaviBarTitleLabel"];
        
//        /*
        NSDictionary *textTitleOptions = @{UITextAttributeFont : FONT_SYSTEM_SIZE(18),
                                           UITextAttributeTextShadowColor : TRANSPARENT_COLOR,
                                           UITextAttributeTextColor : barColor,
                                           NSForegroundColorAttributeName : barColor};
        
        [UINavigationBar appearance].titleTextAttributes = textTitleOptions;
//        */
    } else {
        //让视图重新调用drawRect
        [self.navigationBar setNeedsDisplay];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadThemeImage];
    
}

#pragma mark - override methods
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    RootViewController *vc = (RootViewController *)[super popViewControllerAnimated:animated];
    
    [vc cancelConnectionAndImageLoading];
    
    return vc;
}

- (BOOL)shouldAutorotate {
    if ([[self topViewController] isKindOfClass:[DirectionMPMoviePlayerViewController class]]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [[self topViewController] supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //    return (toInterfaceOrientation != UIInterfaceOrientationMaskPortraitUpsideDown);
    if ([[self topViewController] isKindOfClass:[DirectionMPMoviePlayerViewController class]]) {
        return YES;
    }
    return NO;
}

@end
