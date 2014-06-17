//
//  MapAnnoationTitleView.h
//  Aladdin
//
//  Created by Peter on 14-3-3.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXWLabel.h"

@interface MapAnnoationTitleView : UIView

@property (nonatomic, assign) WXWLabel *titleLabel;
@property (nonatomic, assign) WXWLabel *subTitleLabel;

-(id)initWithTitle:(CGRect )rect title:(NSString *)title subTitle:(NSString *)subTitle;

@end
