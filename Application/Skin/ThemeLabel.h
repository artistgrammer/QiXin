
/*!
 @header ThemeLabel.h
 @abstract Lable多主题
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <UIKit/UIKit.h>
#import "GlobalConstants.h"

@interface ThemeLabel : UILabel

- (id)initWithFrame:(CGRect)frame
          colorName:(NSString *)colorName
               font:(UIFont *)font;

@end
