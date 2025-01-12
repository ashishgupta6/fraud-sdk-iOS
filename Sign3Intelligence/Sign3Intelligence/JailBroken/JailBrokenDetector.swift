//
//  JailBrokenDetector.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 12/09/24.
//

import Foundation
import UIKit
import MachO.dyld.utils

internal class JailBrokenDetector{
    
    private let TAG = "JailBrokenDetector"
    
    private enum JailBrokenDetectorCheck {
        case urlSchemes
        case existenceOfSuspiciousFiles
        case suspiciousFilesCanBeOpened
        case restrictedDirectoriesWriteable
        case fork
        case symbolicLinks
        case dyld
        case suspiciousObjCClasses
        case checkJainBrokenFromObjectiveC
    }
    private typealias CheckResult = (passed: Bool, failMessage: String)
    private let simulatorDetector = SimulatorDetector()
    
    internal func isJailBrokenDetected() async -> Bool{
        return await Utils.getDeviceSignals(
            functionName: TAG,
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                await amiJailBroken([
                    JailBrokenDetector.JailBrokenDetectorCheck.urlSchemes,
                    JailBrokenDetector.JailBrokenDetectorCheck.existenceOfSuspiciousFiles,
                    JailBrokenDetector.JailBrokenDetectorCheck.suspiciousFilesCanBeOpened,
                    JailBrokenDetector.JailBrokenDetectorCheck.restrictedDirectoriesWriteable,
                    JailBrokenDetector.JailBrokenDetectorCheck.fork,
                    JailBrokenDetector.JailBrokenDetectorCheck.symbolicLinks,
                    JailBrokenDetector.JailBrokenDetectorCheck.dyld,
                    JailBrokenDetector.JailBrokenDetectorCheck.suspiciousObjCClasses,
                    JailBrokenDetector.JailBrokenDetectorCheck.checkJainBrokenFromObjectiveC
                ])
            })
    }
    
    
    private func amiJailBroken(_ checks: [JailBrokenDetectorCheck]) async -> Bool{
        var isJailBrokenFlag = false
        for check in checks {
            switch check {
            case .urlSchemes:
                if checkURLSchemes(){
                    isJailBrokenFlag = true
                }
            case .existenceOfSuspiciousFiles:
                if checkExistenceOfSuspiciousFiles(){
                    isJailBrokenFlag = true
                }
            case .suspiciousFilesCanBeOpened:
                if checkSuspiciousFilesCanBeOpened(){
                    isJailBrokenFlag = true
                }
            case .restrictedDirectoriesWriteable:
                if checkRestrictedDirectoriesWriteable(){
                    isJailBrokenFlag = true
                }
            case .fork:
                if await !simulatorDetector.isSimulatorDetected() {
                    if checkFork(){
                        isJailBrokenFlag = true
                    }
                }
            case .symbolicLinks:
                if checkSymbolicLinks(){
                    isJailBrokenFlag = true
                }
            case .dyld:
                if checkDYLD(){
                    isJailBrokenFlag = true
                }
            case .suspiciousObjCClasses:
                if checkSuspiciousObjCClasses(){
                    isJailBrokenFlag = true
                }
            case .checkJainBrokenFromObjectiveC:
                if checkJainBrokenFromObjectiveC(){
                    isJailBrokenFlag = true
                }
            }
        }
        
        return isJailBrokenFlag
    }
    
    private func checkJainBrokenFromObjectiveC()  -> Bool{
        let jailBrokenChecker = JailBrokenChecker()
        return jailBrokenChecker.isJailBroken()
    }
    
    private func checkURLSchemes() -> Bool {
        return canOpenUrlFromList(urlSchemes: JailBrokenDetectorConst.urlSchemes)
    }
    
    private func canOpenUrlFromList(urlSchemes: [String]) -> Bool {
        for urlScheme in urlSchemes {
            if let url = URL(string: urlScheme) {
                if UIApplication.shared.canOpenURL(url) {
                    return true
                }
            }
        }
        return false
    }
    
    private func checkExistenceOfSuspiciousFiles() -> Bool {
        // These files can give false positive in the emulator
        if  !simulatorDetector.isSimulatorDetectedWithoutAsync() {
            JailBrokenDetectorConst.suspiciousFilePath += [
                "/bin/bash",
                "/usr/sbin/sshd",
                "/usr/libexec/ssh-keysign",
                "/bin/sh",
                "/etc/ssh/sshd_config",
                "/usr/libexec/sftp-server",
                "/usr/bin/ssh"
            ]
        }
        
        for path in JailBrokenDetectorConst.suspiciousFilePath {
            if FileManager.default.fileExists(atPath: path) {
                return true
            } else if FileChecker.checkExistenceOfSuspiciousFilesViaStat(path: path) {
                return true
            } else if FileChecker.checkExistenceOfSuspiciousFilesViaFOpen(
                path: path,
                mode: .readable
            ) {
                return true
            } else if FileChecker.checkExistenceOfSuspiciousFilesViaAccess(
                path: path,
                mode: .readable
            ) {
                return true
            }
        }
        
        return false
    }
    
    private func checkSuspiciousFilesCanBeOpened() -> Bool {
        // These files can give false positive in the emulator
        if !simulatorDetector.isSimulatorDetectedWithoutAsync() {
            JailBrokenDetectorConst.suspiciousFilePath += [
                "/bin/bash",
                "/usr/sbin/sshd",
                "/usr/libexec/ssh-keysign",
                "/bin/sh",
                "/etc/ssh/sshd_config",
                "/usr/libexec/sftp-server",
                "/usr/bin/ssh"
            ]
        }
        
        for path in JailBrokenDetectorConst.suspiciousFilePath {
            if FileManager.default.isReadableFile(atPath: path) {
                return true
            } else if FileChecker.checkExistenceOfSuspiciousFilesViaFOpen(
                path: path,
                mode: .writable
            ) {
                return true
            } else if FileChecker.checkExistenceOfSuspiciousFilesViaAccess(
                path: path,
                mode: .writable
            ) {
                return true
            }
            
        }
        
        return false
    }
    
    private func checkRestrictedDirectoriesWriteable() -> Bool {
        if FileChecker.checkRestrictedPathIsReadonlyViaStatvfs(path: "/") == false {
            return true
        } else if FileChecker.checkRestrictedPathIsReadonlyViaStatfs(path: "/") == false {
            return true
        } else if FileChecker.checkRestrictedPathIsReadonlyViaGetfsstat(name: "/") == false {
            return true
        }
        
        // If library won't be able to write to any restricted directory the return(false, ...) is never reached
        // because of catch{} statement
        for path in JailBrokenDetectorConst.directory {
            do {
                let pathWithSomeRandom = path + UUID().uuidString
                try "AmIJailbroken?".write(
                    toFile: pathWithSomeRandom,
                    atomically: true,
                    encoding: String.Encoding.utf8
                )
                // clean if succesfully written
                try FileManager.default.removeItem(atPath: pathWithSomeRandom)
                return true
            } catch {
                return false
            }
        }
        
        return false
    }
    
    private func checkFork() -> Bool {
        let pointerToFork = UnsafeMutableRawPointer(bitPattern: -2)
        let forkPtr = dlsym(pointerToFork, "fork")
        typealias ForkType = @convention(c) () -> pid_t
        let fork = unsafeBitCast(forkPtr, to: ForkType.self)
        let forkResult = fork()
        
        if forkResult >= 0 {
            if forkResult > 0 {
                kill(forkResult, SIGTERM)
            }
            return true
        }
        
        return false
    }
    
    private func checkSymbolicLinks() -> Bool {
        for path in JailBrokenDetectorConst.symbolicPath {
            do {
                let result = try FileManager.default.destinationOfSymbolicLink(atPath: path)
                if !result.isEmpty {
                    return true
                }
            } catch {}
        }
        
        return false
    }
    
    private func checkDYLD() -> Bool {
        for index in 0..<_dyld_image_count() {
            let imageName = String(cString: _dyld_get_image_name(index))
            
            // The fastest case insensitive contains check.
            for library in JailBrokenDetectorConst.suspiciousLibraries where imageName.localizedCaseInsensitiveContains(library) {
                return true
            }
        }
        
        return false
    }
    
    private func checkSuspiciousObjCClasses() -> Bool {
        if let shadowRulesetClass = objc_getClass("ShadowRuleset") as? NSObject.Type {
            let selector = Selector(("internalDictionary"))
            if class_getInstanceMethod(shadowRulesetClass, selector) != nil {
                return true
            }
        }
        return false
    }
}
