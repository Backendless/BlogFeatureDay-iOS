//
//  ViewController.m
//  F25RetrievingGeoPoints
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

    [self loadGeoPointsSync];
    [self loadGeoPointsAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)loadGeoPointsSync {
    
    NSLog(@"\n============ Loading geo points with the SYNC API ============");
    
    @try {

        BackendlessGeoQuery *query = [BackendlessGeoQuery query];
        [query addCategory:@"geoservice_sample"];
        query.includeMeta = @YES;
        
        BackendlessCollection *points = [backendless.geoService getPoints:query];
        
        NSLog(@"Total points in category %@", points.totalObjects);
        
        while ([points getCurrentPage].count) {
            
            NSArray *geoPoints = [points getCurrentPage];
            for (GeoPoint *geoPoint in geoPoints) {
                NSLog(@"%@", geoPoint);
            }
            
            points = [points nextPage];
        }
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
        return;
    }
}

-(void)nextPageAsync:(BackendlessCollection *)points {
    
    if (![points getCurrentPage].count) {
        return;
    }
    
    NSArray *geoPoints = [points getCurrentPage];
    for (GeoPoint *geoPoint in geoPoints) {
        NSLog(@"%@", geoPoint);
    }
    
    [points nextPageAsync:^(BackendlessCollection *rest) {
         [self nextPageAsync:rest];
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

-(void)loadGeoPointsAsync {
    
    NSLog(@"\n============ Loading geo points with the ASYNC API ============");
    
    BackendlessGeoQuery *query = [BackendlessGeoQuery query];
    [query addCategory:@"geoservice_sample"];
    query.includeMeta = @YES;
    
    [backendless.geoService getPoints:query
     response:^(BackendlessCollection *points) {
         NSLog(@"Total points in category %@", points.totalObjects);
         [self nextPageAsync:points];
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

@end
