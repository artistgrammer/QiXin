
/*!
 @header RootViewController.h
 @abstract 基础视图
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CGColor.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <AddressBookUI/ABUnknownPersonViewController.h>
#import <MapKit/MKReverseGeocoder.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MessageUI/MessageUI.h"
#import "WXWConnectionTriggerHolderDelegate.h"
#import "WXWLocationFetcherDelegate.h"
#import "WXWImageDisplayerDelegate.h"
#import "WXWConnectorDelegate.h"
#import "BaseConstants.h"
#import "WXWLocationManager.h"

#import "WXWCommonUtils.h"
#import "WXWSystemInfoManager.h"
#import "WXWUIUtils.h"
#import "ColofulNavigationBar.h"
#import "WXWSyncConnectorFacade.h"
#import "ProjectAppDelegate.h"
#import "ThemeManager.h"
#import "ModelEngineVoip.h"

#import "TextConstants.h"
#import "WXWLabel.h"
#import "WXWCoreDataUtils.h"
#import "WXWDebugLogOutput.h"
#import "WXWImageManager.h"
#import "WXWTextPool.h"
#import "WXWBarItemButton.h"
#import "BaseConstants.h"
#import "WXWSyncConnectorFacade.h"

#import "ProjectDBManager.h"
#import "GlobalConstants.h"
#import "CommonUtils.h"
#import "JSONKit.h"

#import "AppManager.h"
#import "ProjectAPI.h"
#import "TextPool.h"
#import "JSONParser.h"

#import "ECClickableElementDelegate.h"

#import "VPImageCropperViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIColor+expanded.h"
#import "UIImageView+WebCache.h"

@class WXWAsyncConnectorFacade;
@class WXWConnector;

@interface RootViewController : UIViewController <WXWConnectorDelegate, WXWImageDisplayerDelegate, WXWLocationFetcherDelegate, WXWConnectionTriggerHolderDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate, UIActionSheetDelegate, ModelEngineUIDelegate, UINavigationControllerDelegate,
    UIImagePickerControllerDelegate, VPImageCropperDelegate> {
    
    NSInteger _currentType;
    BOOL _needGoHome;
    int _alertType;
    int _sheetType;
    UITableView *_tableView;
    
    CGFloat _viewHeight;
    
    NSManagedObjectContext *_MOC;
    NSFetchedResultsController *_fetchedRC;
    NSPredicate *_predicate;
    NSString *_entityName;
    NSMutableArray *_descriptors;
    
    NSString *_sectionNameKeyPath;
    UIActivityIndicatorView *_activityView;
    UIView *_activityBackgroundView;
    UILabel *_loadingLabel;
    
    UIPickerView *_PickerView;
    NSMutableArray *_DropDownValArray;
    NSMutableArray *_PickData;
    UIView *_PopView;
    UIView *_PopBGView;
    
    int iFliterIndex;
    int pickSel0Index;
    int pickSel1Index;
    BOOL isPickSelChange;
    
    id _holder;
    SEL _backToHomeAction;
    
    WXWAsyncConnectorFacade *_connFacade;
    NSString *_connectionErrorMsg;
    
    NSMutableDictionary *_connDic;
    
    NSMutableDictionary *_errorMsgDic;
    
    NSMutableDictionary *_imageUrlDic;
    
    // sub class responsible for setting this message, then closeAsyncLoadingView will check its value
    // to determine whether show this message
    NSString *_connectionResultMessage;
    
    WXWLocationManager *_locationManager;
    
    UIView *disableViewOverlay;
    
    // navigation
    BOOL _noNeedBackButton;
    
    // swipe back to parent view controller
    BOOL _allowSwipeBackToParentVC;
    
    // session management
    BOOL _sessionExpired;
    
@private
    // async loading
    UIView *_asyncLoadingBackgroundView;
    UILabel *_asyncLoadingLabel;
    UIImageView *_operaFacebookImageView;
    BOOL _reverseFromRightToLeft;
    BOOL _stopAsyncLoading;
    BOOL _blockCurrentView;
    BOOL _userCancelledLocate;
    
    // tiny notification
    UIView *_tinyNotifyBackgroundView;
    UILabel *_tinyNotifyLabel;
    
    // animate view
    UIViewController *modalDisplayedVC;
    
    // session management
    NSInteger _sessionExpiredRequestType;
    BOOL _showAlert;
}

@property (nonatomic, retain) NSManagedObjectContext *MOC;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) WXWAsyncConnectorFacade *connFacade;
@property (nonatomic, retain) NSString *connectionErrorMsg;
@property (nonatomic, retain) NSMutableDictionary *connDic;
@property (nonatomic, retain) NSMutableDictionary *errorMsgDic;
@property (nonatomic, retain) NSMutableDictionary *imageUrlDic;
@property (nonatomic, retain) NSFetchedResultsController *fetchedRC;
@property (nonatomic, copy) NSString *entityName;
@property (nonatomic, copy) NSString *sectionNameKeyPath;
@property (nonatomic, retain) NSMutableArray *descriptors;
@property (nonatomic, retain) NSPredicate *predicate;
@property (nonatomic, copy) NSString *connectionResultMessage;
@property (nonatomic, retain) UIView *disableViewOverlay;


// Picker View
@property (nonatomic,retain) IBOutlet UIPickerView *_PickerView;
@property (nonatomic,retain) NSMutableArray* DropDownValArray;
@property (nonatomic,retain) NSMutableArray *_PickData;
@property (nonatomic,retain) UIView *_PopView;
@property (nonatomic,retain) UIView *_PopBGView;

// animate view
@property (nonatomic, retain) UIViewController *modalDisplayedVC;

@property (nonatomic, retain) ModelEngineVoip *modelEngineVoip;
@property (nonatomic, retain) UIImagePickerController *imagePicker;

- (void)adjustNavigationBarImage:(UIImage *)image
         forNavigationController:(UINavigationController *)navigationController;

- (void)initTableView;
- (void)deselectCell;

- (id)initWithMOC:(NSManagedObjectContext *)MOC;

- (id)initWithMOCWithoutBackButton:(NSManagedObjectContext *)MOC;

#pragma mark - set bar item buttons
- (void)setRightButtonTitle:(NSString *)title;
- (void)setLeftButtonTitle:(NSString *)title;
- (void)addRightBarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)addLeftBarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

#pragma mark - back to homepage
- (void)backToHomepage:(id)sender;

- (void)back:(id)sender;
- (void)backToRootViewController:(id)sender;

#pragma mark - network consumer methods-- sync
- (WXWSyncConnectorFacade *)setupSyncConnectorForUrl:(NSString *)url
                                         contentType:(NSInteger)contentType;

#pragma mark - network consumer methods -- async
- (WXWAsyncConnectorFacade *)setupAsyncConnectorForUrl:(NSString *)url
                                           contentType:(NSInteger)contentType;

#pragma mark - check connection error message
- (BOOL)connectionMessageIsEmpty:(NSError *)error;

#pragma mark - cancel connection/location when navigation back to parent layer
- (void)cancelConnection;
- (void)cancelLocation;

#pragma mark - location fetch
- (void)forceGetLocation;
- (void)getCurrentLocationInfoIfNecessary;

#pragma mark - async loading animation
- (void)showAsyncLoadingView:(NSString *)message blockCurrentView:(BOOL)blockCurrentView;
- (void)changeAsyncLoadingMessage:(NSString *)message;
- (void)closeAsyncLoadingView;

#pragma mark - show tiny notification
- (void)showTinyNotification:(NSString *)message;

#pragma mark - cancel connection and image loading
- (void)cancelConnectionAndImageLoading;

#pragma mark - picker
- (void)pickerSelectRow:(NSInteger)row;
- (void)clearPickerSelIndex2Init:(int)size;
- (void)setPopView;
- (void)onPopCancle;
- (void)onPopSelectedOk;
- (int)pickerList0Index;

#pragma mark - core data
- (NSFetchedResultsController *)prepareFetchRC;

#pragma mark - DisableView option
- (void)initDisableView:(CGRect)frame;
- (void)showDisableView;
- (void)removeDisableView;

#pragma mark - manage modal view controller
- (void)presentModalQuickViewController:(RootViewController *)vc;
- (void)presentModalQuickView:(UIView *)view;
- (void)dismissModalQuickView;

#pragma mark -- featch MOC
- (void)configureMOCFetchConditions;

#pragma mark -- MOC
- (void)fetchContentFromMOC;

#pragma mark -- navigation bar font
- (void)updateNavigationBarSizeFont:(NSString *)fontName size:(int)size;

- (void)popPromptViewWithMsg:(NSString *)message;

//进行中的view操作
- (void)displayProgressingView;
- (void)dismissProgressingView;

#pragma mark - Camera & PhotoLibrary
- (void)enterCameraForUser;
- (void)enterPhotoLibraryForUser;

#pragma mark - show coming alert
- (void)showCommingAlert;

//账号在其他客户端登录消息提示
- (void)responseKickedOff;

@end
