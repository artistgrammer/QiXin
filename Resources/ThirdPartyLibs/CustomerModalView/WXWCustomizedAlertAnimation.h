//
//  WXWCustomizedAlertAnimation.h
//  Project
//
//  Created by Adam on 13-9-30.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ALERT_DONE_TYPE_CANCEL = 1,
    ALERT_DONE_TYPE_OK = 2,
    ALERT_DONE_TYPE_OPTION = 3,
} AlertDoneType;

@protocol WXWCustomizedAlertAnimationDelegate;


@interface WXWCustomizedAlertAnimation : NSObject

@property (strong, nonatomic) UIView *view;
@property (assign, nonatomic) AlertDoneType type;
@property (assign, nonatomic) id<WXWCustomizedAlertAnimationDelegate> delegate;

-(id)customizedAlertAnimationWithUIview:(UIView *)v;

-(void)showAlertAnimation;

-(void)dismissAlertAnimation:(AlertDoneType)type;
@end



@protocol WXWCustomizedAlertAnimationDelegate

-(void)showCustomizedAlertAnimationIsOverWithUIView:(UIView *)v;

-(void)dismissCustomizedAlertAnimationIsOverWithUIView:(UIView *)v type:(AlertDoneType)type;
@end