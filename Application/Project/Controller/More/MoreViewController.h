
/*!
 @header MoreViewController.h
 @abstract 系统设置
 @author Adam
 @version 1.00 2014/05/26 Creation
 */

#import "RootViewController.h"
#import "BaseNavigationController.h"

@interface MoreViewController : RootViewController
{
    id  _personalEntrance;
    SEL _refreshAction;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
       viewHeight:(int)viewHeight;
@end
