//
//  iOSDataRequest.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

//internal struct iOSDataRequest: Codable {
//    let iOSDeviceID: String
//    let applicationId: String
//    let advertisingID: String
//    let cloudId: String
//    let simulator: Bool
//    let jailBroken: Bool
//    let isVpn: Bool
//    let isGeoSpoofed: Bool
//    let isAppTampering: Bool
//    let hooking: Bool
//    let proxy: Bool
//    let mirroredScreen: Bool
//    let gpsLocation: GPSLocation
//    let cloned: Bool
//    
//    enum CodingKeys: String, CodingKey {
//        case iOSDeviceID = "a"
//        case applicationId = "b"
//        case advertisingID = "c"
//        case cloudId = "d"
//        case simulator = "e"
//        case jailBroken = "f"
//        case isVpn = "g"
//        case isGeoSpoofed = "h"
//        case isAppTampering = "i"
//        case hooking = "j"
//        case proxy = "k"
//        case mirroredScreen = "l"
//        case gpsLocation = "m"
//        case cloned = "n"
//    }
//}

internal actor iOSDataRequest: Codable {
    let iOSDeviceID: String
    let applicationId: String
    let advertisingID: String
    let cloudId: String
    let simulator: Bool
    let jailBroken: Bool
    let isVpn: Bool
    let isGeoSpoofed: Bool
    let isAppTampering: Bool
    let hooking: Bool
    let proxy: Bool
    let mirroredScreen: Bool
    let gpsLocation: GPSLocation
    let cloned: Bool
    let appInstalledPath: String
    
    enum CodingKeys: String, CodingKey {
        case iOSDeviceID = "a"
        case applicationId = "b"
        case advertisingID = "c"
        case cloudId = "d"
        case simulator = "e"
        case jailBroken = "f"
        case isVpn = "g"
        case isGeoSpoofed = "h"
        case isAppTampering = "i"
        case hooking = "j"
        case proxy = "k"
        case mirroredScreen = "l"
        case gpsLocation = "m"
        case cloned = "n"
        case appInstalledPath = "o"
    }

    init(
        iOSDeviceID: String,
        applicationId: String,
        advertisingID: String,
        cloudId: String,
        simulator: Bool,
        jailBroken: Bool,
        isVpn: Bool,
        isGeoSpoofed: Bool,
        isAppTampering: Bool,
        hooking: Bool,
        proxy: Bool,
        mirroredScreen: Bool,
        gpsLocation: GPSLocation,
        cloned: Bool,
        appInstalledPath: String
    ) {
        self.iOSDeviceID = iOSDeviceID
        self.applicationId = applicationId
        self.advertisingID = advertisingID
        self.cloudId = cloudId
        self.simulator = simulator
        self.jailBroken = jailBroken
        self.isVpn = isVpn
        self.isGeoSpoofed = isGeoSpoofed
        self.isAppTampering = isAppTampering
        self.hooking = hooking
        self.proxy = proxy
        self.mirroredScreen = mirroredScreen
        self.gpsLocation = gpsLocation
        self.cloned = cloned
        self.appInstalledPath = appInstalledPath
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(iOSDeviceID, forKey: .iOSDeviceID)
        try container.encode(applicationId, forKey: .applicationId)
        try container.encode(advertisingID, forKey: .advertisingID)
        try container.encode(cloudId, forKey: .cloudId)
        try container.encode(simulator, forKey: .simulator)
        try container.encode(jailBroken, forKey: .jailBroken)
        try container.encode(isVpn, forKey: .isVpn)
        try container.encode(isGeoSpoofed, forKey: .isGeoSpoofed)
        try container.encode(isAppTampering, forKey: .isAppTampering)
        try container.encode(hooking, forKey: .hooking)
        try container.encode(proxy, forKey: .proxy)
        try container.encode(mirroredScreen, forKey: .mirroredScreen)
        try container.encode(gpsLocation, forKey: .gpsLocation)
        try container.encode(cloned, forKey: .cloned)
        try container.encode(appInstalledPath, forKey: .appInstalledPath)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            iOSDeviceID: try container.decode(String.self, forKey: .iOSDeviceID),
            applicationId: try container.decode(String.self, forKey: .applicationId),
            advertisingID: try container.decode(String.self, forKey: .advertisingID),
            cloudId: try container.decode(String.self, forKey: .cloudId),
            simulator: try container.decode(Bool.self, forKey: .simulator),
            jailBroken: try container.decode(Bool.self, forKey: .jailBroken),
            isVpn: try container.decode(Bool.self, forKey: .isVpn),
            isGeoSpoofed: try container.decode(Bool.self, forKey: .isGeoSpoofed),
            isAppTampering: try container.decode(Bool.self, forKey: .isAppTampering),
            hooking: try container.decode(Bool.self, forKey: .hooking),
            proxy: try container.decode(Bool.self, forKey: .proxy),
            mirroredScreen: try container.decode(Bool.self, forKey: .mirroredScreen),
            gpsLocation: try container.decode(GPSLocation.self, forKey: .gpsLocation),
            cloned: try container.decode(Bool.self, forKey: .cloned),
            appInstalledPath: try container.decode(String.self, forKey: .appInstalledPath)
        )
    }
}
