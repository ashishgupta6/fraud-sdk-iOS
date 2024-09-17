//
//  Sign3IntelligenceSdkApiImpl.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation

class Sign3IntelligenceSdkApiImpl: Sign3IntelligenceSdkApi{
    lazy var vpnDetector = VPNDetector()
    lazy var simulatorDetector = SimulatorDetector()
    lazy var jainBrokenDetector = JailBrokenDetector()
    lazy var locationSpoffer = LocationSpoffer()

    
    func isVpnDetected() async -> Bool {
        return await vpnDetector.isVpnEnabled()
    }
    
    func isSimulatorDetected() async -> Bool {
        return await simulatorDetector.isSimulatorDetected()
    }
    
    func isJailBrokenDetected() async -> Bool {
        return await jainBrokenDetector.isJailBrokenDetected()
    }
    
    func isMockLocation() async -> Bool {
        return await locationSpoffer.isMockLocation()
    }
    
}
