//
//  DataRequest.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

internal struct DataRequest: Codable {
    let requestId: String
    let sessionId: String
    let deviceParams: DeviceParams
    let clientParams: ClientParams
    
    enum CodingKeys: String, CodingKey {
        case requestId = "a"
        case sessionId = "b"
        case deviceParams = "c"
        case clientParams = "d"
    }
}
