//
//  UserDefaultsManager.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 17/09/24.
//

import Foundation

internal class UserDefaultsManager {
    private let userDefaults = UserDefaults.standard
    private let responseKey = "IntelligenceResponseKey"
    
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
        //TODO: (Sreyans) Remove this if it is unused
//        saveLatitude(location.latitude)
//        saveLongitude(location.longitude)
//        saveAltitude(location.altitude)
//        saveTimeStamp(location.timeStamp)
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
    
    
    internal func saveIntelligenceResponseToUserDefaults(
        _ dataRequest: DataRequest,
        _ sign3Intelligence: Sign3IntelligenceInternal,
        _ intelligenceResponse: IntelligenceResponse
    ) {
        DispatchQueue.global(qos: .default).async {
            do {
                // Encrypt Response
                let iv = CryptoGCM.getIvHeader()
                let jsonData = try JSONEncoder().encode(intelligenceResponse)
                guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                    return
                }
                var encryptedResponse = try CryptoGCM.encrypt(
                    jsonString,
                    iv
                )
                encryptedResponse.append(" \(iv.base64EncodedString())")
                
                // Save to UserDefaults
                self.userDefaults.set(encryptedResponse, forKey: self.responseKey)
                Log.i("Response saved successfully.", encryptedResponse)
            } catch {
                Log.e("saveIntelligenceResponseToUserDefaults:", "\(error.localizedDescription)")
            }
        }
    }
    
    internal func fetchIntelligenceFromUserDefaults(completion: @escaping (IntelligenceResponse?) -> Void) {
        DispatchQueue.global(qos: .default).async {
            // Retrieve from UserDefaults
            guard let response = self.userDefaults.string(forKey: self.responseKey) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Decrypt Response
            var nonceBase64 = ""
            var ciphertextBase64 = ""
            let trimmedString = response.split(separator: " ")
            if trimmedString.count > 1 {
                nonceBase64 = String(trimmedString[1])
                ciphertextBase64 = String(trimmedString[0])
            }
            
            let decryptedResponse = CryptoGCM.decrypt(ciphertextBase64: ciphertextBase64, nonceBase64: nonceBase64)
            
            if let jsonData = decryptedResponse?.data(using: .utf8) {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(IntelligenceResponse.self, from: jsonData)
                    DispatchQueue.main.async {
                        completion(response)
                    }
                    return
                } catch {
                    Log.e("Error decoding JSON:", error.localizedDescription)
                }
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
}
