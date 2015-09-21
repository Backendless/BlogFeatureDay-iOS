//
//  ViewController.swift
//  F34SendingEmailSwift
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
        
        //
        sendHTMLEmailSync()
        sendHTMLEmailAsync()
        //
    }
    
    func sendHTMLEmailSync() {
        
        print("\n============ Sending email with the SYNC API ============")
        
        Types.tryblock({ () -> Void in

            let subject = "Hello from Backendless! (Sync call)"
            let body = "This is an email sent by <b>synchronous</b> API call from a <a href=\"http://backendless.com\">Backendless</a> backend"
            let recipient = "mark@backendless.com"
            self.backendless.messagingService.sendHTMLEmail(subject, body:body, to:[recipient])
            print("SYNC: HTML email has been sent")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }
    
    func sendHTMLEmailAsync() {
        
        print("\n============ Sending email with the ASYNC API ============")
        
        let subject = "Hello from Backendless! (Async call)"
        let body = "This is an email sent by <b>asynchronous</b> API call from a <a href=\"http://backendless.com\">Backendless</a> backend"
        let recipient = "mark@backendless.com"
        backendless.messagingService.sendHTMLEmail(subject, body:body, to:[recipient],
            response: { ( result : AnyObject!) -> () in
                print("ASYNC: HTML email has been sent")
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
    
}

