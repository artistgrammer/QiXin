//
//  InformationDefault.m
//  Project
//
//  Created by Vshare on 14-4-3.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "InformationDefault.h"

@implementation InformationDefault


+ (UIButton *)createBtnWithFrame:(CGRect)frame withBGImg:(UIImage *)bgImg  withSelImg:(UIImage *)selImg  withImage:(UIImage *)img withTitleColor:(UIColor *)color withFont:(UIFont *)font withTag:(int)tag
{
    UIButton *btn = [[[UIButton alloc]initWithFrame:frame] autorelease];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setBackgroundImage:bgImg forState:UIControlStateNormal];
    [btn setBackgroundImage:selImg forState:UIControlStateSelected];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn.titleLabel setFont:font];
    [btn setTag:tag];
    return btn;
}

+ (UIImageView *)createImgViewWithFrame:(CGRect)frame withImage:(UIImage *)bgImg  withColor:(UIColor *)imgColor withTag:(int)tag
{
    UIImageView *image = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    [image setImage:bgImg];
    [image setTag:tag];
    [image setBackgroundColor:imgColor];
    [image setUserInteractionEnabled:YES];
    
    return image;
}

+ (UILabel *)createLblWithFrame:(CGRect)frame withTextColor:(UIColor *)txtColor withFont:(UIFont *)font withTag:(int)tag
{
    UILabel *lbl = [[[UILabel alloc]initWithFrame:frame]autorelease];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:txtColor];
    [lbl setTag:tag];
    [lbl setFont:font];
    return lbl;
}

@end
