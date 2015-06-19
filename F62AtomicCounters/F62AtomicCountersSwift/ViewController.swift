//
//  ViewController.swift
//  F62AtomicCountersSwift

import UIKit

class ViewController: UIViewController {
    
    let APP_ID = "YOUR-APP-ID-GOES-HERE"
    let SECRET_KEY = "YOUR-IOS-SECRET-KEY-GOES-HERE"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        backendless.hostURL = "http://api.backendless.com";
        
        counterIncrementAndGetSync()
        counterIncrementAndGetAsync()
    }
    
    func counterIncrementAndGetSync() {
        
        Types.try({ () -> Void in
            
            var counter = self.backendless.counters.of("my counter")
            var counterValue = counter.incrementAndGet()
            println("Counter value  (SYNC): \(counterValue )")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error (SYNC): \(exception as! Fault)")
            }
        )
    }
    
    func counterIncrementAndGetAsync() {
        
        var counter = self.backendless.counters.of("my counter")
        counter.incrementAndGet(
            { (var counterValue) -> () in
                println("Counter value  (ASYNC): \(counterValue )")
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
}

