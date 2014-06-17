
/*!
 @header CurrentLoginViewController.h
 @abstract 登录界面
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "SelectView.h"

@protocol CurrentLoginVCDelegate;

@interface CurrentLoginViewController : RootViewController
{
    SelectView *_selectView;
}

@property (nonatomic, assign) id<CurrentLoginVCDelegate> delegate;
@property (nonatomic, retain) SelectView *_selectView;

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

@protocol CurrentLoginVCDelegate <NSObject>

- (BOOL)loginSuccessfull:(CurrentLoginViewController *)currentVC;
- (void)closeSplash;

@end
