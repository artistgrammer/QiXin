//
//  CircleMarketingView.m
//  Project
//
//  Created by XXX on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingView.h"
#import "UIColor+expanded.h"
#import "GlobalConstants.h"

#define IMAGEVIEW_WIDTH  146.f
#define IMAGEVIEW_HEIGHT 32.f

@implementation CircleMarketingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor colorWithHexString:@"0xdfe4ba"];
        
//        [self addButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action {
    self = [self initWithFrame:frame];
    if (self) {
        _target = target;
        _action = action;
        
//        [self addBG];
//        [self addBottomView];
        
        [self addSubview:[self createCommunicationImgViewWithFrame:self.bounds]];
    }
    return self;
}

- (void)addBG {
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
    bg.image = [UIImage imageNamed:@"Home_remain_dlg_Bg.png"];
    [self addSubview:bg];
    [bg release];
}

- (void)addBottomView
{
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - IMAGEVIEW_HEIGHT, IMAGEVIEW_WIDTH, IMAGEVIEW_HEIGHT)];
    imageView.image = [UIImage imageNamed:@"information_circleMarketing_bottom_bg"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:imageView.bounds];
     
    
#if APP_TYPE == APP_TYPE_EMBA
    titleLabel.text = @"待办事项";
#endif
    
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = FONT_SYSTEM_SIZE(16);
    titleLabel.backgroundColor = TRANSPARENT_COLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:titleLabel];
    [titleLabel release];
    
    [self addSubview:imageView];
    [imageView release];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_target && _action) {
        [_target performSelector:_action];
    }
}


- (UIImageView *)createCommunicationImgViewWithFrame:(CGRect)rect
{
    
    UIImageView *communicationView = [[[UIImageView alloc]initWithFrame:rect] autorelease];
    [communicationView setBackgroundColor:[UIColor clearColor]];
    [communicationView setUserInteractionEnabled:YES];
    [communicationView setImage:[[UIImage imageNamed:@"Home_remain_dlg_Bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    
    UIColor *txtColor = [UIColor blackColor];
    UIFont *font = [UIFont systemFontOfSize:14];
    CGRect topicRect = CGRectMake(12, 14.5, 70, 14);
    UILabel *topicLbl = [InformationDefault createLblWithFrame:topicRect withTextColor:txtColor withFont:font withTag:1];
    [topicLbl setText:@"项目管理"];
    [communicationView addSubview:topicLbl];
    
    CGRect  remainRect = CGRectMake(12, 36.5, 70, 12);
    UIFont *remainFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:10];
    UILabel *remainLbl = [InformationDefault createLblWithFrame:remainRect withTextColor:[UIColor colorWithHexString:@"0x999999"] withFont:remainFont withTag:2];
    [remainLbl setText:@"REMIND"];
    [communicationView addSubview:remainLbl];
    
    CGRect imgRect = CGRectMake(99, 23, 36, 37);
    UIImage *img = [UIImage imageNamed:@"Home_remind_clock.png"];
    UIImageView *imageView = [InformationDefault createImgViewWithFrame:imgRect withImage:img withColor:[UIColor clearColor] withTag:3];
    [communicationView addSubview: imageView];
    
    return communicationView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
