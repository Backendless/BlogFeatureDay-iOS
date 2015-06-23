#import <Foundation/Foundation.h>

@interface Location : NSObject
@property (nonatomic, strong) NSString *streetAddress;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *phoneNumber;
@end

