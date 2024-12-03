//
//  Utils.swift
//  FraudSDK-iOS
//
//  Created by Ashish Gupta on 29/08/24.
//

import Foundation
import CoreLocation
import AppTrackingTransparency


class Utils{
    
    private static let locationManager = CLLocationManager()
    
    static func checkThread(){
        let thread = Thread.current
        let threadId = thread.value(forKeyPath: "private.seqNum") as? Int ?? 0
        print("Thread ID: \(threadId)")
        print("Is Main Thread: \(thread.isMainThread)")
    }
    
    static func requestLocationPermission(){
        // Check the current authorization status
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            // Request permission if not determined yet
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // Handle the case where permission is restricted or denied
            print("Location access is restricted or denied.")
        case .authorizedWhenInUse, .authorizedAlways:
            // Permission is already granted
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError("Unhandled authorization status")
        }
    }
    
    static func requestPermissionForIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Log: ATTrackingManager request successful")
                case .denied,
                        .notDetermined,
                        .restricted:
                    print("Log: ATTrackingManager request denied")
                    break
                @unknown default:
                    print("Log: ATTrackingManager request default")
                    break
                }
            }
        } else {
            print("Log: below iOS 14")
        }
    }
    
    static func showInfologs(tags: String, value: String){
        print("\(tags): \(value)")
    }
    
    static func showErrorlogs(tags: String, value: String){
        print("\(tags): \(value)")
    }
    
    static func dateToString(_ timeStamp: CLong) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata") // IST time zone
        return dateFormatter.string(from: date)
    }
}
