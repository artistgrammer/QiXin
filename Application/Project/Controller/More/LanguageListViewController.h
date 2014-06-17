
/*!
 @header LanguageListViewController.h
 @abstract 皮肤列表
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "BaseListViewController.h"
#import "AppSystemDelegate.h"

@interface LanguageListViewController : BaseListViewController

- (id)initWithParentVC:(UIViewController *)parentVC
              entrance:(id)entrance
         refreshAction:(SEL)refreshAction;

@end
