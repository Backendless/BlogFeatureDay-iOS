//
//  ViewController.swift
//  F36DataWithRelatedGeoSwift
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
        
        saveDataWithGeoSync()
        saveDataWithGeoAsync()
    }
    
    func saveDataWithGeoSync() {
        
        println("\n============ Saving data with geo point using the SYNC API ============")
        
        Types.try({ () -> Void in
            
            var driver = Driver()
            driver.driverName = "Ruben Barrichelli"
            driver.rating = 5
            driver.carMake = "Mercedes"
            driver.carModel = "E350"
            driver.location = GeoPoint.geoPoint(GEO_POINT(latitude: 41.878247, longitude: -87.629767), categories: ["drivers"], metadata: ["city":"Chicago"]) as? GeoPoint
            
            driver = self.backendless.persistenceService.of(Driver.ofClass()).save(driver) as! Driver
            println("SYNC: Driver has been saved. Location object ID - \(driver.location!.objectId)")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func saveDataWithGeoAsync() {
        
        println("\n============ Saving data with geo point using the ASYNC API ============")
        
        var driver = Driver()
        driver.driverName = "Jen Buttons"
        driver.rating = 4
        driver.carMake = "Lamborghini"
        driver.carModel = "Diablo"
        driver.location = GeoPoint.geoPoint(GEO_POINT(latitude: 32.803468, longitude: -96.769879), categories: ["drivers"], metadata: ["city":"Dallas"]) as? GeoPoint
        
        backendless.persistenceService.of(Driver.ofClass()).save(driver,
            response: { (var d : AnyObject!) -> () in
                println("ASYNC: Driver has been saved. Location object ID - \((d as! Driver).location!.objectId)")
            },
            
            error: { (var fault : Fault!) -> () in
                println("Server reported an error: \(fault)")
            }
        )
    }

}

