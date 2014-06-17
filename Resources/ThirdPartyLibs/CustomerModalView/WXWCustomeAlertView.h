//
//  WXWCustomeAlertView.h
//  Project
//
//  Created by Adam on 13-9-30.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

#import "WXWCustomizedAlertAnimation.h"

#define CUSTOMIZED_COLOR        @"color"
#define CUSTOMIZED_TIP          @"tip"
#define CUSTOMIZED_TIP_ARRAY    @"tipArray"
#define CUSTOMIZED_TITLE        @"title"

@protocol WXWCustomeAlertViewDelegate ;

@interface WXWCustomeAlertView : UIWindow  <WXWCustomizedAlertAnimationDelegate>

@property(strong,nonatomic)UIView *myView;
@property(strong,nonatomic)UIActivityIndicatorView *activityIndicator;
@property(strong,nonatomic)WXWCustomizedAlertAnimation *animation;
@property(assign,nonatomic)id<WXWCustomeAlertViewDelegate> delegate;

- (void)show;


- (void)updateInfo:(NSDictionary *)info;
- (void)updateInfoWithColor:(NSDictionary *)info;

@end


@protocol WXWCustomeAlertViewDelegate

- (void)CustomeAlertViewDismiss:(WXWCustomeAlertView *) alertView;

@end
