//
//  NotificationManager.swift
//  SwiftSonarr
//
//  Created by Eric Castillo on 12/31/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation
import SwiftR
import NotificationBanner

//class NotificationManager {
//    
//    static let shared = NotificationManager()
//    
//    let persistentConnection = SignalR("http://192.168.1.15:8989/signalr", connectionType: .persistent)
//    
//    let banner = StatusBarNotificationBanner(title: "", style: .success)
//    
//    init() {
//        persistentConnection.queryString = ["apikey": "840696c003ef449e923ee65d52b85978"]
//        
//        persistentConnection.received = { data in
//            //print(data)
//            
//            let dict = data as! [String: Any]
//            
//            if let body = dict["body"] as? [String: Any],
//                let resource = body["resource"] as? [String: Any],
//                let commandName = resource["commandName"] as? String,
//                let message = resource["message"] as? String {
//                print("\(commandName): \(message)")
//
//                self.banner.show()
//                self.banner.titleLabel?.text = "\(commandName): \(message)"
//                self.banner.resetDuration()
//            }
//        }
//    }
//    
//    func start() {
//        persistentConnection.start()
//    }
//}
