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
    
    // BKNDLSS-12192
    let APP_ID = "5F7F7EF0-9B9E-C874-FF62-CD9F2D96D200"
    let SECRET_KEY = "4523642F-231F-7937-FFEC-B2FB24A28100"
    let VERSION_NUM = "v1"
    
    let PAGESIZE = 100
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        //addRestaurants()
        
        basicPaging()
        //basicPagingAsync()
        
        //advancedPaging()
        //advancedPagingAsync()
    }
    
    func addRestaurants() {
        
        Types.tryblock({ () -> Void in
            
            let dataStore = self.backendless.persistenceService.of(Restaurant.ofClass())
            for i in 0 ..< 300 {
                var r = Restaurant()
                r.name = "TastyBaaS \(i)"
                r.cuisine = "mBaaS"
                r = dataStore.save(r) as! Restaurant
                print("Save restaurant name = \(r.name)")
            }
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func basicPaging() {
        
        Types.tryblock({ () -> Void in
            
            let startTime = NSDate()
            
            let query = BackendlessDataQuery()
            var restaurants = self.backendless.persistenceService.of(Restaurant.ofClass()).find(query)
            print("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
            
            var size = restaurants.getCurrentPage().count
            while size > 0 {
                print("Loaded \(size) restaurant in the current page")
                restaurants = restaurants.nextPage()
                size = restaurants.getCurrentPage().count
            }
            
            print("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func nextPageAsync(restaurants: BackendlessCollection, startTime: NSDate) {
        
        let size = restaurants.getCurrentPage().count
        if size == 0 {
            print("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            return
        }
        
        print("Loaded \(size) restaurant in the current page")
        
        restaurants.nextPageAsync(
            { ( rests : BackendlessCollection!) -> () in
                self.nextPageAsync(rests, startTime:startTime)
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
    
    func basicPagingAsync() {
        
        let startTime = NSDate()
        
        let query = BackendlessDataQuery()
        backendless.persistenceService.of(Restaurant.ofClass()).find(
            query,
            response: { ( restaurants : BackendlessCollection!) -> () in
                print("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
                self.nextPageAsync(restaurants, startTime:startTime)
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
    
    func advancedPaging() {
        
        Types.tryblock({ () -> Void in
            
            let startTime = NSDate()
            
            let query = BackendlessDataQuery()
            query.queryOptions.pageSize = self.PAGESIZE // set page size
            var restaurants = self.backendless.persistenceService.of(Restaurant.ofClass()).find(query)
            print("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
            
            var offset = 0
            var size = restaurants.getCurrentPage().count
            while size > 0 {
                print("Loaded \(size) restaurant in the current page")
                offset += size
                restaurants = restaurants.getPage(offset, pageSize:self.PAGESIZE)
                size = restaurants.getCurrentPage().count
            }
            
            print("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func getPageAsync(restaurants: BackendlessCollection, var offset: Int, startTime: NSDate) {
        
        let size = restaurants.getCurrentPage().count
        if size == 0 {
            print("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            return
        }
        
        print("Loaded \(size) restaurant in the current page")
        
        offset += size
        restaurants.getPage(
            offset,
            pageSize:PAGESIZE,
            response: { ( rests : BackendlessCollection!) -> () in
                self.getPageAsync(rests, offset:offset, startTime:startTime)
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
    
    func advancedPagingAsync() {
        
        let startTime = NSDate()
        
        let offset = 0
        let query = BackendlessDataQuery()
        query.queryOptions.pageSize = PAGESIZE // set page size
        backendless.persistenceService.of(Restaurant.ofClass()).find(
            query,
            response: { ( restaurants : BackendlessCollection!) -> () in
                print("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
                self.getPageAsync(restaurants, offset:offset, startTime:startTime)
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
    
}

