//
//  ViewController.swift
//  F57GeoPointsInRectangularSwift

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
            
            var nordWest = GEO_POINT(latitude: 49.615, longitude: -152.944)
            var southEast = GEO_POINT(latitude: 25.648, longitude: -21.636)
            var query = BackendlessGeoQuery.queryWithRect(nordWest, southEast:southEast, categories: ["geoservice_sample"]) as! BackendlessGeoQuery
            query.includeMeta = true
            
            var points = self.backendless.geoService.getPoints(query)
            println("Total points in rectangular \(points.totalObjects)")
            
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
        
        var nordWest = GEO_POINT(latitude: 49.615, longitude: -152.944)
        var southEast = GEO_POINT(latitude: 25.648, longitude: -21.636)
        var query = BackendlessGeoQuery.queryWithRect(nordWest, southEast:southEast, categories: ["geoservice_sample"]) as! BackendlessGeoQuery
        query.includeMeta = true
        
        backendless.geoService.getPoints(
            query,
            response: { (var points : BackendlessCollection!) -> () in
                println("Total points in rectangular \(points.totalObjects)")
                self.nextPageAsync(points)
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error: \(fault)")
            }
        )
    }

}

