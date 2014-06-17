
/*!
 @header ThemeManager.h
 @abstract 主题管理
 @author Adam
 @version 1.00 2014/05/20 Creation
 */

#import <Foundation/Foundation.h>

//更主题的通知
#define kThemeDidChangeNotification         @"kThemeDidChangeNotification"
#define kThemeName                          @"kThemeName"

@interface ThemeManager : NSObject {
}

//当前使用的主题名称
@property (nonatomic, retain) NSArray *themeValues;
@property (nonatomic, retain) NSArray *themeNames;

+ (ThemeManager *)shareInstance;

//获取当前主题下的图片
- (UIImage *)getThemeImage:(NSString *)imageName;

//返回当前主题下的颜色
- (UIColor *)getColorWithName:(NSString *)name;

- (void)setThemeNameIndex:(int)themeNameIndex;

@end
