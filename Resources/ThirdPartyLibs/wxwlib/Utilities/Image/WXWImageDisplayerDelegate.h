//
//  WXWImageDisplayerDelegate.h
//  Project
//
//  Created by Adam on 11-11-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WXWImageDisplayerDelegate <NSObject>

@optional
- (void)saveDisplayedImage:(UIImage *)image;

@required
- (void)registerImageUrl:(NSString *)url;

@end
