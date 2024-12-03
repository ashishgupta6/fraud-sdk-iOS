//
//  VPNDetector.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation

internal class VPNDetector{
    
    private let TAG = "VpnDetector"
    
    internal func isVpnEnabled() async -> Bool{
        return await Utils.getDeviceSignals(
            functionName: TAG,
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                let cfDict = CFNetworkCopySystemProxySettings()
                let nsDict = cfDict!.takeRetainedValue() as NSDictionary
                let keys = nsDict["__SCOPED__"] as! NSDictionary
  
                for key: String in keys.allKeys as! [String] {
                    if (key == "tap" || key == "tun" || key == "ppp" || key == "ipsec" || key == "ipsec0" || key == "ipsec1" || key == "utun1" || key == "utun2" || key == "utun5") {
                        return true
                    }
                }
                return false
            }
        )
    }
}
