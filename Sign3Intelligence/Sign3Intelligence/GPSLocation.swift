//
//  GPSLocation.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 12/12/24.
//

public struct GPSLocation: Codable {
    public let latitude: Double
    public let longitude: Double
    public let altitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case altitude = "altitude"
    }
}
