//
//  BJAddNewCoacherViewController.h
//  Project
//
//  Created by sun art on 14-6-6.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "RootViewController.h"
#import "CommonMethod.h"

@interface BJAddNewCoacheeViewController : RootViewController<UITextFieldDelegate>
{
    NSInteger mCurrentSelectedIndex;
}

@property (nonatomic, retain) IBOutlet UIImageView *mFirstImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mSecondImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mThirdImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mForthImageview;

@property (nonatomic, retain) IBOutlet UITextField *mFromDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *mToDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *mCoacheeOneDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *mCoacheeTwoDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *mCoacheeThreeDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *mCoacheeFourDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *mCoacheeFiveDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *mCoacherTextField;


- (IBAction)buttonAction:(id)sender;

- (id)initWithMOC:(NSManagedObjectContext *)MOC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC;

- (void)addTapGestureRecognizer:(UIImageView*)targetImageview;

-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer;

@end