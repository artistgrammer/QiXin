//
//  UIMenuItem.m
//  TesdXcodeUserGuideDemo
//
//  Created by xd.su on 13-2-19.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

#import "UIMenuBarItem.h"
#import <QuartzCore/QuartzCore.h>


#define kWidthGap 20.0f
#define kOneLineCount 4

@interface UIMenuBarItem ()

- (void)setup;
- (void)layOutSubviews;

@end

@implementation UIMenuBarItem

@synthesize title = _title;
@synthesize image = _image;
@synthesize action = _action;
@synthesize containView = _containView;
@synthesize sizeValue = _sizeValue;

- (id)initWithTitle:(NSString *)title
             target:(id)target
              image:(UIImage *)image
             action:(SEL)action
{
    if(self = [super init]){
        
        _title = [[NSString stringWithFormat:@"%@", title] retain];
        _image = [[UIImage imageWithCGImage:image.CGImage] retain];
        _action = action;
        _target = [target retain];
        
        _containView = [[UIControl alloc] initWithFrame:CGRectZero];
        [_containView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        _imageView = [[UIImageView alloc] initWithImage:image];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:13.f];
        _titleLabel.text = title;
        
        [_containView addSubview:_imageView];
        [_containView addSubview:_titleLabel];
        
        _sizeValue = ([UIScreen mainScreen].bounds.size.width - (kOneLineCount + 1)*kWidthGap)/kOneLineCount;
        
        [self setup];
        
    }
    return self;
}

- (void)setup
{
    _containView.backgroundColor = [UIColor clearColor];
    
    [_containView addTarget:self
                     action:@selector(addHighlight)
           forControlEvents: UIControlEventTouchDown];
    
    [_containView addTarget:self
                     action:@selector(removeHighlight)
           forControlEvents: UIControlEventTouchCancel | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [self layOutSubviews];
    
}

- (void)addHighlight
{
    _containView.backgroundColor = [UIColor clearColor];
}

- (void)removeHighlight
{
    _containView.backgroundColor = [UIColor clearColor];
}



- (void)layOutSubviews
{
    _containView.frame = CGRectMake(0, 0, _sizeValue, _sizeValue + 24);
    //_containView.layer.borderWidth = 1.0f;
    //_containView.layer.borderColor = [[UIColor orangeColor] CGColor];
    _imageView.center = CGPointMake(_containView.center.x,
                                    _sizeValue/2);
    
    _titleLabel.frame = CGRectMake(2,
                                   _containView.bounds.size.height-13.0f,
                                   _containView.bounds.size.width-4,
                                   13.0f);
    
}


- (void)dealloc
{
    [_title release], _title = nil;
    [_image release], _image = nil;
    [_target release], _target = nil;
    [_containView release], _containView = nil;
    [_imageView release], _imageView = nil;
    [_titleLabel release], _titleLabel = nil;
    [super dealloc];
}

@end
