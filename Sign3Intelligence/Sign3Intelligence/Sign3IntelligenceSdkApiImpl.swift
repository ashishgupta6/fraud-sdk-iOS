//
//  Sign3IntelligenceSdkApiImpl.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation

class Sign3IntelligenceSdkApiImpl: Sign3IntelligenceSdkApi{
    
    init(deviceSignalsApi: DeviceSignalsApi){
        self.deviceSignalsApi = deviceSignalsApi
    }
    
    private let deviceSignalsApi: DeviceSignalsApi

    private lazy var vpnDetector = VPNDetector()
    private lazy var simulatorDetector = SimulatorDetector()
    private lazy var jainBrokenDetector = JailBrokenDetector()
    private lazy var locationSpoffer = LocationSpoffer()
    private lazy var appTampering = AppTampering(deviceSignalsApi: deviceSignalsApi)
    private lazy var proxyDetector = ProxyDetector()
    
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
    
    func isAppTampered() async -> Bool {
        return await appTampering.isAppTampered([
            AppTampering.AppTamperingCheck.bundleID("com.sign3labs.fraudsdk.FraudSDK"),
            AppTampering.AppTamperingCheck.isDebuggerEnabled,
            AppTampering.AppTamperingCheck.isJailBroken,
            AppTampering.AppTamperingCheck.checkBuildConfiguration,
            AppTampering.AppTamperingCheck.isMobileProvisionModified("13c287086eff1f58f9c8192e383b75a978047cbd32407c33bb872c614ac4d1b4")
        ])
    }
    
    func isProxyDetected() async -> Bool {
        return await proxyDetector.detectProxy()
    }
    
}
