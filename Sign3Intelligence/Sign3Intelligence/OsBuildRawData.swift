//
//  OsBuildRawData.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation


//internal struct OsBuildRawData: Codable {
//    let kernalVersion: String
//    let kernalOsVersion: String
//    let kernalOsRelease: String
//    let kernalOSType: String
//    let iOSVersion: String
//    let securityProvidersData: [String]
//    
//    enum CodingKeys: String, CodingKey {
//        case kernalVersion = "a"
//        case kernalOsVersion = "b"
//        case kernalOsRelease = "c"
//        case kernalOSType = "d"
//        case iOSVersion = "e"
//        case securityProvidersData = "f"
//    }
//}

internal actor OsBuildRawData: Codable {
    let kernalVersion: String
    let kernalOsVersion: String
    let kernalOsRelease: String
    let kernalOSType: String
    let iOSVersion: String
    let securityProvidersData: [String]

    enum CodingKeys: String, CodingKey {
        case kernalVersion = "a"
        case kernalOsVersion = "b"
        case kernalOsRelease = "c"
        case kernalOSType = "d"
        case iOSVersion = "e"
        case securityProvidersData = "f"
    }

    init(
        kernalVersion: String,
        kernalOsVersion: String,
        kernalOsRelease: String,
        kernalOSType: String,
        iOSVersion: String,
        securityProvidersData: [String]
    ) {
        self.kernalVersion = kernalVersion
        self.kernalOsVersion = kernalOsVersion
        self.kernalOsRelease = kernalOsRelease
        self.kernalOSType = kernalOSType
        self.iOSVersion = iOSVersion
        self.securityProvidersData = securityProvidersData
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kernalVersion, forKey: .kernalVersion)
        try container.encode(kernalOsVersion, forKey: .kernalOsVersion)
        try container.encode(kernalOsRelease, forKey: .kernalOsRelease)
        try container.encode(kernalOSType, forKey: .kernalOSType)
        try container.encode(iOSVersion, forKey: .iOSVersion)
        try container.encode(securityProvidersData, forKey: .securityProvidersData)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            kernalVersion: try container.decode(String.self, forKey: .kernalVersion),
            kernalOsVersion: try container.decode(String.self, forKey: .kernalOsVersion),
            kernalOsRelease: try container.decode(String.self, forKey: .kernalOsRelease),
            kernalOSType: try container.decode(String.self, forKey: .kernalOSType),
            iOSVersion: try container.decode(String.self, forKey: .iOSVersion),
            securityProvidersData: try container.decode([String].self, forKey: .securityProvidersData)
        )
    }
}

