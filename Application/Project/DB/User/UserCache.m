//
//  UserCache.m
//  Project
//
//  Created by Peter on 13-11-5.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "UserCache.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"
#import "ChatModel.h"
#import "GlobalConstants.h"
#import "FirendUserListDataModal.h"

@implementation UserCache

#pragma mark - life cycle methods
- (id)init {
	self = [super init];
    
    return self;
}

- (BOOL)isUserExistOfUserId:(NSString*)userId{
    BOOL isExist = NO;
    @try
    {
        const char *sqlString = "select count(*) from user where userId = ?";
        static WXWStatement * queryStmt = nil;
        if (nil == queryStmt)
        {
            queryStmt = [WXWDBConnection statementWithQuery:sqlString];
            [queryStmt retain];
        }
        [queryStmt bindString:userId forIndex:1];
        if (SQLITE_ROW == [queryStmt step])
        {
            NSInteger count = [queryStmt getInt32:0];
            if (count > 0)
            {
                isExist = YES;
            }
        }
        [queryStmt reset];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception name=%@",exception.name);
        NSLog(@"Exception reason=%@",exception.reason);
    }
    @finally
    {
        return isExist;
    }
}

- (void)insertOrUpdateUserInfos:(UserObject *)userObject{
    @try
    {
        [WXWDBConnection beginTransaction];
//        for (UserObject *userObject in userInfos)
        {
            if ([self isUserExistOfUserId:userObject.userId])
            {
                [self updateUserObjectDB:userObject];
            }
            else
            {
                [self insertUserObjectDB:userObject];
            }
        }
        [WXWDBConnection commitTransaction];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception name=%@", exception.name);
        NSLog(@"Exception reason=%@", exception.reason);
    }
    @finally
    {
    }
}

- (void)insertUserObjectDB:(UserObject *)userInfo
{
    WXWStatement *inserStmt = nil;
    
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO user VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    
	[inserStmt bindString:userInfo.userId forIndex:1];
	[inserStmt bindString:userInfo.userName forIndex:2];
	[inserStmt bindString:userInfo.userNameEn forIndex:3];
	[inserStmt bindString:userInfo.chatId forIndex:4];
	[inserStmt bindString:userInfo.customerId forIndex:5];
	[inserStmt bindString:userInfo.userImageUrl forIndex:6];
    [inserStmt bindString:userInfo.userTel forIndex:7];
	[inserStmt bindString:userInfo.userEmail forIndex:8];
	[inserStmt bindString:userInfo.userStatus forIndex:9];
    [inserStmt bindString:userInfo.userCode forIndex:10];
    [inserStmt bindString:userInfo.groupId forIndex:11];
    [inserStmt bindString:userInfo.userDept forIndex:12];
    [inserStmt bindString:userInfo.userTitle forIndex:13];
    [inserStmt bindString:userInfo.userRole forIndex:14];
    [inserStmt bindInt32:userInfo.isFriend forIndex:15];
    [inserStmt bindInt32:userInfo.isDelete forIndex:16];
    [inserStmt bindInt32:userInfo.userGender forIndex:17];
    [inserStmt bindString:userInfo.userCellphone forIndex:18];
    [inserStmt bindString:userInfo.userBirthDay forIndex:19];
    [inserStmt bindString:userInfo.superName forIndex:20];
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    [inserStmt release];
}

- (BOOL)updateUserObjectDB:(UserObject *)userInfo
{
    @try {
        WXWStatement *updateStmt = nil;
        
        if (updateStmt == nil) {
            updateStmt = [WXWDBConnection statementWithQuery:"update user set userId=?,userName=?,userNameEn=?,chatId=?,customerId=?,userImageUrl=?,userTel=?,userEmail=?,userStatus=?,userCode=?,groupId=?,userDept=?,userTitle=?,userRole=?,isFriend=?,isDelete =?,userGender =?,userCellphone =?, userBirthDay =?,superName =? where userId = ?"];
            [updateStmt retain];
        }
        
        [updateStmt bindString:userInfo.userId forIndex:1];
        [updateStmt bindString:userInfo.userName forIndex:2];
        [updateStmt bindString:userInfo.userNameEn forIndex:3];
        [updateStmt bindString:userInfo.chatId forIndex:4];
        [updateStmt bindString:userInfo.customerId forIndex:5];
        [updateStmt bindString:userInfo.userImageUrl forIndex:6];
        [updateStmt bindString:userInfo.userTel forIndex:7];
        [updateStmt bindString:userInfo.userEmail forIndex:8];
        [updateStmt bindString:userInfo.userStatus forIndex:9];
        [updateStmt bindString:userInfo.userCode forIndex:10];
        [updateStmt bindString:userInfo.groupId forIndex:11];
        [updateStmt bindString:userInfo.userDept forIndex:12];
        [updateStmt bindString:userInfo.userTitle forIndex:13];
        [updateStmt bindString:userInfo.userRole forIndex:14];
        [updateStmt bindInt32:userInfo.isFriend forIndex:15];
        [updateStmt bindInt32:userInfo.isDelete forIndex:16];
        [updateStmt bindInt32:userInfo.userGender forIndex:17];
        [updateStmt bindString:userInfo.userCellphone forIndex:18];
        [updateStmt bindString:userInfo.userBirthDay forIndex:19];
        [updateStmt bindString:userInfo.superName forIndex:20];
        [updateStmt bindString:userInfo.userId forIndex:21];
        
        if ([updateStmt step] == SQLITE_ROW) {
        }
        
        [updateStmt reset];
        [updateStmt release];
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception name=%@",exception.name);
        NSLog(@"Exception reason=%@",exception.reason);
    }
    @finally {
    }
    return NO;
}

- (BOOL)isChatUserExistOfUserId:(UserObject *)userInfo
{
    BOOL isExist = NO;
    @try
    {
        const char *sqlString = "select count(*) from chat_group_user where groupId=? and userId = ? and chatId=?";
        static WXWStatement * queryStmt = nil;
        if (nil == queryStmt)
        {
            queryStmt = [WXWDBConnection statementWithQuery:sqlString];
            [queryStmt retain];
        }
        
        [queryStmt bindString:userInfo.groupId forIndex:1];
        [queryStmt bindString:userInfo.userId forIndex:2];
        [queryStmt bindString:userInfo.chatId forIndex:3];
        
        if (SQLITE_ROW == [queryStmt step])
        {
            NSInteger count = [queryStmt getInt32:0];
            if (count > 0)
            {
                isExist = YES;
            }
        }
        [queryStmt reset];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception name=%@",exception.name);
        NSLog(@"Exception reason=%@",exception.reason);
    }
    @finally
    {
        return isExist;
    }
}

- (void)insertChatUserObjectDB:(UserObject *)userInfo
{
    WXWStatement *inserStmt = nil;
    
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO chat_group_user VALUES(?,?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    
	[inserStmt bindString:userInfo.groupId forIndex:1];
	[inserStmt bindString:userInfo.userId forIndex:2];
	[inserStmt bindString:userInfo.chatId forIndex:3];
	[inserStmt bindString:userInfo.userName forIndex:4];
	[inserStmt bindString:userInfo.userNameEn forIndex:5];
	[inserStmt bindString:userInfo.customerId forIndex:6];
    [inserStmt bindString:userInfo.userImageUrl forIndex:7];
	[inserStmt bindString:userInfo.userCode forIndex:8];
    [inserStmt bindInt32:userInfo.isDelete forIndex:9];
    
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    [inserStmt release];
}

- (BOOL)updateChatUserObjectDB:(UserObject *)userInfo
{
    @try {
        WXWStatement *queryStmt = nil;
        
        if (queryStmt == nil) {
            queryStmt = [WXWDBConnection statementWithQuery:"update chat_group_user set groupId=?, userId=?,chatId=?,userName=?,userNameEn=?,customerId=?,userImageUrl=?,userCode=?,isDelete =? where groupId=? and userId = ? and chatId=?"];
            [queryStmt retain];
        }
        
        [queryStmt bindString:userInfo.groupId forIndex:1];
        [queryStmt bindString:userInfo.userId forIndex:2];
        [queryStmt bindString:userInfo.chatId forIndex:3];
        [queryStmt bindString:userInfo.userName forIndex:4];
        [queryStmt bindString:userInfo.userNameEn forIndex:5];
        [queryStmt bindString:userInfo.customerId forIndex:6];
        [queryStmt bindString:userInfo.userImageUrl forIndex:7];
        [queryStmt bindString:userInfo.userCode forIndex:8];
        [queryStmt bindInt32:userInfo.isDelete forIndex:9];
        [queryStmt bindString:userInfo.groupId forIndex:10];
        [queryStmt bindString:userInfo.userId forIndex:11];
        [queryStmt bindString:userInfo.chatId forIndex:12];
        
        if ([queryStmt step] == SQLITE_ROW) {
        }
        
        [queryStmt reset];
        [queryStmt release];
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception name=%@",exception.name);
        NSLog(@"Exception reason=%@",exception.reason);
    }
    @finally {
    }
    return NO;
}

- (void)insertOrUpdateChatGroupUserInfos:(UserObject*)userObject
{
    @try
    {
        [WXWDBConnection beginTransaction];
        //        for (UserObject *userObject in userInfos)
        {
            if ([self isChatUserExistOfUserId:userObject])
            {
                [self updateChatUserObjectDB:userObject];
            }
            else
            {
                [self insertChatUserObjectDB:userObject];
            }
        }
        [WXWDBConnection commitTransaction];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception name=%@", exception.name);
        NSLog(@"Exception reason=%@", exception.reason);
    }
    @finally
    {
    }
}

//TODO delete

- (void)insertUserObjectDB:(UserObject *)userInfo timestamp:(double)timestamp
{}

/*
 userId integer ,
 groupId TEXT,
 displayIndex integer,
 propName TEXT,
 propValue TEXT,
 isFriend integer,
 isDelete integer,
 */
- (void)upinsertUserProfile:(int)userId groupId:(int)groupId displayIndex:(int)displayIndex propName:(NSString *)propName propValue:(NSString *)propValue isFriend:(int)isFriend isDelete:(int)isDelete
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO userProfile VALUES(?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    DLog(@"displayIndex:%d", displayIndex);
	[inserStmt bindInt32:userId forIndex:1];
	[inserStmt bindInt32:groupId forIndex:2];
	[inserStmt bindInt32:displayIndex forIndex:3];
	[inserStmt bindString:propName forIndex:4];
	[inserStmt bindString:propValue forIndex:5];
	[inserStmt bindInt32:isFriend forIndex:6];
	[inserStmt bindInt32:isDelete forIndex:7];
    
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    [inserStmt release];
}

- (void)upinsertUserProfile:(UserProfile *)userProfile
{
    int userId = userProfile.userID;
    int isFriend = userProfile.isFriend;
    for (int i = 0; i < userProfile.propertyGroups.count; ++i) {
        
        PropertyGroup *pg = (PropertyGroup *)userProfile.propertyGroups[i];
        
        int groupId = pg.propertyGroupID;
        
        for (int j = 0; j < pg.propertyLists.count; j++) {
            
            PropertyList *pl = (PropertyList *)pg.propertyLists[j];
            
            NSString *value = @"";
            if (pl.controlType == CONTROLTYPE_DROPLIST) {
                
                for (int ii = 0; ii < pl.optionLists.count; ii++) {
                    
                    OptionList *opl = pl.optionLists[ii];
                    
                    if ([pl.propertyValue isEqualToString:[NSString stringWithFormat:@"%d",opl.optionLookupID]]) {
                        //                        [up.values addObject:opl.optionValue];
                        value = opl.optionValue;
                    }
                }
            }else {
                value = pl.propertyValue;
            }
            DLog(@"name:%@  value:%@", pl.propertyName, value);
            
            [self upinsertUserProfile:userId groupId:groupId displayIndex:pl.displayIndex propName:pl.propertyName propValue:value isFriend:isFriend isDelete:0];
        }
    }
}


/*
 userId integer ,
 groupId integer,
 displayIndex integer,
 propName TEXT,
 propValue TEXT,
 isFriend integer,
 isDelete integer,
 */
- (UserDBProperty *)parseUserProperty:(WXWStatement *)queryStmt
{
    UserDBProperty *userDBprop =  [[[UserDBProperty alloc] init] autorelease];
    
    userDBprop.userId = [NUMBER([queryStmt getInt32:0]) integerValue];
    userDBprop.groupId = [NUMBER([queryStmt getInt32:1]) integerValue];
    userDBprop.displayIndex = [NUMBER([queryStmt getInt32:2]) integerValue];
    userDBprop.propName = [queryStmt getString:3];
    userDBprop.propValue = [queryStmt getString:4];
    userDBprop.isFriend =  [NUMBER([queryStmt getInt32:5]) integerValue];
    userDBprop.isDelete =  [NUMBER([queryStmt getInt32:6]) integerValue];
    
    return userDBprop;
}

- (NSMutableArray *)getUserPropertiesByUserId:(int)userId
{
    WXWStatement *queryStmt = nil;
    NSMutableArray *userPropArray = [[[NSMutableArray alloc] init] autorelease];
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from userProfile where userId=? order by displayIndex"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:userId forIndex:1];
    
    while ([queryStmt step] != SQLITE_DONE) {
        [userPropArray addObject:[self parseUserProperty:queryStmt]];
    }
    [queryStmt release];
    return  userPropArray;
}

- (NSMutableArray *)getUserPropertiesByUserId:(int)userId groupId:(int)groupId
{
    WXWStatement *queryStmt = nil;
    NSMutableArray *userPropArray = [[[NSMutableArray alloc] init] autorelease];
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from userProfile where userId=? and groupId = ? order by displayIndex"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:userId forIndex:1];
	[queryStmt bindInt32:groupId forIndex:2];
    
    while ([queryStmt step] != SQLITE_DONE) {
        [userPropArray addObject:[self parseUserProperty:queryStmt]];
    }
    [queryStmt release];
    return  userPropArray;
}

- (int)getGroupCountByUserId:(int)userId
{
    WXWStatement *queryStmt = nil;
    
    int count=0;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select count(distinct groupId) from userProfile where  userId = ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:userId forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER([queryStmt getInt32:0]) integerValue];
	}
    
	[queryStmt reset];
    
    [queryStmt release];
    return count;
}

- (int)allUserCount
{
    WXWStatement *queryStmt = nil;
    
    int userCount = 0;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select count(*) from user where isDelete != ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:1 forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
        userCount = [NUMBER([queryStmt getInt32:0]) integerValue];
	}
    
	[queryStmt reset];
    
    [queryStmt release];
    return userCount;
}

- (int)isFriend:(int)userId
{
    WXWStatement *queryStmt = nil;
    
    int isFriend=0;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select isFriend from user where userId = ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:userId forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
        isFriend = [NUMBER([queryStmt getInt32:0]) integerValue];
	}
    
	[queryStmt reset];
    
    [queryStmt release];
    return isFriend;
}

- (void)updateIsFriend:(NSArray *)array
{
    
    WXWStatement *queryStmt = nil;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"update user set isFriend = 1 where userId = ?"];
		[queryStmt retain];
	}
    
    for (int i = 0; i < array.count; ++i) {
        FirendUserListDataModal *model = [array objectAtIndex:i];
        
        [queryStmt bindInt32:[model.userId integerValue] forIndex:1];
        if ([queryStmt step] == SQLITE_ROW) {
        }
        
        [queryStmt reset];
    }
    
    [queryStmt release];
}

-(void)updateIsFriendWithId:(NSString *)userId isFriend:(BOOL)isFriend
{
    WXWStatement *queryStmt = nil;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"update user set  isFriend = ? where userId = ?"];
		[queryStmt retain];
	}
    
    [queryStmt bindInt32:isFriend forIndex:1 ];
    [queryStmt bindInt32:[userId integerValue] forIndex:2];
    if ([queryStmt step] == SQLITE_ROW) {
    }
    
    [queryStmt reset];
    [queryStmt release];
}

- (UserObject *)getUserInfoByUserIdFromDB:(NSString *)userId
{
    WXWStatement *queryStmt = nil;
    
    UserObject *baseInfo = nil;
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from user where userId = ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindString:userId forIndex:1];
    if ([queryStmt step] == SQLITE_ROW) {
        baseInfo = [[self parseUserBaseInfo:queryStmt] retain];
	}
    
	[queryStmt reset];
    [queryStmt release];
    return baseInfo;
}

- (UserObject *)getUserInfoByVoipIdFromDB:(NSString*)userChatId
{
    WXWStatement *queryStmt = nil;
    
    UserObject *baseInfo = nil;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from user where chatId = ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindString:userChatId forIndex:1];
    if ([queryStmt step] == SQLITE_ROW) {
        baseInfo = [[self parseUserBaseInfo:queryStmt] retain];
	}
    
	[queryStmt reset];
    [queryStmt release];
    return baseInfo;
}

- (UserObject *)parseUserBaseInfo:(WXWStatement *)queryStmt
{
    UserObject *userObject = [[[UserObject alloc] init] autorelease];
    
    userObject.userId = [queryStmt getString:0];
    userObject.userName = [queryStmt getString:1];
    userObject.userNameEn = [queryStmt getString:2];
    userObject.chatId = [queryStmt getString:3];
    userObject.customerId = [queryStmt getString:4];
    userObject.userImageUrl = [queryStmt getString:5];
    userObject.userTel = [queryStmt getString:6];
    userObject.userEmail = [queryStmt getString:7];
    userObject.userStatus = [queryStmt getString:8];
    userObject.userCode = [queryStmt getString:9];
    userObject.groupId = [queryStmt getString:10]; //
    userObject.userDept = [queryStmt getString:11]; // 部门
    userObject.userTitle = [queryStmt getString:12]; // 头衔
    userObject.userRole = [queryStmt getString:13]; // 角色
    userObject.isFriend = [queryStmt getInt32:14];
    userObject.isDelete = [queryStmt getInt32:15];
    userObject.userGender = [queryStmt getInt32:16];
    
    return userObject;
}

- (NSMutableArray *)getAllUserInfoFromDB
{
    WXWStatement *queryStmt = nil;
    NSMutableArray *userarray = [NSMutableArray array];
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from user where isdelete != 1"];
		[queryStmt retain];
	}
    
    while ([queryStmt step] != SQLITE_DONE) {
        [userarray addObject:[self parseUserBaseInfo:queryStmt]];
    }
    
    [queryStmt release];
    return  userarray;
}

- (NSMutableArray *)getUserInfoWithKeyword:(NSString *)keyword {
    WXWStatement *queryStmt = nil;
    NSMutableArray *userarray = [NSMutableArray array];
    
    if (queryStmt == nil) {
        NSString *queryStr = [NSString stringWithFormat:@"select * from user where userName like '%%%@%%' or userNameEn like '%%%@%%'", keyword, keyword];
        queryStmt = [WXWDBConnection statementWithQuery:[queryStr UTF8String]];
        
		[queryStmt retain];
	}
    
    while ([queryStmt step] != SQLITE_DONE) {
        [userarray addObject:[self parseUserBaseInfo:queryStmt]];
    }
    
    [queryStmt release];
    return  userarray;
}

-(double)getLatestUserTimestamp
{
    //    WXWStatement *queryStmt = nil;
    //
    //    double count=0;
    //
    //	if (queryStmt == nil) {
    //		queryStmt = [WXWDBConnection statementWithQuery:"select timestamp from user order by timestamp desc limit 1"];
    //		[queryStmt retain];
    //	}
    //
    //    if ([queryStmt step] == SQLITE_ROW) {
    //        count = [NUMBER_DOUBLE([queryStmt getDouble:0]) doubleValue];
    //	}
    //
    //	[queryStmt reset];
    //    [queryStmt release];
    //
    //    return count;
    return 0;
}

#pragma mark - WXWConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
    
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
}

@end