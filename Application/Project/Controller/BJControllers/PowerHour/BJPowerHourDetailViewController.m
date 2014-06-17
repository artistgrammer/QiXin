//
//  BJPowerHourDetailViewController.m
//  Project
//
//  Created by sun art on 14-6-4.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJPowerHourDetailViewController.h"
#import "BJLibarysSecViewController.h"
#import "BJLibaryIntroViewController.h"
#import "BJCommentSubmitViewController.h"
#import "BJPowerHourRegViewController.h"

@implementation BJPowerHourDetailViewController

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
    }
    return self;
}

- (void)refreshTable {
    
    //    [self fetchContentFromMOC];
    
    [_tableView reloadData];
    
}

- (IBAction)buttonAction:(id)sender
{
//    BJCommentSubmitViewController* commentsSubmitViewCtrl= [[BJCommentSubmitViewController alloc] initWithNibName:@"BJCommentSubmitViewController" bundle:nil moc:[CommonMethod getInstance].MOC];
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
    
    self.navigationItem.title = @"Public Lecture";
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PowerHourDetailTitle" owner:self options:nil];
    UITableViewCell* cell = [nib objectAtIndex:0];
    
    [self.view addSubview:cell.contentView];
    
    
    // 按钮
    int btnWidth = SCREEN_WIDTH*2/3;
    int btnHeight = 40;
    
    UIButton *mConfirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6, self.view.frame.size.height-NAV_BAR_HEIGHT + (NAV_BAR_HEIGHT-btnHeight)/2,btnWidth, btnHeight)];
    
    [mConfirmBtn setBackgroundImage:[UIImage imageNamed:@"1.3.4-Scene-teacher_03.png"] forState:UIControlStateNormal];
    [mConfirmBtn setBackgroundImage:[UIImage imageNamed:@"1.3.4-Scene-teacher_03.png"] forState:UIControlStateHighlighted];
    [mConfirmBtn setBackgroundImage:[UIImage imageNamed:@"1.3.4-Scene-teacher_03.png"] forState:UIControlStateSelected];
    
    [mConfirmBtn setTitle:@"Register" forState:UIControlStateNormal];
    [mConfirmBtn setTitle:@"Register" forState:UIControlStateHighlighted];
    [mConfirmBtn setTitle:@"Register" forState:UIControlStateSelected];
    
    mConfirmBtn.titleLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
    [mConfirmBtn addTarget:self action:@selector(ConfirmPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mConfirmBtn];
    [mConfirmBtn release];
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    _tableView.frame = CGRectMake(0, cell.contentView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_BAR_HEIGHT - cell.contentView.frame.size.height - NAV_BAR_HEIGHT-5);
    
    [self refreshTable];
}

- (void)ConfirmPay
{
    BJPowerHourRegViewController *powerHourRegVC = [[BJPowerHourRegViewController alloc] initWithNibName:nil bundle:nil moc:_MOC];
    [CommonMethod pushViewController:powerHourRegVC  withAnimated:YES];
    [powerHourRegVC release];
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
    static NSString *CustomCellIdentifier =@"BJPowerHourDetailViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if (cell ==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PowerHourDetailCell" owner:self options:nil];
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
//    return (SCREEN_HEIGHT-self.navigationController.navigationBar.frame.size.height - TAB_BAR_HEIGHT)/5;
    return 126;
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
    [_mTableviewCell release];
}

@end
