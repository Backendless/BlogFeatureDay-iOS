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
        
        Types.try({ () -> Void in
            
            var p = Person()
            p.name = "James Bond";
            p.age = 42;
            
            self.backendless.cache.put("myobject", object: p)
            println("Person has been placed into cache (SYNC)")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error (SYNC): \(exception as! Fault)")
            }
        )
    }
    
    func getFromCacheSync() {
        
        Types.try({ () -> Void in
            
            var person = self.backendless.cache.get("myobject") as! Person
            println("Received object from cache (SYNC): name - \(person.name), age - \(person.age)")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error (SYNC): \(exception as! Fault)")
            }
        )
    }

    func addToCacheAsync() {
        
        var p = Person()
        p.name = "James Bond";
        p.age = 42;
        
        backendless.cache.put(
            "myobject",
            object: p,
            response: { (var o : AnyObject!) -> () in
                println("Person has been placed into cache (ASYNC)")
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
    
    func getFromCacheAsync() {
        
        backendless.cache.get(
            "myobject",
            response: { (var o : AnyObject!) -> () in
                var person = o as! Person
                println("Received object from cache (ASYNC): name - \(person.name), age - \(person.age)")
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
    
}

