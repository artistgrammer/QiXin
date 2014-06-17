//
//  SearchUserCellView.m
//  Project
//
//  Created by XXX on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "SearchUserCellView.h"
#import "UIColor+expanded.h"
#import "GlobalConstants.h"
#import "InsertLabel.h"
#import "GlobalConstants.h"

#define LOGO_WIDTH  46.f
#define LOGO_HEIGHT 46.f

#define TITLE_LABEL_WIDTH  146.f
#define TITLE_LABEL_HEIGHT 32.f

@implementation SearchUserCellView

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _target = target;
        _action = action;
        
        [self addSubviewElement:self.bounds];
    }
    return self;
}

- (void)addSubviewElement:(CGRect)rect
{
    
    UIImageView *communicationView = [[[UIImageView alloc]initWithFrame:rect] autorelease];
    [communicationView setBackgroundColor:[UIColor clearColor]];
    [communicationView setUserInteractionEnabled:YES];
    [communicationView setImage:[[UIImage imageNamed:@"Home_remain_dlg_Bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    
    UIColor *txtColor = [UIColor blackColor];
    UIFont *font = [UIFont systemFontOfSize:14];
    CGRect topicRect = CGRectMake(16, 19, 70, 14);
    UILabel *topicLbl = [InformationDefault createLblWithFrame:topicRect withTextColor:txtColor withFont:font withTag:1];
    [topicLbl setText:@"通讯录"];
    [communicationView addSubview:topicLbl];
    
    CGRect  remainRect = CGRectMake(16, 40.0, 70, 12);
    UIFont *remainFont = [UIFont fontWithName:@"STHeitiSC-Medium" size:10];
    UILabel *remainLbl = [InformationDefault createLblWithFrame:remainRect withTextColor:[UIColor colorWithHexString:@"0x999999"] withFont:remainFont withTag:2];
    [remainLbl setText:@"MAIL LIST"];
    [communicationView addSubview:remainLbl];
    
    CGRect imgRect = CGRectMake(34, 84, 80, 45);
    UIImage *img = [UIImage imageNamed:@"Home_maillist.png"];
    UIImageView *imageView = [InformationDefault createImgViewWithFrame:imgRect withImage:img withColor:[UIColor clearColor] withTag:3];
    [communicationView addSubview: imageView];
    
    [self addSubview:communicationView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_target && _action) {
        [_target performSelector:_action];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_target && _action) {
        [_target performSelector:_action];
    }
}

@end
