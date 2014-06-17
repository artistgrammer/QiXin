//
//  UserHeaderCache.h
//  Project
//
//  Created by Peter on 13-11-14.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserHeaderCache : NSObject

@property (nonatomic, retain) NSMutableDictionary *headerCacheDictionary;

+ (UserHeaderCache *)instance;

-(void)addImageCache:(NSString *)key image:(UIImage *)image;
-(UIImage *)getImageCache:(NSString *)key;
@end
