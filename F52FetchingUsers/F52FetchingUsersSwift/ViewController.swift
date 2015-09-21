//
//  ViewController.swift
//  F52FetchingUsersSwift

import UIKit

class ViewController: UIViewController {
    
    let APP_ID = "7B92560B-91F0-E94D-FFEB-77451B0F9700"
    let SECRET_KEY = "B9D27BA8-3964-F3AE-FF26-E71FFF487300"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        print("Users have will be fetched")
        
        fetchingUsersSync()
        fetchingUsersAsync()
    }
    
    func fetchingUsersSync() {
        
        Types.tryblock({ () -> Void in
            
            let dataStore = self.backendless.persistenceService.of(BackendlessUser.ofClass())
            let users = dataStore.find()
            print("Users have been fetched (SYNC): \(users)")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error (SYNC): \(exception as! Fault)")
            }
        )
    }
    
    func fetchingUsersAsync() {
        
        let dataStore = self.backendless.persistenceService.of(BackendlessUser.ofClass())
        dataStore.find(
            { ( users : BackendlessCollection!) -> () in
                print("Users have been fetched  (ASYNC): \(users)")
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error (ASYNC): \(fault)")
            }
        )
    }

}

