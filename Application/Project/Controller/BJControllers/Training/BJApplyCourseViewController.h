//
//  BJApplyCourseViewController.h
//  Project
//
//  Created by sun art on 14-5-30.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "RootViewController.h"
#import "CommonMethod.h"

@interface BJApplyCourseViewController : RootViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    
}

@property (nonatomic, retain) IBOutlet UIImageView *mTitleImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mTrainingImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mLibraryImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mPowerhourImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mSurveyImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mCoachImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mRankingImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mPromptImageview;

@property (nonatomic, retain) IBOutlet UIButton *mCancelBtn;
@property (nonatomic, retain) IBOutlet UIButton *mConfirmBtn;

@property (nonatomic, assign) int mCourseID;

- (IBAction)btnAction:(id)sender;


- (id)initWithMOC:(NSManagedObjectContext *)MOC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC;

@end