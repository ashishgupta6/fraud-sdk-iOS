//
//  LocationSpoffer.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 17/09/24.
//

import Foundation
import CoreLocation


class LocationSpoffer {
    
    let TAG = "LocationSpoffer"
    
    func isMockLocation() async -> Bool{
        return await Utils.getDeviceSignals(
            functionName: TAG,
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                // Check if location permission is granted
                guard Utils.checkLocationPermission() else {
                    Utils.showInfologs(tags: "Permission Denied", value: "Location permission not granted")
                    return false
                }
                
                return await withCheckedContinuation { continuation in
                    DispatchQueue.main.async {
                        LocationFramework.shared.startUpdatingLocation { location in
                            if #available(iOS 15.0, *) {
                                let isLocationSimulated = location.sourceInformation?.isSimulatedBySoftware ?? false
                                let isProducedByAccess = location.sourceInformation?.isProducedByAccessory ?? false
                                
                                let info = CLLocationSourceInformation(softwareSimulationState: isLocationSimulated, andExternalAccessoryState: isProducedByAccess)
                                
                                if info.isSimulatedBySoftware == true || info.isProducedByAccessory == true{
                                    LocationFramework.shared.stopUpdatingLocation()
                                    continuation.resume(returning: true)
                                } else {
                                    LocationFramework.shared.stopUpdatingLocation()
                                    continuation.resume(returning: false)
                                }
//                                self.handleLocationForBelowiOS15(location: location, continuation: continuation)
                                
                            } else{
                                // Handle iOS versions below 15
                                self.handleLocationForBelowiOS15(location: location, continuation: continuation)
                            }
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
//             No previously saved location found, assuming it's the first time fetching the location and saving it
            Sign3IntelligenceInternal.sdk?.userDefaultsManager.saveLocation(Location(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                altitude: location.altitude,
                timeStamp: Utils.dateToUnixTimestamp(location.timestamp)))
            
            // Only for testing purpose
//            Sign3IntelligenceInternal.sdk?.userDefaultsManager.saveLocation(Location(
//                latitude: 19.0821775,
//                longitude: 72.716374,
//                altitude: 265.03831481933594,
//                timeStamp: 1726599056))
            
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
        
        let isSpoofed = isLocationSpoofedForBelowiOS15(currentLocation, savedLocation)
        if !isSpoofed {
            Sign3IntelligenceInternal.sdk?.userDefaultsManager.saveLocation(Location(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                altitude: location.altitude,
                timeStamp: Utils.dateToUnixTimestamp(location.timestamp)))
            
            // Only for testing purpose
//            Sign3IntelligenceInternal.sdk?.userDefaultsManager.saveLocation(Location(
//                latitude: 19.0821775,
//                longitude: 72.716374,
//                altitude: 265.03831481933594,
//                timeStamp: 1726599056))
        }
        LocationFramework.shared.stopUpdatingLocation()
        continuation.resume(returning: isSpoofed)
    }
    
    func isLocationSpoofedForBelowiOS15(_ newLocation: Location, _ oldLocation: Location) -> Bool {
        let distanceThreshold: Double = 15000 // 15 KM threshold
        let timeThreshold: Double = 60 * 30  // 30 Minutes threshold
        
        let currentLocation = CLLocation(latitude: newLocation.latitude, longitude: newLocation.longitude)
        let previousLocation = CLLocation(latitude: oldLocation.latitude, longitude: oldLocation.longitude)
        let timeDifference = Double(newLocation.timeStamp - oldLocation.timeStamp)
        
        let distance = currentLocation.distance(from: previousLocation)
        
        if distance > distanceThreshold && timeDifference < timeThreshold {
            return true // Possibly spoofed
        }
        
        return false
    }
}
