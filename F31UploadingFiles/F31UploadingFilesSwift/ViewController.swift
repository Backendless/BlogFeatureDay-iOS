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
        
        print("\n============ Uploading files with the SYNC API ============")
        
        Types.tryblock({ () -> Void in

            let data = "Hello mbaas!\nUploading files is easy!".dataUsingEncoding(NSUTF8StringEncoding)
            let uploadedFile = self.backendless.fileService.saveFile("myfiles/myhelloworld-sync.txt", content: data, overwriteIfExist:true)
            print("File has been uploaded. File URL is - \(uploadedFile.fileURL)")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }

    func uploadAsync() {
        
        print("\n============ Uploading files with the ASYNC API ============")
        
        let data = "Hello mbaas!\nUploading files is easy!".dataUsingEncoding(NSUTF8StringEncoding)
        backendless.fileService.saveFile(
            "myfiles/myhelloworld-async.txt",
            content: data,
            overwriteIfExist:true,
            response: { ( uploadedFile : BackendlessFile!) -> () in
                print("File has been uploaded. File URL is - \(uploadedFile.fileURL)")
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }

}

