//
//  BJCoachHomeViewController.m
//  Project
//
//  Created by sun art on 14-6-5.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJCoachHomeViewController.h"
#import "BJLibarysSecViewController.h"
#import "BJLibaryIntroViewController.h"
#import "BJCommentSubmitViewController.h"
#import "BJPowerHourRegViewController.h"
#import "BJAddNewCoacherViewController.h"
#import "BJAddNewCoacheeViewController.h"
#import "BJCoacherDetailViewController.h"
#import "BJCoacheeDetailViewController.h"

@implementation BJCoachHomeViewController

@synthesize mTitleImageview;
@synthesize mTrainingImageview;
@synthesize mLibraryImageview;
@synthesize mPowerhourImageview;
@synthesize mSurveyImageview;
@synthesize mCoachImageview;
@synthesize mRankingImageview;
@synthesize mPromptImageview;

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
        
        mCurrentSegIndex = 0;
    }
    return self;
}

- (void)refreshTable {
    
    //    [self fetchContentFromMOC];
    
    [_tableView reloadData];
    
}

- (IBAction)buttonAction:(id)sender
{
//    BJAddNewCoacherViewController* commentsSubmitViewCtrl= [[BJAddNewCoacherViewController alloc] initWithNibName:@"BJAddNewCoacherViewController" bundle:nil moc:[CommonMethod getInstance].MOC];
//    
//    [CommonMethod pushViewController:commentsSubmitViewCtrl  withAnimated:YES];
//    [commentsSubmitViewCtrl release];
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
{
    
    self = [super initWithMOC:MOC];
    if (self) {
        _noNeedBackButton = NO;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0,
                                 0,
                                 SCREEN_WIDTH,
                                 SCREEN_HEIGHT - NAV_BAR_HEIGHT);
    
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"Coacher",@"Coachee",nil];
    
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
    
    
    // 按钮
    int btnWidth = SCREEN_WIDTH*2/3;
    int btnHeight = 40;
    
    UIButton *mConfirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6, self.view.frame.size.height-NAV_BAR_HEIGHT + (NAV_BAR_HEIGHT-btnHeight)/2,btnWidth, btnHeight)];
    
    [mConfirmBtn setBackgroundImage:[UIImage imageNamed:@"1.3.4-Scene-teacher_03.png"] forState:UIControlStateNormal];
    [mConfirmBtn setBackgroundImage:[UIImage imageNamed:@"1.3.4-Scene-teacher_03.png"] forState:UIControlStateHighlighted];
    [mConfirmBtn setBackgroundImage:[UIImage imageNamed:@"1.3.4-Scene-teacher_03.png"] forState:UIControlStateSelected];
    
    [mConfirmBtn setTitle:@"Add New" forState:UIControlStateNormal];
    [mConfirmBtn setTitle:@"Add New" forState:UIControlStateHighlighted];
    [mConfirmBtn setTitle:@"Add New" forState:UIControlStateSelected];
    
    mConfirmBtn.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
    [mConfirmBtn addTarget:self action:@selector(ConfirmPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mConfirmBtn];
    [mConfirmBtn release];
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    _tableView.frame = CGRectMake(0, HOMEPAGE_TAB_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_BAR_HEIGHT - HOMEPAGE_TAB_HEIGHT - NAV_BAR_HEIGHT - 5);
    
    [self refreshTable];
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %i", Index);
    switch (Index) {
        case 0:
            mCurrentSegIndex = 0;
            break;
        case 1:
            mCurrentSegIndex = 1;
            break;
        default:
            break;
    }
}

- (void)ConfirmPay
{
    if (0 == mCurrentSegIndex) {
        BJAddNewCoacherViewController* addnewCoacherViewCtrl= [[BJAddNewCoacherViewController alloc] initWithNibName:@"BJAddNewCoacherViewController" bundle:nil moc:[CommonMethod getInstance].MOC];
        
        [CommonMethod pushViewController:addnewCoacherViewCtrl  withAnimated:YES];
        [addnewCoacherViewCtrl release];
    }else if (1 == mCurrentSegIndex)
    {
        BJAddNewCoacheeViewController* addnewCoacheeViewCtrl= [[BJAddNewCoacheeViewController alloc] initWithNibName:@"BJAddNewCoacheeViewController" bundle:nil moc:[CommonMethod getInstance].MOC];
        
        [CommonMethod pushViewController:addnewCoacheeViewCtrl  withAnimated:YES];
        [addnewCoacheeViewCtrl release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10/*CELL_COUNT**/;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CustomCellIdentifier =@"CoachHomeCellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if (cell ==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CoachHomeCell" owner:self options:nil];
        //        if ([nib count] > 0) {
        //            cell = self.mTableviewCell;
        //        } else {
        //            NSLog(@"failed to load CustomCell nib file!");
        //        }
        
        // 注释掉的和该句是两种方式，在这里两种方式都行。但是如果没有上面红色处（图XXX）的拖拽连接过程，这里只能使用nib objectAtIndex方式。
        cell = [nib objectAtIndex:0];
    }
    
    //    NSUInteger row = [indexPath row];
    //
    //    NSLog(@"++++++++++++++ jonesduan %s, cell row:%d", __func__, row);
    //
    //    UIImageView* leftImageview = (UIImageView *)[cell viewWithTag:1];
    //    UIImageView* rightImageview = (UIImageView *)[cell viewWithTag:2];
    //
    //    [self addTapGestureRecognizer:leftImageview];
    //    [self addTapGestureRecognizer:rightImageview];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return (SCREEN_HEIGHT - NAV_BAR_HEIGHT - HOMEPAGE_TAB_HEIGHT - NAV_BAR_HEIGHT - 5)/5;
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if (0 == mCurrentSegIndex) {
        BJCoacherDetailViewController* coacherViewCtrl= [[BJCoacherDetailViewController alloc] initWithNibName:@"BJCoacherDetailViewController" bundle:nil moc:[CommonMethod getInstance].MOC];
        
        [CommonMethod pushViewController:coacherViewCtrl  withAnimated:YES];
        [coacherViewCtrl release];
    }else if (1 == mCurrentSegIndex)
    {
        BJCoacheeDetailViewController* coacheeDetailViewCtrl= [[BJCoacheeDetailViewController alloc] initWithNibName:@"BJCoacheeDetailViewController" bundle:nil moc:[CommonMethod getInstance].MOC];
        
        [CommonMethod pushViewController:coacheeDetailViewCtrl  withAnimated:YES];
        [coacheeDetailViewCtrl release];
    }
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
        //        BJLibaryIntroViewController *libaryIntroVC = [[BJLibaryIntroViewController alloc] initWithNibName:@"BJLibaryIntroViewController" bundle:nil moc:_MOC];
        //        [CommonMethod pushViewController:libaryIntroVC  withAnimated:YES];
        //        [libaryIntroVC release];
    }else if (2 == tagvalue)
    {
        
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
}

@end
