//
//  HashData.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 12/12/24.
//

import Foundation

//internal struct HashData: Codable {
//    var isJailbroken: Bool?
//    var isHooking: Bool?
//    var isVpn: Bool?
//    var isProxy: Bool?
//    var isGeoSpoofed: Bool?
//    var isSimulator: Bool?
//    var isMirroredScreen: Bool?
//    var isAppTampering: Bool?
//    var totalMemory: CLong
//    var availableMemory: CLong
//    var latitude: Double?
//    var longitude: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case isJailbroken = "isJailbroken"
//        case isHooking = "isHooking"
//        case isVpn = "isVpn"
//        case isProxy = "isProxy"
//        case isGeoSpoofed = "isGeoSpoofed"
//        case isSimulator = "isSimulator"
//        case isMirroredScreen = "isMirroredScreen"
//        case isAppTampering = "isAppTampering"
//        case totalMemory = "totalMemory"
//        case availableMemory = "availableMemory"
//        case latitude = "latitude"
//        case longitude = "longitude"
//    }
//}

internal actor HashData: Codable {
    var isJailbroken: Bool?
    var isHooking: Bool?
    var isVpn: Bool?
    var isProxy: Bool?
    var isGeoSpoofed: Bool?
    var isSimulator: Bool?
    var isMirroredScreen: Bool?
    var isAppTampering: Bool?
    var totalMemory: CLong
    var availableMemory: CLong
    var latitude: Double?
    var longitude: Double?

    enum CodingKeys: String, CodingKey {
        case isJailbroken = "isJailbroken"
        case isHooking = "isHooking"
        case isVpn = "isVpn"
        case isProxy = "isProxy"
        case isGeoSpoofed = "isGeoSpoofed"
        case isSimulator = "isSimulator"
        case isMirroredScreen = "isMirroredScreen"
        case isAppTampering = "isAppTampering"
        case totalMemory = "totalMemory"
        case availableMemory = "availableMemory"
        case latitude = "latitude"
        case longitude = "longitude"
    }

    init(isJailbroken: Bool? = nil,
         isHooking: Bool? = nil,
         isVpn: Bool? = nil,
         isProxy: Bool? = nil,
         isGeoSpoofed: Bool? = nil,
         isSimulator: Bool? = nil,
         isMirroredScreen: Bool? = nil,
         isAppTampering: Bool? = nil,
         totalMemory: CLong,
         availableMemory: CLong,
         latitude: Double? = nil,
         longitude: Double? = nil) {
        self.isJailbroken = isJailbroken
        self.isHooking = isHooking
        self.isVpn = isVpn
        self.isProxy = isProxy
        self.isGeoSpoofed = isGeoSpoofed
        self.isSimulator = isSimulator
        self.isMirroredScreen = isMirroredScreen
        self.isAppTampering = isAppTampering
        self.totalMemory = totalMemory
        self.availableMemory = availableMemory
        self.latitude = latitude
        self.longitude = longitude
    }

    nonisolated func encode(to encoder: Encoder) throws {
        Task {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try await container.encode(isJailbroken, forKey: .isJailbroken)
            try await container.encode(isHooking, forKey: .isHooking)
            try await container.encode(isVpn, forKey: .isVpn)
            try await container.encode(isProxy, forKey: .isProxy)
            try await container.encode(isGeoSpoofed, forKey: .isGeoSpoofed)
            try await container.encode(isSimulator, forKey: .isSimulator)
            try await container.encode(isMirroredScreen, forKey: .isMirroredScreen)
            try await container.encode(isAppTampering, forKey: .isAppTampering)
            try await container.encode(totalMemory, forKey: .totalMemory)
            try await container.encode(availableMemory, forKey: .availableMemory)
            try await container.encode(latitude, forKey: .latitude)
            try await container.encode(longitude, forKey: .longitude)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let isJailbroken = try container.decode(Bool?.self, forKey: .isJailbroken)
        let isHooking = try container.decode(Bool?.self, forKey: .isHooking)
        let isVpn = try container.decode(Bool?.self, forKey: .isVpn)
        let isProxy = try container.decode(Bool?.self, forKey: .isProxy)
        let isGeoSpoofed = try container.decode(Bool?.self, forKey: .isGeoSpoofed)
        let isSimulator = try container.decode(Bool?.self, forKey: .isSimulator)
        let isMirroredScreen = try container.decode(Bool?.self, forKey: .isMirroredScreen)
        let isAppTampering = try container.decode(Bool?.self, forKey: .isAppTampering)
        let totalMemory = try container.decode(CLong.self, forKey: .totalMemory)
        let availableMemory = try container.decode(CLong.self, forKey: .availableMemory)
        let latitude = try container.decode(Double?.self, forKey: .latitude)
        let longitude = try container.decode(Double?.self, forKey: .longitude)
        self.init(isJailbroken: isJailbroken, isHooking: isHooking, isVpn: isVpn, isProxy: isProxy, isGeoSpoofed: isGeoSpoofed, isSimulator: isSimulator, isMirroredScreen: isMirroredScreen, isAppTampering: isAppTampering, totalMemory: totalMemory, availableMemory: availableMemory, latitude: latitude, longitude: longitude)
    }
}

