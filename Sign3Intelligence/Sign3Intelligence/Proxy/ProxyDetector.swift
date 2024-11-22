//
//  ProxyDetector.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 20/11/24.
//

import Foundation

internal class ProxyDetector {
    
    internal let TAG = "ProxyDetector"

    internal func detectProxy(considerVPNConnectionAsProxy: Bool = false) async -> Bool {
        guard let unmanagedSettings = CFNetworkCopySystemProxySettings() else {
            return false
        }
        
        let settingsOptional = unmanagedSettings.takeRetainedValue() as? [String: Any]
        
        guard  let settings = settingsOptional else {
            return false
        }
        
        if(considerVPNConnectionAsProxy) {
            if let scoped = settings["__SCOPED__"] as? [String: Any] {
                for interface in scoped.keys {
                    
                    let names = [
                        "tap",
                        "tun",
                        "ppp",
                        "ipsec",
                        "ipsec0",
                        "ipsec1",
                        "utun",
                        "utun1",
                        "utun2",
                        "utun5"
                    ]
                    
                    for name in names {
                        if(interface.contains(name)) {
                            return true
                        }
                    }
                }
            }
        }
        
        return (settings.keys.contains("HTTPProxy") || settings.keys.contains("HTTPSProxy"))
    }
}
