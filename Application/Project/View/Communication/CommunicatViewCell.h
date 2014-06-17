//
//  CommunicatViewCell.h
//  Project
//
//  Created by Peter on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMCommon.h"
#import "TextConstants.h"

@protocol CommunicatViewCellDelegate;

#define kCommunicat_Cell_Height 67.0f

@interface CommunicatViewCell : UITableViewCell {
    UIImageView *_avataImageView; //默认图片
    UIImageView *_checkImageView; //lock
    UIImageView *_noticeImageView;  //voice
    UIImageView *_publicGroupImageView; //group
    
    UILabel *_lastSpeakMemberNameLabel; //最后发言人
    UILabel *_lastSpeakContentLabel; //最后发言内容
    UILabel *_dateLabel; //时间
    UILabel *_groupTypeLabel; //群组人数
    
    UILabel *_bottomLineLabel;//表格分割线
    UILabel *_newMessageLabel;
    
    UIButton *_newMessageButton;
}

@property (nonatomic, retain) UIButton *newMessageButton;
@property (nonatomic, retain) UILabel *newMessageLabel;
@property (nonatomic, retain) NSString *downloadFile;
@property (nonatomic, assign) id<CommunicatViewCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style delegate:(id<CommunicatViewCellDelegate>)delegate reuseIdentifier:(NSString *)reuseIdentifier;

- (void)updateCellInfo:(IMGroupInfo *)dataModal;
- (void)updateMessageCount:(int)count;

@end

@protocol CommunicatViewCellDelegate <NSObject>



@end