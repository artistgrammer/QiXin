
/*!
 @header UserDetailEditViewController.h
 @abstract 我
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <UIKit/UIKit.h>
#import "BaseListViewController.h"

@interface UserDetailEditViewController : BaseListViewController
{
}


/*!
 @method
 @abstract 初始化
 @discussion
 @param text MOC
 @param error nil
 @result id
 */
- (id)initWithMOC:(NSManagedObjectContext *)MOC
       userObject:(UserObject *)userObject;

@end
