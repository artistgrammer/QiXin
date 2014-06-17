//
//  BJLibaryIntroViewController.h
//  Project
//
//  Created by sun art on 14-6-3.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//
#import "RootViewController.h"
#import "CommonMethod.h"
#import "BJLibarysSecViewController.h"

@interface BJLibaryIntroViewController : RootViewController
{
    NSInteger mCurrentSelectedIndex;
}

@property (nonatomic, retain) IBOutlet UIImageView *mFirstImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mSecondImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mThirdImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mForthImageview;

@property (nonatomic, retain) IBOutlet UILabel *mTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *mAvgScoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *mLearnerCountLabel;

@property (nonatomic, retain) IBOutlet UILabel *mCategoryLabel;
@property (nonatomic, retain) IBOutlet UILabel *mTagsLabel;
@property (nonatomic, retain) IBOutlet UILabel *mCompetencyLabel;
@property (nonatomic, retain) IBOutlet UILabel *mBandLabel;
@property (nonatomic, retain) IBOutlet UILabel *mIntroductionLabel;

@property (nonatomic, retain) IBOutlet UIImageView *mBookImageview;

@property (nonatomic, retain) BJLibaryItem *mCurrentLibraryItem;


- (IBAction)buttonAction:(id)sender;

- (id)initWithMOC:(NSManagedObjectContext *)MOC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC;

- (void)addTapGestureRecognizer:(UIImageView*)targetImageview;

-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer;

@end