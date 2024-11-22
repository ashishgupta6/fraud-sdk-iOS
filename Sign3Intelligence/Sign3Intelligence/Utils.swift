//
//  Utils.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 27/08/24.
//

import Foundation
import AppTrackingTransparency
import CoreLocation


internal struct Utils{
    
    internal static func getDeviceSignals<T>(functionName: String, requestId: String, defaultValue: T, function: () async throws -> T) async -> T {
        do {
            return try await function()
        } catch {
            return defaultValue
        }
    }
    
    internal static func getDeviceSignalsWithoutAsync<T>(functionName: String, requestId: String, defaultValue: T, function: () throws -> T) -> T {
        do {
            return try function()
        } catch {
            return defaultValue
        }
    }
    
    internal static func showInfologs(tags: String, value: String){
        print("\(tags): \(value)")
    }
    
    internal static func showErrorlogs(tags: String, value: String){
        print("\(tags): \(value)")
    }
    
    internal static func checkThread(){
        let thread = Thread.current
        let threadId = thread.value(forKeyPath: "private.seqNum") as? Int ?? 0
        
        print("Thread ID: \(threadId)")
        print("Is Main Thread: \(thread.isMainThread)")
    }
    
    internal static func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
    
    internal static func dateToString(_ timeStamp: CLong) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata") // IST time zone
        return dateFormatter.string(from: date)
    }
    
    internal static func dateToUnixTimestamp(_ date: Date) -> CLong {
        return CLong(date.timeIntervalSince1970)
    }
    
    internal static func checkLocationPermission() -> Bool{
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
    
    internal static func checkLocationServiceEnabled() -> Bool{
        if CLLocationManager.locationServicesEnabled() {
            print("Location services are enabled")
            return true
        } else {
            print("Location services are disabled")
            return false
        }
    }
    
    internal static func encodeObject<T: Encodable>(tag: String, object: T){
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
    
    internal static func getSessionId() -> String{
        let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let sessionId = "\(uuid.prefix(8))-\(uuid.prefix(12).suffix(4))-\(uuid.prefix(16).suffix(4))-\(uuid.prefix(20).suffix(4))-\(uuid.suffix(12))"
        return sessionId
    }
    
}
