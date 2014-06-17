//
//  TrainingList.m
//  Project
//
//  Created by Yfeng__ on 13-11-1.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "TrainingList.h"
#import "CourseList.h"


@implementation TrainingList

@dynamic trainingCategoryID;
@dynamic trainingCategoryName;
@dynamic courseNumber;
@dynamic courseLists;


- (void)updateData:(NSDictionary *)dic {
    self.trainingCategoryID = [NSNumber numberWithInteger:[[dic objectForKey:@"trainingCategoryID"] integerValue]];
    self.trainingCategoryName = [[dic objectForKey:@"trainingCategoryName"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"trainingCategoryName"];
    self.courseNumber = [NSNumber numberWithInteger:[[dic objectForKey:@"courseNumber"] integerValue]];
}


@end
