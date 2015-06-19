//
//  ViewController.m
//  F43RequiredUserProperties

#import "ViewController.h"
#import "Backendless.h"

static NSString *APP_ID = @"YOUR-APP-ID-GOES-HERE";
static NSString *SECRET_KEY = @"YOUR-IOS-SECRET-KEY-GOES-HERE";
static NSString *VERSION_NUM = @"v1";

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    [self registerUserSync];
    [self registerUserAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)registerUserSync {
    
    @try {
        
        BackendlessUser *user = [BackendlessUser new];
        user.email = @"spiday@backendless.com";
        user.password = @"greeng0blin";
        //user.name = @"Spidey";
        
        BackendlessUser *registeredUser = [backendless.userService registering:user];
        NSLog(@"User has been registered (SYNC): %@", registeredUser);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error(SYNC): %@", fault);
    }
}

-(void)registerUserAsync {
    
    BackendlessUser *user = [BackendlessUser new];
    user.email = @"spiday@backendless.com";
    user.password = @"greeng0blin";
    //user.name = @"Spidey";
    
    [backendless.userService
     registering:user
     response:^(BackendlessUser *registeredUser) {
         NSLog(@"User has been registered (ASYNC): %@", registeredUser);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error (ASYNC): %@", fault);
     }];
}

@end
