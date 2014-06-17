//
//  FeedEdit.m
//  Project
//
//  Created by XXX on 13-10-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "FeedEdit.h"

static FeedEdit *_instance = nil;

@implementation FeedEdit

+ (FeedEdit *)shared {
    @synchronized(self) {
        if (!_instance) {
            _instance = [[super allocWithZone:NULL] init];
        }
    }
    return _instance;
}

@end
