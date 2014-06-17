
/*!
 @header ThemeImageView.h
 @abstract 图片多主题
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

//图片名称
@property(nonatomic,retain) NSString *imageName;

- (id)initWithImageName:(NSString *)imageName;

@end
