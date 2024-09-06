//
//  LocationManagerDelegate.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 04/09/24.
//

import Foundation
import CoreLocation

class LocationDetector: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    private var onLocationUpdate: ((CLLocation) -> Void)?
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    public func startUpdatingLocation(onUpdate: @escaping (CLLocation) -> Void) {
        self.onLocationUpdate = onUpdate
        locationManager.startUpdatingLocation()
    }
    
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.onLocationUpdate?(location)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Utils.showErrorlogs(tags: "Location Failed", value: error.localizedDescription)
    }
    
}

class LocationFramework {
    public static let shared = LocationDetector()
}
