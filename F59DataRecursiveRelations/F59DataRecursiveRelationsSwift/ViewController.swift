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
        
        Types.try({ () -> Void in
            
            var me = Person()
            me.name = "Bobby"
            me.age = 13
            
            var mom = Person()
            mom.name = "Jennifer"
            mom.age = 40
            mom.children = [me]
            
            var dad = Person()
            dad.name = "Richard"
            dad.age = 41
            dad.children = [me]
            
            me.mom = mom
            me.dad = dad
            
            me = self.backendless.data.save(me) as! Person
            println("Person has been saved (SYNC): \(me.name) -> \(me.age)")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error (SYNC): \(exception as! Fault)")
            }
        )
    }
    
    func savePersonAsync() {
        
        var me = Person()
        me.name = "Bobby"
        me.age = 13
        
        var mom = Person()
        mom.name = "Jennifer"
        mom.age = 40
        mom.children = [me]
        
        var dad = Person()
        dad.name = "Richard"
        dad.age = 41
        dad.children = [me]
        
        me.mom = mom
        me.dad = dad
        
        backendless.data.save(
            me,
            response: { (var person : AnyObject!) -> () in
                println("Person has been saved (ASYNC): \((person as! Person).name) -> \((person as! Person).age)")
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
}

