
/*!
 @header ProjectAppDelegate.h
 @abstract AppDelegate
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "GlobalConstants.h"

#define kKeyboardBtnpng             @"call_interface_icon_01.png"
#define kKeyboardBtnOnpng           @"call_interface_icon_01_on.png"
#define kHandsfreeBtnpng            @"call_interface_icon_03.png"
#define kHandsfreeBtnOnpng          @"call_interface_icon_03_on.png"
#define kMuteBtnpng                 @"call_interface_icon_02.png"
#define kMuteBtnOnpng               @"call_interface_icon_02_on.png"

int globalcontactsChanged;
int globalContactID;
int contactOptState;

@class HomeContainerViewController;
@class BaseNavigationController;
@class ModelEngineVoip;

@interface ProjectAppDelegate : UIResponder <UIApplicationDelegate> {
  
  @private
  
  BOOL _startup;
  
  BaseNavigationController *_premiereNav;
}

@property (nonatomic, retain) HomeContainerViewController *homepageContainer;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (retain, nonatomic) ModelEngineVoip *modelEngineVoip;

- (void)saveContext;
- (void)goHomePage;
- (void)logout;
- (NSURL *)applicationDocumentsDirectory;

#pragma mark - debug log
- (void)printLog:(NSString*)log;

@end
