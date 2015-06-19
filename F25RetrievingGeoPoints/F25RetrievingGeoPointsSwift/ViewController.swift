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
        
        loadGeoPointsSync()
        loadGeoPointsAsync()
    }
    
    func loadGeoPointsSync() {
        
        println("\n============ Loading geo points with the SYNC API ============")
        
        Types.try({ () -> Void in
            
            var query = BackendlessGeoQuery()
            query.addCategory("geoservice_sample")
            query.includeMeta = true
            
            var points = self.backendless.geoService.getPoints(query)
            println("Total points in category \(points.totalObjects)")
            
            while points.getCurrentPage().count > 0 {
                
                var geoPoints = points.getCurrentPage() as! [GeoPoint]
                for geoPoint in geoPoints {
                    println("\(geoPoint)")
                }
                
                points = points.nextPage()
            }
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func nextPageAsync(points: BackendlessCollection) {
        
        if points.getCurrentPage().count == 0 {
            return
        }
        
        var geoPoints = points.getCurrentPage() as! [GeoPoint]
        for geoPoint in geoPoints {
            println("\(geoPoint)")
        }
        
        points.nextPageAsync(
            { (var rest : BackendlessCollection!) -> () in
                self.nextPageAsync(rest)
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error: \(fault)")
            }
        )
    }
    
    func loadGeoPointsAsync() {
        
        println("\n============ Loading geo points with the ASYNC API ============")
        
        var query = BackendlessGeoQuery()
        query.addCategory("geoservice_sample")
        query.includeMeta = true
        
        backendless.geoService.getPoints(
            query,
            response: { (var points : BackendlessCollection!) -> () in
                self.nextPageAsync(points)
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error: \(fault)")
            }
        )
    }

}

