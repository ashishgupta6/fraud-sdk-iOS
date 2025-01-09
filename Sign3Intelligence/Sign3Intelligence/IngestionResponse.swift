//
//  IngestionResponse.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 06/01/25.
//

internal struct IngestionResponse: Codable {
    let deviceId: String
    let requestId:String

    enum CodingKeys: String, CodingKey {
        case deviceId = "deviceId"
        case requestId = "requestId"
    }
}
