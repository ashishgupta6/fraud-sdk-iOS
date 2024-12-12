//
//  iOSDataRequest.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

internal struct iOSDataRequest: Codable {
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
    }
}
