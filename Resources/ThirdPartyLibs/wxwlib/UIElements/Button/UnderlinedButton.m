//
//  UnderlinedButton.m
//  EMBAUnion
//
//  Created by MobGuang on 13-4-17.
//
//

#import "UnderlinedButton.h"

@implementation UnderlinedButton


- (void)drawRect:(CGRect)rect {
  CGRect textRect = self.titleLabel.frame;
  
  CGFloat descender = self.titleLabel.font.descender;
  
  CGContextRef contextRef = UIGraphicsGetCurrentContext();
  
  CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
  
  CGFloat y = textRect.origin.y + textRect.size.height + descender;
  
  CGContextMoveToPoint(contextRef, textRect.origin.x, y);
  CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, y);
  
  CGContextClosePath(contextRef);
  
  CGContextDrawPath(contextRef, kCGPathStroke);
}


@end
