//
//  SelectView.m
//  Project
//
//  Created by VShare on 13-8-11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "SelectView.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectViewCell.h"

@implementation SelectView

#define GAP 38.0f
#define CELLHEIGHT 45.0f

@synthesize _tableView;
@synthesize _imgView;
@synthesize _data;
@synthesize _tipIcon;
@synthesize _visibleFrame;
@synthesize _isScroll;
@synthesize _tipArr;
@synthesize selectViewDelegate;

- (id)initWithData:(NSMutableArray *)data Frame:(CGRect)frame TipIcon:(NSMutableArray *)tipArr Delegate:(id<SelectViewDelegate>)delegate canScroll:(BOOL)isScroll
{
    self = [super init];
    if (self) {
        
        [self set_data:data];
        [self set_isScroll:isScroll];
        [self set_tipArr:tipArr];
        [self set_visibleFrame:frame];
        [self setSelectViewDelegate:delegate];
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return self;
}

-(void)showView
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [self addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchDown];
//    [self setBackgroundColor:[UIColor colorWithRed:.16 green:.17 blue:.21 alpha:0.5]];
    [self setBackgroundColor:[UIColor clearColor]];
    [keyWindow addSubview:self];
    
    [self addSubview:[self setBackgroundView]];

    [_imgView addSubview:[self setSelectTable]];
    
    [self setExtraCellLineHidden:_tableView];
}


- (UIImageView *)setBackgroundView
{
    _imgView = [[UIImageView alloc] initWithFrame:_visibleFrame];
    [_imgView setUserInteractionEnabled:YES];
    [_imgView setBackgroundColor:[UIColor colorWithRed:.16 green:.17 blue:.21 alpha:1.0]];
    return _imgView;
}

- (void)setBackView:(UIImage *)bgImg
{
    if (bgImg) {
        [_imgView setImage:[bgImg stretchableImageWithLeftCapWidth:20 topCapHeight:35]];
        [_imgView setBackgroundColor:[UIColor clearColor]];
        [_imgView setAlpha:1.0f];
        [_tableView setSeparatorColor:[UIColor clearColor]];
    }
}

- (UITableView *)setSelectTable
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView setSeparatorColor:[UIColor blackColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 5, 0, 5)];
    [_tableView setFrame:CGRectMake(0, 0, _visibleFrame.size.width, _visibleFrame.size.height)];
    [_tableView setScrollEnabled:_isScroll];
    return _tableView;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[[[UIView alloc]init]autorelease];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}


-(void)hideView
{
    [self removeFromSuperview];
}

#pragma mark - TableDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SELECTCELL";
    SelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[[SelectViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    UIImage *img = [UIImage imageNamed:[_tipArr objectAtIndex:[indexPath row]]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell updataCellData:img withContent:[_data objectAtIndex:[indexPath row]] withWidth:_visibleFrame.size.width - 10];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectViewDelegate && [selectViewDelegate respondsToSelector:@selector(selectWithData:withIndex:)])
    {
        [selectViewDelegate selectWithData:[_data objectAtIndex:indexPath.row] withIndex:[indexPath row]];
    }
    [self hideView];
}

- (UIImageView *)seperateImgView
{
    UIImageView *seperateView = [[[UIImageView alloc] init]autorelease];
    [seperateView setTag:1001];
    [seperateView setBackgroundColor:[UIColor blackColor]];
    [seperateView setBounds:CGRectMake(0, 0, _tableView.frame.size.width, 0.5)];
    [seperateView setCenter:CGPointMake(_tableView.frame.size.width/2, CELLHEIGHT - seperateView.bounds.size.height/2)];
    return seperateView;
}

-(void)dealloc
{
    [_tableView release],_tableView = nil;
    [_data release],_data = nil;
    [selectViewDelegate release], selectViewDelegate = nil;
    [_imgView release],_imgView = nil;
    [_tipIcon release],_tipIcon = nil;
    [super dealloc];
}

@end
