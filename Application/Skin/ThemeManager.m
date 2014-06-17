
#import "ThemeManager.h"
#import "UIColor+Expanded.h"

@interface ThemeManager ()

//字体的配置信息
@property (nonatomic, retain) NSDictionary *fontConfig;
//当前主题包的目录
@property (nonatomic, retain) NSString *themePath;
@end

static ThemeManager *sigleton = nil;

@implementation ThemeManager
@synthesize themeValues;
@synthesize themeNames;
@synthesize themePath;

- (id)init {
    
    self = [super init];
    if (self != nil) {
        
        //初始化主题配置文件
//        self.themeValues = [NSArray arrayWithObjects:@"", @"Skins/Blue", @"Skins/Orange", nil];
//        self.themeNames = [NSArray arrayWithObjects:@"默认", @"天蓝色", @"桔黄色", nil];
        
        //初始化字体配置文件
        NSString *fontConfigPath = [[NSBundle mainBundle] pathForResource:@"fontColor" ofType:@"plist"];
        _fontConfig = [[NSDictionary dictionaryWithContentsOfFile:fontConfigPath] retain];
    }
    
    return self;
}

- (void)setThemeNameIndex:(int)themeNameIndex {
    
    //获取主题包的根目录
    self.themePath = [self getThemePath:themeNameIndex];
    NSString *filePath = [self.themePath stringByAppendingPathComponent:@"fontColor.plist"];
    
    self.fontConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
}

//获取当前主题包的目录
- (NSString *)getThemePath:(int)themeIndex {
    //项目包的根路径
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];

    if (themeIndex == 0) {
        return resourcePath;
    }

    //取得当前主题的子路径
    NSString *subPath = [self.themeValues objectAtIndex:themeIndex];
    //主题的完整路径
    NSString *path = [resourcePath stringByAppendingPathComponent:subPath];
   
    return path;
}

//获取当前主题下的图片
- (UIImage *)getThemeImage:(NSString *)imageName {
    if (imageName.length == 0) {
        return nil;
    }
    
    //imageName在当前主题的文件路径
    NSString *imagePath = [self.themePath stringByAppendingPathComponent:imageName];
    
    NSLog(@"=========imagePath ========== %@", imagePath);
    
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image = [UIImage imageWithData:imageData];

    return image;
}

//返回当前主题下的颜色
- (UIColor *)getColorWithName:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }
    
    NSString *colorName = [self.fontConfig objectForKey:name];
    
    NSLog(@"%@ getColor is %@", name, colorName);
    
    if ([colorName hasPrefix:@"0x"]) {
        
        return [UIColor colorWithHexString:colorName];
    } else {
        
        NSArray *rgbs = [colorName componentsSeparatedByString:@","];
        
        if (rgbs.count == 3) {
            float r = [rgbs[0] floatValue];
            float g = [rgbs[1] floatValue];
            float b = [rgbs[2] floatValue];
            UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
            
            return color;
        }
    }
    
    return nil;
}

#pragma mark - 单列相关的方法
+ (ThemeManager *)shareInstance {
    if (sigleton == nil) {
        @synchronized(self){
            sigleton = [[ThemeManager alloc] init];
        }
    }
    
    return sigleton;
}

//限制当前对象创建多实例
#pragma mark - sengleton setting
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        
        if (sigleton == nil) {
            sigleton = [super allocWithZone:zone];
        }
    }
    
    return sigleton;
}

+ (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;
}

- (oneway void)release {
}

- (id)autorelease {
    return self;
}

@end
