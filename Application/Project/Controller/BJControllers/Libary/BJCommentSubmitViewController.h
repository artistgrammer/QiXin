//
//  BJCommentSubmitViewController.h
//  Project
//
//  Created by sun art on 14-6-4.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "RootViewController.h"
#import "CommonMethod.h"
#import "BJLibarysSecViewController.h"

@interface BJCommentSubmitViewController : RootViewController<UITextViewDelegate>
{
    NSInteger mCurrentSelectedIndex;
}

@property (nonatomic, retain) IBOutlet UIImageView *mFirstImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mSecondImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mThirdImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mForthImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mFifthImageview;

@property (nonatomic, retain) IBOutlet UITextField *mNicknameTF;
@property (nonatomic, retain) IBOutlet UITextField *mTitleTF;

@property (nonatomic, retain) IBOutlet UITextView *mContentView;
@property (nonatomic, retain) BJLibaryItem *mCurrentLibraryItem;

@property (nonatomic, retain) IBOutlet UIButton *mSubmitBtn;
- (IBAction)buttonAction:(id)sender;

- (id)initWithMOC:(NSManagedObjectContext *)MOC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC;

- (void)addTapGestureRecognizer:(UIImageView*)targetImageview;

-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer;

@end