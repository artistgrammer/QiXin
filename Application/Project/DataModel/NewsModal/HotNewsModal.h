//
//  HotNewsModal.h
//  Project
//
//  Created by Vshare on 14-4-10.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotNewsModal : NSObject
{
    NSMutableArray   *imgArr;
    NSMutableArray   *titleArr;
    NSMutableArray   *detailArr;
    NSMutableArray   *newsType;
    
    NSMutableArray  *m_contentArr;
}

@property (nonatomic, retain)  NSMutableArray  *imgArr;
@property (nonatomic, retain)  NSMutableArray  *titleArr;
@property (nonatomic, retain)  NSMutableArray  *detailArr;
@property (nonatomic, retain)  NSMutableArray  *newsType;
@property (nonatomic, retain)  NSMutableArray  *m_contentArr;

- (id)initWithJSONData:(NSData *)data;

@end
