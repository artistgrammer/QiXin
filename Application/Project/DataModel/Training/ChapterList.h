//
//  ChapterList.h
//  Project
//
//  Created by XXX on 14-1-24.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseDetailList;

@interface ChapterList : NSManagedObject

@property (nonatomic, retain) NSString * chapterCompletion;
@property (nonatomic, retain) NSString * chapterFileURL;
@property (nonatomic, retain) NSNumber * chapterID;
@property (nonatomic, retain) NSString * chapterTitle;
@property (nonatomic, retain) NSNumber * courseID;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * isDelete;
@property (nonatomic, retain) NSNumber * isDownloaded;
@property (nonatomic, retain) NSNumber * percentage;
@property (nonatomic, retain) NSString * lastUpdateTime;
@property (nonatomic, retain) CourseDetailList *courseDetailList;


- (void)updateData:(NSDictionary *)dic  withCourseId:(NSNumber *)courseId;
- (void)updateDataWithObject:(ChapterList *)object;
@end
