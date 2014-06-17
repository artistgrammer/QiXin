//
//  CommunicatGroupBriefView.m
//  Project
//
//  Created by Peter on 13-9-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommunicatGroupBriefView.h"
#import "CommonHeader.h"

@implementation CommunicatGroupBriefView {
    UIImageView *_logoImageView;
    UIImageView *_newMessageImageView;
    UILabel *_titleLabel;
    UILabel *_memberLabel;
    UILabel *_memberValueLabel;
    UILabel *_lastSpeakMemberNameLabel;
    UILabel *_lastSpeakContentLabel;
    UILabel *_dateLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initControls:self];
        [self viewAddGuestureRecognizer:_logoImageView withSEL:@selector(getMemberList:)];
        [self viewAddGuestureRecognizer:self withSEL:@selector(startToChat:)];
        
        self.backgroundColor = RANDOM_COLOR;
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

- (void)initControls:(UIView *)parentView
{
    int startX = 5;
    int startY = 5;
    int height = COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT_BK - 2*startY;
    int width = height;
    
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    _logoImageView.backgroundColor= RANDOM_COLOR;
    _logoImageView.userInteractionEnabled = YES;
    
    
    [parentView addSubview:_logoImageView];
}

- (void)viewAddGuestureRecognizer:(UIView *)view withSEL:(SEL)sel
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:sel];
    
    [view addGestureRecognizer:singleTap];
}

- (void)getMemberList:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getMemberList:)]) {
        [self.delegate getMemberList:_dateLabel];
    }
}


- (void)startToChat:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startToChat:)]) {
        [self.delegate startToChat:_dateLabel];
    }
}

@end
