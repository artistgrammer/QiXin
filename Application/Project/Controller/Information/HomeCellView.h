//
//  HomeCellVIew.h
//  Project
//
//  Created by Vshare on 14-4-22.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    HOME_CELL_TITLE = 1,
    HOME_CELL_MESSGAE,
    HOME_CELL_ICONIMG,
}HomeCellType;

@interface HomeCellView : UIImageView
{
    id  _target;
    SEL _action;
}

@property (nonatomic, retain) UILabel *m_titleLbl;
@property (nonatomic, retain) UILabel *m_msgLbl;
@property (nonatomic, retain) UIImageView *m_imgView;

- (id)initWithFrame:(CGRect)frame withTarget:(id)target withAction:(SEL)action;

@end
