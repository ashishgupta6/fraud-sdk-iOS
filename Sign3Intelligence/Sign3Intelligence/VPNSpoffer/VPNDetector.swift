//
//  VPNDetector.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation

internal class VPNDetector{
    
    private let TAG = "VpnDetector"
    
    internal func isVpnEnabled() async -> Bool {
        return await Utils.getDeviceSignals(
            functionName: TAG,
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                guard let cfDict = CFNetworkCopySystemProxySettings() else {
                    return false
                }

                let nsDict = cfDict.takeRetainedValue() as NSDictionary

                guard let scopedKeys = nsDict["__SCOPED__"] as? NSDictionary else {
                    return false
                }

                for key in scopedKeys.allKeys {
                    if let keyString = key as? String,
                       ["tap", "tun", "ppp", "ipsec", "ipsec0", "ipsec1", "utun1", "utun2", "utun5"].contains(keyString) {
                        return true
                    }
                }

                return false
            }
        )
    }

}
