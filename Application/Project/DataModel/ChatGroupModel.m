//
//  ChatGroupModel.m
//  Project
//
//  Created by Adam on 14-6-3.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "ChatGroupModel.h"
#import "GlobalConstants.h"
#import "CommonUtils.h"


@implementation ChatGroupModel

@dynamic auditNeededLevel;
@dynamic canChat;
@dynamic canDelete;
@dynamic canInvite;
@dynamic canQuit;
@dynamic canViewLog;
@dynamic displayIndex;
@dynamic groupBindId;
@dynamic groupCustomerId;
@dynamic groupDescription;
@dynamic groupEmail;
@dynamic groupId;
@dynamic groupImage;
@dynamic groupName;
@dynamic groupPhone;
@dynamic groupType;
@dynamic groupUserIdArray;
@dynamic groupUserImageArray;
@dynamic groupUserNameArray;
@dynamic groupWebsite;
@dynamic invitationPublicLevel;
@dynamic lastMessageTime;
@dynamic userCount;
@dynamic userStatus;

- (void) updateData:(NSDictionary *)dict
{
    self.groupId = STRING_VALUE_FROM_DIC(dict, @"ChatGroupID");
    self.groupBindId = STRING_VALUE_FROM_DIC(dict,@"BindGroupID");
    self.groupName = STRING_VALUE_FROM_DIC(dict, @"GroupName");
    self.groupImage = STRING_VALUE_FROM_DIC(dict, @"LogoUrl");
    self.groupDescription = STRING_VALUE_FROM_DIC(dict, @"Description");
    self.groupCustomerId =  STRING_VALUE_FROM_DIC(dict, @"CustomerID");
    
    self.canChat = @(INT_VALUE_FROM_DIC(dict,@"canChat"));
    self.canDelete = @(INT_VALUE_FROM_DIC(dict,@"canDelete"));
    self.canInvite = @(INT_VALUE_FROM_DIC(dict,@"canInvite"));
    self.canQuit = @(INT_VALUE_FROM_DIC(dict,@"canQuit"));
    self.canViewLog = @(INT_VALUE_FROM_DIC(dict,@"canViewLog"));
    self.displayIndex = @(INT_VALUE_FROM_DIC(dict,@"displayIndex"));
    self.groupType = @(INT_VALUE_FROM_DIC(dict,@"groupType"));
    self.invitationPublicLevel = @(INT_VALUE_FROM_DIC(dict,@"invitationPublicLevel"));
    
    self.groupEmail = STRING_VALUE_FROM_DIC(dict, @"groupEmail");
    self.groupPhone = STRING_VALUE_FROM_DIC(dict, @"Telephone");
    self.groupWebsite = STRING_VALUE_FROM_DIC(dict, @"groupWebsite");
    
    NSArray *otherAvatarDict = OBJ_FROM_DIC(dict, @"showAvatar");
    
    if (otherAvatarDict) {
        self.groupUserImageArray = @"";
        self.groupUserIdArray = @"";
        self.groupUserNameArray = @"";
        
        if (otherAvatarDict.count) {
            int size = otherAvatarDict.count;
            
            for (int index=0; index<size; index++) {
                
                NSDictionary *userInfo = [otherAvatarDict objectAtIndex:index];
                
                // image
                NSString *tempString = [[userInfo objectForKey:@"headerImage"] isEqual:[NSNull null]] ? @"" : [userInfo objectForKey:@"headerImage"] ;
                
                if (self.groupUserImageArray && self.groupUserImageArray.length > 2) {
                    self.groupUserImageArray = [NSString stringWithFormat:@"%@#%@", self.groupUserImageArray, tempString];
                } else {
                    self.groupUserImageArray = [NSString stringWithFormat:@"%@", tempString];
                }
                
                // Id
                NSString *userIDString = [[userInfo objectForKey:@"userID"] isEqual:[NSNull null]] ? @"" : [userInfo objectForKey:@"userID"] ;
                
                if (self.groupUserIdArray && self.groupUserIdArray.length > 2) {
                    self.groupUserIdArray = [NSString stringWithFormat:@"%@#%@", self.groupUserIdArray, userIDString];
                } else {
                    self.groupUserIdArray = [NSString stringWithFormat:@"%@", userIDString];
                }
                
                // name
                NSString *userNameString = [[userInfo objectForKey:@"userName"] isEqual:[NSNull null]] ? @"" : [userInfo objectForKey:@"userName"] ;
                
                if (self.groupUserNameArray && self.groupUserNameArray.length > 2) {
                    self.groupUserNameArray = [NSString stringWithFormat:@"%@#%@", self.groupUserNameArray, userNameString];
                } else {
                    self.groupUserNameArray = [NSString stringWithFormat:@"%@", userNameString];
                }
            }
        }
    } else {
        self.groupUserImageArray = @"";
        self.groupUserIdArray = @"";
        self.groupUserNameArray = @"";
    }
    
    self.userStatus = @(USER_STATUS_ADMIN);
    self.userCount = @(INT_VALUE_FROM_DIC(dict, @"UserCount"));
}


/*
 userId TEXT,
 canChat integer,
 canDelete integer,
 canInvite integer,
 canQuit integer,
 canViewLog integer,
 displayIndex integer,
 groupDescription TEXT,
 groupEmail TEXT,
 groupId integer,
 groupImage TEXT,
 groupName TEXT,
 groupPhone TEXT,
 groupType integer,
 groupWebsite TEXT,
 invitationPublicLevel integer,
 userCount integer,
 userStatus integer,
 auditNeededLevel integer,
 timestamp double,
 isDelete integer
 */

-(void)updateDataWithStmt:(WXWStatement *)stmt
{
    self.canChat = NUMBER([stmt getInt32:1]);
    self.canDelete = NUMBER([stmt getInt32:2]);
    self.canInvite = NUMBER([stmt getInt32:3]);
    self.canQuit = NUMBER([stmt getInt32:4]);
    self.canViewLog = NUMBER([stmt getInt32:5]);
    self.displayIndex = NUMBER([stmt getInt32:6]);
    self.groupDescription = [stmt getString:7];
    self.groupEmail = [stmt getString:8];
    self.groupId = [stmt getString:9];
    self.groupImage = [stmt getString:10];
    self.groupName = [stmt getString:11];
    self.groupPhone = [stmt getString:12];
    self.groupType = NUMBER([stmt getInt32:13]);
    self.groupWebsite = [stmt getString:14];
    self.invitationPublicLevel = NUMBER([stmt getInt32:15]);
    self.userCount = NUMBER([stmt getInt32:16]);
    self.userStatus = NUMBER([stmt getInt32:17]);
    self.auditNeededLevel = NUMBER([stmt getInt32:18]);
    self.groupUserImageArray = [stmt getString:19];
    self.groupUserIdArray = [stmt getString:20];
    self.groupUserNameArray = [stmt getString:21];
}

- (BOOL)isInGroup
{
    /*
     if ([self.userStatus integerValue] == USER_STATUS_ADMIN || [self.userStatus integerValue] == USER_STATUS_AUDIT) {
     return YES;
     }
     
     return NO;
     */
    
    return YES;
}

- (BOOL)isAdmin
{
    /*
     if ([self.userStatus integerValue] == USER_STATUS_ADMIN) {
     return YES;
     }
     
     return NO;
     */
    
    return YES;
}

@end
