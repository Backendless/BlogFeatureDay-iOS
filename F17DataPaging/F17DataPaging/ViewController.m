//
//  ViewController.m
//  F17DataPaging
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

#define BKNDLSS12192 0

// BasicTest
static NSString *APP_ID = @"25C2E37D-8EB6-8CDA-FF37-D6F05AE7EE00";
static NSString *SECRET_KEY = @"675002F9-A2F8-567F-FFB2-3E348B887900";
static NSString *VERSION_NUM = @"v1";
static NSString *HOST_URL = @"http://api.backendless.com";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    backendless.hostURL = HOST_URL;
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
#if BKNDLSS12192
    // http://support.backendless.com/topic/custom-class-name
    [[backendless data] mapTableToClass:@"Restaurants" type:[Restaurant class]];
#endif
    
    [self addRestaurants];

    [self basicPaging];
    [self basicPagingAsync];
    
    [self advancedPaging];
    [self advancedPagingAsync];
}

#pragma mark -
#pragma mark Private Methods

#define PAGESIZE 100

-(void)addRestaurants {
    
    @try {
        
        id <IDataStore> dataStore = [backendless.persistenceService of:[Restaurant class]];
        
        for (int i = 0; i < 300; i++) {
            Restaurant *r = [Restaurant new];
            r.name = [NSString stringWithFormat:@"TastyBaaS %d", i];
            r.cuisine = @"mBaaS";
            r = [dataStore save:r];
            NSLog(@"Save restaurant name = %@", r.name);
        }
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
    }
}

-(void)basicPaging {
    
    @try {
        
        NSDate *startTime = [NSDate date];
        
        BackendlessDataQuery *query = [BackendlessDataQuery query];
        BackendlessCollection *restaurants = [[backendless.persistenceService of:[Restaurant class]] find:query];
        NSLog(@"Total restaurants in the Backendless storage - %@ <'%@'=='%@'>", [restaurants getTotalObjects], [restaurants type], [restaurants getEntityName]);
        
        unsigned long size = 0;
        while ( (size = [[restaurants getCurrentPage] count]) ) {
            NSLog(@"Loaded %lu restaurant in the current page", size);
            restaurants = [restaurants nextPage];
        }
        
        NSLog(@"Total time (ms) - %g", 1000*[[NSDate date] timeIntervalSinceDate:startTime]);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
    }
}

-(void)nextPageAsync:(BackendlessCollection *)restaurants start:(NSDate *)start {
    
    unsigned long size = [[restaurants getCurrentPage] count];
    if (!size) {
        NSLog(@"Total time (ms) - %g", 1000*[[NSDate date] timeIntervalSinceDate:start]);
        return;
    }
    
    NSLog(@"Loaded %lu restaurant in the current page", size);
    
    [restaurants
     nextPageAsync:^(BackendlessCollection *rests) {
         [self nextPageAsync:rests start:start];
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

-(void)basicPagingAsync {
    
    NSDate *startTime = [NSDate date];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    [[backendless.persistenceService of:[Restaurant class]]
     find:query
     response:^(BackendlessCollection *restaurants) {
         NSLog(@"Total restaurants in the Backendless storage - %@", [restaurants getTotalObjects]);
         [self nextPageAsync:restaurants start:startTime];
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

-(void)advancedPaging {
    
    @try {
        
        NSDate *startTime = [NSDate date];
        
        BackendlessDataQuery *query = [BackendlessDataQuery query];
        query.queryOptions.relationsDepth = @(1);
        query.queryOptions.pageSize = @(PAGESIZE); //set page size
        BackendlessCollection *restaurants = [[backendless.persistenceService of:[Restaurant class]] find:query];
        NSLog(@"Total restaurants in the Backendless storage - %@", [restaurants getTotalObjects]);
        
        int offset = 0;
        unsigned long size = 0;
        while ( (size = [[restaurants getCurrentPage] count]) ) {
            NSLog(@"Loaded %lu restaurant in the current page", size);
            offset += size;
            restaurants = [restaurants getPage:offset pageSize:PAGESIZE];
        }
        
        NSLog(@"Total time (ms) - %g", 1000*[[NSDate date] timeIntervalSinceDate:startTime]);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
    }
}

-(void)getPageAsync:(BackendlessCollection *)restaurants offset:(int)offset start:(NSDate *)start {
    
    unsigned long size = [[restaurants getCurrentPage] count];
    if (!size) {
        NSLog(@"Total time (ms) - %g", 1000*[[NSDate date] timeIntervalSinceDate:start]);
        return;
    }
    
    NSLog(@"Loaded %lu restaurant in the current page", size);
    
    offset += size;
    [restaurants
     getPage:offset pageSize:PAGESIZE
     response:^(BackendlessCollection *rests) {
         [self getPageAsync:rests offset:offset start:start];
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

-(void)advancedPagingAsync {
    
    NSDate *startTime = [NSDate date];
    
    int offset = 0;
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.queryOptions.relationsDepth = @(1);
    query.queryOptions.pageSize = @(PAGESIZE); //set page size
    [[backendless.persistenceService of:[Restaurant class]]
     find:query
     response:^(BackendlessCollection *restaurants) {
         
         NSLog(@"Total restaurants in the Backendless storage - %@", [restaurants getTotalObjects]);
         [self getPageAsync:restaurants offset:offset start:startTime];
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

@end
