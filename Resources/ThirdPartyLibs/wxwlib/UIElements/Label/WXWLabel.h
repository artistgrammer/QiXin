//
//  WXWLabel.h
//  Project
//
//  Created by Adam on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseConstants.h"
#import "GlobalConstants.h"

@interface WXWLabel : UILabel {
    
    BOOL noShadow;
}

@property (nonatomic, readonly, getter = isNoShadow) BOOL noShadow;

- (id)initWithFrame:(CGRect)frame
          textColor:(UIColor *)textColor
        shadowColor:(UIColor *)shadowColor;

- (id)initWithFrame:(CGRect)frame
          textColor:(UIColor *)textColor
        shadowColor:(UIColor *)shadowColor
               font:(UIFont *)font;


@end
