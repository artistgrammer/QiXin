//
//  BJMenu.m
//  Project
//
//  Created by sun art on 14-6-12.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJMenuView.h"

@implementation BJMenuView {
    NSDictionary *_menuItems;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touched = [[touches anyObject] view];
    if (touched == self) {
        
        for (UIView *v in self.subviews) {
            if ([v isKindOfClass:[BJMenuView class]]
                && [v respondsToSelector:@selector(dismissMenu:)]) {
                
                [v performSelector:@selector(dismissMenu:) withObject:@(YES)];
            }
        }
    }
}

- (void)dismissMenu:(BOOL) animated
{
    if (self.superview) {
        
        if (animated) {
            
            self.hidden = YES;
            const CGRect toFrame = (CGRect){self.frame.origin, 1, 1};
            
            [UIView animateWithDuration:0.2
                             animations:^(void) {
                                 
                                 self.alpha = 0;
                                 self.frame = toFrame;
                                 
                             } completion:^(BOOL finished) {
                                 [self removeFromSuperview];
                             }];
            
        } else {
            [self removeFromSuperview];
        }
    }
}

@end
