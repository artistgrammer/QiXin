//
//  NewsListViewController.m
//  Project
//
//  Created by Vshare on 14-4-9.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "NewsListViewController.h"
#import "WXWCoreDataUtils.h"
#import "TradeInformationContentViewController.h"
#import "MessageListController.h"

#define NEWS_CELL_HEIGHT 70.0f

@interface NewsListViewController ()

@end

@implementation NewsListViewController
@synthesize m_newsListTable;
@synthesize m_newsScroll;
@synthesize m_dataDic;


- (id)initWithListType:(int)type withData:(NSDictionary *)dic withHeight:(float)tabHeight
{
    self = [super init];
    if (self)
    {
        m_type = type;
        self.m_dataDic = [[[NSMutableDictionary alloc]initWithDictionary:dic]autorelease];
        m_tabHeight = tabHeight;
    }
    return self;
}


- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    
}

- (void)loadInfoListData
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:[self setListScroll]];
    
    [self.m_newsScroll addSubview:[self initImgScrollView]];
    [self.m_newsScroll addSubview:[self createNewsListTable]];
    [self.m_newsScroll setContentSize:CGSizeMake(SCREEN_WIDTH, IMG_SCROLL_HEIGHT + NEWS_CELL_HEIGHT*6)];
}

#pragma mark - create Control

- (UITableView *)createNewsListTable
{
    self.m_newsListTable = [[[UITableView alloc]initWithFrame:CGRectMake(0, IMG_SCROLL_HEIGHT, SCREEN_WIDTH, NEWS_CELL_HEIGHT*6) style:UITableViewStylePlain]autorelease];
    [m_newsListTable setBackgroundColor:[UIColor clearColor]];
    [m_newsListTable setDataSource:self];
    [m_newsListTable setDelegate:self];
    [m_newsListTable setShowsHorizontalScrollIndicator:NO];
    [m_newsListTable setShowsVerticalScrollIndicator:NO];
    [m_newsListTable setMultipleTouchEnabled:NO];
    [m_newsListTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [m_newsListTable setScrollEnabled:NO];
    return self.m_newsListTable;
}

- (UIScrollView *)setListScroll
{
    self.m_newsScroll = [[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, m_tabHeight)]autorelease];
    [m_newsScroll setPagingEnabled:NO];
    [m_newsScroll setBackgroundColor:[UIColor clearColor]];
    [m_newsScroll setShowsHorizontalScrollIndicator:NO];
    [m_newsScroll setShowsVerticalScrollIndicator:NO];
    [m_newsScroll setDelegate:self];
    
    return  m_newsScroll;
}


-(ImageWallScrollView *)initImgScrollView
{
    NSArray *imgArr = [[NSArray alloc]initWithObjects:@"http://c.hiphotos.baidu.com/image/w%3D1280%3Bcrop%3D0%2C0%2C1280%2C768/sign=7cca3a068594a4c20a23e32936c420b6/2cf5e0fe9925bc31f622da915cdf8db1cb1370b8.jpg",
                              @"http://h.hiphotos.baidu.com/image/w%3D1280%3Bcrop%3D0%2C0%2C1280%2C768/sign=f4d15c7f7af0f736d8fe48033265887a/6609c93d70cf3bc7c088a7ecd300baa1cd112a21.jpg",
                              @"http://e.hiphotos.baidu.com/image/w%3D2048/sign=3eb54a05ca95d143da76e32347c88202/dbb44aed2e738bd4cf0e1437a38b87d6277ff98d.jpg", nil];
    
    CGRect  scrollRect = CGRectMake(0, 0 , SCREEN_WIDTH, IMG_SCROLL_HEIGHT);
    m_imgScroll = [[ImageWallScrollView alloc] initWithFrame:scrollRect backgroundImage:@"defaultLoadingImage.png"];
    m_imgScroll.delegate = self;
    m_imgScroll.autoPlay = YES;
    m_imgScroll.autoScrollDelayTime = 2.0;
    
    [m_imgScroll updateImageListArray:imgArr];
    
    return m_imgScroll;
}

- (void)clickedImage
{
    
     [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:@"制作中，敬请期待" delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles:nil] autorelease] show];
    /*
    TradeInformationContentViewController *vc = [[[TradeInformationContentViewController alloc] initWithMOC:_MOC parentVC:self specialId:348] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];*/
}


#pragma mark - TableView  Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NEWS_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self drawNewsCellContentView:tableView atIndexPath:indexPath];
}

- (UsefullInfoTableViewCell *)drawNewsCellContentView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"NEWS_CONTENT_ID";
    UsefullInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (nil == cell)
    {
        cell = [[[UsefullInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:kCellIdentifier] autorelease];
    }
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell updataCellData:nil];
    
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     MessageListController *addressVC = [[MessageListController alloc]initWithMOC:_MOC parentVC:self];
     [CommonMethod pushViewController:addressVC withAnimated:YES];
}


#pragma mark - Request/Response Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
