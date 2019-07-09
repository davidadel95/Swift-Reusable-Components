//  NetworkManager.swift
//
//  Created by David Adel on 7/6/19.
//  Copyright © 2019 DavidAdel. All rights reserved.
//

import Foundation
import AFNetworking

class NetworkManager {
    
    private static var previousNetworkReachabilityStatus: AFNetworkReachabilityStatus = .unknown
    private static let networkReachabilityChanged = NSNotification.Name("NetworkReachabilityChanged")
    private static var isReachable = false
    
    static func setupNetStateListener(){
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status) in
            
            switch (status) {
            case .reachableViaWWAN, .reachableViaWiFi:
                // Reachable.
                isReachable = true
            default:
                // Not reachable.
                isReachable = false
            }
            
            // Any class which has observer for this notification will be able to report loss of network connection
            // successfully.
            
            if (self.previousNetworkReachabilityStatus != .unknown &&
                status != self.previousNetworkReachabilityStatus) {
                NotificationCenter
                    .default
                    .post(name: self.networkReachabilityChanged,
                          object: nil,
                          userInfo: ["isReachable" : isReachable])
            }
            
            self.previousNetworkReachabilityStatus = status
        }
    }
    
    static func isConnectedToNetwork() -> Bool{
        return isReachable
    }
}
