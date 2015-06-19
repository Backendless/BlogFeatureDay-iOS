//
//  ViewController.swift
//  F43RequiredUserPropertiesSwift

import UIKit

class ViewController: UIViewController {
    
    let APP_ID = "YOUR-APP-ID-GOES-HERE"
    let SECRET_KEY = "YOUR-IOS-SECRET-KEY-GOES-HERE"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        registerUserSync()
        registerUserAsync()
    }
    
    func registerUserSync() {
        
        Types.try({ () -> Void in
            
            var user = BackendlessUser()
            user.email = "spiday@backendless.com"
            user.password = "greeng0blin"
            //user.name = "Spidey";
           
            var registeredUser = self.backendless.userService.registering(user)
            println("User has been registered (SYNC): \(registeredUser)")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error (SYNC): \(exception as! Fault)")
        })
    }
    
    func registerUserAsync() {
        
        var user = BackendlessUser()
        user.email = "spiday@backendless.com"
        user.password = "greeng0blin"
        //user.name = "Spidey";
        
        backendless.userService.registering(user,
            response: { (var registeredUser : BackendlessUser!) -> () in
                println("User has been registered (ASYNC): \(registeredUser)")
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
    
}

