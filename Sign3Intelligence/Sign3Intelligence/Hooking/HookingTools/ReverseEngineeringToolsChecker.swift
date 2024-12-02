//
//  ReverseEngineeringToolsChecker.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 26/11/24.
//

import Foundation

internal class ReverseEngineeringToolsChecker {
    private let TAG = "ReverseEngineeringToolsChecker"
    private let simulatorDetector = SimulatorDetector()
    
    private enum FailedCheck: CaseIterable {
        case existenceOfSuspiciousFiles
        case dyld
        case openedPorts
        case pSelectFlag
    }
    
    internal func isReverseEngineeringToolsBeingUsed() -> Bool {
        return performChecks()
    }
    
    private func performChecks() -> Bool {
        var result = false
        
        for check in FailedCheck.allCases {
            switch check {
            case .existenceOfSuspiciousFiles:
                if checkSuspiciousFilePath() {
                    result = true
                }
            case .dyld:
                if checkDYLD() {
                    result = true
                }
            case .openedPorts:
                if checkOpenedPorts() {
                    result = true
                }
            case .pSelectFlag:
                if checkPSelectFlag() {
                    result = true
                }
            }
        }
        
        return result
    }
    
    private func checkDYLD() -> Bool {
        for index in 0..<_dyld_image_count() {
            let imageName = String(cString: _dyld_get_image_name(index))
            
            // These files can give false positive in the emulator
            if !simulatorDetector.isSimulatorDetectedWithoutAsync() {
                HookingDetectorConst.suspiciousLibraries += [
                    "Flex",
                ]
                
            }
            
            // The fastest case insensitive contains check.
            for library in HookingDetectorConst.suspiciousLibraries where imageName.localizedCaseInsensitiveContains(library) {
                return true
            }
        }
        
        return false
    }
    
    private func checkSuspiciousFilePath() -> Bool {
        // These files can give false positive in the emulator
        if !simulatorDetector.isSimulatorDetectedWithoutAsync() {
            HookingDetectorConst.suspiciousPaths += [
                "/bin/bash",
                "/usr/sbin/sshd",
                "/usr/libexec/ssh-keysign",
                "/bin/sh",
                "/etc/ssh/sshd_config",
                "/usr/libexec/sftp-server",
                "/usr/bin/ssh" ,
            ]
            
        }
        
        for path in HookingDetectorConst.suspiciousPaths where FileManager.default.fileExists(atPath: path) {
            return true
        }
        
        return false
    }
    
    private func checkOpenedPorts() -> Bool {
        for port in HookingDetectorConst.ports where canOpenLocalConnection(port: port) {
            return true
        }
        
        return false
    }
    
    private func canOpenLocalConnection(port: Int) -> Bool {
        func swapBytesIfNeeded(port: in_port_t) -> in_port_t {
            let littleEndian = Int(OSHostByteOrder()) == OSLittleEndian
            return littleEndian ? _OSSwapInt16(port) : port
        }
        
        var serverAddress = sockaddr_in()
        serverAddress.sin_family = sa_family_t(AF_INET)
        serverAddress.sin_addr.s_addr = inet_addr("127.0.0.1")
        serverAddress.sin_port = swapBytesIfNeeded(port: in_port_t(port))
        let sock = socket(AF_INET, SOCK_STREAM, 0)
        
        let result = withUnsafePointer(to: &serverAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                connect(sock, $0, socklen_t(MemoryLayout<sockaddr_in>.stride))
            }
        }
        
        defer {
            close(sock)
        }
        
        if result != -1 {
            return true // Port is opened
        }
        
        return false
    }
    
    private func checkPSelectFlag() -> Bool {
        var kinfo = kinfo_proc()
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let sysctlRet = sysctl(&mib, UInt32(mib.count), &kinfo, &size, nil, 0)
        
        if sysctlRet != 0 {
            print("Error occured when calling sysctl(). This check may not be reliable")
        }
        
        if (kinfo.kp_proc.p_flag & P_SELECT) != 0 {
            return true
        }
        
        return false
    }
    
    
    
    
}
