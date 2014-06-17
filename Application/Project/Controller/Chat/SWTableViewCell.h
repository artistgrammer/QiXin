//
//  SWTableViewCell.h
//  SWTableViewCell
//
//  Created by Chris Wendel on 9/10/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMCommon.h"

@class SWTableViewCell;

@protocol SWTableViewCellDelegate;

@interface SWTableViewCell : UITableViewCell
{
    UIImageView *_userImageView; //默认图片
    UIImageView *_publicGroupImageView; //group
    
    UILabel *_lastSpeakContentLabel; //最后发言内容
    UILabel *_groupTypeLabel; //群组人数
    UILabel *_dateLabel; //时间
    
    BOOL scrollAvailable;
}

@property (nonatomic, retain) NSArray *leftUtilityButtons;
@property (nonatomic, retain) NSArray *rightUtilityButtons;
@property (nonatomic, assign) id <SWTableViewCellDelegate> delegate;
@property (nonatomic, retain) IMGroupInfo *groupObject;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons;

- (void)updateCellInfo:(IMGroupInfo *)groupInfo;
- (void)resetCellState;
@end

@interface NSMutableArray (SWUtilityButtons)

- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title;
- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon;

@end

@protocol SWTableViewCellDelegate <NSObject>
- (BOOL)notifyScroll:(SWTableViewCell *)cell;
- (void)insertTableRowsViewCell:(SWTableViewCell *)cell index:(NSInteger)index;
- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;

@optional
- (void)getMemberList:(IMGroupInfo *)groupObject;
- (void)startToChat:(SWTableViewCell *)cell withDataModal:(IMGroupInfo *)groupObject;

@end
