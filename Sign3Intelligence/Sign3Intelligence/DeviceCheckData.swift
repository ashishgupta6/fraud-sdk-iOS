//
//  DeviceCheckData.swift
//  Sign3Intelligence
//
//  Created by Sreyans Bohara on 18/12/24.
//

internal struct DeviceCheckData: Codable {
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
}

