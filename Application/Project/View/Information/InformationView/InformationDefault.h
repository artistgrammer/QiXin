//
//  InformationDefault.h
//  Project
//
//  Created by Vshare on 14-4-3.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USEFULL_INFO_CELL_HEIGHT  70.0f

@interface InformationDefault : NSObject


+ (UIButton *)createBtnWithFrame:(CGRect)frame
                       withBGImg:(UIImage *)bgImg
                      withSelImg:(UIImage *)selImg
                       withImage:(UIImage *)img
                  withTitleColor:(UIColor *)color
                        withFont:(UIFont *)font
                         withTag:(int)tag;

+ (UIImageView *)createImgViewWithFrame:(CGRect)frame
                              withImage:(UIImage *)bgImg
                              withColor:(UIColor *)imgColor
                                withTag:(int)tag;

+ (UILabel *)createLblWithFrame:(CGRect)frame
                  withTextColor:(UIColor *)txtColor
                       withFont:(UIFont *)font
                        withTag:(int)tag;

@end
