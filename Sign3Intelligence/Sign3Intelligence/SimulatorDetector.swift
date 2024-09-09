//
//  SimulatorDetector.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation


class SimulatorDetector{
    let TAG = "SimulatorDetector"
    
    func isSimulatorDetected() async -> Bool{
        return await Utils.getDeviceSignals(
            functionName: TAG,
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                #if targetEnvironment(simulator)
                    return true
                #else
                    return false
                #endif
            }
        )
    }
}
