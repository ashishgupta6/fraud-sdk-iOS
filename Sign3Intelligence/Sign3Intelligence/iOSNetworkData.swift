//
//  iOSNetworkData.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

//internal struct iOSNetworkData: Codable {
//    let networkLocation: NetworkLocation
//    
//    enum CodingKeys: String, CodingKey {
//        case networkLocation = "a"
//    }
//}

internal actor iOSNetworkData: Codable {
    let networkLocation: NetworkLocation

    enum CodingKeys: String, CodingKey {
        case networkLocation = "a"
    }

    init(networkLocation: NetworkLocation) {
        self.networkLocation = networkLocation
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(networkLocation, forKey: .networkLocation)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            networkLocation: try container.decode(NetworkLocation.self, forKey: .networkLocation)
        )
    }
}

