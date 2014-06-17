//
//  HomeCellVIew.m
//  Project
//
//  Created by Vshare on 14-4-22.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "HomeCellView.h"
#import "InformationDefault.h"
#import "UIColor+expanded.h"

@implementation HomeCellView

- (id)initWithFrame:(CGRect)frame withTarget:(id)target withAction:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _target = target;
        _action = action;
        
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:[self createTitleLbl]];
        [self addSubview:[self createMessageLbl]];
        [self addSubview:[self createIconView]];
    }
    return self;
}

- (UILabel *)createTitleLbl
{
    self.m_titleLbl = [InformationDefault createLblWithFrame:CGRectZero withTextColor:[UIColor blackColor] withFont:[UIFont systemFontOfSize:14] withTag:HOME_CELL_TITLE];
    return self.m_titleLbl;
    
}

- (UILabel *)createMessageLbl
{
    self.m_msgLbl = [InformationDefault createLblWithFrame:CGRectZero withTextColor:[UIColor colorWithHexString:@"0x999999"] withFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:10] withTag:HOME_CELL_MESSGAE];
    return self.m_msgLbl;
}

- (UIImageView *)createIconView
{
    self.m_imgView = [InformationDefault createImgViewWithFrame:CGRectZero withImage:nil withColor:[UIColor clearColor] withTag:HOME_CELL_ICONIMG];
    return self.m_imgView;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_target && _action)
    {
        [_target performSelector:_action];
    }
}

- (void)dealloc
{
    self.m_imgView = nil;
    self.m_msgLbl = nil;
    self.m_titleLbl = nil;
    [super dealloc];
}

@end
