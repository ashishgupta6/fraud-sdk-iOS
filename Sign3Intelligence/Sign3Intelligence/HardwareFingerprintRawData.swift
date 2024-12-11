//
//  HardwareFingerprintRawData.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

internal struct HardwareFingerprintRawData: Codable {
    let batteryState: String
    let batteryLevel: Float
    let cpuCount: Int
    let usedDiskSpace: String
    let freeDiskSpace: String
    let totalDiskSpace: String
    let deviceModel: String
    let deviceName: String
    let wifiIPAddress: String
    let macAddress: String
    let iPhonebluetoothMacAddress: String
    let iPadbluetoothMacAddress: String
    let cameraList: [String]
    let abiType: String
    let glesVersion: String
    let simInfo: [String : String] 
    
    enum CodingKeys: String, CodingKey {
        case batteryState = "a"
        case batteryLevel = "b"
        case cpuCount = "c"
        case usedDiskSpace = "d"
        case freeDiskSpace = "e"
        case totalDiskSpace = "f"
        case deviceModel = "g"
        case deviceName = "h"
        case wifiIPAddress = "i"
        case macAddress = "j"
        case iPhonebluetoothMacAddress = "k"
        case iPadbluetoothMacAddress = "l"
        case cameraList = "m"
        case abiType = "n"
        case glesVersion = "o"
        case simInfo = "p"
    }
    
}
