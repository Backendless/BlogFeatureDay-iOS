//
//  ViewController.swift
//  F17DataPagingSwift
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
    
    let PAGESIZE = 100
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        basicPaging()
        basicPagingAsync()
        
        advancedPaging()
        advancedPagingAsync()
    }
    
    func addRestaurants() {
        
        Types.try({ () -> Void in
            
            var dataStore = self.backendless.persistenceService.of(Restaurant.ofClass())
            for var i = 0; i < 300; ++i {
                var r = Restaurant()
                r.name = "TastyBaaS \(i)"
                r.cuisine = "mBaaS"
                r = dataStore.save(r) as! Restaurant
                println("Save restaurant name = \(r.name)")
            }
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func basicPaging() {
        
        Types.try({ () -> Void in
            
            var startTime = NSDate()
            
            var query = BackendlessDataQuery()
            var restaurants = self.backendless.persistenceService.of(Restaurant.ofClass()).find(query)
            println("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
            
            var size = restaurants.getCurrentPage().count
            while size > 0 {
                println("Loaded \(size) restaurant in the current page")
                restaurants = restaurants.nextPage()
                size = restaurants.getCurrentPage().count
            }
            
            println("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func nextPageAsync(restaurants: BackendlessCollection, startTime: NSDate) {
        
        var size = restaurants.getCurrentPage().count
        if size == 0 {
            println("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            return
        }
        
        println("Loaded \(size) restaurant in the current page")
        
        restaurants.nextPageAsync(
            { (var rests : BackendlessCollection!) -> () in
                self.nextPageAsync(rests, startTime:startTime)
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error: \(fault)")
            }
        )
    }
    
    func basicPagingAsync() {
        
        var startTime = NSDate()
        
        var query = BackendlessDataQuery()
        backendless.persistenceService.of(Restaurant.ofClass()).find(
            query,
            response: { (var restaurants : BackendlessCollection!) -> () in
                println("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
                self.nextPageAsync(restaurants, startTime:startTime)
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error: \(fault)")
            }
        )
    }
    
    func advancedPaging() {
        
        Types.try({ () -> Void in
            
            var startTime = NSDate()
            
            var query = BackendlessDataQuery()
            query.queryOptions.pageSize = self.PAGESIZE // set page size
            var restaurants = self.backendless.persistenceService.of(Restaurant.ofClass()).find(query)
            println("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
            
            var offset = 0
            var size = restaurants.getCurrentPage().count
            while size > 0 {
                println("Loaded \(size) restaurant in the current page")
                offset += size
                restaurants = restaurants.getPage(offset, pageSize:self.PAGESIZE)
                size = restaurants.getCurrentPage().count
            }
            
            println("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func getPageAsync(restaurants: BackendlessCollection, var offset: Int, startTime: NSDate) {
        
        var size = restaurants.getCurrentPage().count
        if size == 0 {
            println("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            return
        }
        
        println("Loaded \(size) restaurant in the current page")
        
        offset += size
        restaurants.getPage(
            offset,
            pageSize:PAGESIZE,
            response: { (var rests : BackendlessCollection!) -> () in
                self.getPageAsync(rests, offset:offset, startTime:startTime)
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error: \(fault)")
            }
        )
    }
    
    func advancedPagingAsync() {
        
        var startTime = NSDate()
        
        var offset = 0
        var query = BackendlessDataQuery()
        query.queryOptions.pageSize = PAGESIZE // set page size
        backendless.persistenceService.of(Restaurant.ofClass()).find(
            query,
            response: { (var restaurants : BackendlessCollection!) -> () in
                println("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
                self.getPageAsync(restaurants, offset:offset, startTime:startTime)
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error: \(fault)")
            }
        )
    }
    
}

