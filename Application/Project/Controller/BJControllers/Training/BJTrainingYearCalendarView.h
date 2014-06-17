//
//  BJTrainingYearCalendarView.h
//  Project
//
//  Created by sun art on 14-5-28.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConstants.h"

@interface BJTrainingYearCalendarView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    
}
- (void)refreshTable;

@property (nonatomic, retain) UITableView* yearCalendarTable;

@property (nonatomic, retain) NSMutableArray* coursesArray;

@property (nonatomic, retain) NSMutableDictionary* contentDic;

@end
