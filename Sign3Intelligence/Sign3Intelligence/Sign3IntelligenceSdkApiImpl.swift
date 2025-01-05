//
//  Sign3IntelligenceSdkApiImpl.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation

internal class Sign3IntelligenceSdkApiImpl: Sign3IntelligenceSdkApi{
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
    private lazy var hookingDetector = HookingDetector(deviceSignalsApi: deviceSignalsApi)
    private lazy var remoteAccessDetector = RemoteAccessDetector()
    private lazy var cloneAppDetector =  ClonedDetector()
    
    internal func isVpnDetected() async -> Bool {
        return await vpnDetector.isVpnEnabled()
    }
    
    internal func isSimulatorDetected() async -> Bool {
        return await simulatorDetector.isSimulatorDetected()
    }
    
    internal func isJailBrokenDetected() async -> Bool {
        return await jainBrokenDetector.isJailBrokenDetected()
    }
    
    internal func isMockLocation() async -> Bool {
        return await locationSpoffer.isMockLocation()
    }
    
    internal func isAppTampered() async -> Bool {
        return await appTampering.isAppTampered()
    }
    
    internal func isProxyDetected() async -> Bool {
        return await proxyDetector.detectProxy()
    }
    
    internal func isHookingDetected() async -> Bool {
        return await hookingDetector.detectHook()
    }
    
    func isScreenBeingMirrored() async -> Bool {
        return await remoteAccessDetector.isScreenBeingMirrored()
    }
    
    func isCloned() async -> Bool {
        return await cloneAppDetector.isClonedApp()
    }
    
}
