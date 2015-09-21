//
//  ViewController.swift
//  F39GeoPointWithRelatedDataSwift
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
        
        addGeoPointWithRelatedDataSync()
        addGeoPointWithRelatedDataAsync()
    }
    
    func addGeoPointWithRelatedDataSync() {
        
        print("\n============ Adding geo point with the SYNC API ============")
        
        Types.tryblock({ () -> Void in
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy 'at' HH:mm"
            
            let gustaveEiffel = Architect();
            gustaveEiffel.name = "Gustave Eiffel";
            gustaveEiffel.birthday = dateFormatter.dateFromString("27.11.1923 at 12:00")
            gustaveEiffel.nationality = "French";
            
            let eiffelTower = GeoPoint.geoPoint(
                GEO_POINT(latitude: 48.85815, longitude: 2.29452),
                categories: ["towers", "placesToVisit"],
                metadata: ["name":"Eiffel Tower", "architect":gustaveEiffel]
                ) as! GeoPoint
            
            let savedPoint = self.backendless.geoService.savePoint(eiffelTower);
            print("SYNC: geo point saved. Object ID - \(savedPoint.objectId)")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func addGeoPointWithRelatedDataAsync() {
        
        print("\n============ Adding geo point with the ASYNC API ============")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy 'at' HH:mm"
        
        let gustaveEiffel = Architect();
        gustaveEiffel.name = "Gustave Eiffel";
        gustaveEiffel.birthday = dateFormatter.dateFromString("27.11.1923 at 12:00")
        gustaveEiffel.nationality = "French";
        
        let eiffelTower = GeoPoint.geoPoint(
            GEO_POINT(latitude: 48.85815, longitude: 2.29452),
            categories: ["towers", "placesToVisit"],
            metadata: ["name":"Eiffel Tower", "architect":gustaveEiffel]
            )as! GeoPoint
        
        backendless.geoService.savePoint(
            eiffelTower,
            response: { ( geoPoint : GeoPoint!) -> () in
                print("ASYNC: geo point saved. Object ID - \(geoPoint.objectId)")
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }

}

