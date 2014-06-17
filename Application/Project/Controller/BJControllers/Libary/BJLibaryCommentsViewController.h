//
//  BJLibaryCommentsViewController.h
//  Project
//
//  Created by sun art on 14-6-4.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BaseListViewController.h"
#import "CommonMethod.h"
#import "BJLibarysSecViewController.h"

@interface BJLibaryCommentsViewController : BaseListViewController
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

@property (nonatomic, retain) IBOutlet UIButton *mApplyButton;

@property (nonatomic, retain) IBOutlet UITableViewCell *mTableviewCell;

@property (nonatomic, retain) BJLibaryItem *mCurrentLibraryItem;

- (IBAction)buttonAction:(id)sender;

- (id)initWithMOC:(NSManagedObjectContext *)MOC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC;


- (void)addTapGestureRecognizer:(UIImageView*)targetImageview;

-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer;

@end