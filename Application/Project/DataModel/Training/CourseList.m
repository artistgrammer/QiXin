//
//  CourseList.m
//  Project
//
//  Created by Yfeng__ on 13-12-31.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CourseList.h"
#import "TrainingList.h"


@implementation CourseList

@dynamic chapterNumber;
@dynamic courseID;
@dynamic courseName;
@dynamic courseType;
@dynamic isDelete;
@dynamic lastUpdateTime;
@dynamic trainingList;

- (void)updateData:(NSDictionary *)dic {
    self.courseID = [NSNumber numberWithInteger:[[dic objectForKey:@"courseID"] integerValue]];
    self.courseName = [[dic objectForKey:@"courseName"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"courseName"];
    self.courseType = [NSNumber numberWithInteger:[[dic objectForKey:@"courseType"] integerValue]];
    self.chapterNumber = [NSNumber numberWithInteger:[[dic objectForKey:@"chapterNumber"] integerValue]];
    self.isDelete = [NSNumber numberWithInteger:[[dic objectForKey:@"isDelete"] integerValue]];
    self.lastUpdateTime = [[dic objectForKey:@"lastUpdateTime"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"lastUpdateTime"];
}

@end
