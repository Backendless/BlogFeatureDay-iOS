//
//  ViewController.m
//  F65MessagingPublishSubscribe

#import "ViewController.h"
#import "Backendless.h"

static NSString *APP_ID = @"YOUR-APP-ID-GOES-HERE";
static NSString *SECRET_KEY = @"YOUR-IOS-SECRET-KEY-GOES-HERE";
static NSString *VERSION_NUM = @"v1";

@interface ViewController () {
    int i;
}
@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    [self publish];
    [self subscribe];
    
    [self publishAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)publishSync {
    
    @try {
        
        NSString *message = [NSString stringWithFormat:@"Message %d", i++];
        MessageStatus *messageStatus =  [backendless.messaging publish:@"default" message:message];
        NSLog(@"Message published (SYNC) - %@", messageStatus.messageId);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error(SYNC): %@", fault);
    }
}

-(void)publishAsync {
    
    NSString *message = [NSString stringWithFormat:@"Message %d", i++];
    [backendless.messaging
     publish:@"default" message:message
     response:^(MessageStatus *messageStatus) {
         NSLog(@"Message published (ASYNC) - %@", messageStatus.messageId);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error (ASYNC): %@", fault);
     }];
}

-(void)publish {
    
    if (i) [self publishSync];
    
    dispatch_time_t interval = dispatch_time(DISPATCH_TIME_NOW, 1ull*NSEC_PER_MSEC*500);
    dispatch_after(interval, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self publish];
    });
}

-(void)subscribe {
    
    [backendless.messaging
     subscribe:@"default"
     subscriptionResponse:^(NSArray *messages) {
         
         for (id obj in messages) {
             if ([obj isKindOfClass:[Message class]]) {
                 Message *message = (Message *)obj;
                 NSLog(@"Received message -  %@", message.data);
             }
         }
     }
     subscriptionError:^(Fault *error) {
         NSLog(@"subscribe (ERROR): %@", error);
     }
     response:^(BESubscription *response) {
         NSLog(@"subscribe: SUBSCRIPTION: %@", response);
     }
     error:^(Fault *fault) {
         NSLog(@"subscribe FAULT: %@", fault);
     }];
}

@end
