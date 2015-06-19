//
//  Address.h
//  F55UserWithRelatedData
//
//  Created by Vyacheslav Vdovichenko on 4/9/15.
//  Copyright (c) 2015 backendless.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@end
