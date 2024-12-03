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
        for port in HookingDetectorConst.fridaPorts where canOpenLocalConnection(port: port) {
            return true
        }
        
        return false
    }
    
    private static func canOpenLocalConnection(port: Int) -> Bool {
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
    
    
    private static func hasFridaLibraries() -> Bool{
        for index in 0..<_dyld_image_count() {
            let imageName = String(cString: _dyld_get_image_name(index))
            
            // The fastest case insensitive contains check.
            for library in HookingDetectorConst.suspiciousFridaLibraries where imageName.localizedCaseInsensitiveContains(library) {
                return true
            }
        }
        
        return false
    }
    
    private static func detectFridaFiles() -> Bool{
        for path in HookingDetectorConst.suspiciousFridaPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
        
    }
    
}
