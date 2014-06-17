//
//  ECTextBoardCell.h
//  ExpatCircle
//
//  Created by Mobguang on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXWLabel.h"
#import "TextConstants.h"

@interface ECTextBoardCell : UITableViewCell {
  @private
  NSMutableArray *_labelsContainer;
}

- (WXWLabel *)initLabel:(CGRect)frame 
             textColor:(UIColor *)textColor 
           shadowColor:(UIColor *)shadowColor;

@end
