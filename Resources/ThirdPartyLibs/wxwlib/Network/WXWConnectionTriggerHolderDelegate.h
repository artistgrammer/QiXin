//
//  WXWConnectionTriggerHolderDelegate.h
//  Project
//
//  Created by Adam on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWAsyncConnectorFacade.h"

@protocol WXWConnectionTriggerHolderDelegate <NSObject>

@required
- (void)registerRequestUrl:(NSString *)url connFacade:(WXWAsyncConnectorFacade *)connFacade;

@end
