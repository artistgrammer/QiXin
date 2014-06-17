//
//  BJCoachLikeDislikeViewController.m
//  Project
//
//  Created by sun art on 14-6-6.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJCoachLikeDislikeViewController.h"
#import "BJLibarysSecViewController.h"
#import "BJLibaryIntroViewController.h"
#import "BJCommentSubmitViewController.h"
#import "BJPowerHourRegViewController.h"

@implementation BJCoachLikeDislikeViewController

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

@synthesize mLikeDislikeFlag = _mLikeDislikeFlag;

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
    
    if (0 == _mLikeDislikeFlag) {
        self.navigationItem.title = @"Like";
    }else if (1 == _mLikeDislikeFlag)
    {
        self.navigationItem.title = @"Dislike";
    }
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    _tableView.frame = self.view.frame;
    
    [self refreshTable];
}

- (void)ConfirmPay
{
    //    BJPowerHourRegViewController *powerHourRegVC = [[BJPowerHourRegViewController alloc] initWithNibName:nil bundle:nil moc:_MOC];
    //    [CommonMethod pushViewController:powerHourRegVC  withAnimated:YES];
    //    [powerHourRegVC release];
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
    static NSString *CustomCellIdentifier =@"CoachLikeDislikeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if (cell ==nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CustomCellIdentifier] autorelease];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = @"1.The Coach is very friendly";
    cell.detailTextLabel.text = @"2014.3.9";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    return (SCREEN_HEIGHT-self.navigationController.navigationBar.frame.size.height - TAB_BAR_HEIGHT)/5;
    return 50;
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

