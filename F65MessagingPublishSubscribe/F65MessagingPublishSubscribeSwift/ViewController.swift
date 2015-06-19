//
//  ViewController.swift
//  F65MessagingPublishSubscribeSwift

import UIKit

class ViewController: UIViewController {
    
    let APP_ID = "YOUR-APP-ID-GOES-HERE"
    let SECRET_KEY = "YOUR-IOS-SECRET-KEY-GOES-HERE"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        publish()
        subscribe()
        
        publishAsync()
    }
    
    func publishSync() {
        
        Types.try({ () -> Void in
            
            var message = "Message \(self.i++)"
            var messageStatus = self.backendless.messaging.publish("default", message:message)
            println("Message published (SYNC) - \(messageStatus.messageId)")
            },
            
            catch: { (exception) -> Void in
                println("Server reported an error (SYNC): \(exception as! Fault)")
            }
        )
    }
    
    func publishAsync() {
        
        var message = "Message \(self.i++)"
        backendless.messaging.publish(
            "default", message:message,
            response: { (var messageStatus) -> () in
                println("Message published (ASYNC) -  \(messageStatus.messageId)")
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
    
    func publish() {
        
        if self.i > 0 {
           publishSync()
        }
        
        let interval = dispatch_time(DISPATCH_TIME_NOW, Int64(500 * Double(NSEC_PER_MSEC)))
        dispatch_after(interval, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.publish()
        }
       
    }
    
    func subscribe() {
        
        backendless.messaging.subscribe(
            "default",
            subscriptionResponse: { (var messages) -> () in
                
                for message in messages as! [Message] {
                    println("Received message - \(message.data)")
                }
            },
            subscriptionError: { (var fault : Fault!) -> () in
                println("Server reported an error (FAULT): \(fault)")
            },
            response: { (var response) -> () in
                println("subscribe -  \(response)")
            },
            error: { (var fault : Fault!) -> () in
                println("Server reported an error (SUBSCRIPTION ERROR): \(fault)")
            }
        )
    }

}

