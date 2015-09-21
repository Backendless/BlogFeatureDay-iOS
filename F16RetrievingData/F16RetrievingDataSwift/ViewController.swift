//
//  ViewController.swift
//  F16RetrievingDataSwift
/*
* *********************************************************************************************************************
*
*  BACKENDLESS.COM CONFIDENTIAL
*
*  ********************************************************************************************************************
*
*  Copyright 2015 BACKENDLESS.COM. All Rights Reserved.
*
*  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
*  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
*  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
*  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
*  unless prior written permission is obtained from Backendless.com.
*
*  ********************************************************************************************************************
*/

import UIKit

class ViewController: UIViewController {
    
    let APP_ID = "YOUR-APP-ID-GOES-HERE"
    let SECRET_KEY = "YOUR-IOS-SECRET-KEY-GOES-HERE"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        fetchingFirstPage()
        fetchingFirstPageAsync()
    }
    
    func fetchingFirstPage() {
        
        print("\n============ Fetching first page using the SYNC API ============")
       
        Types.tryblock({ () -> Void in
            
            let startTime = NSDate()
            
            let query = BackendlessDataQuery()
            let restaurants = self.backendless.persistenceService.of(Restaurant.ofClass()).find(query)
            
            let currentPage = restaurants.getCurrentPage()
            print("Loaded \(currentPage.count) restaurant objects")
            print("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
            
            for restaurant in currentPage as! [Restaurant] {
                print("Restaurant <\(restaurant.ofClass())> name = \(restaurant.name), cuisine = \(restaurant.cuisine)")
            }
            
            print("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func fetchingFirstPageAsync() {
        
        print("\n============ Fetching first page using the ASYNC API ============")
        
        let startTime = NSDate()
        
        let query = BackendlessDataQuery()
        backendless.persistenceService.of(Restaurant.ofClass()).find(
            query,
            response: { ( restaurants : BackendlessCollection!) -> () in
                let currentPage = restaurants.getCurrentPage()
                print("Loaded \(currentPage.count) restaurant objects")
                print("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
                
                for restaurant in currentPage as! [Restaurant] {
                    print("Restaurant name = \(restaurant.name)")
                }
                
                print("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
   
    //______________________ test ______________________________
    
    func addMenuItems() {
        
        Types.tryblock({ () -> Void in
            
            let menuItem1 : NSDictionary = ["name":"Milk", "price":3.75]
            self.backendless.persistenceService.save("MenuItem", entity:menuItem1 as [NSObject : AnyObject])
            
            let menuItem2 : NSDictionary = ["name":"Meet", "price":7.39]
            self.backendless.persistenceService.save("MenuItem", entity:menuItem2 as [NSObject : AnyObject])
            
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception)")
            }
        )
    }
    
    func fetchingFirstPageMenuItems() {
        
        print("\n============ Fetching first page using the SYNC API ============")
        
        Types.tryblock({ () -> Void in
            
            let startTime = NSDate()
            
            let query = BackendlessDataQuery()
            let menuItems = self.backendless.persistenceService.of(MenuItem.ofClass()).find(query)
            
            let currentPage = menuItems.getCurrentPage()
            print("Loaded \(currentPage.count) MenuItem objects")
            print("Total MenuItems in the Backendless starage - \(menuItems.totalObjects)")
            
            for menuItem in currentPage as! [MenuItem] {
                print("<\(menuItem)> name = \(menuItem.name)")
            }
            
            print("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func fetchingFirstPageRestautants() {
        
        Types.tryblock({ () -> Void in
            
            let query = BackendlessDataQuery()
            let restaurants = self.backendless.persistenceService.of(Restaurant.ofClass()).find(query)
            
            let currentPage = restaurants.getCurrentPage()
            print("Loaded \(currentPage.count) restaurant objects")
            print("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
            
            for restaurant in currentPage as! [Restaurant] {
                print("Restaurant <\(restaurant.ofClass())> name = \(restaurant.name), cuisine = \(restaurant.cuisine)")
            }
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }

}

