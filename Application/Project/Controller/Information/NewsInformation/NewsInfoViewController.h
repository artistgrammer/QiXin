//
//  NewsInfoViewController.h
//  Project
//
//  Created by Vshare on 14-4-9.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUNSlideSwitchView.h"
#import "BaseListViewController.h"
#import "NewsListViewController.h"

#define NEWS_TAB_HEIGHT 37.0f

@interface NewsInfoViewController : BaseListViewController<UIScrollViewDelegate,SUNSlideSwitchViewDelegate>
{
    SUNSlideSwitchView *m_tabView;
    UIScrollView *m_tabScroll;
    NSMutableDictionary *m_ListViewDic;
    
}

@property (nonatomic, retain) SUNSlideSwitchView *m_tabView;
@property (nonatomic, retain) UIScrollView *m_tabScroll;
@property (nonatomic, retain) NSMutableDictionary *m_ListViewDic;


- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC;

@end
