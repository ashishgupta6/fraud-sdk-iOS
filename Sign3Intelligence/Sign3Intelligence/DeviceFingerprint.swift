//
//  DeviceFingerprint.swift
//  Sign3Intelligence
//
//  Created by Sreyans Bohara on 13/01/25.
//

//internal struct DeviceFingerprint: Codable {
//    let encodedIv: String
//    let encryptedDeviceId: String
//    let frameworkBuildNumber: String
//    let frameworkVersion: String
//
//    enum CodingKeys: String, CodingKey {
//        case encodedIv = "a"
//        case encryptedDeviceId = "b"
//        case frameworkBuildNumber = "c"
//        case frameworkVersion = "d"
//    }
//}

internal actor DeviceFingerprint: Codable {
    let encodedIv: String
    let encryptedDeviceId: String
    let frameworkBuildNumber: String
    let frameworkVersion: String

    enum CodingKeys: String, CodingKey {
        case encodedIv = "a"
        case encryptedDeviceId = "b"
        case frameworkBuildNumber = "c"
        case frameworkVersion = "d"
    }

    init(encodedIv: String, encryptedDeviceId: String, frameworkBuildNumber: String, frameworkVersion: String) {
        self.encodedIv = encodedIv
        self.encryptedDeviceId = encryptedDeviceId
        self.frameworkBuildNumber = frameworkBuildNumber
        self.frameworkVersion = frameworkVersion
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(encodedIv, forKey: .encodedIv)
        try container.encode(encryptedDeviceId, forKey: .encryptedDeviceId)
        try container.encode(frameworkBuildNumber, forKey: .frameworkBuildNumber)
        try container.encode(frameworkVersion, forKey: .frameworkVersion)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let encodedIv = try container.decode(String.self, forKey: .encodedIv)
        let encryptedDeviceId = try container.decode(String.self, forKey: .encryptedDeviceId)
        let frameworkBuildNumber = try container.decode(String.self, forKey: .frameworkBuildNumber)
        let frameworkVersion = try container.decode(String.self, forKey: .frameworkVersion)
        self.init(encodedIv: encodedIv, encryptedDeviceId: encryptedDeviceId, frameworkBuildNumber: frameworkBuildNumber, frameworkVersion: frameworkVersion)
    }
}


