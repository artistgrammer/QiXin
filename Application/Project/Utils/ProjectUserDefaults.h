//
//  ProjectUserDefaults.h
//  Project
//
//  Created by Peter on 13-10-23.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectUserDefaults : NSObject

- (NSString *)passwordRemembered;
- (NSString *)usernameRemembered;
- (NSString *)customerNameRemembered;

- (void)rememberUsername:(NSString *)username
			  andPassword:(NSString *)password
            customerName:(NSString *)customerName;

@end
