//
//  JailBrokenDetector.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 12/09/24.
//

import Foundation
import UIKit

class JailBrokenDetector{
    
    let TAG = "JailBrokenDetector"
    
    func isJailBrokenDetected() async -> Bool{
        return await Utils.getDeviceSignals(
            functionName: TAG,
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                var isJailBrokenFlag = false
                if (!isJailBrokenFlag){
                    isJailBrokenFlag = await checkJainBroken()
                }
                
                if (!isJailBrokenFlag){
                    isJailBrokenFlag = checkJainBrokenFromObjectiveC()
                }
               
                return isJailBrokenFlag
            }
        )
    }
    
    func checkJainBroken() async -> Bool{
        let fileManager = FileManager.default
        let paths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/"
        ]
        for path in paths {
            if fileManager.fileExists(atPath: path) {
                return true
            }
        }
        if let cydiaURL = URL(string: "cydia://package/com.example.package"),
           await UIApplication.shared.canOpenURL(cydiaURL) {
            return true
        }
        let pathsToCheck = [
            "/bin/bash",
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/usr/sbin/sshd",
            "/etc/apt"
        ]
        for path in pathsToCheck {
            if let file = fopen(path, "r") {
                fclose(file)
                return true
            }
        }
        let testString = "This is a test."
        let testFilePath = "/private/jailbreak.txt"
        do {
            try testString.write(toFile: testFilePath, atomically: true, encoding: .utf8)
            try fileManager.removeItem(atPath: testFilePath)
            return true
        } catch {
            // No error means the file was successfully written, indicating a jailbroken device
            return false
        }
    }
    
    
    func checkJainBrokenFromObjectiveC()  -> Bool{
        let jailBrokenChecker = JailBrokenChecker()
        return jailBrokenChecker.isJailBroken()
    }
}
