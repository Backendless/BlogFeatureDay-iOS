#import "Backendless.h"
#import "Restaurant.h"
#import "Location.h"

@implementation Restaurant

-(void)addToLocations:(Location *)location {

    if (!self.locations)
        self.locations = [NSMutableArray array];

    [self.locations addObject:location];
}

-(void)removeFromLocations:(Location *)location {

    [self.locations removeObject:location];

    if (!self.locations.count) {
        self.locations = nil;
    }
}

-(NSMutableArray *)loadLocations {

    if (!self.locations)
        [backendless.persistenceService load:self relations:@[@"locations"]];

    return self.locations;
}

-(void)freeLocations {

    if (!self.locations)
        return;

    [self.locations removeAllObjects];
    self.locations = nil;
}
@end