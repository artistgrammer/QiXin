//
//  ImageList.h
//  QiXin
//
//  Created by Adam on 14-6-17.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GlobalConstants.h"
#import "CommonUtils.h"

@interface ImageList : NSManagedObject

@property (nonatomic, assign) NSNumber * imageID;
@property (nonatomic, copy) NSString * imageURL;
@property (nonatomic, assign) NSNumber * isDelete;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * topic;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * settingTime;
@property (nonatomic, copy) NSString * shortContent;
@property (nonatomic, copy) NSString * stringTime;
@property (nonatomic, copy) NSString * shortType;

- (void)updateData:(NSDictionary *)dic;

@end
