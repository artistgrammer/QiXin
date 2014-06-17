//
//  MapAnnoationTitleView.m
//  Aladdin
//
//  Created by Peter on 14-3-3.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "MapAnnoationTitleView.h"
#import "GlobalConstants.h"

@implementation MapAnnoationTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)initControl:(CGRect )rect title:(NSString *)title subTitle:(NSString *)subTitle titleSize:(CGSize)titleSize subTitleSize:(CGSize)subTitleSize
{
    
    float distX = 10;
    float distY = 5;
    rect.origin.y = - rect.size.height -2* distY;
//    rect.origin.x = - rect.size.width / 2.f +distX + 35;
    rect.origin.x = 4;
    rect.size.width += 2*distX;
    rect.size.height += 2*distY;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:rect];
    backgroundImageView.image = [[UIImage imageNamed:@"mapAnnoView.png"] stretchableImageWithLeftCapWidth:30.f topCapHeight:20.f];
//    backgroundImageView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:.3f];
    
    [self addSubview:backgroundImageView];
    [backgroundImageView release];
    
    _titleLabel = [[WXWLabel alloc] initWithFrame:CGRectMake((titleSize.width > subTitleSize.width ? 0:(subTitleSize.width - titleSize.width) / 2.f )+ distX, distY, titleSize.width, titleSize.height) textColor:[UIColor whiteColor] shadowColor:TRANSPARENT_COLOR font:FONT_SYSTEM_SIZE(16)];
    _titleLabel.text = title;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    _subTitleLabel = [[WXWLabel alloc] initWithFrame:CGRectMake((titleSize.width > subTitleSize.width ? (titleSize.width - subTitleSize.width) / 2.f:0)+ distX,distY +  titleSize.height, subTitleSize.width, subTitleSize.height) textColor:WHITE_COLOR shadowColor:TRANSPARENT_COLOR font:FONT_SYSTEM_SIZE(12)];
    _subTitleLabel.text = subTitle;
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [backgroundImageView addSubview:_titleLabel];
    [backgroundImageView addSubview:_subTitleLabel];
}

- (id)initWithTitle:(CGRect )rect title:(NSString *)title subTitle:(NSString *)subTitle
{
    if (self = [super initWithFrame:rect]) {
        CGSize titleSize = [title sizeWithFont:FONT_SYSTEM_SIZE(16)];
        CGSize subTitleSize = [subTitle sizeWithFont:FONT_SYSTEM_SIZE(12)];
        
        float width = titleSize.width > subTitleSize.width ? titleSize.width : subTitleSize.width;
        float height = titleSize.height + subTitleSize.height + 10;
        
        
        [self initControl:CGRectMake(0, 0, width, height) title:title subTitle:subTitle titleSize:titleSize subTitleSize:subTitleSize];
        
        
    }
    
    return self;
}

@end
