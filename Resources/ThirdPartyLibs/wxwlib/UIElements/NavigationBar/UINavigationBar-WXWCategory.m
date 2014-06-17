//
//  UINavigationBar-WXWCategory.m
//  wxwlib
//
//  Created by MobGuang on 13-1-10.
//  Copyright (c) 2013年 MobGuang. All rights reserved.
//

#import "UINavigationBar-WXWCategory.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationBar (WXWCategory)

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColor(context, CGColorGetComponents(NAVIGATION_BAR_COLOR.CGColor));
  CGContextFillRect(context, rect);
  self.tintColor = NAVIGATION_BAR_COLOR;
}

@end
