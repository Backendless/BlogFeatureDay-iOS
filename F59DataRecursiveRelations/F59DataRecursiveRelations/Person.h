//
//  Person.h
//  F59DataRecursiveRelations

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) Person *mom;
@property (nonatomic, strong) Person *dad;
@property (nonatomic, strong) NSArray *children;
@end
