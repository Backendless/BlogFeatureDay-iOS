//
//  Order.swift
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

import UIKit

class Order : BackendlessEntity {
    
    var orderNumber = 0
    var orderName : String?
    var orderItems : [OrderItem] = []
    
    // description func
    func show() -> NSString {
        return "Order #\(self.orderNumber) '\(self.orderName)'\n\(self.orderItems)"
    }
}
