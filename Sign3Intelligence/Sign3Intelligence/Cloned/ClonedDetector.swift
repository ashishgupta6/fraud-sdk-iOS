//
//  ClonedDetector.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 12/17/24.
//

import Foundation
import MachO
import CommonCrypto

internal class ClonedDetector{
    
    private let TAG = "ClonedDetector"
    private let jailBrokenDetector = JailBrokenDetector()
    
    internal enum ClonedCheck {
        /// Compare current bundleID with a specified bundleID.
        case bundleID(String)
        
        /// Compare current hash value(SHA256 hex string) of `embedded.mobileprovision` with a specified hash value.
        /// Path: /Users/Library/Developer/Xcode/DerivedData/<ProjectName>/Build/Products/<Debug/Release>-iphoneos/<AppName>.app/embedded.mobileprovision
        /// Use command `"shasum -a 256 embedded.mobileprovision"` to get SHA256 value on your macOS.
        case isMobileProvisionModified(String)
        
        /// Check Jailbroken Device
        case isJailBroken
        
        /// Embedded Mobile Provision Profile Check
        case isProvisioningProfileTampered
        
        /// Bundle Path Check
        case isRunningFromValidPath
        
        /// App Store Receipt Validation
        case validateAppReceipt
    }
    
    internal func isClonedApp() async -> Bool {
        return await Utils.getDeviceSignals(
            functionName: TAG,
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                await amICloned(
                    [
                        ClonedCheck.bundleID("com.sign3labs.fraudsdk.FraudSDK"),
                        ClonedCheck.isJailBroken,
                        ClonedCheck.isMobileProvisionModified("7307a99b67ce4e8e7997e613123162a52a7dc6b18807ad5f4a4de1a9cda54287"),
                        ClonedCheck.isProvisioningProfileTampered,
                        ClonedCheck.isRunningFromValidPath,
                        ClonedCheck.validateAppReceipt
                    ]
                )
            })
    }
    
    private func amICloned(_ checks: [ClonedCheck]) async -> Bool {
        var cloned = false;
        
        for check in checks {
            switch check {
            case .bundleID(let exceptedBundleID):
                if checkBundleID(exceptedBundleID) {
                    cloned = true
                }
            case .isMobileProvisionModified(let expectedSha256Value):
                if isMobileProvisionModified(expectedSha256Value.lowercased()) {
                    cloned = true
                }
            case .isJailBroken:
                if await jailBrokenDetector.isJailBrokenDetected() {
                    cloned = true
                }
            case .isProvisioningProfileTampered:
                if isProvisioningProfileTampered() {
                    cloned = true
                }
            case .isRunningFromValidPath:
                if isRunningFromValidPath() {
                    cloned = true
                }
            case .validateAppReceipt:
                if validateAppReceipt() {
                    cloned = true
                }
            }
        }
        
        return cloned;
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
                
                if Data(hash).hexEncodedString() != expectedSha256Value {
                    return true
                }
            }
        }
        
        return false
    }
    
    private func isProvisioningProfileTampered() -> Bool {
        guard let provisioningPath = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") else {
            return true
        }
        
        do {
            let provisioningData = try Data(contentsOf: URL(fileURLWithPath: provisioningPath))
            if provisioningData.isEmpty {
                return true
            }
        } catch {
            return true
        }
        return false
    }
    
    private func isRunningFromValidPath() -> Bool {
        let validPathPrefix = "/var/containers/Bundle/Application/"
        let currentPath = Bundle.main.bundlePath
        if !currentPath.hasPrefix(validPathPrefix) {
            return false
        }
        return true
    }
    
    
    private func validateAppReceipt() -> Bool {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
            /// Receipt not found. App may be cloned or sideloaded.
            return true
        }
        
        do {
            let receiptData = try Data(contentsOf: appStoreReceiptURL)
            if receiptData.isEmpty {
                /// Receipt is empty. Possible tampering or cloning.
                return true
            }
            /// Receipt is valid.
            return false
        } catch {
            /// Failed to read receipt: \(error.localizedDescription). App might be tampered.
            return true
        }
    }
    
    
}

internal extension Data {
    fileprivate func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
