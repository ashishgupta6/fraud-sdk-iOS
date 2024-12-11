//
//  NetworkLocation.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation


internal struct NetworkLocation: Codable {
    let latitude: Double
    let longitude: Double
    let altitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "a"
        case longitude = "b"
        case altitude = "c"
    }
}
