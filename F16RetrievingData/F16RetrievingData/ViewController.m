//
//  ViewController.m
//  F16RetrievingData
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
#import "Location.h"
#import "Restaurant.h"

static NSString *APP_ID = @"CF47722D-EB7B-A0D0-FFE3-1FADE3346100";
static NSString *SECRET_KEY = @"43B43EF7-247A-ED56-FF2F-ECD43C6E9000";
static NSString *VERSION_NUM = @"v1";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    [self fetchingFirstPage];
    //[self fetchingFirstPageAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)fetchingFirstPage {
    
    NSLog(@"\n============ Fetching first page using the SYNC API ============");
    
    @try {
       
        NSDate *startTime = [NSDate date];
        
        BackendlessDataQuery *query = [BackendlessDataQuery query];
        BackendlessCollection *restaurants = [[backendless.persistenceService of:[Restaurant class]] find:query];
        
        NSArray *currentPage =[restaurants getCurrentPage];
        NSLog(@"Loaded %lu restaurant objects", (unsigned long)[currentPage count]);
        NSLog(@"Total restaurants in the Backendless storage - %@", [restaurants getTotalObjects]);
        
        for (Restaurant *restuarant in currentPage) {
            NSLog(@"Restaurant name = %@", restuarant.name);
        }
        
        NSLog(@"Total time (ms) - %g", 1000*[[NSDate date] timeIntervalSinceDate:startTime]);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
    }
}

-(void)fetchingFirstPageAsync {
    
    NSLog(@"\n============ Fetching first page using the ASYNC API ============");

    NSDate *startTime = [NSDate date];

    BackendlessDataQuery *query = [BackendlessDataQuery query];
    [[backendless.persistenceService of:[Restaurant class]]
     find:query
     response:^(BackendlessCollection *restaurants) {
         
         NSArray *currentPage =[restaurants getCurrentPage];
         NSLog(@"Loaded %lu restaurant objects", (unsigned long)[currentPage count]);
         NSLog(@"Total restaurants in the Backendless storage - %@", [restaurants getTotalObjects]);
         
         for (Restaurant *restuarant in currentPage) {
             NSLog(@"Restaurant name = %@", restuarant.name);
         }
         
         NSLog(@"Total time (ms) - %g", 1000*[[NSDate date] timeIntervalSinceDate:startTime]);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

@end
