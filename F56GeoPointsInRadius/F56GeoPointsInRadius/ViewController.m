//
//  ViewController.m
//  F56GeoPointsInRadius

#import "ViewController.h"
#import "Backendless.h"

#define _PRODUCTION_ 0
#define _TEST_SERVER_ 1
#define _LOCALHOST_ 0
#define _NAVARA_HOST_ 0
#define _KATYA_HOST_ 0

#if _PRODUCTION_
#if 1 // BEDemosiOS app
static NSString *APP_ID = @"88977ABC-84C1-7892-FF31-FE65E43DBB00";
static NSString *SECRET_KEY = @"33C75331-6DAE-EAFB-FFEF-3D6D1F52D600";
#endif
#if 0 // BEVideoChat app
static NSString *APP_ID = @"7B92560B-91F0-E94D-FFEB-77451B0F9700";
static NSString *SECRET_KEY = @"B9D27BA8-3964-F3AE-FF26-E71FFF487300";
#endif
#if 0 // BEFeatureDay app
static NSString *APP_ID = @"CF47722D-EB7B-A0D0-FFE3-1FADE3346100";
static NSString *SECRET_KEY = @"43B43EF7-247A-ED56-FF2F-ECD43C6E9000";
#endif
#endif // _PRODUCTION_

#if _TEST_SERVER_
#if 1 // TestApp200rel app
static NSString *APP_ID = @"11A1C5CE-6818-2FD0-FFCF-577F46F96F00";
static NSString *SECRET_KEY = @"F144006F-04A8-49DA-FF17-305514D71300";
#endif
#endif // _LOCALHOST_

#if _LOCALHOST_
#if 1 // CheckLogging app
static NSString *APP_ID = @"340462A6-7F00-F86A-FFBF-8F011C5A9800";
static NSString *SECRET_KEY = @"6CB0CA74-1840-96EF-FF86-5887E0E1E800";
#endif
#endif // _LOCALHOST_

#if _NAVARA_HOST_ // Alex Navara's app
static NSString *APP_ID = @"CBECDDA7-B669-3E1B-FF63-91415C1B8000";
static NSString *SECRET_KEY = @"CB5C273A-B619-239F-FF53-10205C4B2C00";
#endif // _NAVARA_HOST_

#if _KATYA_HOST_
#if 1 // TestApp app
static NSString *APP_ID = @"202C4FFF-85C7-0445-FF93-751AE1064100";
static NSString *SECRET_KEY = @"9B498173-1558-DC35-FF86-1A03A1E3EA00";
#endif
#endif // _KATYA_HOST_

static NSString *VERSION_NUM = @"v1";

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [DebLog setIsActive:YES];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
#if _PRODUCTION_
    backendless.hostURL = @"http://api.backendless.com";
#endif
#if _TEST_SERVER_
    backendless.hostURL = @"http://api.test.backendless.com";
#endif
#if _LOCALHOST_
    backendless.hostURL = @"http://10.0.1.62:9000";
#endif
#if _NAVARA_HOST_
    backendless.hostURL = @"http://10.0.1.31:9000";
#endif
#if _KATYA_HOST_
    backendless.hostURL = @"http://10.0.1.51:9000";
#endif
    
    [self loadGeoPointsSync];
    //[self loadGeoPointsAsync];
    
}

#pragma mark -
#pragma mark Private Methods

-(void)loadGeoPointsSync {
    
    NSLog(@"\n============ Loading geo points with the SYNC API ============");
    
    @try {
        
        BackendlessGeoQuery *query = [BackendlessGeoQuery
                                      queryWithPoint:(GEO_POINT){.latitude=32.555, .longitude=-97.667}
                                      radius:270 units:MILES
                                      categories:@[@"geoservice_sample"]];
        query.includeMeta = @YES;
        
        BackendlessCollection *points = [backendless.geoService getPoints:query];
        
#if 0
        NSLog(@"Total points in radius %@", points);
#else
        NSLog(@"Total points in radius %@", points.totalObjects);
        
        while ([points getCurrentPage].count) {
            
            NSArray *geoPoints = [points getCurrentPage];
            for (GeoPoint *geoPoint in geoPoints) {
                NSLog(@"%@", geoPoint);
            }
            
            points = [points nextPage];
        }
#endif
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
    
    BackendlessGeoQuery *query = [BackendlessGeoQuery
                                  queryWithPoint:(GEO_POINT){.latitude=32.555, .longitude=-97.667}
                                  radius:270 units:MILES
                                  categories:@[@"geoservice_sample"]];
    query.includeMeta = @YES;
    
    [backendless.geoService
     getPoints:query
     response:^(BackendlessCollection *points) {
         NSLog(@"Total points in radius %@", points.totalObjects);
         [self nextPageAsync:points];
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

@end
