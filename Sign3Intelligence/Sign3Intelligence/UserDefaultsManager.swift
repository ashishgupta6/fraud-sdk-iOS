//
//  UserDefaultsManager.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 17/09/24.
//

import Foundation


import Foundation

class UserDefaultsManager {
    
    private enum UserDefaultsKeys: String {
        case latitude
        case longitude
        case altitude
        case timeStamp
    }
    
    func saveLatitude(_ latitude: Double) {
        UserDefaults.standard.set(latitude, forKey: UserDefaultsKeys.latitude.rawValue)
    }
    
    func saveLongitude(_ longitude: Double) {
        UserDefaults.standard.set(longitude, forKey: UserDefaultsKeys.longitude.rawValue)
    }
    
    func saveAltitude(_ altitude: Double) {
        UserDefaults.standard.set(altitude, forKey: UserDefaultsKeys.altitude.rawValue)
    }
    
    func saveTimeStamp(_ timeStamp: CLong) {
        UserDefaults.standard.set(timeStamp, forKey: UserDefaultsKeys.timeStamp.rawValue)
    }
    
    func getLatitude() -> Double? {
        return UserDefaults.standard.double(forKey: UserDefaultsKeys.latitude.rawValue)
    }
    
    func getLongitude() -> Double? {
        return UserDefaults.standard.double(forKey: UserDefaultsKeys.longitude.rawValue)
    }
    
    func getAltitude() -> Double? {
        return UserDefaults.standard.double(forKey: UserDefaultsKeys.altitude.rawValue)
    }
    
    func getTimeStamp() -> CLong? {
        return CLong(UserDefaults.standard.integer(forKey: UserDefaultsKeys.timeStamp.rawValue))
    }
    
    func saveLocation(_ location: Location) {
        saveLatitude(location.latitude)
        saveLongitude(location.longitude)
        saveAltitude(location.altitude)
        saveTimeStamp(location.timeStamp)
    }
    
    func getLocation() -> Location? {
        guard let latitude = getLatitude(),
              let longitude = getLongitude(),
              let altitude = getAltitude(),
              let timeStamp = getTimeStamp() else {
            return nil
        }
        let location = "Latitude: \(latitude), Longitude: \(longitude), Altitude: \(altitude), Timestamp: \(timeStamp)"
        Utils.showInfologs(tags: "TAG_SAVED_LOCATION", value: location)
        return Location(latitude: latitude, longitude: longitude, altitude: altitude, timeStamp: timeStamp)
    }
    
    func removeLocation() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.latitude.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.longitude.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.altitude.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.timeStamp.rawValue)
    }
}
