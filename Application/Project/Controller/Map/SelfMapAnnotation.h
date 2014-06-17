//
//  SelfMapAnnotation.h
//  Aladdin
//
//  Created by Peter on 14-3-5.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "BasicMapAnnotation.h"

@interface SelfMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
	NSString *_title;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
                 tilte:(NSString *)title
              subTitle:(NSString *)subTitle;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;


@end
