
#import "ThemeLabel.h"
#import "ThemeManager.h"

@interface ThemeLabel ()
{
    BOOL noShadow;
}

@property (nonatomic,copy) NSString *colorName;

@end

@implementation ThemeLabel

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    _colorName = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
          colorName:(NSString *)colorName
               font:(UIFont *)font
{
    self = [super initWithFrame:frame];
    
    if (self) {

        self.backgroundColor = TRANSPARENT_COLOR;
        self.colorName = colorName;
        self.shadowColor = TRANSPARENT_COLOR;
        
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
        
        [self setColor];
        self.font = font;
        
        if (CURRENT_OS_VERSION < IOS7) {
            self.highlightedTextColor = [UIColor whiteColor];
        }
        
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
        
        [self setColor];
    }
    
    return self;
}

- (void)setColor {
    UIColor *textColor = [[ThemeManager shareInstance] getColorWithName:self.colorName];
    self.textColor = textColor;
}

- (void)themeNotification:(NSNotification *)notification {
    [self setColor];
}

@end
