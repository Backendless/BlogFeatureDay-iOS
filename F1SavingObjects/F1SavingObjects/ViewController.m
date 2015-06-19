//
//  ViewController.m
//  F1SavingObjects
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
#import "Order.h"
#import "OrderItem.h"

static NSString *APP_ID = @"YOUR-APP-ID-GOES-HERE";
static NSString *SECRET_KEY = @"YOUR-IOS-SECRET-KEY-GOES-HERE";
static NSString *VERSION_NUM = @"v1";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION_NUM];
    
    @try {
        
        // create the orders datastore
        id <IDataStore> orders = [backendless.persistenceService of:[Order class]];
        
        OrderItem *orderItem1 = [OrderItem new];
        orderItem1.name = @"Printer";
        orderItem1.quantity = @(1);
        orderItem1.price = @(99.0);
        
        OrderItem *orderItem2 = [OrderItem new];
        orderItem2.name = @"Paper";
        orderItem2.quantity = @(10);
        orderItem2.price = @(19.0);
        
        Order *order = [Order new];
        order.orderNumber = @(1);
        order.orderName = @"Office Supplies";
        [order addOrderItem:orderItem1];
        [order addOrderItem:orderItem2];
        
        order = [orders save:order];
        NSLog(@"Order has been saved: %@", order);
    }
    
    @catch (Fault *fault) {
        NSLog(@"Server reported an error: %@", fault);
    }
}

@end
