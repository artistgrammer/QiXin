//
//  BJPowerHourMapViewController.h
//  Project
//
//  Created by sun art on 14-6-4.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "RootViewController.h"
#import "CommonMethod.h"
#import "MapViewAnnotation.h"
#import "JingDianMapCell.h"

@interface BJPowerHourMapViewController : RootViewController<MKMapViewDelegate>
{
    NSInteger mCurrentSelectedIndex;
    
    NSMutableArray *arrayLocation;
    
    NSInteger mCurrentPlayerIndex;
}

@property (nonatomic, retain) IBOutlet UIImageView *mFirstImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mSecondImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mThirdImageview;
@property (nonatomic, retain) IBOutlet UIImageView *mForthImageview;

@property(nonatomic,retain)IBOutlet MKMapView *mapView;

@property(nonatomic,retain)IBOutlet UISegmentedControl* playserSegment;


- (IBAction)buttonAction:(id)sender;

-(IBAction)segmentAction:(UISegmentedControl *)Seg;

- (id)initWithMOC:(NSManagedObjectContext *)MOC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC;

- (void)addTapGestureRecognizer:(UIImageView*)targetImageview;

-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer;

@end