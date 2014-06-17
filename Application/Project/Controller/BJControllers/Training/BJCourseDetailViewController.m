//
//  BJCourseDetailViewController.m
//  Project
//
//  Created by sun art on 14-5-30.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJCourseDetailViewController.h"
#import "BJApplyCourseViewController.h"

@interface BJCourseDetailViewController ()
{
    
}
@end

@implementation BJCourseDetailViewController

@synthesize mTrainingTimeLabel;
@synthesize mVenueLabel;
@synthesize mTrainersLabel;
@synthesize mIntroductionLabel;
@synthesize mCriteriaLabel;
@synthesize mSlotsLabel;
@synthesize mSlotsLeftLabel;
@synthesize mPreworkLabel;
@synthesize mHomeworkLabel;

@synthesize mApplyButton = _mApplyButton;

@synthesize currentCourseItem = _currentCourseItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC
{
    self = [super initWithMOC:viewMOC];
    if (self) {
        _noNeedBackButton = NO;
        self.view = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil].view;
    }
    return self;
}

- (IBAction)buttonAction:(id)sender
{
    BJApplyCourseViewController* courseDetailViewCtrl= [[BJApplyCourseViewController alloc] initWithNibName:@"BJApplyCourseViewController" bundle:nil moc:[CommonMethod getInstance].MOC];
    
    courseDetailViewCtrl.mCourseID =  _currentCourseItem.courseID;
    [CommonMethod pushViewController:courseDetailViewCtrl  withAnimated:YES];
    [courseDetailViewCtrl release];
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
    mTrainingTimeLabel.text = [NSString stringWithFormat:@"%@ - %@",_currentCourseItem.training_time_start,_currentCourseItem.training_time_end];
    mVenueLabel.text = _currentCourseItem.venue;
    
    NSMutableString* trainerNameListStr = [[NSMutableString alloc] init];
    for (int i = 0; i < [_currentCourseItem.trainerItemArray count]; i++) {
        BJTrainerItem* trainerItem = [_currentCourseItem.trainerItemArray objectAtIndex:i];
        [trainerNameListStr appendString:[NSString stringWithFormat:@"%@ ,",trainerItem.name]];
    }
    mTrainersLabel.text = trainerNameListStr;
    [trainerNameListStr release];
    
    mIntroductionLabel.text = _currentCourseItem.introduction;
    mSlotsLabel.text = [NSString stringWithFormat:@"%d",_currentCourseItem.target_slots];
    mSlotsLeftLabel.text = [NSString stringWithFormat:@"%d",_currentCourseItem.target_slots];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Course";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [super dealloc];
    
    [mTrainingTimeLabel release];
    [mVenueLabel release];
    [mTrainersLabel release];
    [mIntroductionLabel release];
    [mCriteriaLabel release];
    [mSlotsLabel release];
    [mSlotsLeftLabel release];
    [mPreworkLabel release];
    [mHomeworkLabel release];
    
    [_currentCourseItem release];
    
//    [_mApplyButton release];
}

@end
