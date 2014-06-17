//
//  BJTrainingYearCalendarView.m
//  Project
//
//  Created by sun art on 14-5-28.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJTrainingYearCalendarView.h"
#import "BJCourseDetailViewController.h"

@implementation BJTrainingYearCalendarView

@synthesize yearCalendarTable = _yearCalendarTable;
@synthesize coursesArray = _coursesArray;
@synthesize contentDic = _contentDic;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initTableViewWithFrame:frame];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)refreshTable {
    
    [_yearCalendarTable reloadData];
    
}

- (void)initTableViewWithFrame:(CGRect)frame {
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    _yearCalendarTable = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _yearCalendarTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _yearCalendarTable.backgroundView = nil;
    _yearCalendarTable.backgroundColor = WHITE_COLOR;
    _yearCalendarTable.delegate = self;
    _yearCalendarTable.dataSource = self;
    
    if (CURRENT_OS_VERSION >= IOS7) {
        _yearCalendarTable.separatorInset = ZERO_EDGE;
    }
    
    [self addSubview:_yearCalendarTable];
    
    _contentDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    /*
     Jan 一月
     Feb二月
     Mar三月
     Apr 四月
     May 五月
     June 六月
     July 七月
     Aug八月
     Sep 九月 
     Oct 十月 
     Nov 十一月 
     Dec 十二月
     **/
    [_contentDic setObject:@"JAN-13" forKey:@"2014-01-13"];
    [_contentDic setObject:@"FEB-13" forKey:@"2014-02-13"];
    [_contentDic setObject:@"MAR-13" forKey:@"2014-03-13"];
    [_contentDic setObject:@"APR-13" forKey:@"2014-04-13"];
    [_contentDic setObject:@"MAY-13" forKey:@"2014-05-13"];
    [_contentDic setObject:@"JUNE-13" forKey:@"2014-06-13"];
    [_contentDic setObject:@"JULY-13" forKey:@"2014-07-13"];
    [_contentDic setObject:@"AUG-13" forKey:@"2014-08-13"];
    [_contentDic setObject:@"SEP-13" forKey:@"2014-09-13"];
    [_contentDic setObject:@"OCT-13" forKey:@"2014-10-13"];
    [_contentDic setObject:@"DEC-13" forKey:@"2014-12-13"];
    [_contentDic setObject:@"JAN-13" forKey:@"2015-01-13"];
    [_contentDic setObject:@"FEB-13" forKey:@"2015-02-13"];
    [_contentDic setObject:@"MAR-13" forKey:@"2015-03-13"];
    [_contentDic setObject:@"APR-13" forKey:@"2015-04-13"];
    [_contentDic setObject:@"MAY-13" forKey:@"2015-05-13"];
    [_contentDic setObject:@"JUNE-13" forKey:@"2015-06-13"];
    [_contentDic setObject:@"JULY-13" forKey:@"2015-07-13"];
    [_contentDic setObject:@"AUG-13" forKey:@"2015-08-13"];
    [_contentDic setObject:@"SEP-13" forKey:@"2015-09-13"];
    [_contentDic setObject:@"OCT-13" forKey:@"2015-10-13"];
    [_contentDic setObject:@"DEC-13" forKey:@"2015-12-13"];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_coursesArray count];
}

- (UITableViewCell *)drawVideoCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"image_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = TRANSPARENT_COLOR;
    cell.contentView.backgroundColor = TRANSPARENT_COLOR;
    
    return cell;
}

- (BOOL) isTrainingExits:(NSString*)key training_time_start:(NSString*)training_time_start training_time_end:(NSString*)training_time_end
{
    if (([key compare:training_time_end] == NSOrderedAscending && [key compare:training_time_start] == NSOrderedDescending)||[key compare:training_time_start] == NSOrderedSame||[key compare:training_time_end] == NSOrderedSame)
    {
        return YES;
    }
    return NO;
}

- (UITableViewCell *)drawOtherInfoCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString *kCellIdentifier = @"otherInfoCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    int row = [indexPath row];
    
    NSArray* dateValueArr = [_contentDic allValues];
    NSArray* dateKeyArr = [_contentDic allKeys];
    
//    if (nil == cell) {
    
    static NSString *CellIdentifier = @"otherInfoCell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = TRANSPARENT_COLOR;
        cell.contentView.backgroundColor = TRANSPARENT_COLOR;
        
        
        int cellW = cell.contentView.frame.size.width/4;
        int cellH = 80;
        int cellGap = 1;
        
//        UIButton *yeardayBtn = [[UIButton alloc] initWithFrame:CGRectMake(cellW,cellGap,cellW-2*cellGap,cellH-2*cellGap)];
//        
//        [yeardayBtn setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
//        
//        [yeardayBtn setTitle:[dateValueArr objectAtIndex:row] forState:UIControlStateNormal];
//        [yeardayBtn setTitle:[dateValueArr objectAtIndex:row] forState:UIControlStateHighlighted];
//        [yeardayBtn setTitle:[dateValueArr objectAtIndex:row] forState:UIControlStateSelected];
//        yeardayBtn.titleLabel.font=[UIFont systemFontOfSize:15];
//        [yeardayBtn.titleLabel setTextColor:[UIColor blackColor]];
//        [yeardayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//        yeardayBtn.tag = 1;
//        [cell.contentView addSubview:yeardayBtn];
//        [yeardayBtn release];
        
        for (int i = 0; i < [_coursesArray count]; i++) {
            BJCourseItem* courseItem = [_coursesArray objectAtIndex:i];
            
            NSString* startDate = courseItem.training_time_start;
            NSString* endDate = courseItem.training_time_end;
            
            for (int k = 0 ; k < [dateKeyArr count]; k++) {
                if ([self isTrainingExits:[dateKeyArr objectAtIndex:k] training_time_start:startDate training_time_end:endDate]) {
                    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellGap,cellGap,cellW-2*cellGap,cellH-2*cellGap)];
                    dateLabel.textAlignment = NSTextAlignmentLeft;
                    dateLabel.numberOfLines = 0;
                    dateLabel.font = [UIFont systemFontOfSize:18];
                    dateLabel.backgroundColor = [UIColor clearColor];
                    dateLabel.text = [dateValueArr objectAtIndex:k];
                    dateLabel.textAlignment = NSTextAlignmentCenter;
                    dateLabel.textColor = [UIColor blackColor];
                    [cell.contentView addSubview:dateLabel];
                    [dateLabel release];
                    
                    UIButton *yeardayBtn = [[UIButton alloc] initWithFrame:CGRectMake(cellW,cellGap,cellW-2*cellGap,cellH-2*cellGap)];
                    if ([courseItem.status intValue] == 0) {
                        [yeardayBtn setBackgroundColor:HEX_COLOR(@"0xf9b552")];
                    }else if ([courseItem.status intValue] == 1)
                    {
                        [yeardayBtn setBackgroundColor:HEX_COLOR(@"0xb4d465")];
                    }else if ([courseItem.status intValue] == 2)
                    {
                        [yeardayBtn setBackgroundColor:HEX_COLOR(@"0xff6666")];
                    }else
                    {
                        [yeardayBtn setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
                    }
                    [yeardayBtn setTitle:courseItem.full_course_name forState:UIControlStateNormal];
                    [yeardayBtn setTitle:courseItem.full_course_name forState:UIControlStateHighlighted];
                    [yeardayBtn setTitle:courseItem.full_course_name forState:UIControlStateSelected];
                    yeardayBtn.titleLabel.font=[UIFont systemFontOfSize:13];
                    [yeardayBtn.titleLabel setTextColor:[UIColor blackColor]];
                    [yeardayBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                    yeardayBtn.tag = i;
                    [cell.contentView addSubview:yeardayBtn];
                    [yeardayBtn release];
                }
            }
        }
//    }
    
    return cell;
}

- (void)btnAction:(id)sender
{
    BJCourseDetailViewController* courseDetailViewCtrl= [[BJCourseDetailViewController alloc] initWithNibName:@"BJCourseDetailViewController" bundle:nil moc:[CommonMethod getInstance].MOC];
    
    int contentIndex = ((UIButton*)sender).tag;
    
    courseDetailViewCtrl.currentCourseItem = [_coursesArray objectAtIndex:contentIndex];
    [CommonMethod pushViewController:courseDetailViewCtrl  withAnimated:YES];
    [courseDetailViewCtrl release];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self drawOtherInfoCell:tableView atIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)dealloc
{
    [super dealloc];
    
    [_yearCalendarTable release];
    [_coursesArray release];
//    [_contentDic release];
}

@end
