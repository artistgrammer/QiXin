
/*!
 @header ThemeButton.h
 @abstract 按钮多主题
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

//normal状态下的图片名称
@property(nonatomic,copy)NSString *imageName;
//高亮状态下的图片名称
@property(nonatomic,copy)NSString *highligtImageName;

- (id)initWithImage:(NSString *)imageName
        highlighted:(NSString *)highligtImageName;

@end
