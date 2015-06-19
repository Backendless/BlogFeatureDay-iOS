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
        
        Types.try({ () -> Void in
            
            var address = Address()
            address.street = "123 Main St"
            address.city = "Dallas"
            address.state = "Texas"
            address.zip = "75032"

            var user = BackendlessUser()
            user.email = "spiday@backendless.com"
            user.password = "greeng0blin"
            user.setProperty("address", object: address)
            
            var registeredUser = self.backendless.userService.registering(user)
            println("User has been registered (SYNC): \(registeredUser)")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error (SYNC): \(exception as! Fault)")
            }
        )
    }
    
    func registerUserAsync() {
        
        var address = Address()
        address.street = "123 Main St"
        address.city = "Dallas"
        address.state = "Texas"
        address.zip = "75032"
        
        var user = BackendlessUser()
        user.email = "green.goblin@backendless.com"
        user.password = "sp1day"
        user.setProperty("address", object: address)
        
        backendless.userService.registering(
            user,
            response: { (var registeredUser : BackendlessUser!) -> () in
                println("User has been registered (ASYNC): \(registeredUser)")
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
}

