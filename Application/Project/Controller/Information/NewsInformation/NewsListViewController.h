//
//  NewsListViewController.h
//  Project
//
//  Created by Vshare on 14-4-9.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListViewController.h"
#import "ImageWallScrollView.h"
#import "UsefullInfoTableViewCell.h"

#define IMG_SCROLL_HEIGHT  185.0f

@interface NewsListViewController :BaseListViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ImageWallDelegate>
{
    UITableView *m_newsListTable;
    UIScrollView *m_newsScroll;
    NSMutableDictionary *m_dataDic;
    ImageWallScrollView *m_imgScroll;
    
    float m_tabHeight;
    int m_type;
}

@property (nonatomic, retain) UITableView *m_newsListTable;
@property (nonatomic, retain) UIScrollView *m_newsScroll;
@property (nonatomic, retain) NSMutableDictionary *m_dataDic;

- (id)initWithListType:(int)type withData:(NSDictionary *)dic withHeight:(float)tabHeight;

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew;

- (void)loadInfoListData;

@end
