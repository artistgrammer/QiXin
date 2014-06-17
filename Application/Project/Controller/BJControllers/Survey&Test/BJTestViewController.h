//
//  BJTestViewController.h
//  Project
//
//  Created by sun art on 14-6-10.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "RootViewController.h"
#import "CommonMethod.h"

@interface BJTestViewController : RootViewController
{
    NSInteger mCurrentSelectedIndex;
    
    //超时计数
	NSTimer* mConnectionTimer;
}

@property (nonatomic, retain) IBOutlet UIImageView *mFirstImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mSecondImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mThirdImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mForthImageview;

@property (nonatomic, retain) IBOutlet UILabel *mBackgroundLabel;
@property (nonatomic, retain) IBOutlet UILabel *mPromptLabel;
@property (nonatomic, retain) IBOutlet UILabel *mProgressLabel;
@property (nonatomic, retain) IBOutlet UILabel *mProgressPercentLabel;

@property (nonatomic, retain) IBOutlet UIButton *mReviewBtn;
@property (nonatomic, retain) IBOutlet UIButton *mNextBtn;


- (IBAction)buttonAction:(id)sender;

- (id)initWithMOC:(NSManagedObjectContext *)MOC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC;

- (void)addTapGestureRecognizer:(UIImageView*)targetImageview;

-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer;

@end