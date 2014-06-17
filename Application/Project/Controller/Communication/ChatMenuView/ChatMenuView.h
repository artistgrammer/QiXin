//
//  ChatMenuView.h
//  Association
//
//  Created by Vshare on 14-4-30.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    CHAT_PHOTOLIB_TAG = 100,
    CHAT_CAMERA_TAG,
    CHAT_LOCATION_TAG,
    CHAT_DOCUMENT_TAG,
} ChatActionType;

@protocol ChatMenuViewDelegate <NSObject>

- (void)chatMenuClick:(int)index;

@end

@interface ChatMenuView : UIView
{
    id<ChatMenuViewDelegate> menuViewDelegate;
}

@property (nonatomic, retain) id<ChatMenuViewDelegate>menuViewDelegate;

- (id)initWithFrame:(CGRect)frame;

@end
