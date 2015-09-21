//
//  ViewController.swift
//  F22OneStepDataLoadingSwift
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
 
        loadRelationsSync()
        loadRelationsAsync()
    }
    
    func printLocations(locations: [Location]?) {
        
        if locations == nil {
            print("Restaurant locations have not been loaded")
            return
        }
        
        if locations?.count == 0 {
            print("There are no related locations")
            return
        }
        
        for location in locations! {
            print("Location: Street address - \(location.streetAdress), City - \(location.city)")
        }
    }
    
    func loadRelationsSync() {
        
        print("\n============ Loading relations with the SYNC API ============")
        
        Types.tryblock({ () -> Void in
            
            let queryOptions = QueryOptions()
            queryOptions.addRelated("locations")
            
            let query = BackendlessDataQuery()
            query.queryOptions = queryOptions
            let restaurants = self.backendless.persistenceService.of(Restaurant.ofClass()).find(query)
            
            let currentPage = restaurants.getCurrentPage()
            print("Loaded \(currentPage.count) restaurant objects")
            print("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
            
            for restaurant in currentPage as! [Restaurant] {
                print("Restaurant name = \(restaurant.name)")
                self.printLocations(restaurant.locations)
            }
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func loadRelationsAsync() {
        
        print("\n============ Loading relations with the ASYNC API ============")
        
        let queryOptions = QueryOptions()
        queryOptions.addRelated("locations")
        
        let query = BackendlessDataQuery()
        query.queryOptions = queryOptions
        backendless.persistenceService.of(Restaurant.ofClass()).find(
            query,
            response: { ( restaurants : BackendlessCollection!) -> () in
                let currentPage = restaurants.getCurrentPage()
                print("Loaded \(currentPage.count) restaurant objects")
                print("Total restaurants in the Backendless starage - \(restaurants.totalObjects)")
                
                for restaurant in currentPage as! [Restaurant] {
                    print("Restaurant name = \(restaurant.name)")
                    self.printLocations(restaurant.locations)
                }
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
    
}


