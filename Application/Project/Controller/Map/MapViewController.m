//
//  MapViewController.m
//  Project
//
//  Created by Vshare on 14-5-9.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CommonMethod.h"
#import "MKMapView+ZoomLevel.h"

//添加水印
#import "UIImage+WaterMark.h"
#import "wiUIImage+Category.h"
#import "wiUIImageView+Category.h"

#define SPAN 5000.f

#define MERCATOR_RADIUS 85445659.44705395

#define GEORGIA_TECH_LATITUDE 33.777328
#define GEORGIA_TECH_LONGITUDE -84.397348

@interface MapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationCoordinate2D _currentLoaction;
    CLLocationManager      *_locationManager;
    MKMapView    *_userMapView;
    
    CAAnimationGroup      *m_pGroupAnimation;
    NSMutableArray *_annotationList;
    
    int enterLocationType;
}

@end

@implementation MapViewController
@synthesize mapViewDelegate;
@synthesize _currentPlace;

- (int)getZoomLevel:(MKMapView*)_mapView {
    
    return 21 - round(log2(_mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * _mapView.bounds.size.width)));
    
}

- (void)dealloc
{
    [_locationManager release],_locationManager = nil;
    [_userMapView release], _userMapView = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
           self.title = @"位置";
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(RootViewController *)pVC

{
    if (self =  [super initWithMOC:MOC
             needRefreshHeaderView:YES
             needRefreshFooterView:NO])
    {
        
        self.parentVC = pVC;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //    [self getCurrentPosition];
}

- (MKMapView *)createMapView
{
    _userMapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    [_userMapView setMapType:MKMapTypeStandard];
    [_userMapView setZoomEnabled:YES];
    [_userMapView setDelegate:self];
    return  _userMapView;
}

/*
//获取自己的当前位置信息
- (void)getCurrentPosition
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
    }
    
    if ([CLLocationManager locationServicesEnabled])
    {
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager setDistanceFilter:10.0f];
        [_locationManager startUpdatingLocation];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations objectAtIndex:[locations count] - 1];
    NSLog(@"newLocation:%@",[newLocation description]);
    _currentLoaction = newLocation.coordinate;
    
    //设置显示区域
    MKCoordinateSpan  span = MKCoordinateSpanMake(0.05,0.05);
    MKCoordinateRegion  region = MKCoordinateRegionMake(_currentLoaction,span);
    [_userMapView setRegion:region animated:YES];
} */


//定位当前位置
-(void)getSelfLocation:(LocationBlock)locaiontBlock  withAddress:(NSStringBlock) addressBlock

{
    __block CLLocationCoordinate2D location;
    [[MMLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        location = locationCorrrdinate;
        _currentLoaction = locationCorrrdinate;
        NSLog(@"latitude == %f,longitude == %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
        if (locaiontBlock) {
            locaiontBlock(locationCorrrdinate);
        }
        
    } withAddress:^(NSString *addressString) {
        
        addressString = [addressString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
       
        self._currentPlace = [NSString stringWithFormat:@"%@",addressString];
         NSLog(@"%@, _currentPalce == %@", addressString,_currentPlace);
        CLLocationDegrees latitude = location.latitude;
        CLLocationDegrees longitude = location.longitude;
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, SPAN, SPAN);
        MKCoordinateRegion adjustedRegion = [_userMapView regionThatFits:region];
        [_userMapView setRegion:adjustedRegion animated:YES];
        [_userMapView setZoomEnabled:YES];
        [_userMapView setCenterCoordinate:location zoomLevel:16 animated:NO];
        
        SelfMapAnnotation *annotation = [[[SelfMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude tilte:@"我的位置" subTitle:@""]  autorelease];
        
        
        [_userMapView addAnnotation:annotation];
        
        if (addressBlock)
            addressBlock(addressString);
    }];
}

#pragma mark - UIImage + Category

//用色素生成一张图片
- (UIImage *)createImageWithColor:(UIColor *)color withFrame:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

//截取图片并保存到相册
- (UIImage *)interceptionLocationViewAndSavedAlbum
{
    float width = 206.0f;
    float heigth = 120.0f;
    
    //截取当前视图
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT - 64), YES, 0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //设置截图的区域(viewImage为iPhone屏幕宽高的2倍)
    CGRect rect =CGRectMake(SCREEN_WIDTH - width, viewImage.size.height - heigth,width*2, heigth*2);
    CGImageRef imageRef = viewImage.CGImage;
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *locationImage = [[[UIImage alloc] initWithCGImage:imageRefRect] autorelease];
    CGImageRelease(imageRefRect);
    
    /*
    //图片处理添加水印:地理位置信息
    UIImage *bgImg = [self createImageWithColor:[UIColor colorWithRed:.16 green:.17 blue:.21 alpha:0.7] withFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    NSString *addressStr = [NSString stringWithFormat:@"  %@",_currentPlace];
    bgImg = [bgImg imageWithStringWaterMark:addressStr atPoint:CGPointMake(0, bgImg.size.height/4) color:[UIColor whiteColor] font:[UIFont systemFontOfSize:21]];
    
    locationImage = [locationImage imageWithWaterMask:bgImg inRect:CGRectMake(0, locationImage.size.height - bgImg.size.height, locationImage.size.width, bgImg.size.height)];
    
    //将图片存入相册
    UIImageWriteToSavedPhotosAlbum(locationImage,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
     */
    
    return locationImage;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    /*
     *error Code == 3310 权限问题，需要在设置，隐私，相册里面打开对该应用的禁用权限
     */
    NSLog(@"error === %@",[error description]);
}

#pragma mark - Positioning

- (void)sendCurrentLocation:(id)sender
{
    NSLog(@"current Location select...");
    
    NSString *latitudeStr = [NSString stringWithFormat:@"%f",_currentLoaction.latitude];
    NSString *longitudeStr = [NSString stringWithFormat:@"%f",_currentLoaction.longitude];
    
    NSMutableDictionary *locationDic = [[NSMutableDictionary alloc]init];
    [locationDic setObject:latitudeStr  forKey:TRANS_MAP_LATITUDE];
    [locationDic setObject:longitudeStr  forKey:TRANS_MAP_LONGITUDE];
    [locationDic setObject:self._currentPlace  forKey:TRANS_MAP_TITLE];
    [locationDic setObject:[NSString stringWithFormat:@"%d", [self getZoomLevel:_userMapView]]  forKey:TRANS_MAP_ZOOMLEVEL];
    
    if(self.mapViewDelegate && [self.mapViewDelegate respondsToSelector:@selector(sendLocationWithImage:withLocationData:)])
    {
        [self.mapViewDelegate sendLocationWithImage:[self interceptionLocationViewAndSavedAlbum] withLocationData:locationDic];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [locationDic release];
}


//定位发送的的位置
- (void)resetAnnitations:(NSMutableDictionary *)data enterType:(int)enterType
{
    [self.view addSubview:[self createMapView]];
    
    switch (enterType)
    {
        case MAP_CURRENTLOCATION_TYPE:
        {
            [self getSelfLocation:nil withAddress:nil];
            [self addRightBarButtonWithTitle:@"发送"
                                      target:self
                                      action:@selector(sendCurrentLocation:)];

        }
            break;
        case MAP_SENDLOCATION_TYPE:
        {
            [self setAnnotionsWithList:data];
        }
            break;
        default:
            break;
    }
    
    
}

- (void)setAnnotionsWithList:(NSMutableDictionary *)dic
{

    NSString *latitudeStr = [NSString stringWithFormat:@"%.6f", [[dic objectForKey:TRANS_MAP_LATITUDE] doubleValue]];
    NSString *longitudeStr = [NSString stringWithFormat:@"%.6f", [[dic objectForKey:TRANS_MAP_LONGITUDE] doubleValue]];
    
    CLLocationDegrees latitude = [latitudeStr doubleValue];
    CLLocationDegrees longitude = [longitudeStr doubleValue];
    
    NSString *title = [dic objectForKey:TRANS_MAP_TITLE];
    
//        NSString *subTitle = [dic objectForKey:@"subTitle"];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, SPAN, SPAN);
    MKCoordinateRegion adjustedRegion = [_userMapView regionThatFits:region];
    [_userMapView setRegion:adjustedRegion animated:YES];
    [_userMapView setZoomEnabled:YES];
    
    CLLocationCoordinate2D centerCoord = { latitude, longitude };
    int zoomLevel = [[dic objectForKey:TRANS_MAP_ZOOMLEVEL] intValue];
    [_userMapView setCenterCoordinate:centerCoord zoomLevel:zoomLevel animated:NO];
    
    BasicMapAnnotation *annotation = [[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude tilte:title subTitle:@""]  autorelease];
    
    [_userMapView addAnnotation:annotation];
}


#pragma mark - Circles Animation

- (CAAnimationGroup *)setAnimation
{
    CAAnimation* myAnimationRotate     = [self animationRotate];
    
    m_pGroupAnimation                  = [CAAnimationGroup animation];
    m_pGroupAnimation.delegate         = self;
    m_pGroupAnimation.removedOnCompletion = NO;
    m_pGroupAnimation.duration         = 1;
    m_pGroupAnimation.timingFunction   = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    m_pGroupAnimation.repeatCount      = FLT_MAX;//FLT_MAX;  //"forever";
    m_pGroupAnimation.fillMode         = kCAFillModeForwards;
    m_pGroupAnimation.animations       = [NSArray arrayWithObjects:myAnimationRotate, nil];
    
    return m_pGroupAnimation;
    
    //    [annotationView.layer addAnimation:m_pGroupAnimation forKey:@"animationRotate"];
}

- (CAAnimation *)animationRotate
{
    // UIButton *theButton = sender;
    // rotate animation
    CATransform3D rotationTransform  = CATransform3DMakeRotation(M_PI, 0, 0, -1);
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    animation.toValue       = [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration      = .3;
    animation.autoreverses  = NO;
    animation.cumulative    = NO;
    animation.repeatCount   = 10;
    animation.beginTime     = 0.1;
    animation.delegate      = self;
    
    return animation;
}

#pragma mark - MapView Delegate

//在定位地点添加标注点
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //判断是否是自己
    if ([annotation isKindOfClass:[SelfMapAnnotation class]])
    {
        MKAnnotationView *annotationView =[_userMapView dequeueReusableAnnotationViewWithIdentifier:@"SelfMapAnnotation"];
        if (!annotationView) {
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"SelfMapAnnotation"] autorelease];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"mapAnnoViewSelfLocation.png"];
            //            annotationView.layer.transform = CATransform3DMakeRotation(expanded ? 0 :M_PI, 0, 0, -1);
            
            [annotationView.layer addAnimation:[self setAnimation] forKey:@"animationRotate"];
        }
		
		return annotationView;
    }
    else if([annotation isKindOfClass:[BasicMapAnnotation class]])
    {
        
        MKAnnotationView *annotationView =[_userMapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomAnnotation"] autorelease];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"mapPin.png"];
        }
        
        BasicMapAnnotation *basicAnno = (BasicMapAnnotation *)annotation;
        MapAnnoationTitleView *titleView = [[[MapAnnoationTitleView alloc] initWithTitle:CGRectMake(0, 0, 200, 35) title:basicAnno.title subTitle:basicAnno.subTitle] autorelease];
        
        [annotationView addSubview:titleView];
		
		return annotationView;

    }
    return nil;
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    /*
    for (MKPinAnnotationView *mkView in views)
    {
        //弹出注解的左右视图
        UIImageView   *  headImageView=[[UIImageView  alloc] initWithImage:[UIImage   imageNamed:@"online.png"] ];
        [headImageView  setFrame:CGRectMake(1, 1, 30, 32)];
        [headImageView  autorelease];
        mkView.leftCalloutAccessoryView=headImageView;
        
        UIButton  *  rightbutton=[UIButton  buttonWithType:UIButtonTypeDetailDisclosure];
        [rightbutton setBackgroundColor:[UIColor greenColor]];
        mkView.rightCalloutAccessoryView=rightbutton;
    }*/
}


//点击注店，弹出标注点说明视图
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    /*
    if ([view.annotation isKindOfClass:[BasicMapAnnotation class]] == NO) {
        return;
    }
    
    UIImageView *headView = (UIImageView *)view.leftCalloutAccessoryView;
    [headView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_self@2x.png"]]];*/
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view  calloutAccessoryControlTapped:(UIControl *) control
{
    NSLog(@"AnnotationView Tapped....");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
