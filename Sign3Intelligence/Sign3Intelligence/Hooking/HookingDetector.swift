//
//  HookingDetector.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 22/11/24.
//

import Foundation

internal class HookingDetector{
    
    private let TAG = "HookingDetector"
    
    init(deviceSignalsApi: DeviceSignalsApi){
        self.devideSignalsApi = deviceSignalsApi
    }
    
    typealias FunctionType = @convention(thin) (Int) -> (Bool)
    private let jailBrokenDetector = JailBrokenDetector()
    private let devideSignalsApi: DeviceSignalsApi
    internal enum HookingDetectorCheck {
        case isJailBroken
        case isDebuggerEnabled
        case isReverseEngineeringToolsDetected
        case amIMSHooked
        case isFridaDetected
    }
    
    internal func detectHook(_ checks: [HookingDetectorCheck]) async -> Bool{
        return await Utils.getDeviceSignals(
            functionName: TAG,
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                var detectHook = false

                func getSwiftFunctionAddr(_ function: @escaping FunctionType) -> UnsafeMutableRawPointer {
                    return unsafeBitCast(function, to: UnsafeMutableRawPointer.self)
                }
                
                func msHookReturnFalse(takes: Int) -> Bool {
                    return false
                }
                
                let funcAddr = getSwiftFunctionAddr(msHookReturnFalse)
                
                for check in checks {
                    switch check {
                    case .isJailBroken:
                        if (await jailBrokenDetector.isJailBrokenDetected()){
                            detectHook = true
                        }
                    case .isDebuggerEnabled:
                        if (await devideSignalsApi.isDebuggerEnabled()){
                            detectHook = true
                        }
                    case .isReverseEngineeringToolsDetected:
                        if (ReverseEngineeringToolsChecker.isReverseEngineeringToolsBeingUsed()){
                            detectHook = true
                        }
                    case .amIMSHooked:
                        if (MSHookChecker.amIMSHooked(funcAddr)){
                            detectHook = true
                        }
                    case .isFridaDetected:
                        if (FridaChecker.isFridaDetected()){
                            detectHook = true
                        }
                    }
                }
                
                return detectHook
            })
    }
    
    
}
