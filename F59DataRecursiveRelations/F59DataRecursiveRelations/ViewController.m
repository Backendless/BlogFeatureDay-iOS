//
//  ViewController.m
//  F59DataRecursiveRelations

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
    
    [self savePersonSync];
    [self savePersonAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)savePersonSync {
    
    @try {
        
        Person *me = [Person new];
        me.name = @"Bobby";
        me.age = @13;
        
        Person *mom = [Person new];
        mom.name = @"Jennifer";
        mom.age = @40;
        mom.children = @[me];
        
        Person *dad = [Person new];
        dad.name = @"Richard";
        dad.age = @41;
        dad.children = @[me];
        
        me.mom = mom;
        me.dad = dad;
        
        me = [backendless.data save:me];
        
        NSLog(@"Person has been saved (SYNC): %@", me);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error(SYNC): %@", fault);
    }
}

-(void)savePersonAsync {
    
    Person *me = [Person new];
    me.name = @"Bobby";
    me.age = @13;
    
    Person *mom = [Person new];
    mom.name = @"Jennifer";
    mom.age = @40;
    mom.children = @[me];
    
    Person *dad = [Person new];
    dad.name = @"Richard";
    dad.age = @41;
    dad.children = @[me];
    
    me.mom = mom;
    me.dad = dad;
    
    [backendless.data
     save:me
     response:^(Person *person) {
         NSLog(@"Person has been saved (ASYNC): %@", person);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error (ASYNC): %@", fault);
     }];
}

@end
