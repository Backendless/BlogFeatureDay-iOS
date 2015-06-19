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
        
        println("\n============ Fetching first page using the SYNC API ============")
       
        Types.try({ () -> Void in
            
            var startTime = NSDate()
            
            var query = BackendlessDataQuery()
            var restaurants = self.backendless.persistenceService.of(Restaurant.ofClass()).find(query)
            
            var currentPage = restaurants.getCurrentPage()
            println("Loaded \(currentPage.count) restaurant objects")
            println("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
            
            for restaurant in currentPage as! [Restaurant] {
                println("Restaurant <\(restaurant.ofClass())> name = \(restaurant.name), cuisine = \(restaurant.cuisine)")
            }
            
            println("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func fetchingFirstPageAsync() {
        
        println("\n============ Fetching first page using the ASYNC API ============")
        
        var startTime = NSDate()
        
        var query = BackendlessDataQuery()
        backendless.persistenceService.of(Restaurant.ofClass()).find(
            query,
            response: { (var restaurants : BackendlessCollection!) -> () in
                var currentPage = restaurants.getCurrentPage()
                println("Loaded \(currentPage.count) restaurant objects")
                println("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
                
                for restaurant in currentPage as! [Restaurant] {
                    println("Restaurant name = \(restaurant.name)")
                }
                
                println("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error: \(fault)")
            }
        )
    }
   
    //______________________ test ______________________________
    
    func addMenuItems() {
        
        Types.try({ () -> Void in
            
            var menuItem1 : NSDictionary = ["name":"Milk", "price":3.75]
            self.backendless.persistenceService.save("MenuItem", entity:menuItem1 as [NSObject : AnyObject])
            
            var menuItem2 : NSDictionary = ["name":"Meet", "price":7.39]
            self.backendless.persistenceService.save("MenuItem", entity:menuItem2 as [NSObject : AnyObject])
            
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error: \(exception)")
            }
        )
    }
    
    func fetchingFirstPageMenuItems() {
        
        println("\n============ Fetching first page using the SYNC API ============")
        
        Types.try({ () -> Void in
            
            var startTime = NSDate()
            
            var query = BackendlessDataQuery()
            var menuItems = self.backendless.persistenceService.of(MenuItem.ofClass()).find(query)
            
            var currentPage = menuItems.getCurrentPage()
            println("Loaded \(currentPage.count) MenuItem objects")
            println("Total MenuItems in the Backendless starage - \(menuItems.totalObjects)")
            
            for menuItem in currentPage as! [MenuItem] {
                println("<\(menuItem)> name = \(menuItem.name)")
            }
            
            println("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func fetchingFirstPageRestautants() {
        
        Types.try({ () -> Void in
            
            var query = BackendlessDataQuery()
            var restaurants = self.backendless.persistenceService.of(Restaurant.ofClass()).find(query)
            
            var currentPage = restaurants.getCurrentPage()
            println("Loaded \(currentPage.count) restaurant objects")
            println("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
            
            for restaurant in currentPage as! [Restaurant] {
                println("Restaurant <\(restaurant.ofClass())> name = \(restaurant.name), cuisine = \(restaurant.cuisine)")
            }
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error: \(exception as! Fault)")
            }
        )
    }

}

