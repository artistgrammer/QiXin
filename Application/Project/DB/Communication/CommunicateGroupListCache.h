//
//  CommunicateGroupListCache.h
//  Project
//
//  Created by Peter on 13-11-21.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"
#import "WXWConnectorDelegate.h"
#import "ChatGroupModel.h"

@interface CommunicateGroupListCache :  NSObject <WXWConnectorDelegate>

-(void)upinsertCommunicateGroupList:(NSString *)userId array:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC;

-(void)updateGroupInfo:(ChatGroupModel *)data;
- (int)getGroupIsDeleted:(NSString *)groupId;
-(void)deleteAllGroupListData;

-(void)deleteGroup:(int)groupId;

-(double)getLatestCommunicateGroupListTime;
@end
