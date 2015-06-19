//
//  ViewController.swift
//  F60DataSaveUserBelongSwift

import UIKit

class ViewController: UIViewController {
    
    let APP_ID = "YOUR-APP-ID-GOES-HERE"
    let SECRET_KEY = "YOUR-IOS-SECRET-KEY-GOES-HERE"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        backendless.hostURL = "http://api.backendless.com"
        
        saveOrderSync()
        saveOrderAsync()
    }
    
    func saveOrderSync() {
        
        Types.try({ () -> Void in
            
            var registeredUser = self.backendless.userService.login("spiday@backendless.com", password: "greeng0blin")
            println("User has been logged in (SYNC): \(registeredUser)")
            
            var order1 = Order()
            order1.orderName = "spider web"
            order1.orderNumber = 1
            order1 = self.backendless.data.save(order1) as! Order
            println("Order 1 has been saved (SYNC): \(order1.orderName) -> \(order1.orderNumber)")
            
            var order2 = Order()
            order2.orderName = "costume"
            order2.orderNumber = 2
            order2 = self.backendless.data.save(order2) as! Order
            println("Order 2 has been saved (SYNC): \(order2.orderName) -> \(order2.orderNumber)")
            
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error (SYNC): \(exception as! Fault)")
        })
    }
    
    func saveOrderAsync() {
        
        backendless.userService.login(
            "spiday@backendless.com", password:"greeng0blin",
            response: { (var registeredUser : BackendlessUser!) -> () in
                println("User has been logged in (ASYNC): \(registeredUser)")
                
                var order1 = Order()
                order1.orderName = "spider web"
                order1.orderNumber = 1
                
                self.backendless.data.save(
                    order1,
                    response: { (var order : AnyObject!) -> () in
                        println("Order 1 has been saved (ASYNC): \((order as! Order).orderName) -> \((order as! Order).orderNumber)")
                    },
                    error: { (var fault : Fault!) -> () in
                        println("Server reported an error (ASYNC): \(fault)")
                   }
                )
                
                var order2 = Order()
                order2.orderName = "costume"
                order2.orderNumber = 2
                
                self.backendless.data.save(
                    order2,
                    response: { (var order : AnyObject!) -> () in
                        println("Order 2 has been saved (ASYNC): \((order as! Order).orderName) -> \((order as! Order).orderNumber)")
                    },
                    error: { (var fault : Fault!) -> () in
                        println("Server reported an error (ASYNC): \(fault)")
                    }
                )

            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
}

