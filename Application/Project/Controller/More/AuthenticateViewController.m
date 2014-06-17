//
//  AuthenticateViewController.m
//  Project
//
//  Created by Adam on 14-3-27.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "AuthenticateViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>
#import "UIColor+expanded.h"
#import "MoreCell.h"
#import "ContactUsViewController.h"
#import "DownloadManageViewController.h"
#import "FeedQuestionViewController.h"
#import "MyInfoViewController.h"
#import "WXWCustomeAlertView.h"
#import "GlobalConstants.h"
#import "CommonHeader.h"
#import "AppManager.h"
#import "ProjectAppDelegate.h"
#import "HomeContainerViewController.h"
#import "WXWLabel.h"
#import "CircleMarkegingApplyWindow.h"
#import "PXAlertView.h"
#import "ProjectDBManager.h"
#import "TextPool.h"
#import "ProjectAPI.h"
#import "JSONParser.h"
#import "JSONKit.h"
#import "GlobalConstants.h"
#import "WXWCommonUtils.h"
#import "CommonUtils.h"
#import "FileUtils.h"
#import "ImageCropperViewController.h"

#define BUTTON_LOGOUT_WIDTH  305.f
#define BUTTON_LOGOUT_HEIGHT 49.f

#define ORIGINAL_MAX_WIDTH          640.0f

enum ALERT_TAG {
    ALERT_TAG_CLEAR_CACHE = 1,
    ALERT_TAG_UPDATE = 2,
};

@interface AuthenticateViewController ()<UITableViewDataSource, UITableViewDelegate, WXWCustomeAlertViewDelegate, CircleMarkegingApplyWindowDelegate,CircleMarkegingApplyWindowDelegate, UIActionSheetDelegate, VPImageCropperDelegate> {
    
    UITableView *moreTable;
    NSArray *imageArr;
    NSArray *titleArr;
    
    int imageType;
}

@property (nonatomic, copy) NSString *portraitImageName;
@property (nonatomic, retain) UIImageView *cardIV;
@property (nonatomic, retain) UIImageView *schoolIV;
@end

@implementation AuthenticateViewController {
    HomeContainerViewController *_parentVC;
    int _viewHeight;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC
       viewHeight:(int)viewHeight{
    
    if (self = [super initWithMOC:MOC]) {
        _parentVC =(HomeContainerViewController *) pVC;
        _viewHeight= viewHeight;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   self.title = @"身份认证";
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HEX_COLOR(@"0xebebeb");
    
    if ([WXWCommonUtils currentOSVersion] < IOS7) {
        self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    }
    
    UIImage *bgImg = [[UIImage imageNamed:@"authenticate.jpg"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
    
    UIImageView *bkImg = [[[UIImageView alloc] initWithImage:bgImg] autorelease];
    bkImg.frame = CGRectMake(0, 25.f, 320.f, 459.f);
    [self.view addSubview:bkImg];
    
    // card
    self.cardIV = [[UIImageView alloc] init];
    self.cardIV.frame = CGRectMake(35, 90, 250, 120);
//    self.cardIV.image = ImageWithName(@"Default");
     [self.view addSubview:self.cardIV];
    
    UIButton *cardBut = [UIButton buttonWithType:UIButtonTypeCustom];
    cardBut.frame = CGRectMake(35, 90, 250, 120);
    [cardBut setBackgroundColor:TRANSPARENT_COLOR];
    [cardBut addTarget:self action:@selector(selCardImg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cardBut];

    // school
    self.schoolIV = [[UIImageView alloc] init];
    self.schoolIV.frame = CGRectMake(35, 253, 250, 120);
//    self.schoolIV.image = ImageWithName(@"Default");
    [self.view addSubview:self.schoolIV];
    
    UIButton *schoolBut = [UIButton buttonWithType:UIButtonTypeCustom];
    schoolBut.frame = CGRectMake(35, 253, 250, 120);
    [schoolBut setBackgroundColor:TRANSPARENT_COLOR];
    [schoolBut addTarget:self action:@selector(selSchoolImg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:schoolBut];
    
    [self loadPortrait];
    
    UIButton *commitBut = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBut.frame = CGRectMake(15.5, 432.5, 286, 42);
    [commitBut setBackgroundColor:TRANSPARENT_COLOR];
    [commitBut addTarget:self action:@selector(doCommit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBut];
    
    /*
    [self initData];
    [self addMoreTable];
     */
}

- (void)dealloc {
    [imageArr release];
    [titleArr release];
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch* touch = [touches anyObject];
    CGPoint xy = [touch locationInView:self.view];
    NSLog(@"%@", NSStringFromCGPoint(xy));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {

    imageArr = [[NSArray alloc] initWithObjects:@"release_cache.png",@"feed.png",@"newVersion.png",@"contact_us.png", nil];
    titleArr = [[NSArray alloc] initWithObjects:@"清空缓存",@"问题反馈",@"版本更新",@"联系我们", nil];

}

- (void)addMoreTable {
    int startX = 0;
    if ([WXWCommonUtils currentOSVersion] >= IOS7) {
        startX = 10;
    }
    moreTable = [[UITableView alloc] initWithFrame:CGRectMake(startX, ITEM_BASE_TOP_VIEW_HEIGHT, self.view.frame.size.width - 2*startX, self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - HOMEPAGE_TAB_HEIGHT - SYS_STATUS_BAR_HEIGHT) style:UITableViewStyleGrouped];
    moreTable.backgroundColor = TRANSPARENT_COLOR;
    moreTable.backgroundView = nil;
    moreTable.delegate = self;
    moreTable.dataSource = self;
    moreTable.showsVerticalScrollIndicator = NO;
    //    moreTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.view addSubview:moreTable];
}

- (void)logout:(UIButton *)sender {
    [[AppManager instance].userDefaults rememberUsername:[[AppManager instance].userDefaults usernameRemembered] andPassword:@"" customerName:@""];
    
    
    [((ProjectAppDelegate *)APP_DELEGATE) logout];
    [_parentVC selectFirstTabBar];
}

- (void)clearCache {
    [self showAsyncLoadingView:@"正在清理..." blockCurrentView:YES];
    
    NSString *imagePath = [CommonMethod getLocalImageFolder];
    NSString *downloadPath = [CommonMethod getLocalDownloadFolder];
    if ([CommonMethod isExist:imagePath]) {
        NSError *err = nil;
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&err];
        
        [FileUtils  mkdir:[CommonMethod getLocalImageFolder]];
    }
    
    if ([CommonMethod isExist:downloadPath]) {
        NSError *err = nil;
        [[NSFileManager defaultManager] removeItemAtPath:downloadPath error:&err];
        [FileUtils mkdir:[CommonMethod getLocalDownloadFolder]];
    }
    
    [[ProjectDBManager instance] dropTables:[CommonMethod tableNames]];
    [self closeAsyncLoadingView];
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
            
#if APP_TYPE == APP_TYPE_EMBA
        case 0:
            {
                return 4;
            }
            break;
                    
#elif APP_TYPE == APP_TYPE_CIO //CIO
        case 0: return 1; break;
        case 1: return 3; break;
            
#elif APP_TYPE == APP_TYPE_O2O //O2O
        case 0: return 2; break;
        case 1: return 4; break;
#else
        case 0: return 2; break;
        case 1: return 3; break;
            
#endif //if APP_TYPE
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 120.f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
        
        CGFloat buttonX = (tableView.frame.size.width - BUTTON_LOGOUT_WIDTH) / 2.f;
        UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
        logout.frame = CGRectMake(buttonX, 33, BUTTON_LOGOUT_WIDTH, BUTTON_LOGOUT_HEIGHT);
        [logout setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"button_logout.png") forState:UIControlStateNormal];
        [logout setTitle:@"退出登录" forState:UIControlStateNormal];
        [logout.titleLabel setTextColor:[UIColor whiteColor]];
        [logout.titleLabel setFont:FONT_SYSTEM_SIZE(18)];
        [logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:logout];
        
        //--------------------------
        CGRect rect = logout.frame;
        rect.origin.y += rect.size.height;
        
        UILabel *version = [[WXWLabel alloc] initWithFrame:rect textColor:[UIColor colorWithHexString:@"0x333333"] shadowColor:TRANSPARENT_COLOR font:FONT_SYSTEM_SIZE(14)];
        [version setText: [NSString stringWithFormat:@"version:%@",VERSION]];
        version.textAlignment = NSTextAlignmentCenter;
        
        [view addSubview:version];
        [version release];
        
        return view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"more_cell";
    
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[MoreCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        cell.imageView.image = IMAGE_WITH_IMAGE_NAME(imageArr[indexPath.row]);
        cell.textLabel.text = titleArr[indexPath.row];
    }else {
        
#if  APP_TYPE == APP_TYPE_CIO //CIO
        cell.imageView.image = IMAGE_WITH_IMAGE_NAME(imageArr[indexPath.row + 3]);
        cell.textLabel.text = titleArr[indexPath.row + 3];
#elif  APP_TYPE == APP_TYPE_O2O //O2O
        cell.imageView.image = IMAGE_WITH_IMAGE_NAME(imageArr[indexPath.row + 2]);
        cell.textLabel.text = titleArr[indexPath.row + 2];
#else
        cell.imageView.image = IMAGE_WITH_IMAGE_NAME(imageArr[indexPath.row + 2]);
        cell.textLabel.text = titleArr[indexPath.row + 2];
        
#endif //if APP_TYPE
        
        switch (indexPath.row ) {
            case 2://版本更新
                if ([AppManager instance].updateURL && ![[AppManager instance].updateURL isEqualToString:@""]) {
                    [cell showRedDot:TRUE];
                }
                break;
                
            default:
                break;
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
//    if (indexPath.section == 0) {
    
//        if (indexPath.row == 0) {
//            MyInfoViewController *myInfo = [[[MyInfoViewController alloc] initWithMOC:_MOC parentVC:_parentVC viewHeight:_viewHeight] autorelease];
//            [CommonMethod pushViewController:myInfo withAnimated:YES];
//        }else {
//            DownloadManageViewController *downloadManage = [[[DownloadManageViewController alloc] initWithMOC:_MOC] autorelease];
//            [CommonMethod pushViewController:downloadManage withAnimated:YES];
//        }

        switch (indexPath.row) {
                
                case 0:
                {
                    CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
                    [customeAlertView setMessage:@"您确定要清空所有缓存吗？"
                                               title:@"温馨提示"];
                    customeAlertView.tag =ALERT_TAG_CLEAR_CACHE;
                    customeAlertView.applyDelegate = self;
                    [customeAlertView show];
                } break;
                
                case 1:
                {
                    FeedQuestionViewController *feed = [[[FeedQuestionViewController alloc] init] autorelease];
                    [CommonMethod pushViewController:feed withAnimated:YES];
                } break;
                
                case 2:
                {
                        
                    if ([AppManager instance].updateURL && ![[AppManager instance].updateURL isEqualToString:@""]) {
                    
                        [CommonMethod update:[AppManager instance].updateURL];
                        
                    }else{
                        [self loadVersion:TRIGGERED_BY_AUTOLOAD forNew:YES];
                    }
                }
                break;
                
                case 3:
                {
                    ContactUsViewController *contactUs = [[[ContactUsViewController alloc] init] autorelease];
                        [CommonMethod pushViewController:contactUs withAnimated:YES];
                }
                break;
                
                default:
                    break;
            }
//    }
}

#pragma mark -- circle marketing delegate

- (void)circleMarkegingApplyWindowCancelDismiss:(CircleMarkegingApplyWindow *) alertView {
        
    [alertView release];
}
    
- (void)circleMarkegingApplyWindowDismiss:(CircleMarkegingApplyWindow *)alertView applyList:(NSArray *)applyArray {
    [alertView release];
    switch (alertView.tag) {
        case ALERT_TAG_CLEAR_CACHE:
                
            [self clearCache];
            break;
        case ALERT_TAG_UPDATE:
            [CommonMethod update:[AppManager instance].updateURL];
            break;
        default:
            break;
    }
}
    
#pragma mark --  customer alert delegate

- (void)CustomeAlertViewDismiss:(WXWCustomeAlertView *) alertView {
    [alertView release];
}
    
//--
    
    
- (void)loadVersion:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_COMMON withApiName:API_NAME_GET_VERSION withCommon:commonDict withSpecial:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:LOAD_UPDATE_VERSION_TY];
    [connFacade fetchGets:url];
}
    
#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    switch (contentType) {
        case LOAD_UPDATE_VERSION_TY:
        {
            
            NSDictionary *resultDic = [result objectFromJSONData];
            NSDictionary *contentDic = OBJ_FROM_DIC(resultDic, @"content");
//            NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
            NSString *code = OBJ_FROM_DIC(resultDic, RET_CODE_NAME);
       
            if ([code isEqualToString:@"200"]) {
                CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
                [customeAlertView setMessage:@"目前已是最新版本!!"
                                       title:@"更新提示"];
                customeAlertView.tag=ALERT_TAG_UPDATE;
                customeAlertView.applyDelegate = self;
                [customeAlertView show];
            }else if ([code isEqualToString:@"220"]) {
#if APP_TYPE != APP_TYPE_O2O
                [AppManager instance].updateURL = OBJ_FROM_DIC(contentDic, @"updateUrl");
                
                CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
                [customeAlertView setMessage:@"有新版本发布， 需要更新吗？"
                                       title:@"温馨提示"];
                customeAlertView.applyDelegate = self;
                customeAlertView.tag=ALERT_TAG_UPDATE;
                [customeAlertView show];
#endif
            }
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    [super connectDone:result
                   url:url
           contentType:contentType];
    
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(ImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    switch (imageType) {
        case 0:
            {
                self.cardIV.image = editedImage;
            }
            break;
            
        case 1:
            {
                self.schoolIV.image = editedImage;
            }
            break;
            
        default:
            break;
    }
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        //  Save Image
        [FileUtils makeProjectDir];
        
        NSString *imageDir = [FileUtils getLocalImageFolder];
        
        NSString *imagePath =[imageDir stringByAppendingPathComponent:self.portraitImageName];
        
        //创建文件夹路径
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
        
        //创建图片
        [UIImagePNGRepresentation(editedImage) writeToFile:imagePath atomically:YES];
    }];
}

- (void)imageCropperDidCancel:(ImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UIActionSheetDelegate method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            
            [self.navigationController presentViewController:controller
                                                    animated:YES
                                                  completion:^(void){
                                                      NSLog(@"Picker View Controller is presented");
                                                  }];
        }
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            
            [self.navigationController presentViewController:controller
                                                    animated:YES
                                                  completion:^(void){
                                                      NSLog(@"Picker View Controller is presented");
                                                  }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        ImageCropperViewController *imgEditorVC = [[ImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark - image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [CommonUtils imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

#pragma mark - cardIV getter
- (UIImageView *)cardIV {
    
    if (!_cardIV) {
        
        _cardIV.frame = CGRectMake(35, 90, 250, 120);
        _cardIV.userInteractionEnabled = YES;
        _cardIV.backgroundColor = TRANSPARENT_COLOR;
        
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selCardImg:)];
        [_cardIV addGestureRecognizer:portraitTap];
    }
    
    return _cardIV;
}

#pragma mark - schoolIV getter
- (UIImageView *)schoolIV {
    
    if (!_schoolIV) {
        
        _schoolIV.frame = CGRectMake(35, 253, 250, 120);
        _schoolIV.userInteractionEnabled = YES;
        _schoolIV.backgroundColor = TRANSPARENT_COLOR;
        
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selSchoolImg:)];
        [_schoolIV addGestureRecognizer:portraitTap];

    }
    
    return _schoolIV;
}

- (BOOL)checkCommit
{
    NSString *imageDir = [FileUtils getLocalImageFolder];
    
    // card
    NSString *cardImagePath =[imageDir stringByAppendingPathComponent:@"cardImg.png"];
    if (![FileUtils fileExistsAtPath:cardImagePath]) {
        return NO;
    }
    
    // school
    NSString *schoolImagePath =[imageDir stringByAppendingPathComponent:@"schoolImg.png"];
    if (![FileUtils fileExistsAtPath:schoolImagePath]) {
        return NO;
    }
    
    return YES;
}

- (void)loadPortrait {
    
    NSString *imageDir = [FileUtils getLocalImageFolder];
    
    // card
    NSString *cardImagePath =[imageDir stringByAppendingPathComponent:@"cardImg.png"];
    if ([FileUtils fileExistsAtPath:cardImagePath]) {
        UIImage *image = [[[UIImage alloc] initWithContentsOfFile:cardImagePath] autorelease];
        self.cardIV.image = image;
    }
    
    // school
    NSString *schoolImagePath =[imageDir stringByAppendingPathComponent:@"schoolImg.png"];
    if ([FileUtils fileExistsAtPath:schoolImagePath]) {
        UIImage *image = [[[UIImage alloc] initWithContentsOfFile:schoolImagePath] autorelease];
        self.schoolIV.image = image;
    }
}

- (void)selCardImg:(id)sender{
    self.portraitImageName = @"cardImg.png";
    imageType = 0;
    [self selImg:sender];
}

- (void)selSchoolImg:(id)sender{
    self.portraitImageName = @"schoolImg.png";
    imageType = 1;
    [self selImg:sender];
}

- (void)selImg:(id)sender{
    
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

- (void)doCommit:(id)sender {
    
    if ([self checkCommit]) {
        [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:@"提交成功，敬请期待" delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles:nil] autorelease] show];
    } else {
        [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:@"请选择图片后，再提交" delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles:nil] autorelease] show];
    }
    
}

@end
