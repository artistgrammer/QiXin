
/*!
 @header AppManager.h
 @abstract 系统内存
 @author Adam
 @version 1.00 2014/03/26 Creation
 */

#import <Foundation/Foundation.h>
#import "UserHeader.h"
#import "ProjectUserDefaults.h"
#import "AppSystemDelegate.h"

@interface AppManager : NSObject {
    
    id<AppSettingDelegate>_settingDelegate;
    BOOL _reloadDataForLanguageSwitch;
    
    NSMutableArray *visiblePopTipViews;
    NSString *chartContent;
}

@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userChatId;
@property (nonatomic, copy) NSString *userChatPwd;
@property (nonatomic, copy) NSString *userChatAccountId;
@property (nonatomic, copy) NSString *userChatToken;

@property (nonatomic, copy) NSString *userType;
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *customerID;
@property (nonatomic, copy) NSString *vipID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userTitle;
@property (nonatomic, copy) NSString *userDept;

@property (nonatomic, copy) NSString *userImageUrl;

@property (nonatomic, copy) NSString *isLoginLicall;
@property (nonatomic, retain) NSMutableDictionary *common;
@property (nonatomic, retain) NSMutableDictionary *commonUsedDic;
@property (nonatomic, copy) NSString *passwd;
@property (nonatomic, copy) NSString *hostUrl;
@property (nonatomic, retain) NSString *updateURL;
@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, assign) int isMandatory;
@property (nonatomic, assign) NSString *recommend;
@property (nonatomic, assign) NSInteger vipType;


@property (nonatomic, retain) UserDataManager *userDM;

@property (nonatomic, retain) NSMutableArray *visiblePopTipViews;
@property (nonatomic, copy) NSString *chartContent;

@property (nonatomic, assign) NSDictionary *bundleDict;

@property (nonatomic, assign) ProjectUserDefaults *userDefaults;

// TODO only for Test
@property (nonatomic, retain) NSMutableDictionary *chatUserDict;

@property (nonatomic, assign) long long int lastUpdateUserMsgTime;

+ (AppManager *)instance;

- (void)prepareData;
- (void)initUserDefaults;

- (NSMutableDictionary *)specialWithInvokeType:(int)type;
- (NSMutableDictionary *)specialWithInvokeType:(int)type specifieduserID:(int)userId;

- (void) updateLoginSuccess:(NSDictionary *)dict;

- (void)exchangeRuleToExpert;
- (void)exchangeRuleToDaPeople;

//Language
- (void)reloadForLanguageSwitch:(id<AppSettingDelegate>)settingDelegate;

@end
