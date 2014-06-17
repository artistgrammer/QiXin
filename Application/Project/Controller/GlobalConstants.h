
/*!
 @header GlobalConstants.h
 @abstract 全局定义
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <Foundation/Foundation.h>
#import "BaseConstants.h"
#import "UIColor+expanded.h"

// 皮肤
#import "ThemeManager.h"
#import "ThemeLabel.h"
#import "ThemeButton.h"
#import "ThemeImageView.h"

#pragma mark - app type

//EMBA商学院
#define APP_TYPE_EMBA   1

//CIO地址
#define APP_TYPE_CIO    2

//O2O云商户
#define APP_TYPE_O2O    3

#define APP_TYPE   APP_TYPE_EMBA

#pragma mark - app properties

#if APP_TYPE == APP_TYPE_EMBA
#define VERSION                     @"1.2.3"
#else
#define VERSION                     @"1.2.2"
#endif

#if APP_TYPE == APP_TYPE_EMBA
#define FORGET_PASSWORD_LINK                     @"http://112.124.68.147:5000/Mobile/RetrievePasswordList.aspx"
#else
#define FORGET_PASSWORD_LINK                     @"http://112.124.68.147:5010/Mobile/RetrievePasswordList.aspx"
#endif

#define CUSTOMER_ID              @"a2573925f3b94a32aca8cac77baf6d33"

#define kChatUserRoleName        @"ChatUserRoleName"
#define kChatUserRoleNameArray   @"kChatUserRoleNameArray"
#define kChatUserRoleMap         @"kChatUserRoleMap"

#if APP_TYPE == APP_TYPE_EMBA

#define WEIXIN_APP_ID       @"wxaf2414de75f47280"
#define WEIXIN_APP_KEY      @"266e26e26a06a36d3111913daeae69b3"

#elif APP_TYPE == APP_TYPE_CIO

#define WEIXIN_APP_ID       @"wxaf2414de75f47280"
#define WEIXIN_APP_KEY     @"266e26e26a06a36d3111913daeae69b3"

#elif APP_TYPE == APP_TYPE_O2O

#define WEIXIN_APP_ID       @"wxaf2414de75f47280"
#define WEIXIN_APP_KEY     @"266e26e26a06a36d3111913daeae69b3"

#endif

// Style
#define STYLE_NAVIGATIONBAR_COLOR   @"0x1e70e0"
#define STYLE_BLUE_COLOR             @"0x3678b5"
#define STYLE_RED_COLOR               @"0xe64125"

#define MESSAGE_CREATE_GROUP(creator)   \
[NSString stringWithFormat:@"%@创建了此群", creator]

#define MESSAGE_INVITED_GROUP(inviter, invitee)     \
[NSString stringWithFormat:@"%@被%@邀请加入此群", invitee, inviter]

#define MESSAGE_REMOVE_FROM_GROUP(remover, removee)     \
[NSString stringWithFormat:@"%@被%@从此群中移除", removee, remover]

#define MESSAGE_QUIT_GROUP(quiter)      \
[NSString stringWithFormat:@"%@已退出此群", quiter]

enum USER_STATUS{
    USER_STATUS_NO_AUDIT = 0,
    USER_STATUS_AUDIT,
    USER_STATUS_REFUSED,
    USER_STATUS_ADMIN,
};


#pragma mark - notification

#define INFO_VIEW_REFREASH_NOTIFY       @"InfoViewRefreashNotify"

#define COMMUNICAT_VIEW_CONTROLLER_DELETE_GROUP @"CommunicationViewControllerDeleteGroup"

#define COMMUNICAT_VIEW_CONTROLLER_QUIT_CHAT_GROUP @"CommunicationViewControllerQuiteGroup"

#define TRAINING_VIEW_CONTROLLER_REFRESH_COURSE_LIST    @"TrainingViewControllerRefreshCourseList"

#define COMMUNICAT_VIEW_CONTROLLER_DELETE_GROUP_FROM_AILIAO @"CommunicatViewControllerDeleteGroupFromAiLiao"

#pragma mark - font
#define BASE_INFO_COLOR                 COLOR(130, 130, 140)
#define DARK_TEXT_COLOR                 COLOR(98, 87, 87)
#define HEADER_CELL_TITLE_FONT          BOLD_FONT(13)

#pragma mark - table cell
#define CELL_TITLE_COLOR                COLOR(30.0f, 30.0f, 30.0f)

#define CELL_COLOR                      COLOR(239, 239, 239)

#define COMMON_CELL_SUBTITLE_FONT       BOLD_FONT(12)
#define COMMON_CELL_TITLE_FONT          BOLD_FONT(14)
#define COMMON_CELL_CONTENT_FONT        BOLD_FONT(13)

#define CELL_TITLE_IMAGE_SIDE_LENGTH    24.0f

#define CELL_CONTENT_PORTRAIT_WIDTH     280.0f

#define PLAIN_TABLE_NO_TITLE_IMAGE_ACCESS_DISCLOSUR_WIDTH     266.0f
#define PLAIN_TABLE_NO_IMAGE_ACCESS_NONE_WIDTH                300.0f
#define GROUPED_TABLE_NO_TITLE_IMAGE_ACCESS_DISCLOSUR_WIDTH   216.0f
#define GROUPED_TABLE_NO_TITLE_IMAGE_ACCESS_NONE_WIDTH        270.0f

#define PLAIN_TABLE_WITH_TITLE_IMAGE_ACCESS_DISCLOSUR_WIDTH   232.0f
#define PLAIN_TABLE_WITH_IMAGE_ACCESS_NONE_WIDTH              246.0f
#define GROUPED_TABLE_WITH_TITLE_IMAGE_ACCESS_DISCLOSUR_WIDTH 232.0f
#define GROUPED_TABLE_WITH_TITLE_IMAGE_ACCESS_NONE_WIDTH      236.0f

#define GROUP_STYLE_CELL_CORNER_RADIUS  10.0f

#define DEFAULT_CELL_HEIGHT             44.0f
#define DEFAULT_HEADER_CELL_HEIGHT      20.0f

#pragma mark - table list
#define SEPARATOR_LINE_COLOR            COLOR(158,161,168)

#define NUMBER(__OBJ) [NSNumber numberWithInt:__OBJ]

#pragma mark - color
#define RANDOM_COLOR [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1]

#define TITLE_COLOR               COLOR(90.0f, 90.0f, 90.0f)
#define BLUE_TITLE_COLOR          COLOR(36.0f, 107.0f, 195.0f)
#define LIGHT_GRAY_BACKGROUND_COLOR COLOR(252.0f, 252.0f, 252.0f)
#define WHITE_COLOR             [UIColor whiteColor]
#define BLUE_COLOR              [UIColor blueColor]

#define DEFAULT_VIEW_COLOR  COLOR(0xe1, 0xe5, 0xe7)
//#define DEFAULT_VIEW_COLOR [UIColor colorWithPatternImage:IMAGE_WITH_NAME(@"background.png")]

#define DEFAULT_BACKGROUND_COLOR COLOR(0xed, 0xed, 0xed)

#define COLOR_WITH_IMAGE_NAME(name)     [UIColor colorWithPatternImage:[UIImage imageNamed:name]]
#define IMAGE_WITH_IMAGE_NAME(name)     [UIImage imageNamed:name]

#pragma mark - common ui elements
#define NUMBER_BADGE_COLOR    COLOR(231,50,47)
#define PHOTO_MARGIN                    3.0f

#define APP_DELEGATE                [UIApplication sharedApplication].delegate
#define APP_WINDOW                  ((UIWindow *)([[UIApplication sharedApplication].windows objectAtIndex:0]))

#define kDEFAULT_DATE_TIME_FORMAT   (@"yyyy-MM-dd HH:mm:ss")
#define kDATE_TIME_FORMAT           (@"yyyyMMddHHmmss")

#define MARGIN                      5.0f

#define NOTIFY_NETWORK_STATUS       @"notify.network.status"

//聊天的类型
enum CHAT_TYPE {
    CHAT_TYPE_UNKNOWN = 0,
    CHAT_TYPE_GROUP = 1,
    CHAT_TYPE_PRIVATE,
};

typedef enum {
    NetworkConnectionStatusOff,
    NetworkConnectionStatusOn,
    NetworkConnectionStatusDoing,
    NetworkConnectionStatusDone,
    NetworkConnectionStatusLoading,
} NetworkConnectionStatus;

#define HEADER_SCROLL_HEIGHT  240.f

#define CHART_PHOTO_WIDTH               35.f //42.5f
#define CHART_PHOTO_HEIGHT              35.f //50.0f

//底部高度
#define ITEM_BASE_TOP_VIEW_HEIGHT       0
#define ITEM_BASE_BOTTOM_VIEW_HEIGHT    40

#define ALONE_MARKETING_TAB_HEIGHT      44

#pragma mark - network


#pragma mark - we chat
#define WX_API_KEY @"test"


#pragma mark - homepage
#define HOMEPAGE_TAB_HEIGHT             48.0f
#define NO_IMAGE_FLAG                   @"no_image_url_"

#define TAB_BAR_HEIGHT 68
#define NAV_BAR_HEIGHT 44

#pragma mark - WeChat integration
#define MAX_WECHAT_ATTACHED_IMG_SIZE    30 * 1024
#define MAX_WECHAT_MAX_DESC_CHAR_COUNT  32
#define MAX_WECHAT_MAX_TITLE_CHAR_COUNT 60

#pragma mark - o2o customer type

typedef enum {
    TAB_BAR_FIRST_TAG,
    TAB_BAR_SECOND_TAG,
    TAB_BAR_THIRD_TAG,
    TAB_BAR_FOURTH_TAG,
    TAB_BAR_FIFTH_TAG,
} HomeEntranceItemTagType;

typedef enum {
    CustomerType_Weixun = 1,
    CustomerType_HotWind = 2,
    CustomerType_FlyHorse = 3,
}CustomerType;

#pragma mark - date formatter type
typedef enum {
    FormatType_Default = 0,
    FormatType_Han
}FormatType;

#pragma mark - training

typedef enum {
    MY_COURSE_TY,
    ALL_COURSE_TY,
}TrainingCourseType;


#pragma mark - alumnus
typedef enum {
    OTHER_CLASS_ALUMNUS_TY,
    SAME_CLASS_ALUMNUS_TY,
} KnownAlumnusType;

typedef enum {
	CHAT_SHEET_IDX,
	DETAIL_SHEET_IDX,
    CANCEL_SHEET_IDX,
} UserListActionSheetType;


typedef struct {
    CGFloat left;
    CGFloat right;
    CGFloat top;
    CGFloat bottom;
}CellMargin;

UIKIT_STATIC_INLINE CellMargin NSCellMarginMake(CGFloat left,
                                                CGFloat right,
                                                CGFloat top,
                                                CGFloat bottom) {
    CellMargin cm = {left, right, top, bottom};
    return cm;
}

typedef struct {
    CGFloat x;
    CGFloat y;
}CellDist;

UIKIT_STATIC_INLINE CellDist NSCellDistanceMake(CGFloat x,
                                                CGFloat y) {
    CellDist cd = {x, y};
    return cd;
}

enum GROUP_PROPERTY_TYPE {
    GROUP_PROPERTY_TYPE_NAME = 1,
    GROUP_PROPERTY_BRIEF,
    GROUP_PROPERTY_PHONE,
    GROUP_PROPERTY_EMAIL,
    GROUP_PROPERTY_WEBSITE,
};

enum USER_PROPERTY_TYPE {
    USER_PROPERTY_EMAIL = 0,
    USER_PROPERTY_PHONE,
    USER_PROPERTY_TEL,
    USER_PROPERTY_GENDER,
};

enum FRIEND_TYPE {
    FRIEND_TYPE_UPDATE = 0,
    FRIEND_TYPE_DELETE = 2,
    FRIEND_TYPE_ADD = 1,
    FRIEND_TYPE_PRIVATE_DELETE=3,
};

#pragma mark - event
#define FAKE_EVENT_INTERVAL_DAY   -1

typedef enum {
    OTHER_CATEGORY_EVENT = 0,
    TODAY_CATEGORY_EVENT = 1,
    THIS_MONTH_CATEGORY_EVENT,
} EventDateCategory;

#pragma mark - download status

typedef enum {
    DownloadStatus_unDownload = 1 << 5,
    DownloadStatus_Downloaded,
    DownloadStatus_Paused,
    DownloadStatus_Downloading
}DownloadStatus;

typedef enum {
    ChapterStatue_Learned = 1 << 2,
    ChapterStatus_Unlearn,
}ChapterStatus;

typedef struct {
    DownloadStatus downloadStatus;
    ChapterStatus chapterStatus;
}ManageStatus;

UIKIT_STATIC_INLINE ManageStatus NSManageStatusSet(DownloadStatus ds,
                                                   ChapterStatus cs) {
    ManageStatus nmss = {ds, cs};
    return nmss;
}

#pragma mark - load item type
typedef enum {
    USER_LOGIN_TY,//登录
    
    USER_LIST_TY, //用户列表
    
    CHAT_GROUP_LIST_TY,      //获取交流群组列表
    CHAT_GROUP_CREAT_TY,     //创建群组
    CHAT_GROUP_ADD_USER_TY,  //群组加人
    CHAT_GROUP_DETAIL_TY,    //群组明细
    CHAT_GROUP_UPDATE_TY,     //创建群组
    CHAT_GROUP_USER_LIST_TY,    //获取群组用户列表
    CHAT_GROUP_DELETE_TY,     //删除群组
    CHAT_GROUP_DELETE_MEMBER_TY,//删除群组成员
    
    SUBMIT_JOING_CHAT_GROUP_TY,//加入群组
    

    //更多
    UPLOAD_IMAGE_TY,//上传头像
    GET_IMAGE_URL_TY,//得到头像上传地址
    
    SUBMIT_PRIVETE_LETTER_TY,//提交私信，	向某人发送私信，但不能自己向自己发
    
    LOAD_LATEST_VIDEO_TY,
    EVENTLIST_TY,
    LOAD_KNOWN_ALUMNUS_TY,
    SUBMIT_FEEDBACK_TY,
    
    //common
    LOAD_IMAGE_LIST_TY,//获取 图片墙图片信息
    LOAD_BUSINESS_IMAGE_LIST_TY,
    LOAD_UPDATE_VERSION_TY,
    
    GET_USER_PROFILES,//登录前获取所有用户信息
    
    //资讯
    SEARCH_INFORMATION_LIST_TY,//获取资讯列表
    GET_APPLY_MEMBER_LIST_TY,//获取报名成员列表
    LOAD_INFORMATION_LIST_TY,//获取资讯列表
    LOAD_INFORMATION_LIST_WITH_SPECIFIEDID_TY,
    LOAD_CATEGORY_TY,//不打扰营销列表
    LOAD_EVENT_PRE_TY,//获取活动预告
    LOAD_EVENT_REV_TY,//获取活动回顾
    LOAD_EVENT_DETAIL_PRE_TY,//获取活动预告详情
    
    LOAD_EVENT_DETAIL_REV_TY,//获取活动回顾详情
    SUBMIT_APPLY_TY,
    UPDATE_READER_TY, //更新读者数
    LOAD_INFORMATION_COMMENT_TY,
    SUBMIT_INFORMATION_COMMENT_TY,
    
    //企信
    LOAD_ORDER_LIST_TY,
    LOAD_ORDER_DETAIL_TY,
    LOAD_MESSAGE_LIST_TY,
    SEND_MESSAGE_TEXT_TY,
    SEND_MESSAGE_IMAGE_TY,
    SEND_MESSAGE_VIDEO_TY,
    SEND_MESSAGE_VOICE_TY,
    LOAD_VIP_PROFILE_TY,
    LOAD_ITEM_KEEP_TY,
    LOAD_VIP_TAGS_TY,
    
    //业务
    LOAD_EVENT_VOTE_LIST,
    GET_BUSINESS_CATEGORY,
    LOAD_EVENT_COMMENT_TY,
    SUBMIT_EVENT_COMMENT_TY,
    
    GET_DETAIL_PAGE_1_TY,
    //培训
    GET_TRAINING_LIST_TY,
    GET_COURSE_CHAPTER_TY,
    SUBMIT_CHAPTER_COMPLETION_TY,
    GET_BOOK_IMAGE_LIST,
    GET_BOOK_LIST_TY,
    
    //交流
    SET_USER_LOGIN_LICALL,//设置爱聊
    
    GET_USER_SEARCH_TY,//获取用户搜索
    SUBMIT_VOTE_TY,//提交投票
    
    GET_CHAT_GROUP_LIST_TY,//获取群组好友列表
    
    GET_CHAT_GROUP_JOINED_TY,//获取某会员加入的群组列表
    GET_PRIVATE_LETTER_USER_LIST_TY,//私信人员列表
    GET_FRIEND_LETTER_USER_LIST_TY,//好友列表
    
    SUBMIT_NEW_PWD_TY,
    
    //PG相关
    PG_GET_LOGIN_INFO,
    PG_GET_NEWSLIST,
    PG_GET_ALLCOURSES,
    PG_GET_ALLLIBRARYS,
    PG_GET_ALLMETERIALS,
    PG_GET_ALLCOMMENTS,
    PG_GET_ADDCOMMENT,
    PG_GET_ALLSURVEYS,
    
} WebItemType;

enum DOWNLOADED_CELL_MODE {
    DOWNLOADED_CELL_MODE_NORMAL = 1,
    DOWNLOADED_CELL_MODE_EDIT = 2,
};

typedef enum {
    ALL_NEWS_TY,
    FOR_HOMEPAGE_NEWS_TY = 1,
    ALUMNI_NEWS_TY,
    UNION_NEWS_TY,
} NewsType;

typedef enum {
    
    ERR_CODE = -1,
    SUCCESS_CODE = 0,
    MOC_SAVE_ERR_CODE = 1,
    NO_DATA_CODE = 1001,
    RESP_OK = 200,
    APP_EXPIRED_CODE = 206,
    SOFT_UPDATE_CODE = 220,
    
    // system error code
    SESSION_EXPIRED_CODE = 101,
    BACKEND_ERR_CODE = 102,
    DB_ERROR_CODE = 103,
    USER_NO_AUTH_CODE = 104,
    
    // biz error code
    CUSTOMER_NAME_ERR_CODE = 300,
    USERNAME_ERR_CODE = 301,
    PASSWORD_ERR_CODE = 302,
    ACCOUNT_INVALID_CODE = 303,
    MOBILE_OCCUPIED_CODE = 304,
    EMAIL_OCCUPIED_CODE = 305,
    HAS_NEW_VERSION_CODE = 306,
    // join the group
    GROUP_REJECT_JOIN = 307,
    GROUP_NEED_AUDIT_JOIN = 308,
    GROUP_APPLY_JOINED = 309,
    GROUP_EXIT_FAILED = 400,
    
    // object handle
    OBJ_IS_NULL_CODE = 404,
    
    PASSWORD_OLD_ERR_CODE = 425,
    
    GROUP_NOT_EXIST = 1002,
    // coustom jump
    COUSTOM_JUMP_PROFILE = 4001,// 个人名片页面
    COUSTOM_JUMP_CERTIFICATION = 4002,// 提交认证资料页面
    COUSTOM_JUMP_APPROVAL = 4003,// 待认证页面
    
} ConnectionAndParserResultCode;


typedef enum {
    HOT_ATTENTION_TYPE = 110,
    NEWS_LIST_TYPE,
    NEW_DETAIL_TYPE,
} NewsInfoType;

#define ORIGINAL_MAX_WIDTH          640.0f

#define OBJ_FROM_DIC(_DIC_, _KEY_) [CommonUtils validateResult:_DIC_ dicKey:_KEY_]
#define STRING_VALUE_FROM_DIC(_DIC_, _KEY_) (NSString *)OBJ_FROM_DIC(_DIC_, _KEY_)
#define INT_VALUE_FROM_DIC(_DIC_, _KEY_) ((NSString *)OBJ_FROM_DIC(_DIC_, _KEY_)).intValue
#define FLOAT_VALUE_FROM_DIC(_DIC_, _KEY_) ((NSString *)OBJ_FROM_DIC(_DIC_, _KEY_)).floatValue
#define DOUBLE_VALUE_FROM_DIC(_DIC_, _KEY_) ((NSString *)OBJ_FROM_DIC(_DIC_, _KEY_)).doubleValue

#define RET_RESULT_NAME               @"error"
#define RET_OBJECT_NAME               @"object"
#define RET_PROPERTY_NAME             @"property"
#define RET_CODE_NAME                 @"err_code"
#define RET_MSG_NAME                  @"err_msg"

//------------------------communication--------------------------------
#define COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT   78
#define COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT_BK   76
#define COMMUNICATION_GROUP_BRIEF_VIEW_BOTTOM_HEIGHT   0.5


#define SYSTEM_STATUS_BAR_HEIGHT   20


#define COMMUNICATE_PROPERTY_CELL_HEIGHT    45
#define COMMUNICATE_PROPERTY_CELL_FOOTER_HEIGHT    20

#define COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_MAX_COLUMN_COUNT 4
#define COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_WIDTH   61.5
#define COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_HEIGHT   (COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_WIDTH + 20)


#pragma mark - local user default storage
#define USER_ID_LOCAL_KEY               @"USER_ID_LOCAL_KEY"
#define USER_NAME_LOCAL_KEY             @"USER_NAME_LOCAL_KEY"
#define USER_EMAIL_LOCAL_KEY            @"USER_EMAIL_LOCAL_KEY"
#define USER_ACCESS_TOKEN_LOCAL_KEY     @"USER_ACCESS_TOKEN_LOCAL_KEY"
#define SYSTEM_LANGUAGE_LOCAL_KEY       @"SYSTEM_LANGUAGE_LOCAL_KEY"
#define USER_CITY_ID_LOCAL_KEY          @"USER_CITY_ID_LOCAL_KEY"
#define USER_CITY_NAME_LOCAL_KEY        @"USER_CITY_NAME_LOCAL_KEY"
#define USER_COUNTRY_ID_LOCAL_KEY       @"USER_COUNTRY_ID_LOCAL_KEY"
#define USER_COUNTRY_NAME_LOCAL_KEY     @"USER_COUNTRY_NAME_LOCAL_KEY"
#define FONT_SIZE_LOCAL_KEY             @"FONT_SIZE_LOCAL_KEY"
#define HOST_LOCAL_KEY                  @"HOST_LOCAL_KEY"
#define HOMEPAGE_HANDY_NOTIFY_LOCAL_KEY @"HOMEPAGE_HANDY_NOTIFY_LOCAL_KEY"
#define NEWS_FAV_HANDY_NOTIFY_LOCAL_KEY @"NEWS_FAV_HANDY_NOTIFY_LOCAL_KEY"
#define SWIPE_HANDY_NOTIFY_LOCAL_KEY    @"SWIPE_HANDY_NOTIFY_LOCAL_KEY"
#define LOADING_NOTIFY_LOCAL_KEY        @"LOADING_NOTIFY_LOCAL_KEY"
#define REFRESH_NEARBY_NOTIFY           @"REFRESH_NEARBY_NOTIFY"

#define KEY_PROPERTY_CONTENT_TYPE_TITLE @"contentTitle"
#define KEY_PROPERTY_CONTENT_TYPE_VALUE @"contentVale"
#define KEY_PROPERTY_CONTENT_TYPE_TYPE  @"contentType"
#define KEY_PROPERTY_CONTENT_TYPE_SEL  @"contentSEL"
#define KEY_PROPERTY_CONTENT_TYPE_TARGET  @"contentTarget"

#define PROPERTY_TYPE_BUTTON    @"1"
#define PROPERTY_TYPE_TEXT      @"2"

#pragma mark - notification names
#define REFRESH_SESSION_NOTIFY          @"REFRESH_SESSION_NOTIFY"
#define REDO_REQUEST_NOTIFY             @"REDO_REQUEST_NOTIFY"
#define SESSION_EXPIRED_URL_KEY         @"SESSION_EXPIRED_URL_KEY"
#define SESSION_EXPIRED_VIEW_KEY        @"SESSION_EXPIRED_VIEW_KEY"
#define SESSION_EXPIRED_TYPE_KEY        @"SESSION_EXPIRED_TYPE_KEY"
#define SESSION_ID_KEY                  @"SESSION_ID_KEY"

#pragma mark - session handler
#define SESSION_PREFIX                  @"<session_id>"
#define SESSION_SUFFIX                  @"</session_id>"
#define ALIPAY_MARK                     @"#Group/Detail"


#pragma mark - network
//  Publish
//#define HOST_TYPE                   12
//#define HOST_URL                    @"http://180.153.154.21:9000/"
//  Test
#define HOST_TYPE                   14
#define HOST_URL                    @"http://180.153.154.21:9007/"

#define ASSOCATION_API_URL       @"http://112.124.68.147:9004/Module/XieHuiBao/XieHuiBaoHandler.ashx"

//------------------------
#define APP_NAME                    @"Project"
#define SINGLE_LOGIN_APP_NAME       @"Project"
#define PLATFORM                    @"iPhone"
#define APP_ID                      @"Project"
#define LOG                         @"log"

// AiLiaoKey
#if APP_TYPE == APP_TYPE_EMBA
    #define APP_KEY                     @"2740e59e-bbcf-11e3-a1a7-00163e0028ea"
#elif APP_TYPE == APP_TYPE_CIO //CIO
    #define APP_KEY                     @"352e736a-4120-11e3-8165-ab3a22f97e8b"
#elif APP_TYPE == APP_TYPE_O2O //O2O
    #define APP_KEY                     @"448dd89e-686a-11e3-a1a7-00163e0028ea"
#endif

#pragma mark - invoketype

#define INVOKETYPE_LOOKUSERINFO  1
#define INVOKETYPE_EDITUSERINFO  2
#define INVOKETYPE_SEARCHUSER    3
#define INVOKETYPE_SAVEUSERINFO  4
#define INVOKETYPE_ALLUSERINFO   5

#pragma mark - controlType

#define CONTROLTYPE_TEXT        1
#define CONTROLTYPE_MTEXT       2
#define CONTROLTYPE_DROPLIST    3
#define CONTROLTYPE_IMAGE       4

#pragma mark - imageType

#define IMAGETYPE_INFORMATION       1
#define IMAGETYPE_EVENT             2
#define IMAGETYPE_TRAIN             3
#define IMAGETYPE_PROJECT_THUMBNAIL 4
#define IMAGETYPE_PROJECT_ORIGINAL  5

#pragma mark - informationtype

#define INFORMATION_TYPE_NEWS_INFOTMATION        1
#define INFORMATION_TYPE_ALONE_MARKETING         2
#define INFORMATION_TYPE_BUSINESS                3
#define INFORMATION_TYPE_RECOMMEND_BOOK          4

#pragma mark - eventsType

#define EVENTS_TYPE_PRE  0 //预告
#define EVENTS_TYPE_REV  1 //回顾
#define EVENTS_TYPE_ALL  2 //全部


#define GROUP_PROPERTY_MAX_COUNT_NAME   20
#define GROUP_PROPERTY_MAX_COUNT_BRIEF  200
#define GROUP_PROPERTY_MAX_COUNT_PHONE  15
#define GROUP_PROPERTY_MAX_COUNT_EMAIL  40
#define GROUP_PROPERTY_MAX_COUNT_WEBSITE    20

#pragma MARK - categoryType

#define CATEGORY_TYPE_ALONE_MARKETING   2
#define CATEGORY_TYPE_BUSINESS          3

#define USE_ASIHTTP 0

#define ImageWithName(string) [UIImage imageNamed:string]

#define NUMBER(__OBJ) [NSNumber numberWithInt:__OBJ]
#define NUMBER_LONG(__OBJ) [NSNumber numberWithLong:__OBJ]
#define NUMBER_DOUBLE(__OBJ) [NSNumber numberWithDouble:__OBJ]

@interface GlobalConstants : NSObject {
    
}

@end