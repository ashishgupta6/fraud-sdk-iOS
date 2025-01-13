//
//  DeviceFingerprint.swift
//  Sign3Intelligence
//
//  Created by Sreyans Bohara on 13/01/25.
//

internal struct DeviceFingerprint: Codable {
    let iv: String = CryptoGCM.getIvHeader().base64EncodedString()
    let deviceId: String

    enum CodingKeys: String, CodingKey {
        case iv = "iv"
        case deviceId = "deviceId"
    }
}
