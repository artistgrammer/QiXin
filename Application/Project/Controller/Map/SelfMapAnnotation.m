//
//  SelfMapAnnotation.m
//  Aladdin
//
//  Created by Peter on 14-3-5.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "SelfMapAnnotation.h"

@interface SelfMapAnnotation()


@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;


@end

@implementation SelfMapAnnotation

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize title = _title;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude {
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
	}
	return self;
}


- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
                 tilte:(NSString *)title
              subTitle:(NSString *)subTitle
{
    if (self = [super init]) {
        self.latitude = latitude;
        self.longitude = longitude;
        self.title = title;
        self.subTitle = subTitle;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	self.latitude = newCoordinate.latitude;
	self.longitude = newCoordinate.longitude;
}

@end
