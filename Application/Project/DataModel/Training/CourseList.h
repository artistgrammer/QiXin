//
//  CourseList.h
//  Project
//
//  Created by Yfeng__ on 13-12-31.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TrainingList;

@interface CourseList : NSManagedObject

@property (nonatomic, retain) NSNumber * chapterNumber;
@property (nonatomic, retain) NSNumber * courseID;
@property (nonatomic, retain) NSString * courseName;
@property (nonatomic, retain) NSNumber * courseType;
@property (nonatomic, retain) NSNumber * isDelete;
@property (nonatomic, retain) NSString * lastUpdateTime;
@property (nonatomic, retain) TrainingList *trainingList;

- (void)updateData:(NSDictionary *)dic;

@end
