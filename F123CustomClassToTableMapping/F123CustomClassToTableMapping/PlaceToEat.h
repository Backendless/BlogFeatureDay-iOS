//
//  PlaceToEat.h
//  F123CustomClassToTableMapping

#import <Foundation/Foundation.h>

@class BackendlessUser;

@interface PlaceToEat : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *cuisine;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) BackendlessUser *owner;
@end
