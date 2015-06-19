//
//  ViewController.m
//  F38DynamicUserDefinition
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2015 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

#import "ViewController.h"
#import "Backendless.h"

static NSString *APP_ID = @"YOUR-APP-ID-GOES-HERE";
static NSString *SECRET_KEY = @"YOUR-IOS-SECRET-KEY-GOES-HERE";
static NSString *VERSION_NUM = @"v1";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    [self registerUserWithDynamicPropertiesSync];
    [self registerUserWithDynamicPropertiesAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)registerUserWithDynamicPropertiesSync {
    
    @try {
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd.MM.yyyy 'at' HH:mm"];
        NSDate *birthDate = [dateFormatter dateFromString:@"12.05.1980 at 12:00"];
        
        BackendlessUser *user = [BackendlessUser new];
        user.email = @"spiderman@backendless.com";
        user.password = @"greeng0blin";
        [user setProperty:@"name" object:@"Spidey"];
        [user setProperty:@"birthdate" object:birthDate];
        [user setProperty:@"employeeId" object:@101];
        
        BackendlessUser *registeredUser = [backendless.userService registering:user];
        NSLog(@"User has been registered (SYNC): %@", registeredUser);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error (SYNC): %@", fault);
    }
}

-(void)registerUserWithDynamicPropertiesAsync {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd.MM.yyyy 'at' HH:mm"];
    NSDate *birthDate = [dateFormatter dateFromString:@"12.05.1980 at 12:00"];
    
    BackendlessUser *user = [BackendlessUser new];
    user.email = @"spiderman@backendless.com";
    user.password = @"greeng0blin";
    [user setProperty:@"name" object:@"Spidey"];
    [user setProperty:@"birthdate" object:birthDate];
    [user setProperty:@"employeeId" object:@101];
    
    [backendless.userService
     registering:user
     response:^(BackendlessUser *registeredUser) {
         NSLog(@"User has been registered (ASYNC): %@", registeredUser);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error (ASYNC): %@", fault);
     }];
}

@end
