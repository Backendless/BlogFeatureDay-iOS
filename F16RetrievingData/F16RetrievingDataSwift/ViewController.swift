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
    
    /* - production (UserServiceOperation)
    let APP_ID = "1A9E560D-E6EE-DEF9-FF2C-2565B567E800"
    let SECRET_KEY = "2146BA33-CA63-EBC6-FFE4-1EAC4E0CD400"
    */
    // - production (BEFeatureDay)
    let APP_ID = "CF47722D-EB7B-A0D0-FFE3-1FADE3346100"
    let SECRET_KEY = "43B43EF7-247A-ED56-FF2F-ECD43C6E9000"
    //
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("self.ofClass = \(Types.insideTypeClassName(self.ofClass()))")
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        backendless.hostURL = "http://api.backendless.com"
        
        fetchingFirstPage()
        fetchingFirstPageAsync()
        
        //fetchingFirstPageMenuItems()
    }
    
    func fetchingFirstPage() {
        
        print("\n============ Fetching first page using the SYNC API ============")
        
        let startTime = NSDate()
       
        Types.tryblock({ () -> Void in
            
            let query = BackendlessDataQuery()
            let restaurants = self.backendless.persistenceService.of(Restaurant.ofClass()).find(query)
            
            let currentPage = restaurants.getCurrentPage()
            print("Loaded \(currentPage.count) restaurant objects:")
            print("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
            for restaurant in currentPage as! [Restaurant] {
                print("Restaurant <\(restaurant.ofClass())> name = \(restaurant.name), cuisine = \(restaurant.cuisine)")
            }
            },
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            },
            
            finally: {() -> Void in
                print("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
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
        
        let startTime = NSDate()
        
        Types.tryblock({ () -> Void in
            
            let query = BackendlessDataQuery()
            let menuItems = self.backendless.persistenceService.of(MenuItem.ofClass()).find(query)
            
            let currentPage = menuItems.getCurrentPage()
            print("Loaded \(currentPage.count) MenuItem objects")
            print("Total MenuItems in the Backendless starage - \(menuItems.totalObjects)")
            
            for menuItem in currentPage as! [MenuItem] {
                print("<\(menuItem)> name = \(menuItem.name)")
                }
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            },
            
            finally: {() -> Void in
                print("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
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

