//
//  ViewController.m
//  F34SendingEmail
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2015 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

#import "ViewController.h"
#import "Backendless.h"

static NSString *APP_ID = @"CF47722D-EB7B-A0D0-FFE3-1FADE3346100";
static NSString *SECRET_KEY = @"43B43EF7-247A-ED56-FF2F-ECD43C6E9000";
static NSString *VERSION_NUM = @"v1";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    [self sendHTMLEmailSync];
    [self sendHTMLEmailAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)sendHTMLEmailSync {
    
    NSLog(@"\n============ Sending email with the SYNC API ============");
    
    @try {
        NSString *subject = @"Hello from Backendless! (Sync call)";
        NSString *body = @"This is an email sent by <b>synchronous</b> API call from a <a href=\"http://backendless.com\">Backendless</a> backend";
        NSString *recipient = @"slavav@themidnightcoders.com";
        [backendless.messagingService sendHTMLEmail:subject body:body to:@[recipient]];
        NSLog(@"SYNC: HTML email has been sent");
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
        return;
    }
}

-(void)sendHTMLEmailAsync {
    
    NSLog(@"\n============ Sending email with the ASYNC API ============");
    
    NSString *subject = @"Hello from Backendless! (Async call)";
    NSString *body = @"This is an email sent by <b>asynchronous</b> API call from a <a href=\"http://backendless.com\">Backendless</a> backend";
    NSString *recipient = @"slavav@themidnightcoders.com";
    [backendless.messagingService
     sendHTMLEmail:subject body:body to:@[recipient]
     response:^(id result) {
         NSLog(@"ASYNC: HTML email has been sent");
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

@end
