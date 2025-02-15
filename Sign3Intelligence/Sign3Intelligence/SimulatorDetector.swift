//
// SimulatorDetector.swift
// Sign3Intelligence
//
// Created by Ashish Gupta on 09/09/24.
//
import Foundation

internal class SimulatorDetector{
    
    private let TAG = "SimulatorDetector"
    
    internal func isSimulatorDetected() async -> Bool{
        return await Utils.getDeviceSignals(
            functionName: TAG,
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                var simulatorFlag = false
                if (!simulatorFlag){
                    simulatorFlag = checkSimulator()
                }
                if (!simulatorFlag){
                    simulatorFlag = checkSimulatorFromObjectiveC()
                }
                if (!simulatorFlag){
                    simulatorFlag = checkRuntime()
                }
                return simulatorFlag
            }
        )
    }
    
    internal func isSimulatorDetectedWithoutAsync() -> Bool{
        return Utils.getDeviceSignalsWithoutAsync(
            functionName: TAG,
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                var simulatorFlag = false
                if (!simulatorFlag){
                    simulatorFlag = checkSimulator()
                }
                if (!simulatorFlag){
                    simulatorFlag = checkSimulatorFromObjectiveC()
                }
                if (!simulatorFlag){
                    simulatorFlag = checkRuntime()
                }
                return simulatorFlag
            }
        )
    }
    
    
    private func checkSimulator() -> Bool{
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
    
    
    private func checkSimulatorFromObjectiveC() -> Bool{
        let simulatorChecker = SimulatorChecker()
        if simulatorChecker.isSimulator() {
            return true
        } else {
            return false
        }
    }
    
    private func checkRuntime() -> Bool {
      return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
}
