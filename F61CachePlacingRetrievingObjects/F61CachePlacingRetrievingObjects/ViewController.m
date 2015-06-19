//
//  ViewController.m
//  F61CachePlacingRetrievingObjects

#import "ViewController.h"
#import "Backendless.h"
#import "Person.h"

static NSString *APP_ID = @"YOUR-APP-ID-GOES-HERE";
static NSString *SECRET_KEY = @"YOUR-IOS-SECRET-KEY-GOES-HERE";
static NSString *VERSION_NUM = @"v1";

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    [self addToCacheSync];
    [self getFromCacheSync];
    
    [self addToCacheAsync];
    [self getFromCacheAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)addToCacheSync {
    
    @try {
        
        Person *p = [Person new];
        p.name = @"James Bond";
        p.age = @42;
        
        [backendless.cache put:@"myobject" object:p];
        NSLog(@"Person has been placed into cache (SYNC)");
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error(SYNC): %@", fault);
    }
}

-(void)getFromCacheSync {
    
    @try {
        
        Person *person = [backendless.cache get:@"myobject"];
        NSLog(@"Received object from cache (SYNC): name - %@, age - %@", person.name, person.age);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error(SYNC): %@", fault);
    }
}

-(void)addToCacheAsync {
    
    Person *p = [Person new];
    p.name = @"James Bond";
    p.age = @42;
    
    [backendless.cache
     put:@"myobject" object:p
     response:^(id o) {
         NSLog(@"Person has been placed into cache (ASYNC): %@", o);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error (ASYNC): %@", fault);
     }];
}

-(void)getFromCacheAsync {
    
    [backendless.cache
     get:@"myobject"
     response:^(id o) {
         Person *person = (Person *)o;
         NSLog(@"Received object from cache (ASYNC): name - %@, age - %@", person.name, person.age);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error (ASYNC): %@", fault);
     }];
}

@end
