//
//  MapViewAnnotation.m
//  Project
//
//  Created by sun art on 14-6-4.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "MapViewAnnotation.h"
@implementation MapViewAnnotation
@synthesize title, coordinate,index;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
    self = [super init];
    title = ttl;
    coordinate = c2d;
    return self;
}
- (id)initWithTitle:(NSString *)ttl Coordinate:(CLLocationCoordinate2D)c2d andIndex:(int)intIndex
{
    self = [super init];
    title = ttl;
    coordinate = c2d;
    index = intIndex;
    return self;
}

+(MKCoordinateRegion) regionForAnnotations:(NSArray*) annotations
{
    NSAssert(annotations!=nil, @"annotations was nil");
    NSAssert([annotations count]!=0, @"annotations was empty");
    
    double minLat=360.0f, maxLat=-360.0f;
    double minLon=360.0f, maxLon=-360.0f;
    
    for (id<MKAnnotation> vu in annotations) {
        if ( vu.coordinate.latitude  < minLat ) minLat = vu.coordinate.latitude;
        if ( vu.coordinate.latitude  > maxLat ) maxLat = vu.coordinate.latitude;
        if ( vu.coordinate.longitude < minLon ) minLon = vu.coordinate.longitude;
        if ( vu.coordinate.longitude > maxLon ) maxLon = vu.coordinate.longitude;
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat+maxLat)/2.0, (minLon+maxLon)/2.0);
    MKCoordinateSpan span = MKCoordinateSpanMake(maxLat-minLat, maxLon-minLon);
    MKCoordinateRegion region = MKCoordinateRegionMake (center, span);
    return region;
}
@end
