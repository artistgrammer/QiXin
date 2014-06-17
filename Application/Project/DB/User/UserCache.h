//
//  UserCache.h
//  Project
//
//  Created by Peter on 13-11-5.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWImageFetcherDelegate.h"
#import "WXWConnectorDelegate.h"
#import "UserObject.h"
#import "UserProfile.h"

@interface UserCache  : NSObject <WXWConnectorDelegate>

- (void)insertUserObjectDB:(UserObject *)userInfo;
- (UserObject *)getUserInfoByVoipIdFromDB:(NSString*)userChatId;
- (UserObject *)getUserInfoByUserIdFromDB:(NSString *)userId;
- (void)insertOrUpdateUserInfos:(UserObject*)userObject;
- (void)insertOrUpdateChatGroupUserInfos:(UserObject*)userObject;
- (int)allUserCount;

// TODO delete
- (void)upinsertUserProfile:(UserProfile *)userProfile;
- (NSMutableArray *)getUserPropertiesByUserId:(int)userId;
- (NSMutableArray *)getUserPropertiesByUserId:(int)userId groupId:(int)groupId;
- (int)getGroupCountByUserId:(int)userId;
- (int)isFriend:(int)userId;
-(void)updateIsFriend:(NSArray *)array;
-(void)updateIsFriendWithId:(NSString *)userId isFriend:(BOOL)isFriend;

- (NSMutableArray *)getAllUserInfoFromDB;
- (NSMutableArray *)getUserInfoWithKeyword:(NSString *)keyword;

-(double)getLatestUserTimestamp;

@end
