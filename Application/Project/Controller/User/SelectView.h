//
//  SelectView.h
//  Project
//
//  Created by VShare on 13-8-11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectViewDelegate;

@interface SelectView : UIControl <UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _data;
    UIImageView * _imgView;
    
    NSMutableArray *_tipArr;
    
    BOOL _isScroll;
    CGRect _visibleFrame;
    
    __weak id<SelectViewDelegate> selectViewDelegate;
}
@property(nonatomic,weak) id<SelectViewDelegate> selectViewDelegate;
@property(nonatomic,retain) UITableView * _tableView;
@property(nonatomic,retain) UIImageView * _imgView;
@property(nonatomic,retain) NSMutableArray * _data;
@property(nonatomic,retain) NSMutableArray * _tipArr;
@property(nonatomic,retain) NSString * _title;
@property(nonatomic,retain) UIImage * _tipIcon;
@property(nonatomic,assign) CGRect _visibleFrame;
@property(nonatomic,assign) BOOL _isScroll;

-(id)initWithData:(NSMutableArray *)data Frame:(CGRect)frame TipIcon:(NSMutableArray *)tipIcon Delegate:(id<SelectViewDelegate>)delegate canScroll:(BOOL)isScroll;

-(void)showView;

- (void)setBackView:(UIImage *)bgImg;
@end


@protocol SelectViewDelegate <NSObject>

@optional

- (void)selectWithData:(NSString *)data withIndex:(int)index;

@end