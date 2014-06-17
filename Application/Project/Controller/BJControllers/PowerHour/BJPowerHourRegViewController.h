//
//  BJPowerHourRegViewController.h
//  Project
//
//  Created by sun art on 14-6-5.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "RootViewController.h"
#import "CommonMethod.h"
#import "MapViewAnnotation.h"
#import "JingDianMapCell.h"
#import "DropDown.h"

@interface BJPowerHourRegViewController : RootViewController<MKMapViewDelegate,UITextFieldDelegate>
{
    NSInteger mCurrentSelectedIndex;
}

@property (nonatomic, retain) IBOutlet UIImageView *mFirstImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mSecondImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mThirdImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mForthImageview;

@property (nonatomic, retain) IBOutlet UITextField *mFromDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *mToDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *mTopicsTextField;


- (IBAction)buttonAction:(id)sender;

- (id)initWithMOC:(NSManagedObjectContext *)MOC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC;

- (void)addTapGestureRecognizer:(UIImageView*)targetImageview;

-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer;

@end