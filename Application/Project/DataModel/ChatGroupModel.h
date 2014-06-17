//
//  ChatGroupModel.h
//  Project
//
//  Created by Adam on 14-6-3.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ChatGroupModel : NSManagedObject

@property (nonatomic, retain) NSNumber * auditNeededLevel;
@property (nonatomic, retain) NSNumber * canChat;
@property (nonatomic, retain) NSNumber * canDelete;
@property (nonatomic, retain) NSNumber * canInvite;
@property (nonatomic, retain) NSNumber * canQuit;
@property (nonatomic, retain) NSNumber * canViewLog;
@property (nonatomic, retain) NSNumber * displayIndex;
@property (nonatomic, retain) NSString * groupBindId;
@property (nonatomic, retain) NSString * groupCustomerId;
@property (nonatomic, retain) NSString * groupDescription;
@property (nonatomic, retain) NSString * groupEmail;
@property (nonatomic, retain) NSString * groupId;
@property (nonatomic, retain) NSString * groupImage;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSString * groupPhone;
@property (nonatomic, retain) NSNumber * groupType;
@property (nonatomic, retain) NSString * groupUserIdArray;
@property (nonatomic, retain) NSString * groupUserImageArray;
@property (nonatomic, retain) NSString * groupUserNameArray;
@property (nonatomic, retain) NSString * groupWebsite;
@property (nonatomic, retain) NSNumber * invitationPublicLevel;
@property (nonatomic, retain) NSNumber * lastMessageTime;
@property (nonatomic, retain) NSNumber * userCount;
@property (nonatomic, retain) NSNumber * userStatus;

- (BOOL)isInGroup;
- (BOOL)isAdmin;

- (void)updateData:(NSDictionary *)dict;

@end
