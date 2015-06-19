//
//  ViewController.swift
//  F52FetchingUsersSwift

import UIKit

class ViewController: UIViewController {
    
    let APP_ID = "YOUR-APP-ID-GOES-HERE"
    let SECRET_KEY = "YOUR-IOS-SECRET-KEY-GOES-HERE"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        fetchingUsersSync()
        fetchingUsersAsync()
    }
    
    func fetchingUsersSync() {
        
        Types.try({ () -> Void in
            
            var dataStore = self.backendless.persistenceService.of(BackendlessUser.ofClass())
            var users = dataStore.find()
            println("Users have been fetched (SYNC): \(users)")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error (SYNC): \(exception as! Fault)")
            }
        )
    }
    
    func fetchingUsersAsync() {
        
        var dataStore = self.backendless.persistenceService.of(BackendlessUser.ofClass())
        dataStore.find(
            { (var users : BackendlessCollection!) -> () in
                println("Users have been fetched  (ASYNC): \(users)")
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
    
}

