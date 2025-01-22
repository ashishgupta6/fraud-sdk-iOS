//
//  DeviceCheckData.swift
//  Sign3Intelligence
//
//  Created by Sreyans Bohara on 18/12/24.
//

//internal struct DeviceCheckData: Codable {
//    let deviceToken: String
//    let transactionId: String
//    let timestamp: Int64
//    let bit0: Bool
//    let bit1: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case deviceToken = "device_token"
//        case transactionId = "transaction_id"
//        case timestamp = "timestamp"
//        case bit0 = "bit0"
//        case bit1 = "bit1"
//    }
//}

internal actor DeviceCheckData: Codable {
    let deviceToken: String
    let transactionId: String
    let timestamp: Int64
    let bit0: Bool
    let bit1: Bool

    enum CodingKeys: String, CodingKey {
        case deviceToken = "device_token"
        case transactionId = "transaction_id"
        case timestamp = "timestamp"
        case bit0 = "bit0"
        case bit1 = "bit1"
    }

    init(deviceToken: String, transactionId: String, timestamp: Int64, bit0: Bool, bit1: Bool) {
        self.deviceToken = deviceToken
        self.transactionId = transactionId
        self.timestamp = timestamp
        self.bit0 = bit0
        self.bit1 = bit1
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deviceToken, forKey: .deviceToken)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(bit0, forKey: .bit0)
        try container.encode(bit1, forKey: .bit1)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let deviceToken = try container.decode(String.self, forKey: .deviceToken)
        let transactionId = try container.decode(String.self, forKey: .transactionId)
        let timestamp = try container.decode(Int64.self, forKey: .timestamp)
        let bit0 = try container.decode(Bool.self, forKey: .bit0)
        let bit1 = try container.decode(Bool.self, forKey: .bit1)
        self.init(deviceToken: deviceToken, transactionId: transactionId, timestamp: timestamp, bit0: bit0, bit1: bit1)
    }
}


