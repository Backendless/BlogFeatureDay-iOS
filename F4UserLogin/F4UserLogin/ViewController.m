//
//  ViewController.m
//  F4UserLogin
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

#define LOCALHOST 1
#if LOCALHOST
static NSString *APP_ID = @"FD096198-52AE-F66F-FFCC-235D4EF5B900";
static NSString *SECRET_KEY = @"9B498173-1558-DC35-FF86-1A03A1E3EA00";
#else
static NSString *APP_ID = @"88977ABC-84C1-7892-FF31-FE65E43DBB00";
static NSString *SECRET_KEY = @"33C75331-6DAE-EAFB-FFEF-3D6D1F52D600";
#endif
static NSString *VERSION_NUM = @"v1";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
#if LOCALHOST
    backendless.hostURL = @"http://10.0.1.62:9000";
#endif
    
    [self loginUser];
    [self loginUserAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)loginUser {
    
    @try {
        
        BackendlessUser *registeredUser = [backendless.userService login:@"spiday@backendless.com" password:@"greeng0blin"];
        NSLog(@"User has been logged in (SYNC): %@", registeredUser);
        [backendless.userService logout];
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
    }
    
    @finally {
    }
}

-(void)loginUserAsync {
    
    [backendless.userService
     login:@"spiday@backendless.com" password:@"greeng0blin"
     response:^(BackendlessUser *registeredUser) {
         NSLog(@"User has been logged in (ASYNC): %@", registeredUser);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

@end
