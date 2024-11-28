//
//  FridaChecker.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 27/11/24.
//

import Foundation
import Network


internal class FridaChecker {
    private static let TAG = "FridaChecker"
    
    
    internal static func isFridaDetected() -> Bool{
        return isFridaRunning() || hasFridaLibraries() || detectFridaFiles()
    }
    
    
    private static func isFridaRunning() -> Bool{
        let port = NWEndpoint.Port(integerLiteral: 27042)
        let connection = NWConnection(host: "127.0.0.1", port: port, using: .tcp)
        
        var isFridaDetected = false
        let semaphore = DispatchSemaphore(value: 0)
        
        connection.stateUpdateHandler = { state in
            if state == .ready {
                isFridaDetected = true
            }
            semaphore.signal()
        }
        
        connection.start(queue: .global())
        _ = semaphore.wait(timeout: .now() + 1)
        connection.cancel()
        
        return isFridaDetected
    }
    
    private static func hasFridaLibraries() -> Bool{
        let count = _dyld_image_count()
        for i in 0..<count {
            if let name = _dyld_get_image_name(i) {
                let libraryName = String(cString: name)
                if libraryName.contains("frida") || libraryName.contains("gadget") {
                    return true
                }
            }
        }
        return false
    }
    
    private static func detectFridaFiles() -> Bool{
        for path in HookingDetectorConst.suspiciousPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
        
    }
    
}
