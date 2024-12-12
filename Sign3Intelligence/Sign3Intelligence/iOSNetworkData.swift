//
//  iOSNetworkData.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

internal struct iOSNetworkData: Codable {
    let networkLocation: NetworkLocation
    
    enum CodingKeys: String, CodingKey {
        case networkLocation = "a"
    }
}
