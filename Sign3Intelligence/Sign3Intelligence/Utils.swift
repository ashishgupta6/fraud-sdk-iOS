//
//  Utils.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 27/08/24.
//

import Foundation
import AppTrackingTransparency
import CoreLocation


struct Utils{
    
    static func getDeviceSignals<T>(functionName: String, requestId: String, defaultValue: T, function: () async throws -> T) async -> T {
        do {
            return try await function()
        } catch {
            return defaultValue
        }
    }
    
    static func getDeviceSignalsWithoutAsync<T>(functionName: String, requestId: String, defaultValue: T, function: () throws -> T) -> T {
        do {
            return try function()
        } catch {
            return defaultValue
        }
    }
    
    static func showInfologs(tags: String, value: String){
        print("\(tags): \(value)")
    }
    
    static func showErrorlogs(tags: String, value: String){
        print("\(tags): \(value)")
    }
    
    static func checkThread(){
        let thread = Thread.current
        let threadId = thread.value(forKeyPath: "private.seqNum") as? Int ?? 0
        
        print("Thread ID: \(threadId)")
        print("Is Main Thread: \(thread.isMainThread)")
    }
    
    static func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
    
    static func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata") // IST time zone
        dateFormatter.dateFormat = "dd-MM-yyyy HH:MM a"
        return dateFormatter.string(from: date)
    }
    
    static func checkLocationPermission() -> Bool{
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            // You might want to request permission here
            return false
        case .restricted:
            return false
        case .denied:
            return false
        case .authorizedWhenInUse:
            return true
        case .authorizedAlways:
            return true
        @unknown default:
            return false
        }
    }
    
    static func checkLocationServiceEnabled() -> Bool{
        if CLLocationManager.locationServicesEnabled() {
            print("Location services are enabled")
            return true
        } else {
            print("Location services are disabled")
            return false
        }
    }
    
    static func encodeObject<T: Encodable>(tag: String, object: T){
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(object)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                Utils.showInfologs(tags: tag, value: jsonString)
            }
        } catch {
            print("Failed to encode: \(error)")
        }
    }
    
    static func getSessionId() -> String{
        let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let sessionId = "\(uuid.prefix(8))-\(uuid.prefix(12).suffix(4))-\(uuid.prefix(16).suffix(4))-\(uuid.prefix(20).suffix(4))-\(uuid.suffix(12))"
        return sessionId
    }
    
}
