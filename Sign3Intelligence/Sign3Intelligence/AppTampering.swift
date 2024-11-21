//
//  AppTampering.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 12/09/24.
//

import Foundation
import MachO
import CommonCrypto

class AppTampering{
    
    init(deviceSignalsApi: DeviceSignalsApi){
        self.devideSignalsApi = deviceSignalsApi
    }
    
    private let devideSignalsApi: DeviceSignalsApi
    private let jailBrokenDetector = JailBrokenDetector()
    public enum AppTamperingCheck {
        
        /// Compare current bundleID with a specified bundleID.
        case bundleID(String)
        
        /// Compare current hash value(SHA256 hex string) of `embedded.mobileprovision` with a specified hash value.
        /// Path: /Users/Library/Developer/Xcode/DerivedData/<ProjectName>/Build/Products/<Debug/Release>-iphoneos/<AppName>.app/embedded.mobileprovision
        /// Use command `"shasum -a 256 embedded.mobileprovision"` to get SHA256 value on your macOS.
        case isMobileProvisionModified(String)
        
        /// Check Jailbroken Device
        case isJailBroken
        
        /// Check if Debugger is enabled
        case isDebuggerEnabled
        
        /// Check Build Configuration
        case checkBuildConfiguration
    }
            
    func isAppTampered(_ checks: [AppTamperingCheck]) async -> Bool {
        var isAppTampering = false;
    
        for check in checks {
            switch check {
            case .bundleID(let exceptedBundleID):
                if checkBundleID(exceptedBundleID) {
                    isAppTampering = true
                }
            case .isMobileProvisionModified(let expectedSha256Value):
                if isMobileProvisionModified(expectedSha256Value.lowercased()) {
                    isAppTampering = true
                }
            case .isJailBroken:
                if await jailBrokenDetector.isJailBrokenDetected() {
                    isAppTampering = true
                }
            case .isDebuggerEnabled:
                if await devideSignalsApi.isDebuggerEnabled() {
                    isAppTampering = true
                }
            case .checkBuildConfiguration:
                if await devideSignalsApi.checkBuildConfiguration() == "Debug" {
                    isAppTampering = true
                }
            }
        }
    
        return (isAppTampering);
    }
    
    private func checkBundleID(_ expectedBundleID: String) -> Bool {
        if expectedBundleID != Bundle.main.bundleIdentifier {
            return true
        }
        
        return false
    }
    
    private func isMobileProvisionModified(_ expectedSha256Value: String) -> Bool {
        guard let path = Bundle.main.path(
            forResource: "embedded", ofType: "mobileprovision"
        ) else {
            return false
        }
        
        let url = URL(fileURLWithPath: path)
        
        if FileManager.default.fileExists(atPath: url.path) {
            if let data = FileManager.default.contents(atPath: url.path) {
                // Hash: SHA256
                var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
                data.withUnsafeBytes {
                    _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
                }
                
                print("Hex Encoded String: \(Data(hash).hexEncodedString())")
                if Data(hash).hexEncodedString() != expectedSha256Value {
                    return true
                }
            }
        }
        
        return false
    }
}

extension Data {
  fileprivate func hexEncodedString() -> String {
    return map { String(format: "%02hhx", $0) }.joined()
  }
}
