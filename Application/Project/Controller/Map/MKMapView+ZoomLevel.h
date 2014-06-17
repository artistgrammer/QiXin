//
//  MKMapView+ZoomLevel.h
//  Project
//
//  Created by Adam on 14-5-12.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
