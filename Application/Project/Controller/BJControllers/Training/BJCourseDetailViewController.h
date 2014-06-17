//
//  BJCourseDetailViewController.h
//  Project
//
//  Created by sun art on 14-5-30.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//
#import "RootViewController.h"
#import "CommonMethod.h"
#import "CKViewController.h"

@interface BJCourseDetailViewController : RootViewController
{
    
}

@property (nonatomic, retain) IBOutlet UILabel *mTrainingTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *mVenueLabel;
@property (nonatomic, retain) IBOutlet UILabel *mTrainersLabel;
@property (nonatomic, retain) IBOutlet UILabel *mIntroductionLabel;
@property (nonatomic, retain) IBOutlet UILabel *mCriteriaLabel;
@property (nonatomic, retain) IBOutlet UILabel *mSlotsLabel;
@property (nonatomic, retain) IBOutlet UILabel *mSlotsLeftLabel;
@property (nonatomic, retain) IBOutlet UILabel *mPreworkLabel;
@property (nonatomic, retain) IBOutlet UILabel *mHomeworkLabel;

@property (nonatomic, retain) BJCourseItem* currentCourseItem;

@property (nonatomic, retain) IBOutlet UIButton *mApplyButton;

- (IBAction)buttonAction:(id)sender;

- (id)initWithMOC:(NSManagedObjectContext *)MOC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC;

@end