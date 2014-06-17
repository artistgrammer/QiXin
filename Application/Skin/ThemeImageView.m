
#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
        
        [self loadThemeImage];
    }
    return self;
}

- (id)initWithImageName:(NSString *)imageName {
    
    self = [super initWithFrame:CGRectZero];
    if (self != nil) {
        self.imageName = imageName;
        
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
        
        [self loadThemeImage];        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [_imageName release];
    [super dealloc];
}

- (void)loadThemeImage {
    if(self.imageName.length == 0) {
        return;
    }
    
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:self.imageName];
    self.image = image;
}

- (void)themeNotification:(NSNotification *)notification {
    [self loadThemeImage];
}

@end
