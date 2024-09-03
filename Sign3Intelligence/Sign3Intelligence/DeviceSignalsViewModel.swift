//
//  DeviceSignalsViewModel.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 29/08/24.
//

import Foundation
import Foundation
import Combine

final class DeviceSignalsViewModel: ObservableObject {
    
    private let deviceSignalsApi: DeviceSignalsApiImpl
    @Published private(set) var deviceId: String = "Unknown"
    
    init(deviceSignalsApi: DeviceSignalsApiImpl) {
        self.deviceSignalsApi = deviceSignalsApi
        DispatchQueue.global().async {
            Task.detached {
                await self.fetchDeviceSignals()
            }
        }
    }
    
    
    public func fetchDeviceSignals() async -> IntelligenceResponse{
        deviceId = await deviceSignalsApi.getiOSDeviceId()
        Utils.showInfologs(tags: "Device ID", value: deviceId)
        
        return IntelligenceResponse(
            deviceId: deviceId
        )
    }
}

