//
//  BJSurveyHomeViewController.m
//  Project
//
//  Created by sun art on 14-6-10.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJSurveyHomeViewController.h"
#import "BJLibaryIntroViewController.h"
#import "BJTestViewController.h"

@interface BJSurveyHomeViewController ()
{
    
}
@end

@implementation BJSurveyHomeViewController

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
        
        mSurveyArray = [[NSMutableArray alloc] initWithCapacity:10];
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
    
    _tableView.frame = CGRectMake(0, HOMEPAGE_TAB_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - navH - HOMEPAGE_TAB_HEIGHT);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadAllSurveys];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int navH = self.navigationController.navigationBar.frame.size.height;
    self.view.frame = CGRectMake(0,
                                 navH,
                                 SCREEN_WIDTH,
                                 SCREEN_HEIGHT - navH);
    
    self.navigationItem.title = @"Survey&Test";
    
    //        if ([WXWCommonUtils currentOSVersion] < IOS7) {
    //            self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    //        }
    //
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    [self adjustTableLayout];
    
    [self refreshTable];
    
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"Survey",@"Test",nil];
    
    //初始化UISegmentedControl
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    [segmentedArray release];
    
    segmentedControl.frame = CGRectMake((SCREEN_WIDTH-250)/2, 5, 250.0, HOMEPAGE_TAB_HEIGHT - 10);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = [UIColor redColor];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;//设置样式
    //  segmentedControl.momentary = YES;//设置在点击后是否恢复原样
    
    //添加委托方法
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentedControl];
    [segmentedControl release];
    
    
//    int gap = 5;
//    int leftrightW = 60;
//    
//    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    [titleView setBackgroundColor:[UIColor blackColor]];
//    titleView.alpha = 0.5f;
//    
//    UIButton *_filterButton = [[UIButton alloc] initWithFrame:CGRectMake(gap, gap, leftrightW, 20)];
//    
//    [_filterButton setBackgroundColor:[UIColor clearColor]];
//    [_filterButton setTitle:@"Filter" forState:UIControlStateNormal];
//    [_filterButton setTitle:@"Filter" forState:UIControlStateHighlighted];
//    [_filterButton setTitle:@"Filter" forState:UIControlStateSelected];
//    _filterButton.titleLabel.font=[UIFont systemFontOfSize:20];
//    [_filterButton.titleLabel setTextColor:[UIColor whiteColor]];
//    
//    [_filterButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    _filterButton.tag = 0;
//    [titleView addSubview:_filterButton];
//    [_filterButton release];
//    
//    
//    UIButton *yeardayBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-leftrightW*2-gap*2,gap,leftrightW*2+2*gap,20)];
//    
//    [yeardayBtn setBackgroundColor:[UIColor clearColor]];
//    
//    [yeardayBtn setTitle:@"Default sort" forState:UIControlStateNormal];
//    [yeardayBtn setTitle:@"Default sort" forState:UIControlStateHighlighted];
//    [yeardayBtn setTitle:@"Default sort" forState:UIControlStateSelected];
//    yeardayBtn.titleLabel.font=[UIFont systemFontOfSize:20];
//    [yeardayBtn.titleLabel setTextColor:[UIColor whiteColor]];
//    [yeardayBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    yeardayBtn.tag = 1;
//    [titleView addSubview:yeardayBtn];
//    [yeardayBtn release];
//    
//    [self.view addSubview:titleView];
//    [titleView release];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mSurveyArray count]/*CELL_COUNT**/;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CustomCellIdentifier =@"BJLibarysViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if (cell ==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SurveyHomeCell" owner:self options:nil];
        //        if ([nib count] > 0) {
        //            cell = self.mTableviewCell;
        //        } else {
        //            NSLog(@"failed to load CustomCell nib file!");
        //        }
        
        // 注释掉的和该句是两种方式，在这里两种方式都行。但是如果没有上面红色处（图XXX）的拖拽连接过程，这里只能使用nib objectAtIndex方式。
        cell = [nib objectAtIndex:0];
    }
    
    NSUInteger row = [indexPath row];
    
    NSLog(@"++++++++++++++ jonesduan %s, cell row:%d", __func__, row);
    
    UIImageView* leftImageview = (UIImageView *)[cell viewWithTag:1];
    UIImageView* rightImageview = (UIImageView *)[cell viewWithTag:2];
    
    [self addTapGestureRecognizer:leftImageview];
    [self addTapGestureRecognizer:rightImageview];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //            return (SCREEN_HEIGHT-self.navigationController.navigationBar.frame.size.height*3)/3;
    return 100;
}

#pragma mark - for gesture
- (void)addTapGestureRecognizer:(UIImageView*)targetImageview {
    UITapGestureRecognizer *swipeGR = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(imageviewTouchEvents:)] autorelease];
    swipeGR.delegate = self;
    
    [targetImageview addGestureRecognizer:swipeGR];
}

-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *view = (UIImageView*)[gestureRecognizer view];
    int tagvalue = view.tag;
    
    DLog(@"%d is touched",tagvalue);
    if (1 == tagvalue) {
        BJLibaryIntroViewController *libaryIntroVC = [[BJLibaryIntroViewController alloc] initWithNibName:@"BJLibaryIntroViewController" bundle:nil moc:_MOC];
        [CommonMethod pushViewController:libaryIntroVC  withAnimated:YES];
        [libaryIntroVC release];
    }else if (2 == tagvalue)
    {
        //        BJLibarysSecViewController *libarysVC = [[BJLibarysSecViewController alloc] initWithNibName:nil bundle:nil moc:_MOC];
        //        [CommonMethod pushViewController:libarysVC  withAnimated:YES];
        //        [libarysVC release];
    }
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
    
    [mSurveyArray release];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    int section = [indexPath section];
	NSLog(@"didselect row= %d,section= %d",row,section);
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn1 setImage:[UIImage imageNamed:@"1.2.1-library_25.png"] forState:UIControlStateNormal];
//    [btn1 setImage:[UIImage imageNamed:@"1.2.1-library_26.png"] forState:UIControlStateHighlighted];
    [btn1 setFrame:CGRectMake(20, 260, 120, 40)];
    [btn1 setBackgroundColor:[UIColor orangeColor]];
    
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn1 setTitle:@"Start" forState:UIControlStateNormal];
    [btn1 setTitle:@"Start" forState:UIControlStateHighlighted];
    [btn1 setTitle:@"Start" forState:UIControlStateSelected];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn2 setImage:[UIImage imageNamed:@"1.2.1-library_25.png"] forState:UIControlStateNormal];
//    [btn2 setImage:[UIImage imageNamed:@"1.2.1-library_26.png"] forState:UIControlStateHighlighted];
    [btn2 setFrame:CGRectMake(163, 260, 120, 40)];
    [btn2 setBackgroundColor:[UIColor orangeColor]];
    
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn2 setTitle:@"Cancel" forState:UIControlStateNormal];
    [btn2 setTitle:@"Cancel" forState:UIControlStateHighlighted];
    [btn2 setTitle:@"Cancel" forState:UIControlStateSelected];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"1.2.4-survey&test－survey_33.png"];
    //    UIImage *content = [UIImage imageNamed:@"puzzle_warning_sn.png"];
    //    BJCustomAlert * alert = [[BJCustomAlert alloc] initWithImage:backgroundImage contentImage:content ];
    
    BJCustomAlert * alert = [[BJCustomAlert alloc] initWithImage:backgroundImage contentImage:nil];
    
    alert.BJdelegate = self;
    [alert addButtonWithUIButton:btn1];
    [alert addButtonWithUIButton:btn2];
    
    
    [alert show];
}

#pragma mark --custom UIAlertView

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"button1 clicked");
            BJTestViewController *testVC = [[BJTestViewController alloc] initWithNibName:@"BJTestViewController" bundle:nil moc:_MOC];
            [CommonMethod pushViewController:testVC  withAnimated:YES];
            [testVC release];
            break;
        case 1:
            NSLog(@"button2 clicked");
        default:
            break;
    }
}
#pragma mark UITextFieldDelegate
//判定输入格式的合法性
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)loadAllSurveys
{
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setObject:@"0" forKey:@"pageIndex"];
    [specialDict setObject:@"100" forKey:@"pageSize"];
    
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:PG_SERVER_URL_GETALLSURVEYS
                                                              contentType:PG_GET_ALLSURVEYS];
    [connFacade post:PG_SERVER_URL_GETALLSURVEYS data:[specialDict JSONData]];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    switch (contentType) {
        case PG_GET_ALLSURVEYS:
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
                
                /*
                 list =     (
                 {
                 id = 2;
                 "is_multi_answer" = 1;
                 "is_passed" = 0;
                 "joined_count" = 742;
                 "passed_count" = 738;
                 "release_time" = "2014-03-13 13:45:05";
                 topic = "FMOT Online Capability Qualification";
                 type = Test;
                 },
                 {
                 id = 28;
                 "is_multi_answer" = 0;
                 "is_passed" = 0;
                 "joined_count" = 99;
                 "passed_count" = 75;
                 "release_time" = "2014-05-08 11:23:52";
                 topic = "FY1314 CBD\"\U505a\U6b63\U786e\U7684\U4e8b\U7ade\U8d5b\U201c\U2014\U2014\U5927\U5bb6\U6765\U627e\U832c";
                 type = Test;
                 },

                 **/
                NSArray* listArr = [resultDic objectForKey:@"list"];
                
                if ([listArr count] == 0) {
                    [self displayEmptyMessage];
                }else{
                    if ([mSurveyArray count] > 0) {
                        [mSurveyArray removeAllObjects];
                    }
                    
                    for (int i =0 ; i < [listArr count]; i++) {
                        NSDictionary* libraryItemDic = [listArr objectAtIndex:i];
                        
//                        BJLibaryItem* library_item = [[BJLibaryItem alloc] init];
//                        
//                        library_item.avg_score = INT_VALUE_FROM_DIC(libraryItemDic, @"avg_score");
//                        library_item.comment_count = INT_VALUE_FROM_DIC(libraryItemDic, @"comment_count");
//                        
//                        NSDictionary* competencyDic = [libraryItemDic objectForKey:@"competency"];
//                        library_item.competencyID = INT_VALUE_FROM_DIC(competencyDic, @"id");
//                        library_item.competencyValue = INT_VALUE_FROM_DIC(competencyDic, @"value");
//                        library_item.competencyRef = OBJ_FROM_DIC(libraryItemDic, @"$ref");
//                        
//                        library_item.icon_file = [NSString stringWithFormat:@"%@%@",PG_SERVER_URL,OBJ_FROM_DIC(libraryItemDic, @"icon_file")];
//                        library_item.libraryID = INT_VALUE_FROM_DIC(libraryItemDic, @"id");
//                        library_item.learner_count = INT_VALUE_FROM_DIC(libraryItemDic, @"learner_count");
//                        library_item.min_band = INT_VALUE_FROM_DIC(libraryItemDic, @"min_band");
//                        library_item.topic = OBJ_FROM_DIC(libraryItemDic, @"topic");
//                        library_item.intruduction = OBJ_FROM_DIC(libraryItemDic, @"introduction");
//                        
//                        [mSurveyArray addObject:library_item];
//                        [library_item release];
                    }
                    
                    [self refreshTable];
                }
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
