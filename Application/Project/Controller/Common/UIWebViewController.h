//
//  UIWebViewController.h
//  Module
//
//  Created by Adam on 14-1-14.
//  Copyright (c) 2012年 _MyCompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface UIWebViewController : RootViewController <UIWebViewDelegate,UIActionSheetDelegate>
{
    NSString *strUrl;
    NSString *strTitle;
    
    UIWebView *_webView;
}

@property (nonatomic, assign) BOOL needBackImag;
@property (nonatomic, retain) NSString *strUrl;
@property (nonatomic, retain) NSString *strTitle;
@property (nonatomic, assign) BOOL needShowImageSave;

@end
