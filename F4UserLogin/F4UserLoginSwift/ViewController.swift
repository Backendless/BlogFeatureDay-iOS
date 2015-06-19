//
//  ViewController.swift
//  F4UserLoginSwift
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
    
    let APP_ID = "FD096198-52AE-F66F-FFCC-235D4EF5B900"
    let SECRET_KEY = "9B498173-1558-DC35-FF86-1A03A1E3EA00"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        backendless.hostURL = "http://10.0.1.62:9000"
        
        loginUser()
        //loginUserAsync()
    }
    
    func loginUser() {
        
        Types.try({ () -> Void in
            
            var registeredUser = self.backendless.userService.login("spiday@backendless.com", password: "greeng0blin")
            println("User has been logged in (SYNC): \(registeredUser)")
            self.backendless.userService.logout()
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error: \(exception as! Fault)")
        })
    }
    
    func loginUserAsync() {
        
        backendless.userService.login(
            "spiday@backendless.com", password:"greeng0blin",
            response: { (var registeredUser : BackendlessUser!) -> () in
                println("User has been logged in (ASYNC): \(registeredUser)")
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error: \(fault)")
            }
        )
    }

}

