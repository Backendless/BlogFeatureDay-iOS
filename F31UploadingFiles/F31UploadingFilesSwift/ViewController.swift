//
//  ViewController.swift
//  F31UploadingFilesSwift
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
        uploadSync()
        uploadAsync()
        //
    }

    func uploadSync() {
        
        println("\n============ Uploading files with the SYNC API ============")
        
        Types.try({ () -> Void in

            var data = NSData(bytes:"Hello mbaas!\nUploading files is easy!", length:37)
            var uploadedFile = self.backendless.fileService.upload("myfiles/myhelloworld-sync.txt", content: data)
            println("File has been uploaded. File URL is - \(uploadedFile.fileURL)")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error: \(exception as! Fault)")
            }
        )
    }

    func uploadAsync() {
        
        println("\n============ Uploading files with the ASYNC API ============")
        
        var data = NSData(bytes:"Hello mbaas!\nUploading files is easy!", length:37)
        backendless.fileService.upload("myfiles/myhelloworld-async.txt", content: data,
            response: { (var uploadedFile : BackendlessFile!) -> () in
                println("File has been uploaded. File URL is - \(uploadedFile.fileURL)")
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error: \(fault)")
            }
        )
    }

}

