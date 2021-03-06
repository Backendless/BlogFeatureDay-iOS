//
//  FileInfo.h
//  backendlessAPI
//
//  Created by Slava Vdovichenko on 8/13/15.
//  Copyright (c) 2015 BACKENDLESS.COM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileInfo : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *createOn;
@property (strong, nonatomic) NSString *publicUrl;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSNumber *size;
@end