//
//  DeviceStateRawData.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

//internal struct DeviceStateRawData: Codable {
//    let displayWidth: Float
//    let displayHeight: Float
//    let displayScale: Float
//    let timeZone: String
//    let currentTime: CLong
//    let currentLocal: String
//    let preferredLanguage: String
//    let sandboxPath: String
//    let mcc: String
//    let ncc: String
//    let hostName: String
//    let isiOSAppOnMac: Bool
//    let orientation: String
//    let carrierName: String
//    let networkType: String
//    let systemUptime: CLong
//    let ramUsage: String
//    let totalRamSize: String
//    let telephonySupport: Bool
//    let ringtoneSource: String
//    let availableLocals: [String]
//    let fingerprintSensorStatus: [String]
//    let developerOptionEnabled: Bool
//    let httpProxy: String
//    let accessibilitySettings: [String]
//    let touchExplorationEnabled: Bool
//    let alarmAlertPath: String
//    let time12Or24: String
//    let fontScale: Float
//    let textAutoReplace: Bool
//    let textAutoPunctuate: Bool
//    let bootTime: CLong
//    let currentBrightness: Float
//    let defaultBrowser: String
//    let audioVolumeCurrent: Float
//    let carrierCountry: String
//    let debuggerEnabled: Bool
//    let checkBuildConfiguration: String
//    let cpuType: String
//    let proximitySensor: Bool
//    let localizedModel: String
//    let systemName: String
//    let lockdownMode: Bool
//    let wifiSSID: String
//    let deviceReference: DeviceFingerprint?
//    
//    enum CodingKeys: String, CodingKey {
//        case displayWidth = "a"
//        case displayHeight = "b"
//        case displayScale = "c"
//        case timeZone = "d"
//        case currentTime = "e"
//        case currentLocal = "f"
//        case preferredLanguage = "g"
//        case sandboxPath = "h"
//        case mcc = "i"
//        case ncc = "j"
//        case hostName = "k"
//        case isiOSAppOnMac = "l"
//        case orientation = "m"
//        case carrierName = "n"
//        case networkType = "o"
//        case systemUptime = "p"
//        case ramUsage = "q"
//        case totalRamSize = "r"
//        case telephonySupport = "s"
//        case ringtoneSource = "t"
//        case availableLocals = "u"
//        case fingerprintSensorStatus = "v"
//        case developerOptionEnabled = "w"
//        case httpProxy = "x"
//        case accessibilitySettings = "y"
//        case touchExplorationEnabled = "z"
//        case alarmAlertPath = "aa"
//        case time12Or24 = "ab"
//        case fontScale = "ac"
//        case textAutoReplace = "ad"
//        case textAutoPunctuate = "ae"
//        case bootTime = "af"
//        case currentBrightness = "ag"
//        case defaultBrowser = "ah"
//        case audioVolumeCurrent = "ai"
//        case carrierCountry = "aj"
//        case debuggerEnabled = "ak"
//        case checkBuildConfiguration = "al"
//        case cpuType = "am"
//        case proximitySensor = "an"
//        case localizedModel = "ao"
//        case systemName = "ap"
//        case lockdownMode = "aq"
//        case wifiSSID = "ar"
//        case deviceReference = "as"
//    }
//}

internal actor DeviceStateRawData: Codable {
    let displayWidth: Float
    let displayHeight: Float
    let displayScale: Float
    let timeZone: String
    let currentTime: CLong
    let currentLocal: String
    let preferredLanguage: String
    let sandboxPath: String
    let mcc: String
    let ncc: String
    let hostName: String
    let isiOSAppOnMac: Bool
    let orientation: String
    let carrierName: String
    let networkType: String
    let systemUptime: CLong
    let ramUsage: String
    let totalRamSize: String
    let telephonySupport: Bool
    let ringtoneSource: String
    let availableLocals: [String]
    let fingerprintSensorStatus: [String]
    let developerOptionEnabled: Bool
    let httpProxy: String
    let accessibilitySettings: [String]
    let touchExplorationEnabled: Bool
    let alarmAlertPath: String
    let time12Or24: String
    let fontScale: Float
    let textAutoReplace: Bool
    let textAutoPunctuate: Bool
    let bootTime: CLong
    let currentBrightness: Float
    let defaultBrowser: String
    let audioVolumeCurrent: Float
    let carrierCountry: String
    let debuggerEnabled: Bool
    let checkBuildConfiguration: String
    let cpuType: String
    let proximitySensor: Bool
    let localizedModel: String
    let systemName: String
    let lockdownMode: Bool
    let wifiSSID: String
    let deviceReference: DeviceFingerprint?

    enum CodingKeys: String, CodingKey {
        case displayWidth = "a"
        case displayHeight = "b"
        case displayScale = "c"
        case timeZone = "d"
        case currentTime = "e"
        case currentLocal = "f"
        case preferredLanguage = "g"
        case sandboxPath = "h"
        case mcc = "i"
        case ncc = "j"
        case hostName = "k"
        case isiOSAppOnMac = "l"
        case orientation = "m"
        case carrierName = "n"
        case networkType = "o"
        case systemUptime = "p"
        case ramUsage = "q"
        case totalRamSize = "r"
        case telephonySupport = "s"
        case ringtoneSource = "t"
        case availableLocals = "u"
        case fingerprintSensorStatus = "v"
        case developerOptionEnabled = "w"
        case httpProxy = "x"
        case accessibilitySettings = "y"
        case touchExplorationEnabled = "z"
        case alarmAlertPath = "aa"
        case time12Or24 = "ab"
        case fontScale = "ac"
        case textAutoReplace = "ad"
        case textAutoPunctuate = "ae"
        case bootTime = "af"
        case currentBrightness = "ag"
        case defaultBrowser = "ah"
        case audioVolumeCurrent = "ai"
        case carrierCountry = "aj"
        case debuggerEnabled = "ak"
        case checkBuildConfiguration = "al"
        case cpuType = "am"
        case proximitySensor = "an"
        case localizedModel = "ao"
        case systemName = "ap"
        case lockdownMode = "aq"
        case wifiSSID = "ar"
        case deviceReference = "as"
    }

    init(
        displayWidth: Float,
        displayHeight: Float,
        displayScale: Float,
        timeZone: String,
        currentTime: CLong,
        currentLocal: String,
        preferredLanguage: String,
        sandboxPath: String,
        mcc: String,
        ncc: String,
        hostName: String,
        isiOSAppOnMac: Bool,
        orientation: String,
        carrierName: String,
        networkType: String,
        systemUptime: CLong,
        ramUsage: String,
        totalRamSize: String,
        telephonySupport: Bool,
        ringtoneSource: String,
        availableLocals: [String],
        fingerprintSensorStatus: [String],
        developerOptionEnabled: Bool,
        httpProxy: String,
        accessibilitySettings: [String],
        touchExplorationEnabled: Bool,
        alarmAlertPath: String,
        time12Or24: String,
        fontScale: Float,
        textAutoReplace: Bool,
        textAutoPunctuate: Bool,
        bootTime: CLong,
        currentBrightness: Float,
        defaultBrowser: String,
        audioVolumeCurrent: Float,
        carrierCountry: String,
        debuggerEnabled: Bool,
        checkBuildConfiguration: String,
        cpuType: String,
        proximitySensor: Bool,
        localizedModel: String,
        systemName: String,
        lockdownMode: Bool,
        wifiSSID: String,
        deviceReference: DeviceFingerprint?
    ) {
        self.displayWidth = displayWidth
        self.displayHeight = displayHeight
        self.displayScale = displayScale
        self.timeZone = timeZone
        self.currentTime = currentTime
        self.currentLocal = currentLocal
        self.preferredLanguage = preferredLanguage
        self.sandboxPath = sandboxPath
        self.mcc = mcc
        self.ncc = ncc
        self.hostName = hostName
        self.isiOSAppOnMac = isiOSAppOnMac
        self.orientation = orientation
        self.carrierName = carrierName
        self.networkType = networkType
        self.systemUptime = systemUptime
        self.ramUsage = ramUsage
        self.totalRamSize = totalRamSize
        self.telephonySupport = telephonySupport
        self.ringtoneSource = ringtoneSource
        self.availableLocals = availableLocals
        self.fingerprintSensorStatus = fingerprintSensorStatus
        self.developerOptionEnabled = developerOptionEnabled
        self.httpProxy = httpProxy
        self.accessibilitySettings = accessibilitySettings
        self.touchExplorationEnabled = touchExplorationEnabled
        self.alarmAlertPath = alarmAlertPath
        self.time12Or24 = time12Or24
        self.fontScale = fontScale
        self.textAutoReplace = textAutoReplace
        self.textAutoPunctuate = textAutoPunctuate
        self.bootTime = bootTime
        self.currentBrightness = currentBrightness
        self.defaultBrowser = defaultBrowser
        self.audioVolumeCurrent = audioVolumeCurrent
        self.carrierCountry = carrierCountry
        self.debuggerEnabled = debuggerEnabled
        self.checkBuildConfiguration = checkBuildConfiguration
        self.cpuType = cpuType
        self.proximitySensor = proximitySensor
        self.localizedModel = localizedModel
        self.systemName = systemName
        self.lockdownMode = lockdownMode
        self.wifiSSID = wifiSSID
        self.deviceReference = deviceReference
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(displayWidth, forKey: .displayWidth)
        try container.encode(displayHeight, forKey: .displayHeight)
        try container.encode(displayScale, forKey: .displayScale)
        try container.encode(timeZone, forKey: .timeZone)
        try container.encode(currentTime, forKey: .currentTime)
        try container.encode(currentLocal, forKey: .currentLocal)
        try container.encode(preferredLanguage, forKey: .preferredLanguage)
        try container.encode(sandboxPath, forKey: .sandboxPath)
        try container.encode(mcc, forKey: .mcc)
        try container.encode(ncc, forKey: .ncc)
        try container.encode(hostName, forKey: .hostName)
        try container.encode(isiOSAppOnMac, forKey: .isiOSAppOnMac)
        try container.encode(orientation, forKey: .orientation)
        try container.encode(carrierName, forKey: .carrierName)
        try container.encode(networkType, forKey: .networkType)
        try container.encode(systemUptime, forKey: .systemUptime)
        try container.encode(ramUsage, forKey: .ramUsage)
        try container.encode(totalRamSize, forKey: .totalRamSize)
        try container.encode(telephonySupport, forKey: .telephonySupport)
        try container.encode(ringtoneSource, forKey: .ringtoneSource)
        try container.encode(availableLocals, forKey: .availableLocals)
        try container.encode(fingerprintSensorStatus, forKey: .fingerprintSensorStatus)
        try container.encode(developerOptionEnabled, forKey: .developerOptionEnabled)
        try container.encode(httpProxy, forKey: .httpProxy)
        try container.encode(accessibilitySettings, forKey: .accessibilitySettings)
        try container.encode(touchExplorationEnabled, forKey: .touchExplorationEnabled)
        try container.encode(alarmAlertPath, forKey: .alarmAlertPath)
        try container.encode(time12Or24, forKey: .time12Or24)
        try container.encode(fontScale, forKey: .fontScale)
        try container.encode(textAutoReplace, forKey: .textAutoReplace)
        try container.encode(textAutoPunctuate, forKey: .textAutoPunctuate)
        try container.encode(bootTime, forKey: .bootTime)
        try container.encode(currentBrightness, forKey: .currentBrightness)
        try container.encode(defaultBrowser, forKey: .defaultBrowser)
        try container.encode(audioVolumeCurrent, forKey: .audioVolumeCurrent)
        try container.encode(carrierCountry, forKey: .carrierCountry)
        try container.encode(debuggerEnabled, forKey: .debuggerEnabled)
        try container.encode(checkBuildConfiguration, forKey: .checkBuildConfiguration)
        try container.encode(cpuType, forKey: .cpuType)
        try container.encode(proximitySensor, forKey: .proximitySensor)
        try container.encode(localizedModel, forKey: .localizedModel)
        try container.encode(systemName, forKey: .systemName)
        try container.encode(lockdownMode, forKey: .lockdownMode)
        try container.encode(wifiSSID, forKey: .wifiSSID)
        try container.encode(deviceReference, forKey: .deviceReference)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.displayWidth = try container.decode(Float.self, forKey: .displayWidth)
        self.displayHeight = try container.decode(Float.self, forKey: .displayHeight)
        self.displayScale = try container.decode(Float.self, forKey: .displayScale)
        self.timeZone = try container.decode(String.self, forKey: .timeZone)
        self.currentTime = try container.decode(CLong.self, forKey: .currentTime)
        self.currentLocal = try container.decode(String.self, forKey: .currentLocal)
        self.preferredLanguage = try container.decode(String.self, forKey: .preferredLanguage)
        self.sandboxPath = try container.decode(String.self, forKey: .sandboxPath)
        self.mcc = try container.decode(String.self, forKey: .mcc)
        self.ncc = try container.decode(String.self, forKey: .ncc)
        self.hostName = try container.decode(String.self, forKey: .hostName)
        self.isiOSAppOnMac = try container.decode(Bool.self, forKey: .isiOSAppOnMac)
        self.orientation = try container.decode(String.self, forKey: .orientation)
        self.carrierName = try container.decode(String.self, forKey: .carrierName)
        self.networkType = try container.decode(String.self, forKey: .networkType)
        self.systemUptime = try container.decode(CLong.self, forKey: .systemUptime)
        self.ramUsage = try container.decode(String.self, forKey: .ramUsage)
        self.totalRamSize = try container.decode(String.self, forKey: .totalRamSize)
        self.telephonySupport = try container.decode(Bool.self, forKey: .telephonySupport)
        self.ringtoneSource = try container.decode(String.self, forKey: .ringtoneSource)
        self.availableLocals = try container.decode([String].self, forKey: .availableLocals)
        self.fingerprintSensorStatus = try container.decode([String].self, forKey: .fingerprintSensorStatus)
        self.developerOptionEnabled = try container.decode(Bool.self, forKey: .developerOptionEnabled)
        self.httpProxy = try container.decode(String.self, forKey: .httpProxy)
        self.accessibilitySettings = try container.decode([String].self, forKey: .accessibilitySettings)
        self.touchExplorationEnabled = try container.decode(Bool.self, forKey: .touchExplorationEnabled)
        self.alarmAlertPath = try container.decode(String.self, forKey: .alarmAlertPath)
        self.time12Or24 = try container.decode(String.self, forKey: .time12Or24)
        self.fontScale = try container.decode(Float.self, forKey: .fontScale)
        self.textAutoReplace = try container.decode(Bool.self, forKey: .textAutoReplace)
        self.textAutoPunctuate = try container.decode(Bool.self, forKey: .textAutoPunctuate)
        self.bootTime = try container.decode(CLong.self, forKey: .bootTime)
        self.currentBrightness = try container.decode(Float.self, forKey: .currentBrightness)
        self.defaultBrowser = try container.decode(String.self, forKey: .defaultBrowser)
        self.audioVolumeCurrent = try container.decode(Float.self, forKey: .audioVolumeCurrent)
        self.carrierCountry = try container.decode(String.self, forKey: .carrierCountry)
        self.debuggerEnabled = try container.decode(Bool.self, forKey: .debuggerEnabled)
        self.checkBuildConfiguration = try container.decode(String.self, forKey: .checkBuildConfiguration)
        self.cpuType = try container.decode(String.self, forKey: .cpuType)
        self.proximitySensor = try container.decode(Bool.self, forKey: .proximitySensor)
        self.localizedModel = try container.decode(String.self, forKey: .localizedModel)
        self.systemName = try container.decode(String.self, forKey: .systemName)
        self.lockdownMode = try container.decode(Bool.self, forKey: .lockdownMode)
        self.wifiSSID = try container.decode(String.self, forKey: .wifiSSID)
        self.deviceReference = try container.decodeIfPresent(DeviceFingerprint.self, forKey: .deviceReference)
    }
}
