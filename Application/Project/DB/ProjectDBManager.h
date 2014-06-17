//
//  ProjectDBManager.h
//  Project
//
//  Created by Peter on 13-11-6.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserCache.h"
#import "InformationImageWallCache.h"
#import "CommunicateGroupListCache.h"

#define INFORMATION_SHARE_WEIXIN_KEY   @"informationShareWeixinKey"

@interface ProjectDBManager : NSObject

+ (ProjectDBManager *)instance;

- (int)getGroupNewMessageCount:(NSString *)groupId userId:(NSString *)userId;
- (int)getPrivateNewMessageCount:(NSString *)friendId userId:(NSString *)userId;
- (int)getGroupIsDeleted:(NSString *)groupId;
- (void)setGroupMessageReaded:(NSString *)groupId;
- (void)setPrivateMessageReaded:(NSString *)friendId;
- (void)setGroupDeleted:(NSString *)groupId;

//------------ user db------------
- (void)insertUserObjectDB:(UserObject *)userInfo;
- (UserObject *)getUserInfoByUserIdFromDB:(NSString*)userId;
- (UserObject *)getUserInfoByVoipIdFromDB:(NSString*)userChatId;
- (int)allUserCount;
- (void)insertOrUpdateUserInfos:(UserObject *)userInfo;
- (void)insertOrUpdateChatGroupUserInfos:(UserObject *)userInfo;

//TODO delete
- (void)insertUserObjectDB:(UserObject *)userInfo timestamp:(double)timestamp;
- (void)upinsertUserProfile:(UserProfile *)userProfile;
- (NSMutableArray *)getUserPropertiesByUserId:(int)userId;
- (NSMutableArray *)getUserPropertiesByUserId:(int)userId groupId:(int)groupId;
- (int)getGroupCountByUserId:(int)userId;
- (int)isFriend:(int)userId;
- (void)updateIsFriend:(NSArray *)array;
- (void)updateIsFriendWithId:(NSString *)userId isFriend:(BOOL)isFriend;
- (NSMutableArray *)getAllUserInfoFromDB;
- (NSMutableArray *)getUserInfoWithKeyword:(NSString *)keyword;
- (double)getLatestUserTimestamp;

//---------------information image wall
- (void)upinsertInfomationImageWall:(NSArray *)array timestamp:(double)timestamp;
- (double)getLatestInfoImageWallTime;

//--------------information list
- (void)upinsertInfomationInfo:(NSArray *)array timestamp:(double)timestamp;
- (double)getLatestInfomationTimestamp;
- (double)getOldestInfomationTimestamp;
- (void)deleteOldInfomationFromTimestamp:(NSString *)timestamp;

- (void)updateInformationCommentCount:(int)infoId count:(int)count;
-(void)updateInformationCommentReader:(int)infoId count:(int)count;

- (int)getInformationCommentCount:(int)infoId;
- (int)getInformationCommentReader:(int)infoId;
//---------------AloneMarketing
- (void)upinsertAloneMarketing:(NSArray *)array timestamp:(double)timestamp;
- (double)getLatestAloneMarketingTime;

//--------------Circlemarketing
- (void)upinsertCircleMarketing:(NSArray *)array timestamp:(double)timestamp;
- (double)getLatestCircleMarketingTime:(int)type;

//--------------communicate group list
- (void)upinsertCommunicateGroupList:(NSString *)userId array:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC;
- (double)getLatestCommunicateGroupListTime;
- (void)deleteGroup:(int)groupId;
- (void)deleteAllGroupListData;


//--------------common table
- (void)upinsertCommonTable:(NSString *)key value:(NSString *)value;
- (NSString*)getCommon:(NSString *)key;

//--------------drop tables
- (void)dropTables:(NSArray *)table;
- (void)deleteEntity:(NSArray *)entities MOC:(NSManagedObjectContext *)MOC;

@end
