//
//  BJPowerHourMapViewController.m
//  Project
//
//  Created by sun art on 14-6-4.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BJPowerHourMapViewController.h"
#import "BJMaterialsViewController.h"
#import "BJLibaryCommentsViewController.h"
#import "BJPowerHourDetailViewController.h"
#import <MapKit/MKPointAnnotation.h>

@interface BJPowerHourMapViewController ()
{
}

@end

@implementation BJPowerHourMapViewController

@synthesize mFirstImageview;
@synthesize mSecondImageview;
@synthesize mThirdImageview;
@synthesize mForthImageview;

@synthesize playserSegment = _playserSegment;

@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
                  moc:(NSManagedObjectContext*)viewMOC
{
    self = [super initWithMOC:viewMOC];
    if (self) {
        _noNeedBackButton = NO;
        self.view = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil].view;
        
        mFirstImageview.tag = 0;
        mSecondImageview.tag = 1;
        mThirdImageview.tag = 2;
        mForthImageview.tag = 3;
        
        mCurrentSelectedIndex = 0;
    }
    return self;
}

- (IBAction)buttonAction:(id)sender
{
    //    BJApplyCourseViewController* courseDetailViewCtrl= [[BJApplyCourseViewController alloc] initWithNibName:@"BJApplyCourseViewController" bundle:nil moc:[CommonMethod getInstance].MOC];
    //
    //    [CommonMethod pushViewController:courseDetailViewCtrl  withAnimated:YES];
    //    [courseDetailViewCtrl release];
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
{
    
    self = [super initWithMOC:MOC];
    if (self) {
        _noNeedBackButton = NO;
    }
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Power Hour";
    
    [self addTapGestureRecognizer:mFirstImageview];
    [self addTapGestureRecognizer:mSecondImageview];
    [self addTapGestureRecognizer:mThirdImageview];
    [self addTapGestureRecognizer:mForthImageview];
    
    arrayLocation = [[NSMutableArray alloc] init];
//    NSMutableArray *arrAnnotations  = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"31.235542" forKey:@"latitude"];
    [dict setValue:@"120.481772" forKey:@"longitude"];
    [dict setValue:@"ShangHai" forKey:@"title"];
    [arrayLocation addObject:dict];
    [dict release];
    dict = nil;
    
    dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"31.235542" forKey:@"latitude"];
    [dict setValue:@"121.481772" forKey:@"longitude"];
    [dict setValue:@"BeiJing" forKey:@"title"];
    [arrayLocation addObject:dict];
    [dict release];
    dict = nil;
    
    dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"31.235542" forKey:@"latitude"];
    [dict setValue:@"123.481772" forKey:@"longitude"];
    [dict setValue:@"HangZhou" forKey:@"title"];
    [arrayLocation addObject:dict];
    [dict release];
    dict = nil;
    
    dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"32.235542" forKey:@"latitude"];
    [dict setValue:@"122.481772" forKey:@"longitude"];
    [dict setValue:@"NanJing" forKey:@"title"];
    [arrayLocation addObject:dict];
    [dict release];
    dict = nil;
    
    for(int i=0;i<[arrayLocation count];i++)
    {
        CLLocationCoordinate2D location;
        location.latitude = [[[arrayLocation objectAtIndex:i] objectForKey:@"latitude"] doubleValue];
        location.longitude = [[[arrayLocation objectAtIndex:i] objectForKey:@"longitude"] doubleValue];
        
        MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:[[arrayLocation objectAtIndex:i] objectForKey:@"title"] Coordinate:location andIndex:i];
//        [arrAnnotations addObject:newAnnotation];
        
        [_mapView addAnnotation:newAnnotation];
//        [_mapView selectAnnotation:newAnnotation animated:true];
        [newAnnotation release];
    }
//    [_mapView addAnnotations:arrAnnotations];
//    [arrAnnotations release];
    
    
    //设置显示范围
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 31.235542;
    coordinate.longitude = 121.481772;
    
    MKCoordinateRegion region;
    region.span.latitudeDelta = 20;
    region.span.longitudeDelta = 20;
    region.center = coordinate;
    
    // 设置显示位置(动画)
    [_mapView setRegion:region animated:YES];
    
    // 设置地图显示的类型及根据范围进行显示
    [_mapView regionThatFits:region];
}

/*0:trainer 1:trainee 2:chairman*/
-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %i", Index);
    mCurrentPlayerIndex = Index;
    
    switch (Index) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - for gesture
- (void)addTapGestureRecognizer:(UIImageView*)targetImageview {
    UITapGestureRecognizer *swipeGR = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(imageviewTouchEvents:)] autorelease];
    swipeGR.delegate = self;
    [targetImageview addGestureRecognizer:swipeGR];
}


-(void)imageviewTouchEvents:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *view = (UIImageView*)[gestureRecognizer view];
    int tagvalue = view.tag;
    DLog(@"%d is touched",tagvalue);
    view.highlighted = !view.highlighted;
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == _mapView.userLocation)
    {
        return nil;
    }
    
    if ([annotation isKindOfClass:[MapViewAnnotation class]]) {
        
        MKAnnotationView *annotationView =[_mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomAnnotation"] autorelease];
            annotationView.canShowCallout = YES;
            
            CGSize size = CGSizeMake(17, 17);
            [annotationView sizeThatFits:size];
            annotationView.image = [UIImage imageNamed:@"1.3.0-map1_26.png"];
            annotationView.contentMode = UIViewContentModeScaleAspectFit;
            annotationView.selected = YES;
        }
        
		return annotationView;
    }
    
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
	if ([view.annotation isKindOfClass:[MapViewAnnotation class]]) {
        debugLog(@"点击至之后你要在这干点啥1");

	}
    else{
        
        debugLog(@"点击至之后你要在这干点啥");
    }
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	if ([view.annotation isKindOfClass:[MapViewAnnotation class]]) {
        debugLog(@"idDeselectAnnotationView-点击至之后你要在这干点啥1");
        
        BJPowerHourDetailViewController *powerHourDetailVC = [[BJPowerHourDetailViewController alloc] initWithNibName:nil bundle:nil moc:_MOC];
        [CommonMethod pushViewController:powerHourDetailVC  withAnimated:YES];
        [powerHourDetailVC release];
	}
    else{
        
        debugLog(@"idDeselectAnnotationView-点击至之后你要在这干点啥");
    }
}

- (void) dealloc
{
    [super dealloc];
    
    [mFirstImageview release];
    [mSecondImageview release];
    [mThirdImageview release];
    [mForthImageview release];
    
//    [_mapView release];
    
    [arrayLocation release];
    [_playserSegment release];
}
@end
