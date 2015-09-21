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
        
        print("\n============ Loading geo points with the SYNC API ============")
        
        Types.tryblock({ () -> Void in
            
            let nordWest = GEO_POINT(latitude: 49.615, longitude: -152.944)
            let southEast = GEO_POINT(latitude: 25.648, longitude: -21.636)
            let query = BackendlessGeoQuery.queryWithRect(nordWest, southEast:southEast, categories: ["geoservice_sample"]) as! BackendlessGeoQuery
            query.includeMeta = true
            
            var points = self.backendless.geoService.getPoints(query)
            print("Total points in rectangular \(points.totalObjects)")
            
            while points.getCurrentPage().count > 0 {
                
                let geoPoints = points.getCurrentPage() as! [GeoPoint]
                for geoPoint in geoPoints {
                    print("\(geoPoint)")
                }
                
                points = points.nextPage()
            }
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func nextPageAsync(points: BackendlessCollection) {
        
        if points.getCurrentPage().count == 0 {
            return
        }
        
        let geoPoints = points.getCurrentPage() as! [GeoPoint]
        for geoPoint in geoPoints {
            print("\(geoPoint)")
        }
        
        points.nextPageAsync(
            { ( rest : BackendlessCollection!) -> () in
                self.nextPageAsync(rest)
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
    
    func loadGeoPointsAsync() {
        
        print("\n============ Loading geo points with the ASYNC API ============")
        
        let nordWest = GEO_POINT(latitude: 49.615, longitude: -152.944)
        let southEast = GEO_POINT(latitude: 25.648, longitude: -21.636)
        let query = BackendlessGeoQuery.queryWithRect(nordWest, southEast:southEast, categories: ["geoservice_sample"]) as! BackendlessGeoQuery
        query.includeMeta = true
        
        backendless.geoService.getPoints(
            query,
            response: { ( points : BackendlessCollection!) -> () in
                print("Total points in rectangular \(points.totalObjects)")
                self.nextPageAsync(points)
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }

}

