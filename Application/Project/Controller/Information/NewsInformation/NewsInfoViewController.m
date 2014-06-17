//
//  NewsInfoViewController.m
//  Project
//
//  Created by Vshare on 14-4-9.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "NewsInfoViewController.h"

@interface NewsInfoViewController ()

@end

@implementation NewsInfoViewController
@synthesize m_tabView;
@synthesize m_tabScroll;
@synthesize m_ListViewDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"资讯";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC {
    
    self = [super initWithMOC:MOC
        needRefreshHeaderView:YES
        needRefreshFooterView:YES];
    
    if (self) {
        self.parentVC = pVC;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_ListViewDic = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setScrollContentView];
    
    [self.view addSubview:[self setTabView]];
    
    
    /*
    [self.view addSubview:[self setTabScroll]];
    [self setScrollContentData];
     */
}

#pragma mark - create Control

- (SUNSlideSwitchView *)setTabView
{
    self.m_tabView = [[[SUNSlideSwitchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)] autorelease];
    self.m_tabView.tabItemNormalColor = [UIColor grayColor];
    self.m_tabView.tabItemSelectedColor = [UIColor grayColor];
    self.m_tabView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    self.m_tabView.m_tabArr = [[[NSMutableArray alloc] initWithObjects:@"全部",@"热门",@"科技",@"财经", nil]autorelease];
    self.m_tabView.slideSwitchViewDelegate = self;
    [m_tabView  buildUI];
    
    return self.m_tabView;
}


- (void)setScrollContentView
{
    for (int i = 0; i < 4; i ++)
    {
        int tag = 10 + i;
        NewsListViewController *newList = [[NewsListViewController alloc] initWithListType:tag withData:nil withHeight:SCREEN_HEIGHT - 64.0 - 37.0];
        [m_ListViewDic setObject:newList forKey:[NSNumber numberWithInt:tag]];
    }
}

/*
- (UIScrollView *)setTabScroll
{
    self.m_tabScroll = [[[UIScrollView alloc]initWithFrame:CGRectMake(0, NEWS_TAB_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NEWS_TAB_HEIGHT)]autorelease];
    [m_tabScroll setPagingEnabled:YES];
    [m_tabScroll setBackgroundColor:[UIColor clearColor]];
    [m_tabScroll setShowsHorizontalScrollIndicator:NO];
    [m_tabScroll setShowsVerticalScrollIndicator:NO];
    [m_tabScroll setDelegate:self];

    return self.m_tabScroll;
}

- (void)setScrollContentData
{
    for (int i = 0; i < 4; i++)
    {
        int tag = 10+ i;
        NewsListViewController *newsListView = [[NewsListViewController alloc]initWithListType:10 withData:nil withHeight:SCREEN_HEIGHT - NEWS_TAB_HEIGHT];
        [self addChildViewController:newsListView];
        [newsListView.view setTag:tag];
        [newsListView.view setFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NEWS_TAB_HEIGHT)];
        
        NSLog(@"SCREEN_HEIGHT - NEWS_TAB_HEIGHT == %f",SCREEN_HEIGHT - NEWS_TAB_HEIGHT);
        [m_tabScroll addSubview:newsListView.view];
        
    }
    [self.m_tabScroll setContentSize:CGSizeMake(SCREEN_WIDTH *4,  SCREEN_HEIGHT - NEWS_TAB_HEIGHT)];
}
 */

#pragma mark - SUNSlideSwitch Delegate Methods
- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return 4;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    NewsListViewController *listView = (NewsListViewController *)[m_ListViewDic objectForKey:[NSNumber numberWithInt:number + 10]];
    return listView;
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    NewsListViewController *currentView = nil;
    currentView = (NewsListViewController *)[m_ListViewDic objectForKey:[NSNumber numberWithInt:number + 10]];
    
    [currentView loadInfoListData];
    NSLog(@"number == %d",number);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
