//
//  LocationSpoffer.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 17/09/24.
//

import Foundation
import CoreLocation
import UIKit


internal class LocationSpoffer {
    
    private let TAG = "LocationSpoffer"
    
    internal func isMockLocation() async -> Bool{
        return await Utils.getDeviceSignals(
            functionName: TAG,
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                /// Check if location permission is granted
                if await UIApplication.shared.applicationState == .background {
                    guard Utils.hasBackgroundLocationPermission() else {
                        Log.e("Permission Denied", "Background Location permission not granted")
                        return false
                    }
                } else {
                    guard Utils.hasForegroundLocationPermission() else {
                        Log.e("Permission Denied", "Foreground Location permission not granted")
                        return false
                    }
                }
                
                return await withCheckedContinuation { continuation in
                    DispatchQueue.main.async {
                        var hasResumed = false
                        LocationFramework.shared.startUpdatingLocation { location in
                            if hasResumed { return }
                            if #available(iOS 15.0, *) {
                                let isLocationSimulated = location.sourceInformation?.isSimulatedBySoftware ?? false
                                let isProducedByAccess = location.sourceInformation?.isProducedByAccessory ?? false
                                
                                let info = CLLocationSourceInformation(softwareSimulationState: isLocationSimulated, andExternalAccessoryState: isProducedByAccess)
                                
                                if info.isSimulatedBySoftware == true || info.isProducedByAccessory == true{
                                    hasResumed = true
                                    LocationFramework.shared.stopUpdatingLocation()
                                    continuation.resume(returning: true)
                                    return
                                } else {
                                    hasResumed = true
                                    LocationFramework.shared.stopUpdatingLocation()
                                    continuation.resume(returning: false)
                                    return
                                }
                            } else{
                                /// Handle iOS versions below 15
                                self.handleLocationForBelowiOS15(location: location, continuation: continuation)
                                return
                            }
            
                        }
                        
                        /// This code executes when the app goes into the background. It waits for 10 seconds to get the current location, if not obtained, it defaults to `false`.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            /// Prevent duplicate resumes
                            guard !hasResumed else { return }
                            hasResumed = true
                            continuation.resume(returning: false)
                        }
                    }
                }
            }
        )
    }
    
    
    private func saveValidLocation(_ location: CLLocation) {
        Sign3IntelligenceInternal.sdk?.userDefaultsManager.saveLocation(Location(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude,
            timeStamp: Utils.dateToUnixTimestamp(location.timestamp)
        ))
        LocationFramework.shared.stopUpdatingLocation()
    }
    
    private func handleLocationForBelowiOS15(location: CLLocation, continuation: CheckedContinuation<Bool, Never>) {
        guard let savedLocation = Sign3IntelligenceInternal.sdk?.userDefaultsManager.getLocation() else {
//          No previously saved location found, assuming it's the first time fetching the location and saving it
            Sign3IntelligenceInternal.sdk?.userDefaultsManager.saveLocation(Location(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                altitude: location.altitude,
                timeStamp: Utils.dateToUnixTimestamp(location.timestamp)))
            
            LocationFramework.shared.stopUpdatingLocation()
            continuation.resume(returning: false)
            return
        }
        
        let currentLocation = Location(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude,
            timeStamp: Utils.dateToUnixTimestamp(location.timestamp)
        )
        
        Task {
            let isSpoofed = await isLocationSpoofedForBelowiOS15(currentLocation, savedLocation)
            if !isSpoofed {
                Sign3IntelligenceInternal.sdk?.userDefaultsManager.saveLocation(Location(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    altitude: location.altitude,
                    timeStamp: Utils.dateToUnixTimestamp(location.timestamp)))
            }
            LocationFramework.shared.stopUpdatingLocation()
            continuation.resume(returning: isSpoofed)
        }
    }
    
    private func isLocationSpoofedForBelowiOS15(_ currentLocation: Location, _ savedLocation: Location) async -> Bool {
        let distanceThreshold: Double = 15000 // 15 KM threshold
        
        if await savedLocation.isZeroLocation() {
            return false
        }
        
        let currentLocation = await CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let previousLocation = await CLLocation(latitude: savedLocation.latitude, longitude: savedLocation.longitude)
        
        let distance = currentLocation.distance(from: previousLocation)
        
        if distance > distanceThreshold{
            return true // Possibly spoofed
        }
        
        return false
    }
}
