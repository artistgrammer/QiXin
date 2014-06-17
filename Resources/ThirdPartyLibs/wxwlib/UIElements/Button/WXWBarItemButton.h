//
//  WXWBarItemButton.h
//  wxwlib
//
//  Created by MobGuang on 13-1-30.
//  Copyright (c) 2013年 MobGuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXWBarItemButton : UIButton {
  @private
  
  BOOL _forBackStyle;
  
  BOOL _onRight;
}

- (id)initBackStyleButtonWithFrame:(CGRect)frame;

- (id)initRightButtonWithFrame:(CGRect)frame
                         title:(NSString *)title
                        target:(id)target
                        action:(SEL)action;

- (id)initLeftButtonWithFrame:(CGRect)frame
                        title:(NSString *)title
                       target:(id)target
                       action:(SEL)action;
@end
