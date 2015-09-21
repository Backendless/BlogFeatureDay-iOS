//
//  ViewController.swift
//  F59DataRecursiveRelationsSwift

import UIKit

class ViewController: UIViewController {
    
    let APP_ID = "YOUR-APP-ID-GOES-HERE"
    let SECRET_KEY = "YOUR-IOS-SECRET-KEY-GOES-HERE"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        savePersonSync()
        savePersonAsync()
    }
    
    func savePersonSync() {
        
        Types.tryblock({ () -> Void in
            
            var me = Person()
            me.name = "Bobby"
            me.age = 13
            
            let mom = Person()
            mom.name = "Jennifer"
            mom.age = 40
            mom.children = [me]
            
            let dad = Person()
            dad.name = "Richard"
            dad.age = 41
            dad.children = [me]
            
            me.mom = mom
            me.dad = dad
            
            me = self.backendless.data.save(me) as! Person
            print("Person has been saved (SYNC): \(me.name) -> \(me.age)")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error (SYNC): \(exception as! Fault)")
            }
        )
    }
    
    func savePersonAsync() {
        
        let me = Person()
        me.name = "Bobby"
        me.age = 13
        
        let mom = Person()
        mom.name = "Jennifer"
        mom.age = 40
        mom.children = [me]
        
        let dad = Person()
        dad.name = "Richard"
        dad.age = 41
        dad.children = [me]
        
        me.mom = mom
        me.dad = dad
        
        backendless.data.save(
            me,
            response: { ( person : AnyObject!) -> () in
                print("Person has been saved (ASYNC): \((person as! Person).name) -> \((person as! Person).age)")
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
}

