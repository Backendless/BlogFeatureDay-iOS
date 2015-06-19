//
//  ViewController.m
//  F39GeoPointWithRelatedData
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
#import "Architect.h"

static NSString *APP_ID = @"CF47722D-EB7B-A0D0-FFE3-1FADE3346100";
static NSString *SECRET_KEY = @"43B43EF7-247A-ED56-FF2F-ECD43C6E9000";
static NSString *VERSION_NUM = @"v1";

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    [self addGeoPointWithRelatedDataSync];
    [self addGeoPointWithRelatedDataAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)addGeoPointWithRelatedDataSync {
    
    NSLog(@"\n============ Adding geo point with the SYNC API ============");
    
    @try {
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd.MM.yyyy 'at' HH:mm"];
        
        Architect *gustaveEiffel = [Architect new];
        gustaveEiffel.name = @"Gustave Eiffel";
        gustaveEiffel.birthday = [dateFormatter dateFromString:@"27.11.1923 at 12:00"];
        gustaveEiffel.nationality = @"French";
        
        GeoPoint *eiffelTower = [GeoPoint
                                 geoPoint:(GEO_POINT){.latitude=48.85815, .longitude=2.29452}
                                 categories:@[@"towers", @"placesToVisit"]
                                 metadata:@{@"name":@"Eiffel Tower", @"architect":gustaveEiffel}
                                 ];
        
        GeoPoint *savedPoint = [backendless.geoService savePoint:eiffelTower];
        NSLog(@"SYNC: geo point saved. Object ID - %@", savedPoint.objectId);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
        return;
    }
}

-(void)addGeoPointWithRelatedDataAsync {
    
    NSLog(@"\n============ Adding geo point with the ASYNC API ============");
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd.MM.yyyy 'at' HH:mm"];
    
    Architect *gustaveEiffel = [Architect new];
    gustaveEiffel.name = @"Gustave Eiffel";
    gustaveEiffel.birthday = [dateFormatter dateFromString:@"27.11.1923 at 12:00"];
    gustaveEiffel.nationality = @"French";
    
    GeoPoint *eiffelTower = [GeoPoint
                             geoPoint:(GEO_POINT){.latitude=48.85815, .longitude=2.29452}
                             categories:@[@"towers", @"placesToVisit"]
                             metadata:@{@"name":@"Eiffel Tower", @"architect":gustaveEiffel}
                             ];
    
    [backendless.geoService
     savePoint:eiffelTower
     response:^(GeoPoint *geoPoint) {
         NSLog(@"ASYNC: geo point saved. Object ID - %@", geoPoint.objectId);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

@end
