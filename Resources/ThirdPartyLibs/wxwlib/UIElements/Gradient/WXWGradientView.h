//
//  WXWGradientView.h
//  Project
//
//  Created by Adam on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseConstants.h"

@interface WXWGradientView : UIView {
  
}

- (id)initWithFrame:(CGRect)frame topColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;

- (void)drawWithTopColor:(UIColor *)topColor
             bottomColor:(UIColor *)bottomColor;
@end
