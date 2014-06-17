//
//  BJHomePageViewController.h
//  Project
//
//  Created by sun art on 14-5-26.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//
#import "RootViewController.h"
#import "CKViewController.h"
#import "CommonMethod.h"
#import "BJLibarysSecViewController.h"
#import "ImageWallScrollView.h"
#import "BJSurveyHomeViewController.h"

#define WIDTH_GAP          7.0f
#define HEIGHT_GAP         14.0f
#define VIDEO_35INCH_HEIGHT   165.0f

@interface BJHomePageViewController : RootViewController <ImageWallDelegate>
{
    //超时计数
	NSTimer* mConnectionTimer;
    
    NSString* mPromptStr;
}

@property (nonatomic, retain) IBOutlet UIImageView *mTitleImageview;
@property (nonatomic, retain) IBOutlet UIButton *mTrainingImageview;
@property (nonatomic, retain) IBOutlet UIButton *mLibraryImageview;
@property (nonatomic, retain) IBOutlet UIButton *mPowerhourImageview;
@property (nonatomic, retain) IBOutlet UIButton *mSurveyImageview;
@property (nonatomic, retain) IBOutlet UIButton *mCoachImageview;
@property (nonatomic, retain) IBOutlet UIButton *mPromptImageview;
@property (nonatomic, retain) IBOutlet UILabel *mPromptLabel;

-(IBAction)btnAction:(id)sender;


- (id)initWithMOC:(NSManagedObjectContext *)MOC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC;

- (void)addTapGestureRecognizer:(UIImageView*)targetImageview;

-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer;
@end