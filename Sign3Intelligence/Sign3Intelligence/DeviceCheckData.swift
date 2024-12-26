//
//  DeviceCheckData.swift
//  Sign3Intelligence
//
//  Created by Sreyans Bohara on 18/12/24.
//

public struct DeviceCheckData: Codable {
    public let deviceToken: String
    public let transactionId: String
    public let timestamp: Int64
    public let bit0: Bool
    public let bit1: Bool

    enum CodingKeys: String, CodingKey {
        case deviceToken = "device_token"
        case transactionId = "transaction_id"
        case timestamp = "timestamp"
        case bit0 = "bit0"
        case bit1 = "bit1"
    }
}

