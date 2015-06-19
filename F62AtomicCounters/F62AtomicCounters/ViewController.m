//
//  ViewController.m
//  F62AtomicCounters

#import "ViewController.h"
#import "Backendless.h"

static NSString *APP_ID = @"YOUR-APP-ID-GOES-HERE";
static NSString *SECRET_KEY = @"YOUR-IOS-SECRET-KEY-GOES-HERE";
static NSString *VERSION_NUM = @"v1";

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    [self counterIncrementAndGetSync];
    [self counterIncrementAndGetAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)counterIncrementAndGetSync {
    
    @try {
        
        id <IAtomic> counter  = [backendless.counters of:@"my counter"];
        NSNumber *counterValue = [counter incrementAndGet];
        NSLog(@"Counter value (SYNC): %@", counterValue);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error(SYNC): %@", fault);
    }
}

-(void)counterIncrementAndGetAsync {
    
    id <IAtomic> counter  = [backendless.counters of:@"my counter"];
    [counter
     incrementAndGet:^(NSNumber *counterValue) {
         NSLog(@"Counter value (ASYNC): %@", counterValue);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error (ASYNC): %@", fault);
     }];
}

@end
