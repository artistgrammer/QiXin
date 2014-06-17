//
//  BJLibarysSecViewController.m
//  Project
//
//  Created by sun art on 14-6-3.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJLibarysSecViewController.h"
#import "BJLibaryIntroViewController.h"
#import "UIImageView+WebCache.h"
@implementation BJLibaryItem

@synthesize avg_score = _avg_score;
@synthesize comment_count = _comment_count;
@synthesize icon_file = _icon_file;
@synthesize libraryID = _libraryID;
@synthesize learner_count = _learner_count;
@synthesize min_band = _min_band;
@synthesize topic = _topic;
@synthesize competencyID = _competencyID;
@synthesize competencyValue = _competencyValue;
@synthesize competencyRef = _competencyRef;
@synthesize intruduction = _intruduction;

- (void)dealloc
{
    [_icon_file release];
    [_topic release];
    [_competencyRef release];
    [_intruduction release];
    
    [super dealloc];
}

@end

@implementation BJLibaryImageView

@synthesize mImageview = _mImageview;
@synthesize mContentItem = _mContentItem;

#pragma mark - for gesture
- (void)addTapGestureRecognizer{
    UITapGestureRecognizer *swipeGR = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(imageviewTouchEvents:)] autorelease];
    swipeGR.delegate = self;
    
    [_mImageview addGestureRecognizer:swipeGR];
}

-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *view = (UIImageView*)[gestureRecognizer view];
    int tagvalue = view.tag;
    
    DLog(@"%d is touched",tagvalue);
    if (14 == tagvalue) {
        BJLibaryIntroViewController *libaryIntroVC = [[BJLibaryIntroViewController alloc] initWithNibName:@"BJLibaryIntroViewController" bundle:nil moc:((ProjectAppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext];
        libaryIntroVC.mCurrentLibraryItem = _mContentItem;
        [CommonMethod pushViewController:libaryIntroVC  withAnimated:YES];
        [libaryIntroVC release];
    }else if (15 == tagvalue)
    {
        BJLibaryIntroViewController *libaryIntroVC = [[BJLibaryIntroViewController alloc] initWithNibName:@"BJLibaryIntroViewController" bundle:nil moc:((ProjectAppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext];
                libaryIntroVC.mCurrentLibraryItem = _mContentItem;
        [CommonMethod pushViewController:libaryIntroVC  withAnimated:YES];
        [libaryIntroVC release];
    }
}

- (void)dealloc
{
    [_mImageview release];
    [_mContentItem release];
    
    [super dealloc];
}

@end

@interface BJLibarysSecViewController ()
{
    
}
@end

@implementation BJLibarysSecViewController

@synthesize mTitleImageview;
@synthesize mTrainingImageview;
@synthesize mLibraryImageview;
@synthesize mPowerhourImageview;
@synthesize mSurveyImageview;
@synthesize mCoachImageview;
@synthesize mRankingImageview;
@synthesize mPromptImageview;

@synthesize mTableviewCell = _mTableviewCell;

@synthesize mApplyButton = _mApplyButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC
{
    self = [super initWithMOC:viewMOC needRefreshHeaderView:YES needRefreshFooterView:YES tableStyle:UITableViewStyleGrouped];
    if (self) {
        _noNeedBackButton = NO;
        //        self.view = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil].view;
        
        mTitleImageview.tag = 0;
        mTrainingImageview.tag = 1;
        mLibraryImageview.tag = 2;
        mPowerhourImageview.tag = 3;
        mSurveyImageview.tag = 4;
        mCoachImageview.tag = 5;
        mRankingImageview.tag = 6;
        mPromptImageview.tag = 7;
        
        libraryArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)refreshTable {
    
    //    [self fetchContentFromMOC];
    [_tableView reloadData];
    
}

- (IBAction)buttonAction:(id)sender
{
    //    BJApplyCourseViewController* courseDetailViewCtrl= [[BJApplyCourseViewController alloc] initWithNibName:@"BJApplyCourseViewController" bundle:nil moc:[CommonMethod getInstance].MOC];
    //
    //    [CommonMethod pushViewController:courseDetailViewCtrl  withAnimated:YES];
    //    [courseDetailViewCtrl release];
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
{
    
    self = [super initWithMOC:MOC];
    if (self) {
        _noNeedBackButton = NO;
    }
    return self;
    
}

- (void)adjustTableLayout {
    int navH = self.navigationController.navigationBar.frame.size.height;
    
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - navH - HOMEPAGE_TAB_HEIGHT);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadAllLibrarys];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int navH = self.navigationController.navigationBar.frame.size.height;
    self.view.frame = CGRectMake(0,
                                 navH,
                                 SCREEN_WIDTH,
                                 SCREEN_HEIGHT - navH);
    
    self.navigationItem.title = @"Libary";
    
    //        if ([WXWCommonUtils currentOSVersion] < IOS7) {
    //            self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    //        }
    //
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    [self adjustTableLayout];
    
    [self refreshTable];
    
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"ALL",@"My bookshelf",nil];
    
    //初始化UISegmentedControl
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    [segmentedArray release];
    
    segmentedControl.frame = CGRectMake((SCREEN_WIDTH-250)/2, self.tableView.frame.size.height + 5, 250.0, HOMEPAGE_TAB_HEIGHT - 10);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = [UIColor redColor];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;//设置样式
    //  segmentedControl.momentary = YES;//设置在点击后是否恢复原样

    //添加委托方法
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentedControl];
    [segmentedControl release];
    
    
    int gap = 5;
    int leftrightW = 60;
    
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [titleView setBackgroundColor:[UIColor blackColor]];
    titleView.alpha = 0.5f;
    
    UIButton *_filterButton = [[UIButton alloc] initWithFrame:CGRectMake(gap, gap, leftrightW, 20)];
    
    [_filterButton setBackgroundColor:[UIColor clearColor]];
    [_filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    [_filterButton setTitle:@"Filter" forState:UIControlStateHighlighted];
    [_filterButton setTitle:@"Filter" forState:UIControlStateSelected];
    _filterButton.titleLabel.font=[UIFont systemFontOfSize:20];
    [_filterButton.titleLabel setTextColor:[UIColor whiteColor]];
    
    [_filterButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _filterButton.tag = 0;
    [titleView addSubview:_filterButton];
    [_filterButton release];
    
    
    UIButton *yeardayBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-leftrightW*2-gap*2,gap,leftrightW*2+2*gap,20)];
    
    [yeardayBtn setBackgroundColor:[UIColor clearColor]];
    
    [yeardayBtn setTitle:@"Default sort" forState:UIControlStateNormal];
    [yeardayBtn setTitle:@"Default sort" forState:UIControlStateHighlighted];
    [yeardayBtn setTitle:@"Default sort" forState:UIControlStateSelected];
    yeardayBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [yeardayBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [yeardayBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    yeardayBtn.tag = 1;
    [titleView addSubview:yeardayBtn];
    [yeardayBtn release];
    
    [self.view addSubview:titleView];
    [titleView release];
}

//具体委托方法实例
-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %i", Index);
    switch (Index) {
        case 0:
            
            break;
        default:
            
            break;
            
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
	NSLog(@"didselect = %d",row);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [libraryArray count]/2/*CELL_COUNT**/;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CustomCellIdentifier =@"BJLibarysViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    int row = indexPath.row;
    BJLibaryItem* item = [libraryArray objectAtIndex:row*2];
    BJLibaryItem* itemR = [libraryArray objectAtIndex:row*2+1];
    
    if (cell ==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BJLibarysCell" owner:self options:nil];
        
        // 注释掉的和该句是两种方式，在这里两种方式都行。但是如果没有上面红色处（图XXX）的拖拽连接过程，这里只能使用nib objectAtIndex方式。
        cell = [nib objectAtIndex:0];
    }
    
    NSLog(@"++++++++++++++ jonesduan %s, cell row:%d", __func__, row);
    
    UIImageView* leftImageview = (UIImageView *)[cell viewWithTag:14];
    UIImageView* rightImageview = (UIImageView *)[cell viewWithTag:15];
    
    BJLibaryImageView* leftLibraryImg = [[BJLibaryImageView alloc] init];
    leftLibraryImg.mImageview = leftImageview;
    leftLibraryImg.mContentItem = item;
    [leftLibraryImg addTapGestureRecognizer];
    
    
    BJLibaryImageView* rightLibraryImg = [[BJLibaryImageView alloc] init];
    rightLibraryImg.mImageview = rightImageview;
    rightLibraryImg.mContentItem = itemR;
    [rightLibraryImg addTapGestureRecognizer];
    

    [leftImageview setImageWithURL:[NSURL URLWithString:item.icon_file]
                                            placeholderImage:[UIImage imageNamed:@"1.2.1-library_14.png"]];
    [rightImageview setImageWithURL:[NSURL URLWithString:itemR.icon_file]
                                            placeholderImage:[UIImage imageNamed:@"1.2.1-library_14.png"]];
    
    UILabel* leftAvgscoreLabel = (UILabel *)[cell viewWithTag:10];
    UILabel* rightAvgscoreLabel = (UILabel *)[cell viewWithTag:12];
    leftAvgscoreLabel.text = [NSString stringWithFormat:@"%d",item.avg_score];
    rightAvgscoreLabel.text = [NSString stringWithFormat:@"%d",itemR.avg_score];
    
    UILabel* leftLearnercountLabel = (UILabel *)[cell viewWithTag:11];
    UILabel* rightLearnercountLabel = (UILabel *)[cell viewWithTag:13];
    leftLearnercountLabel.text = [NSString stringWithFormat:@"%d",item.learner_count];
    rightLearnercountLabel.text = [NSString stringWithFormat:@"%d",itemR.learner_count];
    
    UILabel* leftTitleLabel = (UILabel *)[cell viewWithTag:16];
    UILabel* rightTitleLabel = (UILabel *)[cell viewWithTag:17];
    leftTitleLabel.text = item.topic;
    rightTitleLabel.text = itemR.topic;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //            return (SCREEN_HEIGHT-self.navigationController.navigationBar.frame.size.height*3)/3;
    return 120;
}

- (void) dealloc
{
    [super dealloc];
    [mTitleImageview release];
    [mTrainingImageview release];
    [mLibraryImageview release];
    [mPowerhourImageview release];
    [mSurveyImageview release];
    [mCoachImageview release];
    [mRankingImageview release];
    [mPromptImageview release];
    
    [_mApplyButton release];
    [_mTableviewCell release];
    
    [libraryArray release];
}

- (void)loadAllLibrarys
{
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:PG_SERVER_URL_GETALLLIBRARYS
                                                              contentType:PG_GET_ALLLIBRARYS];
    [connFacade fetchGets:PG_SERVER_URL_GETALLLIBRARYS];
    
    /*
     channelId	String	是	渠道id
     queryType	String	是	查询类型
     keyword	String	是	关键字
     pageIndex	String	是	当前页数
     pageSize	String	是	当页显示记录数
     **/
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    switch (contentType) {
        case PG_GET_ALLLIBRARYS:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDic = [result objectFromJSONData];
 
                NSDictionary *errorDict = [resultDic objectForKey:@"error"];
                if (errorDict) {
                    NSString* err_code = OBJ_FROM_DIC(errorDict, @"err_code");
                    NSString* err_msg = OBJ_FROM_DIC(errorDict, @"err_msg");
                    NSString* request_args = OBJ_FROM_DIC(errorDict, @"request_args");
                }
 
                NSArray* listArr = [resultDic objectForKey:@"list"];
                
                if ([libraryArray count] > 0) {
                    [libraryArray removeAllObjects];
                }
                
                for (int i =0 ; i < [listArr count]; i++) {
                    /*
                     {
                     "avg_score" = 0;
                     "comment_count" = 0;
                     competency =             {
                     "$ref" = "$.list[0].competency";
                     };
                     "icon_file" = "/courseware/275/9995b38c-6f39-42b2-b43b-65f3fc479642.png";
                     id = 275;
                     introduction = "Newly updated in May.2014 College II-Selling.";
                     "learner_count" = 9;
                     "min_band" = 2;
                     topic = "Business Planning, Execution and Review";
                     },
                     {
                     "avg_score" = 0;
                     "comment_count" = 0;
                     competency =             {
                     id = 42;
                     value = "Insight & Foresight";
                     };
                     "icon_file" = "/courseware/274/95e6c0bf-85d9-47ae-9902-bf5e620feb35.png";
                     id = 274;
                     introduction = "This is a newly updated Channel lanscape brief introduction in China nowadays. Includes Department store, Cosmetic store,Baby store and etc. new findings. ";
                     "learner_count" = 3;
                     "min_band" = 2;
                     topic = "Channel Landscape -CMK";
                     },

                     **/
                    NSDictionary* libraryItemDic = [listArr objectAtIndex:i];
                    
                    BJLibaryItem* library_item = [[BJLibaryItem alloc] init];
                    
                    library_item.avg_score = INT_VALUE_FROM_DIC(libraryItemDic, @"avg_score");
                    library_item.comment_count = INT_VALUE_FROM_DIC(libraryItemDic, @"comment_count");
                    
                    NSDictionary* competencyDic = [libraryItemDic objectForKey:@"competency"];
                    library_item.competencyID = INT_VALUE_FROM_DIC(competencyDic, @"id");
                    library_item.competencyValue = INT_VALUE_FROM_DIC(competencyDic, @"value");
                    library_item.competencyRef = OBJ_FROM_DIC(libraryItemDic, @"$ref");
                    
                    library_item.icon_file = [NSString stringWithFormat:@"%@%@",PG_SERVER_URL,OBJ_FROM_DIC(libraryItemDic, @"icon_file")];
                    library_item.libraryID = INT_VALUE_FROM_DIC(libraryItemDic, @"id");
                    library_item.learner_count = INT_VALUE_FROM_DIC(libraryItemDic, @"learner_count");
                    library_item.min_band = INT_VALUE_FROM_DIC(libraryItemDic, @"min_band");
                    library_item.topic = OBJ_FROM_DIC(libraryItemDic, @"topic");
                    library_item.intruduction = OBJ_FROM_DIC(libraryItemDic, @"introduction");
                    
                    [libraryArray addObject:library_item];
                    [library_item release];
                }
                
                [self refreshTable];
            }
            break;
        }
            
        default:
            break;
    }
    
    [super connectDone:result url:url contentType:contentType];
    
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
}

@end

