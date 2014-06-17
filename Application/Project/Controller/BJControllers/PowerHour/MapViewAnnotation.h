//
//  MapViewAnnotation.h
//  Project
//
//  Created by sun art on 14-6-4.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation>{
    NSString *title;
    int index;
    CLLocationCoordinate2D coordinate;
    
}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readwrite) int index;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;
- (id)initWithTitle:(NSString *)ttl Coordinate:(CLLocationCoordinate2D)c2d andIndex:(int)intIndex;

+(MKCoordinateRegion) regionForAnnotations:(NSArray*) annotations ;
@end
