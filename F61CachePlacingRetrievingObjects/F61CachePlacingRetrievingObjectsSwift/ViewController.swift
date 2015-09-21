//
//  ViewController.swift
//  F61CachePlacingRetrievingObjectsSwift

import UIKit

class ViewController: UIViewController {
    
    let APP_ID = "YOUR-APP-ID-GOES-HERE"
    let SECRET_KEY = "YOUR-IOS-SECRET-KEY-GOES-HERE"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        addToCacheSync()
        getFromCacheSync()
        
        addToCacheAsync()
        getFromCacheAsync()
    }
    
    func addToCacheSync() {
        
        Types.tryblock({ () -> Void in
            
            let p = Person()
            p.name = "James Bond";
            p.age = 42;
            
            self.backendless.cache.put("myobject", object: p)
            print("Person has been placed into cache (SYNC)")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error (SYNC): \(exception as! Fault)")
            }
        )
    }
    
    func getFromCacheSync() {
        
        Types.tryblock({ () -> Void in
            
            let person = self.backendless.cache.get("myobject") as! Person
            print("Received object from cache (SYNC): name - \(person.name), age - \(person.age)")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error (SYNC): \(exception as! Fault)")
            }
        )
    }

    func addToCacheAsync() {
        
        let p = Person()
        p.name = "James Bond";
        p.age = 42;
        
        backendless.cache.put(
            "myobject",
            object: p,
            response: { ( o : AnyObject!) -> () in
                print("Person has been placed into cache (ASYNC)")
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
    
    func getFromCacheAsync() {
        
        backendless.cache.get(
            "myobject",
            response: { ( o : AnyObject!) -> () in
                let person = o as! Person
                print("Received object from cache (ASYNC): name - \(person.name), age - \(person.age)")
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
    
}

