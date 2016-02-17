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
    
    let APP_ID = "E7E19714-4915-AB27-FF93-A081D48C5100"
    let SECRET_KEY = "B4CE8CD5-756C-3367-FFB2-2349543D8100"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        Types.tryblock({ () -> Void in
            
            // create the orders datastore
            let orders = self.backendless.persistenceService.of(Order().ofClass())
            
            let orderItem1 = OrderItem()
            orderItem1.name = "Printer"
            orderItem1.quantity = 1
            orderItem1.price = 99.0
            
            let orderItem2 = OrderItem()
            orderItem2.name = "Paper"
            orderItem2.quantity = 10
            orderItem2.price = 19.0
            
            var order = Order()
            order.orderNumber = 1
            order.orderName = "Office Supplies"
            order.orderItems.append(orderItem1)
            order.orderItems.append(orderItem2)
            
            order = orders.save(order) as! Order
            print("Order has been saved: \(order.show())")
            
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
        })
    }

}

