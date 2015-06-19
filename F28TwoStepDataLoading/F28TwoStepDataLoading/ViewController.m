//
//  ViewController.m
//  F28TwoStepDataLoading
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

static NSString *APP_ID = @"YOUR-APP-ID-GOES-HERE";
static NSString *SECRET_KEY = @"YOUR-IOS-SECRET-KEY-GOES-HERE";
static NSString *VERSION_NUM = @"v1";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    [self twoStepsLoadRelationsSync];
    [self twoStepsLoadRelationsAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)printLocations:(NSArray *)locations {
    
    if (!locations) {
        NSLog(@"Restaurant locations have not been loaded");
        return;
    }
    
    if (!locations.count) {
        NSLog(@"There are no related locations");
        return;
    }
    
    for (Location *location in locations) {
        NSLog(@"Location: Street address - %@, City - %@", location.streetAddress, location.city);
    }
}

-(void)twoStepsLoadRelationsSync {
    
    NSLog(@"\n============ Loading relations with the SYNC API ============");
    
    @try {
        
        BackendlessDataQuery *query = [BackendlessDataQuery query];
        BackendlessCollection *restaurants = [[backendless.persistenceService of:[Restaurant class]] find:query];
        
        NSArray *currentPage =[restaurants getCurrentPage];
        NSLog(@"Loaded %lu restaurant objects", (unsigned long)[currentPage count]);
        NSLog(@"Total restaurants in the Backendless storage - %@", [restaurants getTotalObjects]);
        
        for (Restaurant *restaurant in currentPage) {
            [backendless.persistenceService load:restaurant relations:@[@"locations"]];
            NSLog(@"Restaurant name = %@", restaurant.name);
            [self printLocations:restaurant.locations];
        }
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
    }
}

-(void)twoStepsLoadRelationsAsync {
    
    NSLog(@"\n============ Loading relations with the ASYNC API ============");
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    [[backendless.persistenceService of:[Restaurant class]]
     find:query
     response:^(BackendlessCollection *restaurants) {
         
         NSArray *currentPage =[restaurants getCurrentPage];
         NSLog(@"Loaded %lu restaurant objects", (unsigned long)[currentPage count]);
         NSLog(@"Total restaurants in the Backendless storage - %@", [restaurants getTotalObjects]);
         
         for (Restaurant *restaurant in currentPage) {
             [backendless.persistenceService
              load:restaurant
              relations:@[@"locations"]
              response:^(Restaurant *r) {
                  NSLog(@"Restaurant name = %@", r.name);
                  [self printLocations:r.locations];
              }
              error:^(Fault *fault) {
                  NSLog(@"Server reported an error: %@", fault);
              }];
         }
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

@end
