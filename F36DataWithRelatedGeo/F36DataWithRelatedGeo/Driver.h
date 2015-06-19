#import <Foundation/Foundation.h>

@class GeoPoint;

@interface Driver : NSObject
@property (nonatomic, strong) NSString *driverName;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *carMake;
@property (nonatomic, strong) NSString *carModel;
@property (nonatomic, strong) GeoPoint *location;
@end
