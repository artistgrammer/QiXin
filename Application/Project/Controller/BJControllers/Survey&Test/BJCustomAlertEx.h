//
//  BJCustomAlertEx.h
//  Project
//
//  Created by sun art on 14-6-10.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol BJCustomAlertExDelegate <NSObject>
@optional
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface BJCustomAlertEx : UIAlertView {
    id  BJdelegate;
	UIImage *backgroundImage;
    UIImage *contentImage;
    NSMutableArray *_buttonArrays;
    
}

@property(readwrite, retain) UIImage *backgroundImage;
@property(readwrite, retain) UIImage *contentImage;
@property(nonatomic, assign) id BJdelegate;
- (id)initWithImage:(UIImage *)image contentImage:(UIImage *)content;
-(void) addButtonWithUIButton:(UIButton *) btn;
@end