//
//  DeviceFingerprint.swift
//  Sign3Intelligence
//
//  Created by Sreyans Bohara on 13/01/25.
//

internal struct DeviceFingerprint: Codable {
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
}
