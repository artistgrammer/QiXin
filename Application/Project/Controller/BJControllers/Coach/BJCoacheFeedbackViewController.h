//
//  BJCoacheFeedbackViewController.h
//  Project
//
//  Created by sun art on 14-6-6.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//
#import "BaseListViewController.h"
#import "CommonMethod.h"

@interface BJCoacheFeedbackViewController : BaseListViewController
{
    
}

@property (nonatomic, retain) IBOutlet UIImageView *mFiveImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mFourImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mThreeImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mTwoImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mOneImageview;

@property (nonatomic, retain) IBOutlet UIButton *mCancelButton;
@property (nonatomic, retain) IBOutlet UIButton *mSubmitButton;

@property (nonatomic, retain) UITableViewCell *mSelectedCell;

- (IBAction)buttonAction:(id)sender;

- (id)initWithMOC:(NSManagedObjectContext *)MOC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC;


- (void)addTapGestureRecognizer:(UIImageView*)targetImageview;

-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer;

@end