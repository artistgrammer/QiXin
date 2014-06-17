//
//  BJCoacheFeedbackViewController.m
//  Project
//
//  Created by sun art on 14-6-6.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJCoacheFeedbackViewController.h"
#import "BJLibarysSecViewController.h"
#import "BJLibaryIntroViewController.h"
#import "BJCommentSubmitViewController.h"
#import "BJPowerHourRegViewController.h"

@implementation BJCoacheFeedbackViewController

@synthesize mFiveImageview = _mFiveImageview;
@synthesize mFourImageview = _mFourImageview;
@synthesize mThreeImageview = _mThreeImageview;
@synthesize mTwoImageview = _mTwoImageview;
@synthesize mOneImageview = _mOneImageview;

@synthesize mCancelButton = _mCancelButton;
@synthesize mSubmitButton = _mSubmitButton;

@synthesize mSelectedCell = _mSelectedCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC
{
    self = [super initWithMOC:viewMOC needRefreshHeaderView:YES needRefreshFooterView:YES tableStyle:UITableViewStyleGrouped];
    if (self) {
        _noNeedBackButton = NO;
        //        self.view = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil].view;
        
        _mFiveImageview.tag = 0;
        _mFourImageview.tag = 1;
        _mThreeImageview.tag = 2;
        _mTwoImageview.tag = 3;
        _mOneImageview.tag = 4;
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
    
    self.navigationItem.title = @"Feedback";
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    _tableView.frame = self.view.frame;
    
//    UIView* totalView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height, SCREEN_WIDTH, self.view.frame.size.height/2)];
//    
//    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CoachFeedbackTotal" owner:self options:nil];
//    UITableViewCell* cell = [nib objectAtIndex:0];
//    
//    [totalView addSubview:cell.contentView];
//    
//    
//    [self.view addSubview:totalView];
//    [totalView release];
    
    [self addTapGestureRecognizer:_mFiveImageview];
    [self addTapGestureRecognizer:_mFourImageview];
    [self addTapGestureRecognizer:_mThreeImageview];
    [self addTapGestureRecognizer:_mTwoImageview];
    [self addTapGestureRecognizer:_mOneImageview];
    
    
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
    int section = [indexPath section];
	NSLog(@"didselect row= %d,section= %d",row,section);
    
    _mSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10+1/*CELL_COUNT**/;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int index = indexPath.row;
    
    if (index == 10) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CoachFeedbackTotal" owner:self options:nil];
        UITableViewCell* cell = [nib objectAtIndex:0];
        
        return  cell;
    }else{
        static NSString *CustomCellIdentifier =@"CoachFeedbackCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
        if (cell ==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CoachFeedbackCell" owner:self options:nil];
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
        
        for (int i=0; i<5; i++) {
            UIImageView *imageview = (UIImageView*)[cell.contentView viewWithTag:(i+10)];
            [self addTapGestureRecognizer:imageview];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    return (SCREEN_HEIGHT-self.navigationController.navigationBar.frame.size.height - TAB_BAR_HEIGHT)/5;
    
    int index = indexPath.row;
    if (index == 10) {
        return 200;
    }
    return 85;
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
    
    if (!view.highlighted) {
        view.highlighted = YES;
        
        for (int i = 0; i < 5; i++) {
            if (i != tagvalue-10) {
                ((UIImageView*)[_mSelectedCell viewWithTag:(i+10)]).highlighted = NO;
            }
        }
    }else
    {
        view.highlighted = NO;
    }
}

- (void) dealloc
{
    [super dealloc];
    [_mOneImageview release];
    [_mTwoImageview release];
    [_mThreeImageview release];
    [_mFourImageview release];
    [_mFiveImageview release];
    
    [_mCancelButton release];
    [_mSubmitButton release];
    
    [_mSelectedCell release];
}

@end
