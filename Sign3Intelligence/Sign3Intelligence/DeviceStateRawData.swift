//
//  DeviceStateRawData.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

internal struct DeviceStateRawData: Codable {
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
    let serialNumber: String
    
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
        case serialNumber = "aq"
    }
}
