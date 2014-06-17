//
//  ImageObject.m
//  EMBAUnion
//
//  Created by MobGuang on 13-4-26.
//
//

#import "ImageObject.h"

@implementation ImageObject


- (void)dealloc {
  
  self.thumbnailUrl = nil;
  self.middleUrl = nil;
  self.originalUrl = nil;
  
  [super dealloc];
}

@end
