//
//  SearchUserCellView.h
//  Project
//
//  Created by XXX on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationDefault.h"


@interface SearchUserCellView : UIView {
    @private
    
    id  _target;
    SEL _action;
}

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

@end
