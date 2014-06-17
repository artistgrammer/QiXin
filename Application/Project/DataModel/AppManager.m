
#import "AppManager.h"
#import "GlobalConstants.h"
#import "ProjectAPI.h"
#import "CommonUtils.h"
#import "ProjectAPI.h"

@implementation AppManager {
}

@synthesize hostUrl = _hostUrl;
// Delete
@synthesize common = _common;
@synthesize commonUsedDic = _commonUsedDic;
@synthesize sessionId = _sessionId;

@synthesize clientID = _clientID;
@synthesize isLoginLicall = _isLoginLicall;
@synthesize userId = _userId;
@synthesize userType = _userType;
@synthesize userName;
@synthesize userTitle;
@synthesize userDept;
@synthesize userImageUrl;
@synthesize updateURL = _updateURL;
@synthesize deviceToken = _deviceToken;
@synthesize isMandatory = _isMandatory;
@synthesize userChatId;
@synthesize userChatPwd;
@synthesize userChatAccountId;
@synthesize userChatToken;

@synthesize visiblePopTipViews;
@synthesize chartContent;

@synthesize userDefaults = _userDefaults;

@synthesize bundleDict = _bundleDict;
@synthesize recommend = _recommend;

@synthesize chatUserDict;

@synthesize lastUpdateUserMsgTime;

static AppManager *shareInstance = nil;

+ (AppManager *)instance {
    @synchronized(self) {
        if (nil == shareInstance) {
            shareInstance = [[self alloc] init];
            
            shareInstance.visiblePopTipViews = [[NSMutableArray alloc] init];
        }
    }
    
    return shareInstance;
}

- (void)prepareData
{
    [self initTheme];
    [self initCommon];
    [self initUser];
    [self initUserDM];
    [self initUserDefaults];
    [self initBundleIdentifier];
    [self initCommonData];
}

- (void)initTheme {
    
    [ThemeManager shareInstance].themeValues = [NSArray arrayWithObjects:@"", @"Skins/Blue", @"Skins/Orange", nil];
    [ThemeManager shareInstance].themeNames = [NSArray arrayWithObjects:@"默认", @"天蓝色", @"桔黄色", nil];
}

- (void)initUser {
    
    [AppManager instance].sessionId = @"";
    [AppManager instance].userType = @"1";
    [AppManager instance].userId = @"-1";
    [AppManager instance].userName = @"我";
    [AppManager instance].userChatAccountId = @"";
    [AppManager instance].userChatToken = @"";
    [AppManager instance].userImageUrl = @"";
    
    int themeIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kThemeName];
    [[ProjectAPI getInstance] switchSkin:themeIndex];
}

- (void)initUserDM {
    _userDM = [UserDataManager defaultManager];
}

- (void)initUserDefaults
{
    _userDefaults = [[ProjectUserDefaults alloc] init];
}

//---------------------------common---

#pragma mark - language switch
- (void)userMetaDataLoaded {
    
    if (_settingDelegate) {
        [_settingDelegate languageSwitchDone];
        _settingDelegate = nil;
    }
    
    _reloadDataForLanguageSwitch = NO;
}

- (void)reloadForLanguageSwitch:(id<AppSettingDelegate>)settingDelegate {
    
    _settingDelegate = settingDelegate;
    _reloadDataForLanguageSwitch = YES;
    
    [self userMetaDataLoaded];
}

- (void)initCommon
{
    [AppManager instance].deviceToken = @"";
    
    _commonUsedDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [_commonUsedDic setObject:@"" forKey:@"openId"];
    [_commonUsedDic setObject:CUSTOMER_ID forKey:@"customerId"];
    [_commonUsedDic setObject:@"" forKey:@"userId"];
    [_commonUsedDic setObject:@"" forKey:@"locale"];
    [_commonUsedDic setObject:@"" forKey:@"roleId"];
    
    _common = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                   @"2",@"channel",
                   @"zh",@"locale",
                   @"6.1",@"osInfo",
                   @"0", @"clientId",
                   @"iPhone",@"plat",
                   @"0", @"userId",
                   @"",@"sessionId",
                   //[AppManager instance].userId,@"userId",
               VERSION,@"version",
               [AppManager instance].deviceToken,@"deviceToken",
                   nil];
    
    self.customerID = @"29E11BDC6DAC439896958CC6866FF64E";
    self.vipID = @"0803118E474E4D60B9A57FB943C147F5";
    self.vipType = 1;
    
    /* vipid
     0803118E474E4D60B9A57FB943C147F5  zj--专家
     C4B5DAAB97804642A608E72EAE09BA83  kf--客服
     2FD5281BC97C4E8F862D52502E037C18  dr--达人
     */
}

- (void)exchangeRuleToDaPeople {
    self.vipID = @"2FD5281BC97C4E8F862D52502E037C18";
    self.vipType = 3;
    DLog(@"viptype---------------------- %d",self.vipType);
}

- (void)exchangeRuleToExpert {
    self.vipID = @"0803118E474E4D60B9A57FB943C147F5";
    self.vipType = 1;
    DLog(@"viptype---------------------- %d",self.vipType);
}

- (void)initBundleIdentifier
{
    
    _bundleDict = [[NSBundle mainBundle] infoDictionary];
}

-(void)initCommonData
{
    _recommend = @"我正在使用CIO联盟官方 CIOUnion APP。通过该APP可以查询全体校友信息、摇出身边校友进行私聊以及发布和参与商业合作，推荐给您。点击下载：http://weixun.co/ceibs_download";
}

//--------------special-----------------------------------------

- (NSMutableDictionary *)specialWithInvokeType:(int)type {
    return [[[NSMutableDictionary alloc] initWithObjectsAndKeys:NUMBER(type),@"invokeType", nil] autorelease];
}

- (NSMutableDictionary *)specialWithInvokeType:(int)type specifieduserID:(int)userId {
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setObject:NUMBER(type) forKey:@"invokeType"];
    [dic setObject:NUMBER(userId) forKey:@"specifieduserID"];
    return dic;
}

- (void) saveHostUrlToLocal:(NSString*) url {
    
    [CommonUtils saveStringValueToLocal:url key:HOST_LOCAL_KEY];
}

- (void)updateLoginSuccess:(NSDictionary *)dict
{
    self.userId = [dict objectForKey:@"userId"];
    self.userType = [dict objectForKey:@"userType"];
    self.clientID = [dict objectForKey:@"clientID"];
    self.isLoginLicall = [dict objectForKey:@"isLoginLicall"];

    _common = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
               @"2",@"channel",
               @"zh",@"locale",
               @"6.1",@"osInfo",
               self.clientID, @"clientId",
               @"iPhone",@"plat",
               self.userId, @"userId",
               @"",@"sessionId",
               //[AppManager instance].userId,@"userId",
               VERSION,@"version",
              [AppManager instance].deviceToken,@"deviceToken",
               nil];
    
    [[ProjectAPI getInstance] setCommon:[AppManager instance].common];
}

@end
