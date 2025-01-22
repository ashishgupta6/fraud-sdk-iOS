//
//  HardwareFingerprintRawData.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

//internal struct HardwareFingerprintRawData: Codable {
//    let batteryState: String
//    let batteryLevel: Float
//    let cpuCount: Int
//    let usedDiskSpace: CLong
//    let freeDiskSpace: CLong
//    let totalDiskSpace: CLong
//    let deviceModel: String
//    let deviceName: String
//    let wifiIPAddress: String
//    let macAddress: String
//    let iPhonebluetoothMacAddress: String
//    let iPadbluetoothMacAddress: String
//    let cameraList: [String]
//    let abiType: String
//    let glesVersion: String
//    let simInfo: [String : String] 
//    
//    enum CodingKeys: String, CodingKey {
//        case batteryState = "a"
//        case batteryLevel = "b"
//        case cpuCount = "c"
//        case usedDiskSpace = "d"
//        case freeDiskSpace = "e"
//        case totalDiskSpace = "f"
//        case deviceModel = "g"
//        case deviceName = "h"
//        case wifiIPAddress = "i"
//        case macAddress = "j"
//        case iPhonebluetoothMacAddress = "k"
//        case iPadbluetoothMacAddress = "l"
//        case cameraList = "m"
//        case abiType = "n"
//        case glesVersion = "o"
//        case simInfo = "p"
//    }
//    
//}

internal actor HardwareFingerprintRawData: Codable {
    let batteryState: String
    let batteryLevel: Float
    let cpuCount: Int
    let usedDiskSpace: CLong
    let freeDiskSpace: CLong
    let totalDiskSpace: CLong
    let deviceModel: String
    let deviceName: String
    let wifiIPAddress: String
    let macAddress: String
    let iPhonebluetoothMacAddress: String
    let iPadbluetoothMacAddress: String
    let cameraList: [String]
    let abiType: String
    let glesVersion: String
    let simInfo: [String: String]

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

    init(
        batteryState: String,
        batteryLevel: Float,
        cpuCount: Int,
        usedDiskSpace: CLong,
        freeDiskSpace: CLong,
        totalDiskSpace: CLong,
        deviceModel: String,
        deviceName: String,
        wifiIPAddress: String,
        macAddress: String,
        iPhonebluetoothMacAddress: String,
        iPadbluetoothMacAddress: String,
        cameraList: [String],
        abiType: String,
        glesVersion: String,
        simInfo: [String: String]
    ) {
        self.batteryState = batteryState
        self.batteryLevel = batteryLevel
        self.cpuCount = cpuCount
        self.usedDiskSpace = usedDiskSpace
        self.freeDiskSpace = freeDiskSpace
        self.totalDiskSpace = totalDiskSpace
        self.deviceModel = deviceModel
        self.deviceName = deviceName
        self.wifiIPAddress = wifiIPAddress
        self.macAddress = macAddress
        self.iPhonebluetoothMacAddress = iPhonebluetoothMacAddress
        self.iPadbluetoothMacAddress = iPadbluetoothMacAddress
        self.cameraList = cameraList
        self.abiType = abiType
        self.glesVersion = glesVersion
        self.simInfo = simInfo
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(batteryState, forKey: .batteryState)
        try container.encode(batteryLevel, forKey: .batteryLevel)
        try container.encode(cpuCount, forKey: .cpuCount)
        try container.encode(usedDiskSpace, forKey: .usedDiskSpace)
        try container.encode(freeDiskSpace, forKey: .freeDiskSpace)
        try container.encode(totalDiskSpace, forKey: .totalDiskSpace)
        try container.encode(deviceModel, forKey: .deviceModel)
        try container.encode(deviceName, forKey: .deviceName)
        try container.encode(wifiIPAddress, forKey: .wifiIPAddress)
        try container.encode(macAddress, forKey: .macAddress)
        try container.encode(iPhonebluetoothMacAddress, forKey: .iPhonebluetoothMacAddress)
        try container.encode(iPadbluetoothMacAddress, forKey: .iPadbluetoothMacAddress)
        try container.encode(cameraList, forKey: .cameraList)
        try container.encode(abiType, forKey: .abiType)
        try container.encode(glesVersion, forKey: .glesVersion)
        try container.encode(simInfo, forKey: .simInfo)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            batteryState: try container.decode(String.self, forKey: .batteryState),
            batteryLevel: try container.decode(Float.self, forKey: .batteryLevel),
            cpuCount: try container.decode(Int.self, forKey: .cpuCount),
            usedDiskSpace: try container.decode(CLong.self, forKey: .usedDiskSpace),
            freeDiskSpace: try container.decode(CLong.self, forKey: .freeDiskSpace),
            totalDiskSpace: try container.decode(CLong.self, forKey: .totalDiskSpace),
            deviceModel: try container.decode(String.self, forKey: .deviceModel),
            deviceName: try container.decode(String.self, forKey: .deviceName),
            wifiIPAddress: try container.decode(String.self, forKey: .wifiIPAddress),
            macAddress: try container.decode(String.self, forKey: .macAddress),
            iPhonebluetoothMacAddress: try container.decode(String.self, forKey: .iPhonebluetoothMacAddress),
            iPadbluetoothMacAddress: try container.decode(String.self, forKey: .iPadbluetoothMacAddress),
            cameraList: try container.decode([String].self, forKey: .cameraList),
            abiType: try container.decode(String.self, forKey: .abiType),
            glesVersion: try container.decode(String.self, forKey: .glesVersion),
            simInfo: try container.decode([String: String].self, forKey: .simInfo)
        )
    }
}

