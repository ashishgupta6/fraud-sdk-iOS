//
//  Sign3IntelligenceInternal.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 28/08/24.
//

import Foundation

class Sign3IntelligenceInternal{
    
    static var sdk: Sign3IntelligenceInternal?
    var deviceSignalsApiImpl = DeviceSignalsApiImpl()
    var deviceSignalsViewModel: DeviceSignalsViewModel?

    public func getDeviceSignalsViewModel() -> DeviceSignalsViewModel? {
            return deviceSignalsViewModel
    }
    
    
    static func getInstance() -> Sign3IntelligenceInternal {
        if sdk == nil {
            synchronized(Sign3IntelligenceInternal.self) {
                if sdk == nil {
                    sdk = Sign3IntelligenceInternal()
                }
            }
        }
        return sdk!
    }
    
    func getIntelligence() {
        DisplayAllSignals.displayAllSignals(deviceSignalsApiImpl: deviceSignalsApiImpl)
    }

    
    func initAsync() {
//        deviceSignalsViewModel = DeviceSignalsViewModel(deviceSignalsApi: DeviceSignalsApiImpl())
    }
    
    
}

private func synchronized(_ lock: Any, _ closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
