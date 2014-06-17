//
//  iChatInstance.h
//  Project
//
//  Created by Peter on 13-11-7.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iChatInstance : NSObject

#define DELETE_GROUP_MESSAGE    @"EDDD8C6120890D04E044005056BE1CB0"

@property (nonatomic, assign) int index;

+ (iChatInstance *) instance;

- (void)imRelogin;
- (void)dologin:(NSString *)userId;
- (void)dologout;
- (void)registerListener:(id)listener;
- (void)unRegisterListener:(id)listener;

-(void)sendDeleteGroupMessage:(NSString *)groupId;

@end
