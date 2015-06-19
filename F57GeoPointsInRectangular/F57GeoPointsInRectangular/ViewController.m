//
//  ViewController.m
//  F57GeoPointsInRectangular

#import "ViewController.h"
#import "Backendless.h"

static NSString *APP_ID = @"YOUR-APP-ID-GOES-HERE";
static NSString *SECRET_KEY = @"YOUR-IOS-SECRET-KEY-GOES-HERE";
static NSString *VERSION_NUM = @"v1";

@implementation ViewController

-(void)viewDidLoad {
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

        GEO_POINT nordWest = (GEO_POINT){.latitude=49.615, .longitude=-152.944};
        GEO_POINT southEast = (GEO_POINT){.latitude=25.648, .longitude=-21.636};
        BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithRect:nordWest southEast:southEast categories:@[@"geoservice_sample"]];
        query.includeMeta = @YES;
        
        BackendlessCollection *points = [backendless.geoService getPoints:query];
        
        NSLog(@"Total points in rectangular %@", points.totalObjects);
        
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
    
    [points
     nextPageAsync:^(BackendlessCollection *rest) {
         [self nextPageAsync:rest];
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

-(void)loadGeoPointsAsync {
    
    NSLog(@"\n============ Loading geo points with the ASYNC API ============");
    
    GEO_POINT nordWest = (GEO_POINT){.latitude=49.615, .longitude=-152.944};
    GEO_POINT southEast = (GEO_POINT){.latitude=25.648, .longitude=-21.636};
    BackendlessGeoQuery *query = [BackendlessGeoQuery queryWithRect:nordWest southEast:southEast categories:@[@"geoservice_sample"]];
    query.includeMeta = @YES;
    
    [backendless.geoService
     getPoints:query
     response:^(BackendlessCollection *points) {
         NSLog(@"Total points in rectangular %@", points.totalObjects);
         [self nextPageAsync:points];
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

@end
