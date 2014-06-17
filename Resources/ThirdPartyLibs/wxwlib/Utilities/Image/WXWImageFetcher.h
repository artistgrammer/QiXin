//
//  WXWImageFetcher.h
//  Project
//
//  Created by Adam on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWConnector.h"

@interface WXWImageFetcher : WXWConnector {
  @private
  NSMutableDictionary *_urlDic;
}

- (void)fetchImage:(NSString *)url showAlertMsg:(BOOL)showAlertMsg;
- (BOOL)imageBeingLoaded:(NSString *)url;
@end
