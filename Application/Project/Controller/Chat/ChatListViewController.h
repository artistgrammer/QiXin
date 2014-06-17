
/*!
 @header ChatListViewController.h
 @abstract 聊天界面
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "BaseListViewController.h"

@interface ChatListViewController : BaseListViewController
{
}

/*!
 @method
 @abstract 初始化
 @discussion
 @param text MOC RootViewController
 @param error nil
 @result id
 */
- (id)initWithMOC:(NSManagedObjectContext *)MOC
       viewHeight:(CGFloat)viewHeight
         parentVC:(RootViewController *)pVC;

@end
