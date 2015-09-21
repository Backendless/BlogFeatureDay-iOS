//
//  ViewController.swift
//  F55UserWithRelatedDataSwift

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
        
        Types.tryblock({ () -> Void in
            
            let address = Address()
            address.street = "123 Main St"
            address.city = "Dallas"
            address.state = "Texas"
            address.zip = "75032"

            let user = BackendlessUser()
            user.email = "spiday@backendless.com"
            user.password = "greeng0blin"
            user.setProperty("address", object: address)
            
            let registeredUser = self.backendless.userService.registering(user)
            print("User has been registered (SYNC): \(registeredUser)")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error (SYNC): \(exception as! Fault)")
            }
        )
    }
    
    func registerUserAsync() {
        
        let address = Address()
        address.street = "123 Main St"
        address.city = "Dallas"
        address.state = "Texas"
        address.zip = "75032"
        
        let user = BackendlessUser()
        user.email = "green.goblin@backendless.com"
        user.password = "sp1day"
        user.setProperty("address", object: address)
        
        backendless.userService.registering(
            user,
            response: { ( registeredUser : BackendlessUser!) -> () in
                print("User has been registered (ASYNC): \(registeredUser)")
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
}

