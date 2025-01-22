//
//  IngestionResponse.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 06/01/25.
//

//internal struct IngestionResponse: Codable {
//    let deviceId: String
//    let requestId:String
//
//    enum CodingKeys: String, CodingKey {
//        case deviceId = "deviceId"
//        case requestId = "requestId"
//    }
//}

internal actor IngestionResponse: Codable {
    let deviceId: String
    let requestId: String

    enum CodingKeys: String, CodingKey {
        case deviceId = "deviceId"
        case requestId = "requestId"
    }

    init(deviceId: String, requestId: String) {
        self.deviceId = deviceId
        self.requestId = requestId
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deviceId, forKey: .deviceId)
        try container.encode(requestId, forKey: .requestId)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let deviceId = try container.decode(String.self, forKey: .deviceId)
        let requestId = try container.decode(String.self, forKey: .requestId)
        self.init(deviceId: deviceId, requestId: requestId)
    }
}

