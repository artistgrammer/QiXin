//
//  UserHeaderCache.m
//  Project
//
//  Created by Peter on 13-11-14.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "UserHeaderCache.h"

@implementation UserHeaderCache

@synthesize headerCacheDictionary =_headerCacheDictionary;

static UserHeaderCache *instance = nil;

+(UserHeaderCache *)instance
{
    @synchronized(self) {
        if(instance == nil) {
            instance = [[super allocWithZone:NULL] init];
            [instance initData];
        }
    }
    
    return instance;
}

-(void)initData
{
    _headerCacheDictionary = [[NSMutableDictionary alloc] init];
}


-(void)addImageCache:(NSString *)key image:(UIImage *)image
{
    _headerCacheDictionary[key] = image;
}

-(UIImage *)getImageCache:(NSString *)key
{
    return _headerCacheDictionary[key];
}

@end
