//
//  InternetConnection.swift
//  Parse Data test
//
//  Created by media-pt on 11.10.16.
//  Copyright © 2016 media-pt. All rights reserved.
//

import Foundation

struct InternetConnection {
    
    static func checkInternetConnection() -> Bool {
        
        let reachability = Reachability()!
        reachability.stopNotifier()
        
        let status = reachability.currentReachabilityStatus
        
        if status == Reachability.NetworkStatus.notReachable {
            return false
        } else {
            return true
        }
    }
}
