//
//  ViewController.swift
//  F21RetrievingAutolodedDataSwift
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
    
    func printLocations(locations: [Location]?) {
        
        if locations == nil {
            println("Restaurant locations have not been loaded")
            return
        }
        
        if locations?.count == 0 {
            println("There are no related locations")
            return
        }
        
        for location in locations! {
            println("Location: Street address - \(location.streetAdress), City - \(location.city)")
        }
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
                self.printLocations(restaurant.locations)
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
                    self.printLocations(restaurant.locations)
                }
                
                println("Total time (ms) - \(1000*NSDate().timeIntervalSinceDate(startTime))")
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error: \(fault)")
            }
        )
    }
    
}

