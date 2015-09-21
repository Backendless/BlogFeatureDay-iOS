//
//  ViewController.m
//  F52FetchingUsers

#import "ViewController.h"
#import "Backendless.h"

static NSString *APP_ID = @"7B92560B-91F0-E94D-FFEB-77451B0F9700";
static NSString *SECRET_KEY = @"B9D27BA8-3964-F3AE-FF26-E71FFF487300";
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
