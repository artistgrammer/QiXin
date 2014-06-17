//
//  WXWDBConnection.h
//  Project
//
//  Created by Adam on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <sqlite3.h>

@class WXWStatement;

@interface WXWDBConnection : NSObject {
  
}

+ (sqlite3 *)prepareBizDB;
+ (void)beginTransaction;
+ (void)commitTransaction;
+ (WXWStatement*)statementWithQuery:(const char *)sql;
+ (void)closeDB;

@end
