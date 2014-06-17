//
//  CommonWebViewController.h
//  Project
//
//  Created by Vshare on 14-4-11.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface CommonWebViewController : RootViewController <UIWebViewDelegate>
{
}

@property (nonatomic, retain) NSString *strUrl;
@property (nonatomic, retain) NSString *strTitle;
@property (nonatomic, retain) UIWebView *webView;

- (id)initWithMOC:(NSManagedObjectContext *)MOC;

@end
