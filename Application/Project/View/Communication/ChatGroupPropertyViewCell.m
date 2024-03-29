//
//  ChatGroupPropertyViewCell.m
//  Project
//
//  Created by Peter on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ChatGroupPropertyViewCell.h"
#import "CommonHeader.h"

enum PROPERTY_CELL_TYPE {
    PROPERTY_CELL_TYPE_BUTTON = 1,
    PROPERTY_CELL_TYPE_TEXT,
};


@implementation ChatGroupPropertyViewCell {
    int _marginX;
    UILabel *_defalutValueLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDictionary:(NSDictionary *)dict withParentViewWidth:(int)parentViewWidth withShowBottomLine:(BOOL)showLine
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        NSString *type = [dict objectForKey:KEY_PROPERTY_CONTENT_TYPE_TYPE];
        NSLog(@"%@", type);
        
        NSString *title = [dict objectForKey:KEY_PROPERTY_CONTENT_TYPE_TITLE];
        
        if ([type isEqualToString:PROPERTY_TYPE_BUTTON]) {
            
            SEL selector = NSSelectorFromString ([dict objectForKey:KEY_PROPERTY_CONTENT_TYPE_SEL]);
            
            [self addSubview:[self propertyView:0 withHeight:COMMUNICATE_PROPERTY_CELL_HEIGHT withTitle:title withDefaultValue:nil withTarget:[dict objectForKey:KEY_PROPERTY_CONTENT_TYPE_TARGET] withSEL:selector withType:PROPERTY_CELL_TYPE_BUTTON withWidth:parentViewWidth withShowBottomLine:showLine]];
            
        } else if ([type isEqualToString:PROPERTY_TYPE_TEXT]) {
            
            [self addSubview:[self propertyView:0 withHeight:COMMUNICATE_PROPERTY_CELL_HEIGHT withTitle:title withDefaultValue:nil withTarget:nil withSEL:Nil withType:PROPERTY_CELL_TYPE_TEXT withWidth:parentViewWidth withShowBottomLine:showLine]];
        }
    }
    return self;
}

-(void)addDefaultLabel:(UILabel *)titleLabel marginX:(int)marginX startY:(int)startY height:(int)height defaultValue:(NSString *)defaultValue button:(UIButton *)button
{
    //---------------------------------------
    int startX =titleLabel.frame.size.width + titleLabel.frame.origin.x + 5;
    int width = self.frame.size.width - startX  - 4*marginX  - 20;
    
    _defalutValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    [_defalutValueLabel setText:defaultValue];
    [_defalutValueLabel setBackgroundColor:TRANSPARENT_COLOR];
    [_defalutValueLabel setTextAlignment:NSTextAlignmentRight];
    //            [defalutValueLabel sizeToFit];
    [_defalutValueLabel setFont:FONT_SYSTEM_SIZE(16)];
    [_defalutValueLabel setTextColor:[UIColor darkGrayColor]];
    
    CGRect rect = _defalutValueLabel.frame;
    rect.origin.y = (height - rect.size.height) / 2.0f;
    rect.origin.x += width - rect.size.width;
    _defalutValueLabel.frame = rect;
    
    [button addSubview:_defalutValueLabel];
//    [defalutValueLabel release];
}

- (UIButton *)propertyView:(int)startY withHeight:(int)height withTitle:(NSString *)title withDefaultValue:(NSString *)defaultValue withTarget:(id)target withSEL:(SEL)sel withType:(enum PROPERTY_CELL_TYPE)type withWidth:(int)parentViewWidth  withShowBottomLine:(BOOL)showLine
{
    int startX = 20;
    int marginX = 5;
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, startY, self.frame.size.width, height);
    
    //----------------title--------------------------
    startY = 0;
    int width = 100;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    [titleLabel setText:title];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setNumberOfLines:1];
    [titleLabel sizeToFit];
    [titleLabel setFont:FONT_SYSTEM_SIZE(16)];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"0x666666"]];
    
    CGRect rect = titleLabel.frame;
    rect.origin.y = (height - rect.size.height) / 2.0f;
    titleLabel.frame = rect;
    
    [button addSubview:titleLabel];
    [titleLabel release];
    
    switch (type) {
        case PROPERTY_CELL_TYPE_BUTTON:
        {
            //--------------------------------------
            [button addTarget:target action:(SEL)sel_getName(sel) forControlEvents:UIControlEventTouchUpInside];
            [self addDefaultLabel:titleLabel marginX:marginX startY:startY height:height defaultValue:defaultValue button:button];
        }
            break;
            
        case PROPERTY_CELL_TYPE_TEXT: {
            
            
            [self addDefaultLabel:titleLabel marginX:marginX startY:startY height:height defaultValue:defaultValue button:button];
            break;
        }
            
        default:
            break;
    }
    //--------------------------------------------
    [button setBackgroundImage:[CommonMethod createImageWithColor:TRANSPARENT_COLOR] forState:UIControlStateNormal];
    [button setBackgroundImage:[CommonMethod createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    
    if (showLine) {
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, height - 1, parentViewWidth - 2, 1)];
        [lineLabel setBackgroundColor:[UIColor colorWithHexString:@"0xcccccc"]];
        [button addSubview:lineLabel];
        [lineLabel release];
    }
    
    return button;
}


- (void)updateDefaultValue:(NSString *)value
{
    _defalutValueLabel.text = value;
}
@end
