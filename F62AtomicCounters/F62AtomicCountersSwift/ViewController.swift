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
        
        Types.tryblock({ () -> Void in
            
            let counter = self.backendless.counters.of("my counter")
            let counterValue = counter.incrementAndGet()
            print("Counter value  (SYNC): \(counterValue )")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error (SYNC): \(exception as! Fault)")
            }
        )
    }
    
    func counterIncrementAndGetAsync() {
        
        let counter = self.backendless.counters.of("my counter")
        counter.incrementAndGet(
            { ( counterValue) -> () in
                print("Counter value  (ASYNC): \(counterValue )")
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
}

