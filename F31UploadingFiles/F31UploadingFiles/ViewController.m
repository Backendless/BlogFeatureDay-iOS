//
//  ViewController.m
//  F31UploadingFiles
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

static NSString *APP_ID = @"YOUR-APP-ID-GOES-HERE";
static NSString *SECRET_KEY = @"YOUR-IOS-SECRET-KEY-GOES-HERE";
static NSString *VERSION_NUM = @"v1";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    [self uploadSync];
    //[self uploadAsync];
}

#pragma mark -
#pragma mark Private Methods

-(void)uploadSync {
    
    NSLog(@"\n============ Uploading file with the SYNC API ============");
    
    @try {
        
        NSData *data = [NSData dataWithBytes:"Hello mbaas!\nUploading files is easy!" length:37];
        BackendlessFile *uploadedFile = [backendless.fileService upload:@"myfiles/myhelloworld-sync.txt" content:data];
        NSLog(@"File has been uploaded. File URL is - %@", uploadedFile.fileURL);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
        return;
    }
}

-(void)uploadAsync {
    
    NSLog(@"\n============ Uploading file  with the ASYNC API ============");
    
    NSData *data = [NSData dataWithBytes:"Hello mbaas!\nUploading files is easy!" length:37];
    [backendless.fileService upload:@"myfiles/myhelloworld-async.txt" content:data
     response:^(BackendlessFile *uploadedFile) {
         NSLog(@"File has been uploaded. File URL is - %@", uploadedFile.fileURL);
     }
     error:^(Fault *fault) {
         NSLog(@"Server reported an error: %@", fault);
     }];
}

@end
