//
//  ViewController.m
//  F36DataWithRelatedGeo
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
#import "Driver.h"

static NSString *APP_ID = @"1A9E560D-E6EE-DEF9-FF2C-2565B567E800";
static NSString *SECRET_KEY = @"2146BA33-CA63-EBC6-FFE4-1EAC4E0CD400";
static NSString *VERSION_NUM = @"v1";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    [backendless networkActivityIndicatorOn:YES];
    
    [self saveDataWithGeoSync];
    //[self saveDataWithGeoAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)saveDataWithGeoSync {
    
    NSLog(@"\n============ Saving data with geo point using the SYNC API ============");
    
    @try {
        
        Driver *driver = [Driver new];
        driver.driverName = @"Ruben Barrichelli";
        driver.rating = @5;
        driver.carMake = @"Mercedes";
        driver.carModel = @"E350";
        driver.location = [GeoPoint geoPoint:(GEO_POINT){.latitude=41.878247, .longitude=-87.629767} categories:@[@"drivers"] metadata:@{@"city":@"Chicago"}];
        
        driver = [[backendless.persistenceService of:Driver.class] save:driver];
        NSLog(@"SYNC: Driver has been saved. Location object ID - %@", driver.location.objectId);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
        return;
    }
}

-(void)saveDataWithGeoAsync {
    
    NSLog(@"\n============ Saving data with geo point using the ASYNC API ============");
    
    Driver *driver = [Driver new];
    driver.driverName = @"Jen Buttons";
    driver.rating = @4;
    driver.carMake = @"Lamborghini";
    driver.carModel = @"Diablo";
    driver.location = [GeoPoint geoPoint:(GEO_POINT){.latitude=32.803468, .longitude=-96.769879} categories:@[@"drivers"] metadata:@{@"city":@"Dallas"}];
    
    [[backendless.persistenceService of:Driver.class]
     save:driver
     response:^(Driver *d) {
         NSLog(@"ASYNC: Driver has been saved. Location object ID - %@", d.location.objectId);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

@end
