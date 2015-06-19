//
//  ViewController.m
//  F52FetchingUsers

#import "ViewController.h"
#import "Backendless.h"

static NSString *APP_ID = @"YOUR-APP-ID-GOES-HERE";
static NSString *SECRET_KEY = @"YOUR-IOS-SECRET-KEY-GOES-HERE";
static NSString *VERSION_NUM = @"v1";

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    [self fetchingUsersSync];
    [self fetchingUsersAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)fetchingUsersSync {
    
    @try {
        
        id <IDataStore> dataStore = [backendless.persistenceService of:[BackendlessUser class]];
        BackendlessCollection *users = [dataStore find];
        
        NSLog(@"Users have been fetched (SYNC): %@", users);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error (SYNC): %@", fault);
    }
}

-(void)fetchingUsersAsync {
    
    id <IDataStore> dataStore = [backendless.persistenceService of:[BackendlessUser class]];
    [dataStore
     find:^(BackendlessCollection *users) {
         NSLog(@"Users have been fetched (ASYNC): %@", users);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error (ASYNC): %@", fault);
     }];
}

@end
