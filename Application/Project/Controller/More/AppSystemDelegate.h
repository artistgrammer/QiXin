//
//  ECAppSystemDelegate.h
//  Project
//
//  Created by Vshare on 14-4-23.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AppSettingDelegate <NSObject>

@optional
- (void)triggerReloadForLanguageSwitch;
- (void)languageSwitchDone;

@end