
/*!
 @header HomeContainerViewController.h
 @abstract 容器
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "RootViewController.h"

@interface HomeContainerViewController : RootViewController {
}

/*!
 @method
 @abstract 初始化
 @discussion
 @param text MOC
 @param error nil
 @result id
 */
- (id)initHomepageWithMOC:(NSManagedObjectContext *)MOC;

/*!
 @method
 @abstract 刷新Tab Item
 @discussion
 @param text MOC
 @param error nil
 @result id
 */
- (void)refreshTabItems;

- (void)modifyFromTabBarFlag;

- (void)changeTabView:(BOOL)isShow;

- (void)selectFirstTabBar;

@end
