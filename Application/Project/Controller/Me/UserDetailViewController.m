
#import "UserDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CommonMethod.h"
#import "MoreViewController.h"
#import "MeViewController.h"
#import "AppManager.h"
#import "WXApi.h"
#import "CommonUtils.h"
#import "UIImageView+WebCache.h"
#import "HomeContainerViewController.h"
#import "MyInfoViewController.h"
#import "MeSettingController.h"
#import "MeStoreController.h"
#import "IdentityAuthViewController.h"
#import "UserDetailCell.h"
#import "SampleTabBarItem.h"
#import "ChatDetailViewController.h"

//#define BOTTOM_HEIGHT 49.f
#define BUTTON_READ_COMMENT_WIDTH  29.f
#define BUTTON_READ_COMMENT_HEIGHT 25.f

#define TAB_COUNT       4
#define MARGIN_LEFT   13.f
#define MARGIN_RIGHT  15.f

#define kTableHeadHeight 67.0f
#define kTableFootheight 52.0f

enum USER_BOTTOM_TYPE {
    USER_DETAIL_CHAT,
    USER_DETAIL_CALL,
    USER_DETAIL_MSG,
    USER_DETAIL_EMAIL,
};

typedef enum : NSUInteger {
    User_Edit_Section0_Type,
    User_Edit_Section1_Type,
    User_Edit_Section2_Type,
} UserEditSectionType;

enum Setting_Section_Type
{
    Setting_Cell_Type,
    Share_Cell_Type,
};

enum Control_Type
{
    Seprate_Img_Type = 102,
    UserName_lbl_Type,
    Vision_lbl_Type,
    
};

enum sheetType
{
    Camera_Sheet_Type,
};

enum Head_Control_Type
{
    Head_userImg_Type = 301,
    Head_name_Type,
    Head_induction_Type,
    Head_login_Type,
    Head_detail_Type,
};


@interface UserDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) UITableView *m_meTableView;
@property (nonatomic, retain) UIImageView *m_userImgView;
@property (nonatomic, retain) UIImageView *m_headView;

@end

@implementation UserDetailViewController
{
    UserObject *userInfo;
    int BOTTOM_HEIGHT;
}

@synthesize m_meTableView;
@synthesize m_userImgView;
@synthesize m_headView;

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
        BOTTOM_HEIGHT = 49.f;
    }
    
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
       userObject:(UserObject *)userObject
       showBottom:(BOOL)showBottom {
    
    self = [super initWithMOC:MOC
        needRefreshHeaderView:NO
        needRefreshFooterView:NO];
    
    if (self) {
        userInfo = userObject;
        if (showBottom) {
            BOTTOM_HEIGHT = 0;
        }
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    userInfo = [[ProjectDBManager instance] getUserInfoByUserIdFromDB:userInfo.userId];
    [self.m_meTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"用户明细";
    [self.view addSubview:[self createMeTypeTable]];
    
    if (BOTTOM_HEIGHT > 0) {
        [self addBottomView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBottomView {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [GlobalInfo getDeviceSize].height - BOTTOM_HEIGHT - NAVIGATION_BAR_HEIGHT - SYS_STATUS_BAR_HEIGHT, self.view.frame.size.width, BOTTOM_HEIGHT)];
    bottomView.backgroundColor = HEX_COLOR(@"0x37343b");
    [self.view addSubview:bottomView];
    
    CGFloat width = SCREEN_WIDTH / TAB_COUNT;
    for (int i = 0; i < TAB_COUNT; i++) {
        CGFloat x = width * i;
        
        SampleTabBarItem *item = [[[SampleTabBarItem alloc] initWithFrame:CGRectMake(x, 0, width, HOMEPAGE_TAB_HEIGHT)
                                                     delegate:self
                                              selectionAction:@selector(selectTag:)
                                                          tag:i] autorelease];
        
        [self setTabItem:item index:i forInit:YES];
        
        [bottomView addSubview:item];
    }

}

- (void)setTabItem:(SampleTabBarItem *)item index:(NSInteger)index forInit:(BOOL)forInit{
    
    NSString *title = nil;
    NSString *imageName = nil;
    NSInteger numberBadge = 0;
    
    switch (index) {
        case TAB_BAR_FIRST_TAG:
        {
            title = @"交流";
            imageName = @"user_chat";
            [item setTitleColorForHighlight:YES];
            
            break;
        }
            
        case TAB_BAR_SECOND_TAG:
        {
            title = @"电话";
            imageName = @"user_call";
            [item setTitleColorForHighlight:YES];
            
            break;
        }
            
        case TAB_BAR_THIRD_TAG:
        {
            title = @"短信";
            imageName = @"user_msg";
            [item setTitleColorForHighlight:YES];
            
            break;
        }
            
        case TAB_BAR_FOURTH_TAG:
        {
            title = @"邮件";
            imageName = @"user_email";
            [item setTitleColorForHighlight:YES];
            
            break;
        }
            
        default:
            break;
    }
    
    [item setTitle:title image:[UIImage imageNamed:imageName]];
    
    [item setNumberBadgeWithCount:numberBadge];
}

- (void)selectTag:(NSNumber *)tag {
    
    switch ([tag intValue]) {
        case USER_DETAIL_CHAT:
        {
            ChatDetailViewController *vc = [[[ChatDetailViewController alloc] initWithData:userInfo.chatId title:userInfo.userName MOC:_MOC] autorelease];
            
            [CommonMethod pushViewController:vc withAnimated:YES];
        }
            break;
            
        case USER_DETAIL_CALL:
        {
            NSString *telStr = [NSString stringWithFormat:@"tel://%@", userInfo.userTel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
        }
            break;

        case USER_DETAIL_MSG:
        {
            NSString *msgStr = [NSString stringWithFormat:@"sms://%@", userInfo.userTel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:msgStr]];
        }
            break;

        case USER_DETAIL_EMAIL:
        {
            NSString *mailStr = [NSString stringWithFormat:@"mailto://%@", userInfo.userEmail];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailStr]];
        }
            break;

        default:
            break;
    }
    
}


#pragma mark - Create Control

- (UITableView *)createMeTypeTable
{
    CGRect tableFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - BOTTOM_HEIGHT);
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

- (UILabel *)createVisionLbl
{
    float lblHeght = 11.0f;
    UIColor *lblColor = [UIColor colorWithHexString:@"0xb1b1b1"];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    CGRect lblFrame = CGRectMake(0, (kTableFootheight - lblHeght)/2, SCREEN_WIDTH, lblHeght);
    UILabel *visionLbl = [InformationDefault createLblWithFrame:lblFrame withTextColor:lblColor withFont:font withTag:Vision_lbl_Type];
    [visionLbl setTextAlignment:NSTextAlignmentCenter];
    [visionLbl setText:[NSString stringWithFormat:@"版本号：1.0"]];
    
    return visionLbl;
}

- (UIImageView *)setUserMsgView
{
    CGRect headRect = CGRectMake(0, 0, SCREEN_WIDTH, kTableHeadHeight + 17.5);
    self.m_headView = [[[UIImageView alloc]initWithFrame:headRect] autorelease];
    [m_headView setBackgroundColor:HEX_COLOR(@"0xdbdbdb")];
    [m_headView setUserInteractionEnabled:YES];
    
    CGRect headSubRect = CGRectMake(0, 0, SCREEN_WIDTH, kTableHeadHeight);
    UIView *subHeadView = [[[UIView alloc] initWithFrame:headSubRect] autorelease];
    [subHeadView setBackgroundColor:[UIColor whiteColor]];
    [m_headView addSubview:subHeadView];
    
//    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myInfoClick)] autorelease];
//    [m_headView addGestureRecognizer:tapGesture];
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
    [self.m_headView addSubview:self.m_userImgView];
    
    CGRect userNameRect = CGRectMake(65, 14, 239, 17);
    UILabel *userNameLbl = [InformationDefault createLblWithFrame:userNameRect withTextColor:[UIColor blackColor] withFont:[UIFont fontWithName:@"Thonburi" size:17] withTag:Head_name_Type];
    [self.m_headView addSubview:userNameLbl];
    
    CGRect inductionRect = CGRectMake(xGap + (bgHeight - yGap*2) + wGap, yGap + 4.0 + hGap + userLblHeight, lblWidth, infoLblHeight);
    UILabel *inductionLbl = [InformationDefault createLblWithFrame:inductionRect withTextColor:[UIColor blackColor] withFont:[UIFont fontWithName:@"Thonburi" size:13] withTag:Head_induction_Type];
    [self.m_headView addSubview:inductionLbl];
    
    CGRect loginRect = CGRectMake(xGap + (bgHeight - yGap*2) + wGap, yGap + 4.0 + hGap + userLblHeight + infoLblHeight + lblGap, lblWidth, infoLblHeight);
    UILabel *loginLbl = [InformationDefault createLblWithFrame:loginRect withTextColor:[UIColor blackColor] withFont:[UIFont fontWithName:@"Thonburi" size:13] withTag:Head_login_Type];
    [self.m_headView addSubview:loginLbl];
    
}

- (void)setUserMessage:(NSDictionary *)dic
{
    UILabel *userNameLbl = (UILabel *)[self.m_headView viewWithTag:Head_name_Type];
    UILabel *inductionLbl = (UILabel *)[self.m_headView viewWithTag:Head_induction_Type];
    UILabel *loginLbl = (UILabel *)[self.m_headView viewWithTag:Head_login_Type];
    
    [userNameLbl setText:userInfo.userName];
    [inductionLbl setText:[NSString stringWithFormat:@""]];
    [loginLbl setText:[NSString stringWithFormat:@""]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  kUserDetailCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == User_Edit_Section0_Type)
    {
        UIView *headView = [[[UIView alloc] init] autorelease];
        [headView setBackgroundColor:[UIColor clearColor]];
        [headView addSubview:[self setUserMsgView]];
        [self setTableHeadView];
        [self setUserMessage:nil];
        
        return headView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"UserDetailCell";
    UserDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (nil == cell)
    {
        cell = [[[UserDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:kCellIdentifier] autorelease];
    }
    
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setLabelData:[[[self getCellTextDictionary] objectForKey:[NSNumber numberWithInt:(indexPath.section + 1) * 100]] objectAtIndex:indexPath.row]];
    
    [cell setTextData:[[[self getCellValueDictionary] objectForKey:[NSNumber numberWithInt:(indexPath.section + 1) * 100]] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!m_userImgView) {
       
        CGFloat width = 73.0f; CGFloat height = width;
        CGFloat xGap = (SCREEN_WIDTH - width)/2;
        CGFloat yGap = 13.0f;
        self.m_userImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(xGap, yGap, width, height)]autorelease];
        [m_userImgView.layer setCornerRadius:(m_userImgView.frame.size.height/2)];
        [m_userImgView.layer setMasksToBounds:YES];
        [m_userImgView setContentMode:UIViewContentModeScaleAspectFill];
        [m_userImgView setClipsToBounds:YES];
        m_userImgView.layer.shadowColor = [UIColor blackColor].CGColor;
        m_userImgView.layer.shadowOffset = CGSizeMake(4, 4);
        m_userImgView.layer.shadowOpacity = 0.5;
        m_userImgView.layer.shadowRadius = 2.0;
        m_userImgView.layer.borderColor = [[UIColor blackColor] CGColor];
        m_userImgView.layer.borderWidth = 2.0f;
        m_userImgView.userInteractionEnabled = YES;
        m_userImgView.backgroundColor = [UIColor blackColor];
    }
    
    return self.m_userImgView;
}

@end
