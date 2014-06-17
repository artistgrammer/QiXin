/*!
 @header UserLoginViewController.h
 @abstract 登录界面
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "RootViewController.h"

@protocol UserLoginViewControllerDelegate;

@interface UserLoginViewController : RootViewController
@property (nonatomic, assign) id<UserLoginViewControllerDelegate> delegate;


/*!
 @method
 @abstract 初始化
 @discussion
 @param text MOC RootViewController
 @param error nil
 @result id
 */
- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC;


- (void)autoLogin;

@end

@protocol UserLoginViewControllerDelegate <NSObject>

- (BOOL)loginSuccessful:(UserLoginViewController *)vc;
-(void)closeSplash;


@end