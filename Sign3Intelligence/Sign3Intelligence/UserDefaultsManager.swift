//
//  UserDefaultsManager.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 17/09/24.
//

import Foundation


import Foundation

internal class UserDefaultsManager {
    
    private enum UserDefaultsKeys: String {
        case latitude
        case longitude
        case altitude
        case timeStamp
    }
    
    internal func saveLatitude(_ latitude: Double) {
        UserDefaults.standard.set(latitude, forKey: UserDefaultsKeys.latitude.rawValue)
    }
    
    internal func saveLongitude(_ longitude: Double) {
        UserDefaults.standard.set(longitude, forKey: UserDefaultsKeys.longitude.rawValue)
    }
    
    internal func saveAltitude(_ altitude: Double) {
        UserDefaults.standard.set(altitude, forKey: UserDefaultsKeys.altitude.rawValue)
    }
    
    internal func saveTimeStamp(_ timeStamp: CLong) {
        UserDefaults.standard.set(timeStamp, forKey: UserDefaultsKeys.timeStamp.rawValue)
    }
    
    internal func getLatitude() -> Double? {
        return UserDefaults.standard.double(forKey: UserDefaultsKeys.latitude.rawValue)
    }
    
    internal func getLongitude() -> Double? {
        return UserDefaults.standard.double(forKey: UserDefaultsKeys.longitude.rawValue)
    }
    
    internal func getAltitude() -> Double? {
        return UserDefaults.standard.double(forKey: UserDefaultsKeys.altitude.rawValue)
    }
    
    internal func getTimeStamp() -> CLong? {
        return CLong(UserDefaults.standard.integer(forKey: UserDefaultsKeys.timeStamp.rawValue))
    }
    
    internal func saveLocation(_ location: Location) {
        saveLatitude(location.latitude)
        saveLongitude(location.longitude)
        saveAltitude(location.altitude)
        saveTimeStamp(location.timeStamp)
    }
    
    internal func getLocation() -> Location? {
        guard let latitude = getLatitude(),
              let longitude = getLongitude(),
              let altitude = getAltitude(),
              let timeStamp = getTimeStamp() else {
            return nil
        }
        let location = "Latitude: \(latitude), Longitude: \(longitude), Altitude: \(altitude), Timestamp: \(timeStamp)"
        Log.i("SAVED_LOCATION",location)
        return Location(latitude: latitude, longitude: longitude, altitude: altitude, timeStamp: timeStamp)
    }
    
    internal func removeLocation() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.latitude.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.longitude.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.altitude.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.timeStamp.rawValue)
    }
}
