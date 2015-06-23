#import <Foundation/Foundation.h>

@class BackendlessUser;
@class Location;

@interface Restaurant : NSObject
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *cuisine;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) BackendlessUser *owner;

-(void)addToLocations:(Location *)location;
-(void)removeFromLocations:(Location *)location;
-(NSMutableArray *)loadLocations;
-(void)freeLocations;
@end
