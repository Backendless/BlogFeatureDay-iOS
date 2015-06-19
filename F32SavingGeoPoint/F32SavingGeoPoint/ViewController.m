//
//  ViewController.m
//  F32SavingGeoPoint
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

    [self addGeoPointSync];
    [self addGeoPointAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)addGeoPointSync {
    
    NSLog(@"\n============ Adding geo point with the SYNC API ============");
    
    @try {
        
        GeoPoint *dallasTX = [GeoPoint
                              geoPoint:(GEO_POINT){.latitude=32.803468, .longitude=-96.769879}
                              categories:@[@"cities"]
                              metadata:@{@"city":@"Dallas",
                                         @"population":@1258000,
                                         @"photo":@"http://en.wikipedia.org/wiki/Dallas#mediaviewer/File:Xvixionx_29_April_2006_Dallas_Skyline.jpg"}
                              ];
        dallasTX = [backendless.geoService savePoint:dallasTX];
        NSLog(@"SYNC: geo point saved. Object ID - %@", dallasTX.objectId);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
        return;
    }
}

-(void)addGeoPointAsync {
    
    NSLog(@"\n============ Adding geo point with the ASYNC API ============");
    
    GeoPoint *houstonTX = [GeoPoint
                           geoPoint:(GEO_POINT){.latitude=29.76429, .longitude=-95.38370}
                           categories:@[@"cities"]
                           metadata:@{@"city":@"Houston",
                                      @"population":@2196000,
                                      @"photo":@"http://en.wikipedia.org/wiki/Houston#mediaviewer/File:Uptown_Houston.jpg"}
                           ];
    
    [backendless.geoService
     savePoint:houstonTX
     response:^(GeoPoint *point) {
         NSLog(@"ASYNC: geo point saved. Object ID - %@", point.objectId);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

@end
