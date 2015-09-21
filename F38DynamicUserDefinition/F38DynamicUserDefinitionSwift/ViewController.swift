//
//  ViewController.swift
//  F38DynamicUserDefinitionSwift
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

class ViewController: UIViewController {
    
    let APP_ID = "YOUR-APP-ID-GOES-HERE"
    let SECRET_KEY = "YOUR-IOS-SECRET-KEY-GOES-HERE"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        registerUserWithDynamicPropertiesSync()
        registerUserWithDynamicPropertiesAsync()
    }
    
    func registerUserWithDynamicPropertiesSync() {
        
        Types.tryblock({ () -> Void in
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy 'at' HH:mm"
            let birthDate = dateFormatter.dateFromString("12.05.1980 at 12:00")
            
            let user = BackendlessUser()
            user.email = "spiderman@backendless.com"
            user.password = "greeng0blin"
            user.setProperty("name", object:"Spidey")
            user.setProperty("birthdate", object:birthDate)
            user.setProperty("employeeId", object:101)
            
            let registeredUser = self.backendless.userService.registering(user)
            print("User has been registered (SYNC): \(registeredUser)")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error (SYNC): \(exception as! Fault)")
        })
    }
    
    func registerUserWithDynamicPropertiesAsync() {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy 'at' HH:mm"
        let birthDate = dateFormatter.dateFromString("12.05.1980 at 12:00")
        
        let user = BackendlessUser()
        user.email = "spiderman@backendless.com"
        user.password = "greeng0blin"
        user.setProperty("name", object:"Spidey")
        user.setProperty("birthdate", object:birthDate)
        user.setProperty("employeeId", object:101)
        
        backendless.userService.registering(user,
            response: { ( registeredUser : BackendlessUser!) -> () in
                print("User has been registered (ASYNC): \(registeredUser)")
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
    
}

