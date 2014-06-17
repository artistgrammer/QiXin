#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BasicMapAnnotation : NSObject <MKAnnotation> {
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
