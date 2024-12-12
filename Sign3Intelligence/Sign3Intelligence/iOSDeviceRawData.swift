//
//  iOSDeviceRawData.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

internal struct iOSDeviceRawData: Codable {
    let iOSDeviceIDs: iOSDeviceIDs?
    let deviceStateRawData: DeviceStateRawData?
    let hardwareFingerprintRawData: HardwareFingerprintRawData
    let installedAppsRawData: InstalledAppsRawData
    let osBuildRawData: OsBuildRawData
    
    enum CodingKeys: String, CodingKey {
        case iOSDeviceIDs = "a"
        case deviceStateRawData = "b"
        case hardwareFingerprintRawData = "c"
        case installedAppsRawData = "d"
        case osBuildRawData = "e"
    }
    
}
