//
//  EMGroup.h
//  GoHigh
//
//  Created by Peter on 13-9-27.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMGroup : NSObject
@property (nonatomic, retain) NSNumber * canVisit;
@property (nonatomic, retain) NSString * groupId;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSNumber * groupType;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * lastPostAuthor;
@property (nonatomic, retain) NSString * lastPostId;
@property (nonatomic, retain) NSString * lastPostMsg;
@property (nonatomic, retain) NSString * lastPostTime;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * postNewCount;
@property (nonatomic, retain) NSNumber * subType;
@property (nonatomic, retain) NSNumber * postCount;
@property (nonatomic, retain) NSNumber * eventCount;
@property (nonatomic, retain) NSNumber * memberCount;
@property (nonatomic, retain) NSNumber * memberStatus;
@property (nonatomic, retain) NSNumber * isAdmin;
@property (nonatomic, retain) NSNumber * canViewPost;
@property (nonatomic, retain) NSNumber * canViewMember;
@property (nonatomic, retain) NSNumber * canSubmitPost;
@property (nonatomic, retain) NSNumber * canJoin;
@property (nonatomic, retain) NSNumber * canExit;
@end
