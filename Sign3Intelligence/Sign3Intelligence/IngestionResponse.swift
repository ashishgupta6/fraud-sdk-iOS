//
//  IngestionResponse.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 06/01/25.
//

public struct IngestionResponse: Codable {
    public let deviceId: String
    public let requestId:String

    enum CodingKeys: String, CodingKey {
        case deviceId = "deviceId"
        case requestId = "requestId"
    }
}
