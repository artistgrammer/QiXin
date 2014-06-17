//
//  ProjectAPI.m
//  Project
//
//  Created by Peter on 13-10-22.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ProjectAPI.h"
#import "JSONKit.h"
#import "CommonMethod.h"
#import "WXWCommonUtils.h"

@implementation ProjectAPI {
    NSDictionary *_common;
}

static ProjectAPI *instance = nil;

+ (ProjectAPI *)getInstance {
    
    @synchronized(self) {
        if(instance == nil)
            instance = [[super allocWithZone:NULL] init];
    }
    
    return instance;
}


- (void)setCommon:(NSDictionary *)common
{
    _common = [common retain];
}

- (NSDictionary *)getCommon
{
    return _common;
}

+ (NSString *)getPostUrl:(NSString *)apiName reqContentDict:(NSDictionary *)reqContentDict
{
    return [NSString stringWithFormat:@"%@?Action=%@&ReqContent=%@", ASSOCATION_API_URL, apiName, [reqContentDict JSONString]];
}

+ (NSString *)getURL:(NSString *)apiName specialDict:(NSDictionary *)specialDict
{
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    if (specialDict != nil) {
        [requestDict setObject:specialDict forKey:@"Parameters"];
    }
    [requestDict setObject:[AppManager instance].userId forKey:@"UserID"];
    [requestDict setObject:[AppManager instance].userChatAccountId forKey:@"SubAccountSid"];
    [requestDict setObject:[AppManager instance].userChatToken forKey:@"SubToken"];
    [requestDict setObject:@"e703dbedadd943abacf864531decdac1" forKey:@"CustomerID"];
    [requestDict setObject:CURRENT_OS_VERSION_SHOW forKey:@"OsInfo"];
    // 默认为中文（值为1）
    [requestDict setObject:@"1" forKey:@"Locale"];
    // 发布渠道[企业发布 0, AppStore 1]
    [requestDict setObject:@"0" forKey:@"Channel"];
    [requestDict setObject:VERSION forKey:@"Version"];
    [requestDict setObject:PLATFORM forKey:@"Plat"];
    
    if (![IPHONE_SIMULATOR isEqualToString:[WXWCommonUtils deviceModel]])
        [requestDict setObject:[AppManager instance].deviceToken forKey:@"Token"];

    return [NSString stringWithFormat:@"%@&req=%@%@", apiName, [requestDict JSONString], API_SERVICE_EXTEND];
}

+ (NSString *)getRequestURL:(NSString *)apiServiceName withApiName:(NSString *)apiName withCommon:(NSDictionary *)commonDict withSpecial:(NSMutableDictionary *)specialDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    
    NSString *apiPrefix = [specialDict objectForKey:KEY_API_PREFIX];
    [specialDict removeObjectForKey:KEY_API_PREFIX];
    
    NSString *apiContent = [specialDict objectForKey:KEY_API_CONTENT];
    [specialDict removeObjectForKey:KEY_API_CONTENT];
    
    NSString *urlString = @"";
        if (dict.count > 1) {
        urlString = [NSString stringWithFormat:apiContent,apiPrefix,apiServiceName,apiName, [dict JSONString]];
    }else {
        urlString = [NSString stringWithFormat:apiContent,apiPrefix,apiServiceName,apiName];
    }
    DLog(@"requstURL:%@", urlString);

    return urlString;
}

+ (NSString *)loadUserSearchHTML5ViewWithParam:(NSDictionary *)dict {
    
    return [NSString stringWithFormat:@"%@/%@%@",VALUE_API_PREFIX, KEY_GETUSERSEARCH_HTML5_URL,[CommonMethod encodeURLWithURL:[dict JSONString]]];
}

+ (NSString *)loadUserInfoCanEditHTML5VuewWithParam:(NSDictionary *)dict {
    return [NSString stringWithFormat:@"%@/%@%@&appname=SAVE&specifiedUserID=5", VALUE_API_PREFIX,KEY_GETUSERSEARCH_HTML5_URL, [CommonMethod encodeURLWithURL:[dict JSONString]]];
}

- (void)switchSkin:(int)type
{   
    [[ThemeManager shareInstance] setThemeNameIndex:type];
}

@end
