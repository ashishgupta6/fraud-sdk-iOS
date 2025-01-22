//
//  Location.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 04/09/24.
//

import Foundation

//internal class Location {
//    var latitude: Double
//    var longitude: Double
//    var altitude: Double
//    var timeStamp: CLong
//
//    init(latitude: Double, longitude: Double, altitude: Double, timeStamp: CLong) {
//        self.latitude = latitude
//        self.longitude = longitude
//        self.altitude = altitude
//        self.timeStamp = timeStamp
//    }
//}
internal actor Location: Codable {
    var latitude: Double
    var longitude: Double
    var altitude: Double
    var timeStamp: CLong

    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case altitude = "altitude"
        case timeStamp = "timeStamp"
    }

    func isZeroLocation() -> Bool {
            return latitude == 0.0 &&
                   longitude == 0.0 &&
                   altitude == 0.0 &&
                   timeStamp == 0
    }
    
    init(latitude: Double, longitude: Double, altitude: Double, timeStamp: CLong) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timeStamp = timeStamp
    }

    nonisolated func encode(to encoder: Encoder) throws {
        Task {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try await container.encode(latitude, forKey: .latitude)
            try await container.encode(longitude, forKey: .longitude)
            try await container.encode(altitude, forKey: .altitude)
            try await container.encode(timeStamp, forKey: .timeStamp)
        }
        
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        let altitude = try container.decode(Double.self, forKey: .altitude)
        let timeStamp = try container.decode(CLong.self, forKey: .timeStamp)
        self.init(latitude: latitude, longitude: longitude, altitude: altitude, timeStamp: timeStamp)
    }
}

