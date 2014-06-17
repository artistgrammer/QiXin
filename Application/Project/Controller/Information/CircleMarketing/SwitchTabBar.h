//
//  SwitchTabBar.h
//  Project
//
//  Created by Yfeng__ on 13-10-25.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchTabBarDelegate <NSObject>

- (void)tabBarSelectedAtIndex:(int)index;

@optional
- (UIColor *)selectedButtonTextColor;
- (UIColor *)selectedButtonColor;
- (NSInteger)badgeNumber;

@end

@interface SwitchTabBar : UIView


@property (nonatomic, assign) id<SwitchTabBarDelegate> delegate;

- (id)initWithFrame:(CGRect)frame
         titleArray:(NSArray *)arr
   hasSeparatorLine:(BOOL)hasSeparatorLine;

- (id)initWithFrame:(CGRect)frame
         titleArray:(NSArray *)arr
   hasSeparatorLine:(BOOL)hasSeparatorLine
           delegate:(id)delegate;

- (id)initWithFrame:(CGRect)frame
         titleArray:(NSArray *)arr
   hasSeparatorLine:(BOOL)hasSeparatorLine
           delegate:(id)delegate
          showBadge:(BOOL)showBadge;

- (void)setBadgeWithCount:(int)count index:(int)index;

@end
