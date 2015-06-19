//
//  ViewController.swift
//  F32SavingGeoPointSwift
//
//  ViewController.swift
//  F25RetrievingGeoPointsSwift
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
        
        addGeoPointSync()
        addGeoPointAsync()
    }
    
    func addGeoPointSync() {
        
        println("\n============ Adding geo point with the SYNC API ============")
        
        Types.try({ () -> Void in
            
            var dallasTX = GeoPoint.geoPoint(
                GEO_POINT(latitude: 32.803468, longitude: -96.769879),
                categories: ["cities"],
                metadata: ["city":"Dallas", "population":1258000, "photo":"http://en.wikipedia.org/wiki/Dallas#mediaviewer/File:Xvixionx_29_April_2006_Dallas_Skyline.jpg"]
                ) as! GeoPoint
            
            dallasTX = self.backendless.geoService.savePoint(dallasTX);
            println("SYNC: geo point saved. Object ID - \(dallasTX.objectId)")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func addGeoPointAsync() {
        
        println("\n============ Adding geo point with the ASYNC API ============")
        
        var houstonTX = GeoPoint.geoPoint(
            GEO_POINT(latitude: 29.76429, longitude: -95.38370),
            categories: ["cities"],
            metadata: ["city":"Houston", "population":2196000, "photo":"http://en.wikipedia.org/wiki/Houston#mediaviewer/File:Uptown_Houston.jpg"]
            ) as! GeoPoint
        
        backendless.geoService.savePoint(
            houstonTX,
            response: { (var point : GeoPoint!) -> () in
                println("ASYNC: geo point saved. Object ID - \(point.objectId)")
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error: \(fault)")
            }
        )
    }
    
}

