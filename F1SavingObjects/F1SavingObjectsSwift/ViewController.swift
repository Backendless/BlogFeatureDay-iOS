//
//  ViewController.swift
//  F1SavingObjectsSwift
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
//

import UIKit

class ViewController: UIViewController {
    
    let APP_ID = "YOUR-APP-ID-GOES-HERE"
    let SECRET_KEY = "YOUR-IOS-SECRET-KEY-GOES-HERE"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        Types.try({ () -> Void in
            
            // create the orders datastore
            var orders = self.backendless.persistenceService.of(Order().ofClass())
            
            var orderItem1 = OrderItem()
            orderItem1.name = "Printer"
            orderItem1.quantity = 1
            orderItem1.price = 99.0
            
            var orderItem2 = OrderItem()
            orderItem2.name = "Paper"
            orderItem2.quantity = 10
            orderItem2.price = 19.0
            
            var order = Order()
            order.orderNumber = 1
            order.orderName = "Office Supplies"
            order.orderItems.append(orderItem1)
            order.orderItems.append(orderItem2)
            
            order = orders.save(order) as! Order
            println("Order has been saved: \(order.show())")
            
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error: \(exception as! Fault)")
        })
    }

}
