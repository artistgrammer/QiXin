//
//  BJLibarysSecViewController.h
//  Project
//
//  Created by sun art on 14-6-3.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BaseListViewController.h"
#import "CommonMethod.h"

@interface BJLibarysSecViewController : BaseListViewController
{
    NSMutableArray* libraryArray;
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

- (IBAction)buttonAction:(id)sender;

- (id)initWithMOC:(NSManagedObjectContext *)MOC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC;


@end

@interface BJLibaryItem : NSObject
{
    
}

@property (nonatomic, assign)int  avg_score;
@property (nonatomic, assign)int comment_count;
@property (nonatomic, assign)int competencyID;
@property (nonatomic, assign)int competencyValue;
@property (nonatomic, retain)NSString* competencyRef;
@property (nonatomic, retain)NSString* intruduction;

@property (nonatomic, retain)NSString* icon_file;
@property (nonatomic, assign)int libraryID;
@property (nonatomic, assign)int learner_count;
@property (nonatomic, assign)int min_band;
@property (nonatomic, retain)NSString* topic;

@end


@interface BJLibaryImageView : NSObject<UIGestureRecognizerDelegate>
{
    
}
-(void)addTapGestureRecognizer;

-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer;

@property (nonatomic, retain)UIImageView*  mImageview;
@property (nonatomic, retain)BJLibaryItem* mContentItem;

@end
