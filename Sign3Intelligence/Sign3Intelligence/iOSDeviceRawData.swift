//
//  iOSDeviceRawData.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation
//
//internal struct iOSDeviceRawData: Codable {
//    let iOSDeviceIDs: iOSDeviceIDs?
//    let deviceStateRawData: DeviceStateRawData?
//    let hardwareFingerprintRawData: HardwareFingerprintRawData
//    let installedAppsRawData: InstalledAppsRawData
//    let osBuildRawData: OsBuildRawData
//    
//    enum CodingKeys: String, CodingKey {
//        case iOSDeviceIDs = "a"
//        case deviceStateRawData = "b"
//        case hardwareFingerprintRawData = "c"
//        case installedAppsRawData = "d"
//        case osBuildRawData = "e"
//    }
//    
//}

internal actor iOSDeviceRawData: Codable {
    let iOSDeviceIdentifiers: iOSDeviceIDs?
    let deviceStateRawData: DeviceStateRawData?
    let hardwareFingerprintRawData: HardwareFingerprintRawData
    let installedAppsRawData: InstalledAppsRawData
    let osBuildRawData: OsBuildRawData

    enum CodingKeys: String, CodingKey {
        case iOSDeviceIdentifiers = "a"
        case deviceStateRawData = "b"
        case hardwareFingerprintRawData = "c"
        case installedAppsRawData = "d"
        case osBuildRawData = "e"
    }

    init(
        iOSDeviceIdentifiers: iOSDeviceIDs?,
        deviceStateRawData: DeviceStateRawData?,
        hardwareFingerprintRawData: HardwareFingerprintRawData,
        installedAppsRawData: InstalledAppsRawData,
        osBuildRawData: OsBuildRawData
    ) {
        self.iOSDeviceIdentifiers = iOSDeviceIdentifiers
        self.deviceStateRawData = deviceStateRawData
        self.hardwareFingerprintRawData = hardwareFingerprintRawData
        self.installedAppsRawData = installedAppsRawData
        self.osBuildRawData = osBuildRawData
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(iOSDeviceIdentifiers, forKey: .iOSDeviceIdentifiers)
        try container.encodeIfPresent(deviceStateRawData, forKey: .deviceStateRawData)
        try container.encode(hardwareFingerprintRawData, forKey: .hardwareFingerprintRawData)
        try container.encode(installedAppsRawData, forKey: .installedAppsRawData)
        try container.encode(osBuildRawData, forKey: .osBuildRawData)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            iOSDeviceIdentifiers: try container.decodeIfPresent(iOSDeviceIDs.self, forKey: .iOSDeviceIdentifiers),
            deviceStateRawData: try container.decodeIfPresent(DeviceStateRawData.self, forKey: .deviceStateRawData),
            hardwareFingerprintRawData: try container.decode(HardwareFingerprintRawData.self, forKey: .hardwareFingerprintRawData),
            installedAppsRawData: try container.decode(InstalledAppsRawData.self, forKey: .installedAppsRawData),
            osBuildRawData: try container.decode(OsBuildRawData.self, forKey: .osBuildRawData)
        )
    }
    
}
