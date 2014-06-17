//
//  ProjectDBManager.m
//  Project
//
//  Created by Peter on 13-11-6.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ProjectDBManager.h"
#import "EntityInstance.h"
#import "WXWCoreDataUtils.h"
#import "InformationImageWallCache.h"
#import "InformationListCache.h"
#import "AloneMarketingCache.h"
#import "CircleMarketingCahce.h"
#import "CommonTableCache.h"

@implementation ProjectDBManager {
    
    UserCache *_userCache;
    InformationImageWallCache *_informationImageWallCache;
    InformationListCache *_informationListCache;
    AloneMarketingCache *_aloneMarketingCache;
    CircleMarketingCahce *_circleMarketingCahce;
    CommunicateGroupListCache *_communicateGroupListCache;
    CommonTableCache *_commonTableCache;
}

static ProjectDBManager *instance = nil;

+ (ProjectDBManager *)instance {
    
    @synchronized(self) {
        if(instance == nil) {
            instance = [[super allocWithZone:NULL] init];
            [instance initData];
        }
    }
    
    return instance;
}

- (void)dealloc
{
    [_userCache release];
    [_informationImageWallCache release];
    [_informationListCache release];
    [_aloneMarketingCache release];
    [_circleMarketingCahce release];
    [_communicateGroupListCache release];
    [_commonTableCache release];
    
    [super dealloc];
}

//----------------init----------------------------------------------
- (void)initData
{
    _userCache = [[UserCache alloc] init];
    _informationImageWallCache = [[InformationImageWallCache alloc] init];
    _informationListCache = [[InformationListCache alloc]init];
    _aloneMarketingCache = [[AloneMarketingCache alloc] init];
    _circleMarketingCahce = [[CircleMarketingCahce alloc] init];
    _communicateGroupListCache = [[CommunicateGroupListCache alloc] init];
    _commonTableCache = [[CommonTableCache alloc] init];
}

- (int)getGroupIsDeleted:(NSString *)groupId
{
    return  [_communicateGroupListCache getGroupIsDeleted:groupId];
}

- (void)setGroupDeleted:(NSString *)groupId
{
    [_communicateGroupListCache deleteGroup:[groupId integerValue]];
}

//---------------------user---------------------------------------
- (void)insertUserObjectDB:(UserObject *)userInfo
{
    [_userCache insertUserObjectDB:userInfo];
}

- (UserObject *)getUserInfoByVoipIdFromDB:(NSString*)userChatId
{
    return [_userCache getUserInfoByVoipIdFromDB:userChatId];
}

- (void)insertOrUpdateUserInfos:(UserObject *)userInfo
{
    [_userCache insertOrUpdateUserInfos:userInfo];
}

- (void)insertOrUpdateChatGroupUserInfos:(UserObject *)userInfo
{
    [_userCache insertOrUpdateChatGroupUserInfos:userInfo];
}

//TODO Delete
- (void)insertUserObjectDB:(UserObject *)userInfo timestamp:(double)timestamp
{
//    [_userCache insertUserObjectDB:userInfo timestamp:timestamp];
}

- (void)upinsertUserProfile:(UserProfile *)userProfile
{
    [_userCache upinsertUserProfile:userProfile];
}

- (UserObject *)getUserInfoByUserIdFromDB:(NSString*)userId
{
    return [_userCache getUserInfoByUserIdFromDB:userId];
}

- (NSMutableArray *)getUserPropertiesByUserId:(int)userId
{
    return [_userCache getUserPropertiesByUserId:userId];
}


- (NSMutableArray *)getUserPropertiesByUserId:(int)userId groupId:(int)groupId
{
    return [_userCache getUserPropertiesByUserId:userId groupId:groupId];
}

- (int)getGroupCountByUserId:(int)userId
{
    return [_userCache getGroupCountByUserId:userId];
}

- (int)allUserCount
{
    return [_userCache allUserCount];
}

- (int)isFriend:(int)userId
{
//    return [_userCache isFriend:userId];
    return 0;
}

-(void)updateIsFriend:(NSArray *)array
{
    [_userCache updateIsFriend:array];
}

-(void)updateIsFriendWithId:(NSString *)userId isFriend:(BOOL)isFriend
{
    [_userCache updateIsFriendWithId:userId isFriend:isFriend] ;
}

- (NSMutableArray *)getAllUserInfoFromDB
{
    return [_userCache getAllUserInfoFromDB];
}

- (NSMutableArray *)getUserInfoWithKeyword:(NSString *)keyword {
    return [_userCache getUserInfoWithKeyword:keyword];
}

-(double)getLatestUserTimestamp
{
    return [_userCache getLatestUserTimestamp];
}

//----------------------------ChapterListInfo---------------
- (CourseDetailList *)getCourseDetailByCourseId:(int)courseId withCourseDetailList:(CourseDetailList *)detail
{
    //    CourseDetailList *detail = [_courseInfoCache getCourseDetailByCourseId:courseId];
    return nil;
}

//---------------information image wall
- (void)upinsertInfomationImageWall:(NSArray *)array timestamp:(double)timestamp
{
    [_informationImageWallCache upinsertInfomationImageWall:array timestamp:timestamp];
}


-(double)getLatestInfoImageWallTime
{
    return [_informationImageWallCache getLatestInfoImageWallTime];
}



//--------------information list
- (void)upinsertInfomationInfo:(NSArray *)array timestamp:(double)timestamp
{
    [_informationListCache upinsertInfomationInfo:array timestamp:timestamp];
}

-(double)getLatestInfomationTimestamp
{
    return [_informationListCache getLatestInfomationTimestamp];
}

-(double)getOldestInfomationTimestamp
{
    
    return [_informationListCache getOldestInfomationTimestamp];
}

-(void)deleteOldInfomationFromTimestamp:(NSString *)timestamp
{
    [_informationListCache deleteOldInfomationFromTimestamp:timestamp];
}


- (void)updateInformationCommentCount:(int)infoId count:(int)count
{
    [_informationListCache updateInformationCommentCount:infoId count:count];
}

-(void)updateInformationCommentReader:(int)infoId count:(int)count
{
    [_informationListCache updateInformationCommentReader:infoId count:count];
}


- (int)getInformationCommentCount:(int)infoId
{
    return [_informationListCache getInformationCommentCount:infoId];
}

-(int)getInformationCommentReader:(int)infoId
{
    return [_informationListCache getInformationCommentReader:infoId];
}

//---------------AloneMarketing
- (void)upinsertAloneMarketing:(NSArray *)array timestamp:(double)timestamp
{
    [_aloneMarketingCache upinsertAloneMarketing:array timestamp:timestamp];
}

-(double)getLatestAloneMarketingTime
{
    return [_aloneMarketingCache getLatestAloneMarketingTime];
}


//--------------Circlemarketing
- (void)upinsertCircleMarketing:(NSArray *)array timestamp:(double)timestamp
{
    [_circleMarketingCahce upinsertCircleMarketing:array timestamp:timestamp];
}

-(double)getLatestCircleMarketingTime:(int)type
{
    return [_circleMarketingCahce getLatestCircleMarketingTime:type];
}
//--------------communicate group list
-(void)upinsertCommunicateGroupList:(NSString *)userId array:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC
{
    [_communicateGroupListCache upinsertCommunicateGroupList:userId array:array timestamp:timestamp MOC:MOC];
}

-(double)getLatestCommunicateGroupListTime
{
    return [_communicateGroupListCache getLatestCommunicateGroupListTime];
}


-(void)deleteGroup:(int)groupId
{
    [_communicateGroupListCache deleteGroup:groupId];
}

-(void)deleteAllGroupListData
{
    [_communicateGroupListCache deleteAllGroupListData];
}
//--------------common table

- (void)upinsertCommonTable:(NSString *)key value:(NSString *)value {
    [_commonTableCache upinsertCommon:key value:value];
}

- (NSString*)getCommon:(NSString *)key
{
    return [_commonTableCache getCommon:key];
}

- (void)dropTables:(NSArray *)table {
    WXWStatement *dropStmt = nil;
    
    for (int i = 0; i < table.count; i++) {
        NSString *tableName = table[i];
        NSString *strSQL = [NSString  stringWithFormat:@"delete from %@", tableName];
        
		dropStmt = [WXWDBConnection statementWithQuery:[strSQL UTF8String]];
        
        [dropStmt step];
        [dropStmt reset];
    }
    
}


-(void)deleteEntity:(NSArray *)entities MOC:(NSManagedObjectContext *)MOC
{
    for (int i = 0; i < entities.count; ++i) {
        
         [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:[entities objectAtIndex:i] predicate:nil];
        
        [WXWCoreDataUtils saveMOCChange:MOC];
    }
}
@end
