//
//  ViewController.m
//  F55UserWithRelatedData

#import "ViewController.h"
#import "Backendless.h"
#import "Address.h"

static NSString *APP_ID = @"7B92560B-91F0-E94D-FFEB-77451B0F9700";
static NSString *SECRET_KEY = @"B9D27BA8-3964-F3AE-FF26-E71FFF487300";
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
        
        Address *address = [Address new];
        address.street = @"123 Main St";
        address.city = @"Dallas";
        address.state = @"Texas";
        address.zip = @"75032";
        
        BackendlessUser *user = [BackendlessUser new];
        user.email = @"spiday@backendless.com";
        user.password = @"greeng0blin";
        user.name = @"spiday";
        [user setProperty:@"address" object:address];
        
        BackendlessUser *registeredUser = [backendless.userService registering:user];
        NSLog(@"User has been registered (SYNC): %@", registeredUser);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error(SYNC): %@", fault);
    }
}

-(void)registerUserAsync {
    
    Address *address = [Address new];
    address.street = @"123 Main St";
    address.city = @"Dallas";
    address.state = @"Texas";
    address.zip = @"75032";
    
    BackendlessUser *user = [BackendlessUser new];
    user.email = @"green.goblin@backendless.com";
    user.password = @"sp1dey";
    user.name = @"green.goblin";
    [user setProperty:@"address" object:address];
    
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
