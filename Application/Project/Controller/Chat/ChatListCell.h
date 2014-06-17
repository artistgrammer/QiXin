//
//  ChatListCell.h
//  ChatListCell
//
//  Created by Chris Wendel on 9/10/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMCommon.h"
#import "BaseTableViewCell.h"

@class ChatListCell;

@protocol ChatListCellDelegate;

@interface ChatListCell : BaseTableViewCell
{
    UIImageView *_userImageView; //默认图片
    UIImageView *_publicGroupImageView; //group
    
    UILabel *_lastSpeakContentLabel; //最后发言内容
    UILabel *_groupTypeLabel; //群组人数
    UILabel *_dateLabel; //时间
    
    UIButton *_newMessageButton;
    UILabel *_newMessageLabel;
    
    BOOL scrollAvailable;
}

@property (nonatomic, retain) NSArray *leftUtilityButtons;
@property (nonatomic, retain) NSArray *rightUtilityButtons;
@property (nonatomic, assign) id <ChatListCellDelegate> delegate;
@property (nonatomic, retain) IMConversation *conversationObject;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons;

- (void)updateCellInfo:(IMConversation *)groupInfo;
- (void)resetCellState;
@end

@interface NSMutableArray (SWUtilityButtons)

- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title;
- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon;

@end

@protocol ChatListCellDelegate <NSObject>
- (BOOL)notifyScroll:(ChatListCell *)cell;
- (void)insertTableRowsViewCell:(ChatListCell *)cell index:(NSInteger)index;
- (void)swippableTableViewCell:(ChatListCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(ChatListCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;

@optional
- (void)getMemberList:(IMConversation *)conversationObject;
- (void)startToChat:(ChatListCell *)cell withDataModal:(IMConversation *)conversationObject;

@end
