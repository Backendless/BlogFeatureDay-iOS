//
//  ViewController.m
//  F60DataSaveUserBelong

#import "ViewController.h"
#import "Backendless.h"
#import "Order.h"

static NSString *APP_ID = @"YOUR-APP-ID-GOES-HERE";
static NSString *SECRET_KEY = @"YOUR-IOS-SECRET-KEY-GOES-HERE";
static NSString *VERSION_NUM = @"v1";

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    [self saveOrderSync];
    [self saveOrderAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)saveOrderSync {
    
    @try {
        
        BackendlessUser *registeredUser = [backendless.userService login:@"spiday@backendless.com" password:@"greeng0blin"];
        NSLog(@"User has been logged in (SYNC): %@", registeredUser);
       
        Order *order1 = [Order new];
        order1.orderName = @"spider web";
        order1.orderNumber = @1;
        order1 = [backendless.data save:order1];
        NSLog(@"Order 1 has been saved (SYNC): %@ -> %@", order1.orderName, order1.orderNumber);
        
        Order *order2 = [Order new];
        order2.orderName = @"costume";
        order2.orderNumber = @2;
        order2 = [backendless.data save:order2];
        NSLog(@"Order 2 has been saved (SYNC): %@ -> %@", order2.orderName, order2.orderNumber);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error (SYNC): %@", fault);
    }
}

-(void)saveOrderAsync {
    
    [backendless.userService
     login:@"spiday@backendless.com" password:@"greeng0blin"
     response:^(BackendlessUser *registeredUser) {
         NSLog(@"User has been logged in (ASYNC): %@", registeredUser);
         
         Order *order1 = [Order new];
         order1.orderName = @"spider web";
         order1.orderNumber = @1;
         [backendless.data
          save:order1
          response:^(Order *order) {
              NSLog(@"Order 1 has been saved (ASYNC): %@ -> %@", order.orderName, order.orderNumber);
          }
          error:^(Fault *fault) {
              NSLog(@"Server reported an error: %@", fault);
          }];
         
         Order *order2 = [Order new];
         order2.orderName = @"costume";
         order2.orderNumber = @2;
         [backendless.data
          save:order2
          response:^(Order *order) {
              NSLog(@"Order 2 has been saved (ASYNC): %@ -> %@", order.orderName, order.orderNumber);
          }
          error:^(Fault *fault) {
              NSLog(@"Server reported an error: %@", fault);
          }];
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

@end
