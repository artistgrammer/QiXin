//
//  HotNewsModal.m
//  Project
//
//  Created by Vshare on 14-4-10.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "HotNewsModal.h"
#import "JSONKit.h"
#import "GlobalConstants.h"
#import "CommonUtils.h"

@implementation HotNewsModal
@synthesize imgArr;
@synthesize titleArr;
@synthesize detailArr;
@synthesize newsType;
@synthesize m_contentArr;

- (id)initWithJSONData:(NSData *)data
{
    NSDictionary *dataDic = [data objectFromJSONData];
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dataDic, @"content");
    
    self.m_contentArr = OBJ_FROM_DIC(contentDic, @"concernList");

    /*
    for (NSDictionary *dic in concernArr)
    {
        self.imgArr = [[dic objectForKey:@"imageUrl"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"imageUrl"];
        self.titleArr = [[dic objectForKey:@"title"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"title"];
        self.detailArr = [[dic objectForKey:@"description"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"description"];
        self.newsType = [[dic objectForKey:@"newsType"] isEqual:[NSNull null]]?@"":[dic objectForKey:@"newsType"];
    }*/
    return self;

}


@end
