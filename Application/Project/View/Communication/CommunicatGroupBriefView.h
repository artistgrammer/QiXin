//
//  CommunicatGroupBriefView.h
//  Project
//
//  Created by Peter on 13-9-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatGroupModel.h"

@protocol CommunicatGroupBriefViewDelegate;

@interface CommunicatGroupBriefView : UIView


@property (nonatomic, assign) id<CommunicatGroupBriefViewDelegate> delegate;

@end


@protocol CommunicatGroupBriefViewDelegate <NSObject>

- (void)getMemberList:(ChatGroupModel *)dataModal;
- (void)startToChat:(ChatGroupModel *)dataModal;

@end