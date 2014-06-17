
#import "UserDetailEditViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CommonMethod.h"
#import "MoreViewController.h"
#import "MeViewController.h"
#import "WXApi.h"

#import "UIImageView+WebCache.h"
#import "HomeContainerViewController.h"
#import "MyInfoViewController.h"
#import "MeSettingController.h"
#import "MeStoreController.h"
#import "IdentityAuthViewController.h"
#import "UserDetailEditCell.h"
#import "UserDetailEditInfoViewController.h"

#define kTableHeadHeight 67.0f
#define kTableFootheight 52.0f

typedef enum : NSUInteger {
    User_Edit_Section0_Type,
    User_Edit_Section1_Type,
    User_Edit_Section2_Type,
} UserEditSectionType;

enum sheetType
{
    Camera_Sheet_Type,
};

enum Head_Control_Type
{
    Head_name_Type = 901,
    Head_title_Type,
    Head_login_Type,
    Head_detail_Type,
    Head_detail_cell_Type,
};


@interface UserDetailEditViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UserDetailEditInfoViewControllerDelegate>

@property (nonatomic, retain) UITableView *m_meTableView;
@property (nonatomic, retain) UIImageView *m_userImgView;
@property (nonatomic, retain) UIImageView *m_headView;
@property (nonatomic, retain) UIView *section0View;
@property (nonatomic, retain) UIImage *selectedPhoto;
@end

@implementation UserDetailEditViewController
{
    UserObject *userInfo;
}

@synthesize m_meTableView;
@synthesize m_userImgView;
@synthesize m_headView;
@synthesize section0View;

- (void)dealloc
{
    RELEASE_OBJ(m_meTableView);
    RELEASE_OBJ(m_userImgView);
    
    [super dealloc];
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
       userObject:(UserObject *)userObject {
    
    self = [super initWithMOC:MOC
        needRefreshHeaderView:NO
        needRefreshFooterView:NO];
    
    if (self) {
        userInfo = userObject;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    userInfo = [[ProjectDBManager instance] getUserInfoByUserIdFromDB:[AppManager instance].userId];
    [self.m_meTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"用户明细";
    [self.view addSubview:[self createMeTypeTable]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create Control

- (UITableView *)createMeTypeTable
{
    CGRect tableFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 /*- 48*/);
    self.m_meTableView = [[[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped] autorelease];
    [m_meTableView setBackgroundColor:COLOR(219, 219, 219)];
    [m_meTableView setDataSource:self];
    [m_meTableView setDelegate:self];
    [m_meTableView setShowsHorizontalScrollIndicator:NO];
    [m_meTableView setShowsVerticalScrollIndicator:NO];
    [m_meTableView setSeparatorInset:UIEdgeInsetsMake(0, 10.f, 0, 0)];
//    [m_meTableView setSectionFooterHeight:12.0];//设置section之间的间距
    [m_meTableView setMultipleTouchEnabled:NO];
    
    return m_meTableView;
}

- (NSMutableDictionary *)getCellTextDictionary
{
    NSMutableArray *cell0TextArray = [[[NSMutableArray alloc]initWithObjects:@"部门", @"职位", @"上级", nil] autorelease];
    
    NSMutableArray *cell1TextArray = [[[NSMutableArray alloc]initWithObjects:@"邮箱", @"手机", @"座机", nil] autorelease];
    
    NSMutableArray *cell2TextArray = [[[NSMutableArray alloc]initWithObjects:@"性别", @"生日", nil] autorelease];
    
    NSMutableDictionary *textDic = [NSMutableDictionary dictionary];
    [textDic setObject:cell0TextArray forKey:[NSNumber numberWithInt:100]];
    [textDic setObject:cell1TextArray forKey:[NSNumber numberWithInt:200]];
    [textDic setObject:cell2TextArray forKey:[NSNumber numberWithInt:300]];
    
    return textDic;
}

- (NSMutableDictionary *)getCellValueDictionary
{
    NSMutableArray *cell0ValueArray = [[[NSMutableArray alloc]initWithObjects:userInfo.userDept, userInfo.userTitle, userInfo.superName == nil ? @"" : userInfo.superName, nil] autorelease];
    
    NSMutableArray *cell1ValueArray = [[[NSMutableArray alloc]initWithObjects:userInfo.userEmail, userInfo.userTel, userInfo.userCellphone == nil ? @"" : userInfo.userCellphone, nil] autorelease];
    
    NSString *genderStr = @"男";
    if (userInfo.userGender > 1) {
        genderStr = @"女";
    }
    
    NSMutableArray *cell2ValueArray = [[[NSMutableArray alloc]initWithObjects:genderStr, @"生日", nil] autorelease];
    
    NSMutableDictionary *valueDic = [NSMutableDictionary dictionary];
    [valueDic setObject:cell0ValueArray forKey:[NSNumber numberWithInt:100]];
    [valueDic setObject:cell1ValueArray forKey:[NSNumber numberWithInt:200]];
    [valueDic setObject:cell2ValueArray forKey:[NSNumber numberWithInt:300]];
    return valueDic;
}

- (UIImageView *)setUserMsgView
{
    CGRect headRect = CGRectMake(0, 0, SCREEN_WIDTH, kTableHeadHeight + 17.5);
    self.m_headView = [[UIImageView alloc] initWithFrame:headRect];
    [m_headView setBackgroundColor:HEX_COLOR(@"0xdbdbdb")];
    [m_headView setUserInteractionEnabled:YES];
    
    CGRect headSubRect = CGRectMake(0, 0, SCREEN_WIDTH, kTableHeadHeight);
    UIView *subHeadView = [[[UIView alloc] initWithFrame:headSubRect] autorelease];
    [subHeadView setBackgroundColor:[UIColor whiteColor]];
    [m_headView addSubview:subHeadView];
    
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraClick)] autorelease];
    [m_headView addGestureRecognizer:tapGesture];
    return m_headView;
}

- (void)setTableHeadView
{
    float xGap = 14.0f;
    float yGap = 19.5f;
    
    float wGap = 13.0f;
    float hGap = 12.5f;
    float lblGap = 6.5f;
    
    float userLblHeight = 17.0f;
    float infoLblHeight = 14.0f;
    float lblWidth = 170.0f;
    float bgHeight = kTableHeadHeight - 15.0f;
    
    CGRect userRect =  CGRectMake(11, 12.5, 46.5f, 46.5f);
    self.m_userImgView = [[UIImageView alloc] initWithFrame:userRect];
    [self.m_userImgView setImageWithURL:[NSURL URLWithString:userInfo.userImageUrl] placeholderImage:[UIImage imageNamed:@"groupCellDefaultHeader.png"]];
    
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraClick)] autorelease];
    [self.m_userImgView addGestureRecognizer:tapGesture];
    [self.m_headView addSubview:self.m_userImgView];
    
    CGRect userNameRect = CGRectMake(65, 14, 239, 19);
    UILabel *userNameLbl = [InformationDefault createLblWithFrame:userNameRect withTextColor:[UIColor blackColor] withFont:[UIFont fontWithName:@"Thonburi" size:17] withTag:Head_name_Type];
    [self.m_headView addSubview:userNameLbl];
    
    CGRect inductionRect = CGRectMake(xGap + (bgHeight - yGap*2) + wGap, yGap + 4.0 + hGap + userLblHeight, lblWidth, infoLblHeight);
    UILabel *inductionLbl = [InformationDefault createLblWithFrame:inductionRect withTextColor:[UIColor blackColor] withFont:[UIFont fontWithName:@"Thonburi" size:13] withTag:Head_title_Type];
    [self.m_headView addSubview:inductionLbl];
    
    CGRect loginRect = CGRectMake(xGap + (bgHeight - yGap*2) + wGap, yGap + 4.0 + hGap + userLblHeight + infoLblHeight + lblGap, lblWidth, infoLblHeight);
    UILabel *loginLbl = [InformationDefault createLblWithFrame:loginRect withTextColor:[UIColor blackColor] withFont:[UIFont fontWithName:@"Thonburi" size:13] withTag:Head_login_Type];
    [self.m_headView addSubview:loginLbl];
    
    // me detail
    UIImage *nextImg = [UIImage imageNamed:@"me_detail"];
    
    UIImageView *moreUserMsgImg = [InformationDefault createImgViewWithFrame:CGRectMake(287, 20, 35, 35) withImage:nextImg withColor:[UIColor clearColor] withTag:Head_detail_Type];
    
    [self.m_headView addSubview:moreUserMsgImg];
}

- (void)setUserMessage:(NSDictionary *)dic
{
    UILabel *userNameLbl = (UILabel *)[self.m_headView viewWithTag:Head_name_Type];
    UILabel *inductionLbl = (UILabel *)[self.m_headView viewWithTag:Head_title_Type];
    UILabel *loginLbl = (UILabel *)[self.m_headView viewWithTag:Head_login_Type];
    
    [userNameLbl setText:userInfo.userName];
    [inductionLbl setText:[NSString stringWithFormat:@""]];
    [loginLbl setText:[NSString stringWithFormat:@""]];
}

- (void)setUserAvtor:(UIImage *)avtorImg
{
    self.selectedPhoto = avtorImg;
   
    [self getAvatarUrl];
}

#pragma mark - Action Click
- (void)myInfoClick
{
    MyInfoViewController *myInfo = [[[MyInfoViewController alloc] initWithMOC:_MOC parentVC:nil viewHeight:0] autorelease];
    [CommonMethod pushViewController:myInfo withAnimated:YES];
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case User_Edit_Section0_Type:
        {
            return 3;
        }
            break;
        
        case User_Edit_Section1_Type:
        {
            return 3;
        }
            break;
            
        case User_Edit_Section2_Type:
        {
            return 2;
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == User_Edit_Section0_Type)
    {
        return  kTableHeadHeight + 17.5;
    } else {
        return  17.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  kUserDetailCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == User_Edit_Section0_Type)
    {
        return [self getSection0HeadView];
    } else {
        return nil;
    }
}

- (UIView *)getSection0HeadView
{
   
    CGRect headRect = CGRectMake(0, 0, SCREEN_WIDTH, kTableHeadHeight + 17.5);
    self.section0View = [[UIView alloc] initWithFrame:headRect];
    [self.section0View setBackgroundColor:TRANSPARENT_COLOR];
    [self.section0View addSubview:[self setUserMsgView]];
    [self setTableHeadView];
    [self setUserMessage:nil];
    
    return self.section0View;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *kCellIdentifier = @"UserDetailEditCell";
    UserDetailEditCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (nil == cell)
    {
        cell = [[[UserDetailEditCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:kCellIdentifier] autorelease];
    }
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setLabelData:[[[self getCellTextDictionary] objectForKey:[NSNumber numberWithInt:(indexPath.section + 1) * 100]] objectAtIndex:indexPath.row]];
    
    [cell setTextData:[[[self getCellValueDictionary] objectForKey:[NSNumber numberWithInt:(indexPath.section + 1) * 100]] objectAtIndex:indexPath.row]];
    
    if (indexPath.section != 0) {
        UIImage *nextImg = [UIImage imageNamed:@"me_detail"];
        UIImageView *moreUserMsgImg = [InformationDefault createImgViewWithFrame:CGRectMake(287, 14, 35, 35) withImage:nextImg withColor:[UIColor clearColor] withTag:Head_detail_cell_Type];
        [cell.contentView addSubview:moreUserMsgImg];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    
    switch (indexPath.section) {
        case User_Edit_Section1_Type:
        {
            UserDetailEditInfoViewController *userEditInfoVC = [[UserDetailEditInfoViewController alloc] initWithMOC:_MOC];
            userEditInfoVC.title = [[[self getCellTextDictionary] objectForKey:[NSNumber numberWithInt:(indexPath.section + 1) * 100]] objectAtIndex:row];
            userEditInfoVC.delegate = self;
            [userEditInfoVC initWithDataModal:userInfo];
            
            if (row == 0) {
                userEditInfoVC.type = USER_PROPERTY_EMAIL;
            } else if(row == 1) {
                userEditInfoVC.type = USER_PROPERTY_PHONE;
            }
            
            [CommonMethod pushViewController:userEditInfoVC withAnimated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)cameraClick
{
    [self editPortrait];
}

- (void)editPortrait
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet setTag:Camera_Sheet_Type];
    
    [choiceSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {

    [self setUserAvtor:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [CommonUtils imageByScalingToMaxSize:portraitImg];
        
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
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

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag)
    {
        case Camera_Sheet_Type:
        {
            if (buttonIndex == 0)
            {
                
                [self enterCameraForUser];
            } else if (buttonIndex == 1) {
                
                [self enterPhotoLibraryForUser];
            } else {
                return;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)getAvatarUrl {
    
    _currentType = GET_IMAGE_URL_TY;
    
    self.connFacade = [[[WXWAsyncConnectorFacade alloc] initWithDelegate:self
                        
                                                  interactionContentType:_currentType] autorelease];
    
    NSDictionary *paramDic = @{@"appId":@"EMBA_UNION", @"moduleId":@"USER_MOD_ID",};
    
    [((WXWAsyncConnectorFacade *)self.connFacade) uploadImage:self.selectedPhoto
                                                          url:@"http://112.124.68.147:5000/UploadImage.aspx"
                                                          dic:paramDic];
}

- (void)uploadAvatar:(NSString *)imgUrl {
    
    _currentType = UPLOAD_IMAGE_TY;
    
    NSMutableDictionary *specialDict = [NSMutableDictionary dictionary];
    [specialDict setValue:imgUrl forKey:@"UploadImageUrl"];
    
     NSString *urlStr = [NSString stringWithFormat:@"%@/%@%@", VALUE_API_PREFIX, API_SERVICE_USER, API_NAME_USER_MODIFYIMAGE];
     NSString *url = [ProjectAPI getURL:urlStr specialDict:specialDict];
     
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:UPLOAD_IMAGE_TY];
    [connFacade fetchGets:url];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case GET_IMAGE_URL_TY:
        {
            NSDictionary *resultDict = [result objectFromJSONData];
            NSString *code = [resultDict objectForKey:@"code"];
            
            if ( [code isEqualToString:@"200"] ) {
                NSDictionary *thumbnailDict = [resultDict objectForKey:@"thumbnailImage"];
                NSString *imgUrl = [thumbnailDict objectForKey:@"imageUrl"];
                NSLog(@"imgUrl = %@", imgUrl);
                
                [self uploadAvatar:imgUrl];
            }
            
            break;
        }
            
        case UPLOAD_IMAGE_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                NSDictionary *resultDict = [result objectFromJSONData];
                NSDictionary *dataDict = [resultDict objectForKey:@"Data"];
                NSString *imgUrl = [dataDict objectForKey:@"ImgUrl"];
                
                userInfo.userImageUrl = imgUrl;
                
                [[ProjectDBManager instance] insertOrUpdateUserInfos:userInfo];
                
                NSLog(@"imgUrl = %@", imgUrl);
                NSLog(@"Update user avtor success!");
                
                [self.m_meTableView reloadData];
            }
            
            [super connectDone:result
                           url:url
                   contentType:contentType];
            
            break;
        }
            
        default:
            break;
    }
    
}

- (void)connectCancelled:(NSString *)url
             contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error
                  url:(NSString *)url
          contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
}

#pragma mark - UserDetailEditInfoViewControllerDelegate method
- (void)userDetailContentChanged:(BOOL)changed
{
}

@end
