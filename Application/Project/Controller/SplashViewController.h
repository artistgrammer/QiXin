
/*!
 @header SplashViewController.h
 @abstract 过度界面
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "RootViewController.h"

@protocol SplashViewControllerDelegate;

@interface SplashViewController : RootViewController

@property (nonatomic, assign) id<SplashViewControllerDelegate> delegate;
@end


@protocol SplashViewControllerDelegate <NSObject>

- (void)endSplash:(SplashViewController *)vc;
- (void)closeSplash:(SplashViewController *)vc;

@end
