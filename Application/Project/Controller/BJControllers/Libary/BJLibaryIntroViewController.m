//
//  BJLibaryIntroViewController.m
//  Project
//
//  Created by sun art on 14-6-3.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJLibaryIntroViewController.h"
#import "BJMaterialsViewController.h"
#import "BJLibaryCommentsViewController.h"
#import "UIImageView+WebCache.h"

@interface BJLibaryIntroViewController ()
{
}
@property (nonatomic, retain) RootViewController *currentVC;

@end

@implementation BJLibaryIntroViewController

@synthesize mFirstImageview;
@synthesize mSecondImageview;
@synthesize mThirdImageview;
@synthesize mForthImageview;
@synthesize mCurrentLibraryItem = _mCurrentLibraryItem;

@synthesize mCategoryLabel = _mCategoryLabel;
@synthesize mTagsLabel = _mTagsLabel;
@synthesize mCompetencyLabel = _mCompetencyLabel;
@synthesize mBandLabel = _mBandLabel;
@synthesize mIntroductionLabel = _mIntroductionLabel;

@synthesize mTitleLabel = _mTitleLabel;
@synthesize mAvgScoreLabel = _mAvgScoreLabel;
@synthesize mLearnerCountLabel = _mLearnerCountLabel;
@synthesize mBookImageview = _mBookImageview;

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
        
        self.currentVC = self;
    }
    return self;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _mTitleLabel.text = _mCurrentLibraryItem.topic;
    _mAvgScoreLabel.text = [NSString stringWithFormat:@"%d",_mCurrentLibraryItem.avg_score];
    _mLearnerCountLabel.text = [NSString stringWithFormat:@"%d",_mCurrentLibraryItem.learner_count];
    _mCategoryLabel.text = @"";
    _mTagsLabel.text = @"";
    _mCompetencyLabel.text = _mCurrentLibraryItem.competencyRef;
    _mBandLabel.text = [NSString stringWithFormat:@"%d",_mCurrentLibraryItem.min_band];
    _mIntroductionLabel.text = _mCurrentLibraryItem.intruduction;
    
    
    
    
    [_mBookImageview setImageWithURL:[NSURL URLWithString:_mCurrentLibraryItem.icon_file]
                  placeholderImage:[UIImage imageNamed:@"1.2.1-library_14.png"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Intro";
    
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


#pragma mark - clear current vc
- (void)clearCurrentVC {
    [self.currentVC cancelConnectionAndImageLoading];
    [self.currentVC cancelLocation];
    
//    if (self.currentVC.view) {
//        [self.currentVC.view removeFromSuperview];
//    }
    
    if ([self.currentVC isKindOfClass:[BJLibaryIntroViewController class]]) {
        [self.currentVC.tableView removeFromSuperview];
    }else{
        [self.currentVC.view removeFromSuperview];
    }
    
    self.currentVC = nil;
}

- (void)removeCurrentView {
    
    [self clearCurrentVC];
}

- (void)arrangeCurrentVC:(RootViewController *)vc {
    
    [self removeCurrentView];
    
    self.currentVC = vc;
    
    if ([self.currentVC isKindOfClass:[BJLibaryIntroViewController class]]) {
        [self.view addSubview:self.currentVC.tableView];
    }else{
        [self.view addSubview:self.currentVC.view];
    }
    
    NSLog(@" ===== currentVC.view.frame ===== %@", NSStringFromCGRect(self.currentVC.view.frame));
    
    if ([WXWCommonUtils currentOSVersion] < IOS5) {
        [self.currentVC viewWillAppear:YES];
    }
}


-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *view = (UIImageView*)[gestureRecognizer view];
    int tagvalue = view.tag;
    
    DLog(@"%d is touched",tagvalue);
    
    if (mCurrentSelectedIndex != tagvalue) {
        if (0 == tagvalue) {
            
            mFirstImageview.highlighted = YES;
            mSecondImageview.highlighted = NO;
            mThirdImageview.highlighted = NO;
            mForthImageview.highlighted = NO;
            
            BJLibaryIntroViewController *infoVC = [[BJLibaryIntroViewController alloc] initWithNibName:nil bundle:nil moc:_MOC];
            [self arrangeCurrentVC:infoVC];
            [infoVC release];
            
        }else if (1 == tagvalue)
        {
            mFirstImageview.highlighted = NO;
            mSecondImageview.highlighted = YES;
            mThirdImageview.highlighted = NO;
            mForthImageview.highlighted = NO;
            
            BJMaterialsViewController *materialsVC = [[BJMaterialsViewController alloc] initWithNibName:nil bundle:nil moc:_MOC];
            materialsVC.mCurrentLibraryItem = _mCurrentLibraryItem;
            [self arrangeCurrentVC:materialsVC];
            [materialsVC release];
            
        }else if (2 == tagvalue)
        {
            mFirstImageview.highlighted = NO;
            mSecondImageview.highlighted = NO;
            mThirdImageview.highlighted = YES;
            mForthImageview.highlighted = NO;
        }else if (3 == tagvalue)
        {
            mFirstImageview.highlighted = NO;
            mSecondImageview.highlighted = NO;
            mThirdImageview.highlighted = NO;
            mForthImageview.highlighted = YES;
            
            BJLibaryCommentsViewController *commentsVC = [[BJLibaryCommentsViewController alloc] initWithNibName:nil bundle:nil moc:_MOC];
             commentsVC.mCurrentLibraryItem = _mCurrentLibraryItem;
            [self arrangeCurrentVC:commentsVC];
            [commentsVC release];
        }
        
        mCurrentSelectedIndex = tagvalue;
    }

}

- (void) dealloc
{
    [super dealloc];
    
    [mFirstImageview release];
    [mSecondImageview release];
    [mThirdImageview release];
    [mForthImageview release];
    
    [_currentVC release];
    _currentVC = nil;
    
    [_mCurrentLibraryItem release];
    
    [_mLearnerCountLabel release];
    [_mTitleLabel release];
    [_mAvgScoreLabel release];
    
    [_mCategoryLabel release];
    [_mTagsLabel release];
    [_mCompetencyLabel release];
    [_mBandLabel release];
    [_mIntroductionLabel release];
    [_mBookImageview release];
}

@end
