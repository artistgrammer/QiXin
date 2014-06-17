//
//  BJCoacherDetailViewController.m
//  Project
//
//  Created by sun art on 14-6-6.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJCoacherDetailViewController.h"
#import "BJMaterialsViewController.h"
#import "BJLibaryCommentsViewController.h"
#import "DropDown.h"
#import "BJCoachLikeDislikeViewController.h"
#import "BJCoachAssessViewController.h"

@implementation BJCoacherDetailViewController

@synthesize mFirstImageview;
@synthesize mSecondImageview;
@synthesize mThirdImageview;
@synthesize mForthImageview;

@synthesize mLikeBtn = _mLikeBtn;
@synthesize mDislikeBtn = _mDislikeBtn;
@synthesize mAssessBtn = _mAssessBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC
{
    self = [super initWithMOC:viewMOC];
    if (self) {
        _noNeedBackButton = NO;
        self.view = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil].view;
        
        mFirstImageview.tag = 0;
        mSecondImageview.tag = 1;
        mThirdImageview.tag = 2;
        mForthImageview.tag = 3;
        
        mCurrentSelectedIndex = 0;
        
        _mLikeBtn.tag = 0;
        _mDislikeBtn.tag = 1;
    }
    return self;
}

- (IBAction)buttonAction:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    
    int tag = btn.tag;
    
    if (0 == tag) {
        BJCoachLikeDislikeViewController* courseDetailViewCtrl= [[BJCoachLikeDislikeViewController alloc] initWithNibName:nil bundle:nil moc:[CommonMethod getInstance].MOC];
        courseDetailViewCtrl.mLikeDislikeFlag = 0;
        [CommonMethod pushViewController:courseDetailViewCtrl  withAnimated:YES];
        [courseDetailViewCtrl release];
    }else if (1 == tag)
    {
        BJCoachLikeDislikeViewController* courseDetailViewCtrl= [[BJCoachLikeDislikeViewController alloc] initWithNibName:nil bundle:nil moc:[CommonMethod getInstance].MOC];
        courseDetailViewCtrl.mLikeDislikeFlag = 1;
        [CommonMethod pushViewController:courseDetailViewCtrl  withAnimated:YES];
        [courseDetailViewCtrl release];
    }else if (2 == tag)
    {
        BJCoachAssessViewController* coachAssesslViewCtrl= [[BJCoachAssessViewController alloc] initWithNibName:nil bundle:nil moc:[CommonMethod getInstance].MOC];
        [CommonMethod pushViewController:coachAssesslViewCtrl  withAnimated:YES];
        [coachAssesslViewCtrl release];
    }
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
    
    self.navigationItem.title = @"Detail";
    
    mFirstImageview.highlighted = YES;
    
    [self addTapGestureRecognizer:mFirstImageview];
    [self addTapGestureRecognizer:mSecondImageview];
    [self addTapGestureRecognizer:mThirdImageview];
    [self addTapGestureRecognizer:mForthImageview];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    view.highlighted = !view.highlighted;
    
}

- (void) dealloc
{
    [super dealloc];
    
    [mFirstImageview release];
    [mSecondImageview release];
    [mThirdImageview release];
    [mForthImageview release];
    
    [_mDislikeBtn release];
    [_mLikeBtn release];
    [_mAssessBtn release];
}

@end

