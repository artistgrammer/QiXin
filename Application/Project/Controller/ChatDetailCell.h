//
//  ChatDetailCell.h
//  Project
//
//  Created by XXX on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"
#import "ECClickableElementDelegate.h"
#import "GroupMemberInfo.h"
#import "UserHeader.h"
#import "ECImageConsumerCell.h"
#import "WXWImageDisplayerDelegate.h"
#import "IMCommon.h"

#define FONT_SIZE       15.0f

@interface ChatDetailCell : ECImageConsumerCell
{
    NSString *_selfImgUrl;
    NSString *_targetImgUrl;
        
    BOOL _isSelf;
}

@property (nonatomic, assign) NSTimer *voiceIconTimer;
@property (nonatomic, retain) UILabel *userNameLabel;

+ (NSString*)getMsgText:(IMMessageObj*)msg;
+ (CGFloat)calculateHeightForMsg:(IMMessageObj *)msg;

- (void)drawChat:(IMMessageObj*)msg row:(NSInteger)row showTime:(BOOL)showTime;

- (id)initWithStyle:(UITableViewCellStyle)style
         ccpVoipMsg:(IMMessageObj *)message
    reuseIdentifier:(NSString *)reuseIdentifier
imageClickableDelegate:(id<ECClickableElementDelegate>)imageClickableDelegate
                row:(NSInteger)row
           showTime:(BOOL)showTime;

- (void)updateUserBaseInfo:(UserBaseInfo *)userBaseInfo message:(IMMessageObj *)message;
- (void)drawAvatar:(NSString *)imageUrl;
- (NSString *)getVoiceCachePath:(IMMessageObj *)msg;
- (void)dismissAllPopTipViews;
- (BOOL)isSelf;
- (void)setPlayedIcon;
- (void)updateTimer:(IMMessageObj *)message;
- (void)updateBubbleVoiceImage;

@end