//
//  HashData.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 12/12/24.
//

import Foundation

internal struct HashData: Codable {
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
}
