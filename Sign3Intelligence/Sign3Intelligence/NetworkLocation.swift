//
//  NetworkLocation.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation


//internal struct NetworkLocation: Codable {
//    let latitude: Double
//    let longitude: Double
//    let altitude: Double
//    
//    enum CodingKeys: String, CodingKey {
//        case latitude = "a"
//        case longitude = "b"
//        case altitude = "c"
//    }
//}

internal actor NetworkLocation: Codable {
    let latitude: Double
    let longitude: Double
    let altitude: Double

    enum CodingKeys: String, CodingKey {
        case latitude = "a"
        case longitude = "b"
        case altitude = "c"
    }

    init(latitude: Double, longitude: Double, altitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(altitude, forKey: .altitude)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            latitude: try container.decode(Double.self, forKey: .latitude),
            longitude: try container.decode(Double.self, forKey: .longitude),
            altitude: try container.decode(Double.self, forKey: .altitude)
        )
    }
}
