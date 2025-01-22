//
//  InstalledAppsRawData.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

//internal struct InstalledAppsRawData: Codable {
//    let applicationName: String
//    let appInstallTime: CLong
//    let AppUpdateTime: CLong
//    let appState: String
//    let frameworkVersion: String
//    let frameworkBuildNumber: String
//    let appVersion: String
//    let appBuildNumber: String
//    
//    enum CodingKeys: String, CodingKey {
//        case applicationName = "a"
//        case appInstallTime = "b"
//        case AppUpdateTime = "c"
//        case appState = "d"
//        case frameworkVersion = "e"
//        case frameworkBuildNumber = "f"
//        case appVersion = "g"
//        case appBuildNumber = "h"
//    }
//}

internal actor InstalledAppsRawData: Codable {
    let applicationName: String
    let appInstallTime: CLong
    let appUpdateTime: CLong
    let appState: String
    let frameworkVersion: String
    let frameworkBuildNumber: String
    let appVersion: String
    let appBuildNumber: String

    enum CodingKeys: String, CodingKey {
        case applicationName = "a"
        case appInstallTime = "b"
        case appUpdateTime = "c"
        case appState = "d"
        case frameworkVersion = "e"
        case frameworkBuildNumber = "f"
        case appVersion = "g"
        case appBuildNumber = "h"
    }

    init(
        applicationName: String,
        appInstallTime: CLong,
        appUpdateTime: CLong,
        appState: String,
        frameworkVersion: String,
        frameworkBuildNumber: String,
        appVersion: String,
        appBuildNumber: String
    ) {
        self.applicationName = applicationName
        self.appInstallTime = appInstallTime
        self.appUpdateTime = appUpdateTime
        self.appState = appState
        self.frameworkVersion = frameworkVersion
        self.frameworkBuildNumber = frameworkBuildNumber
        self.appVersion = appVersion
        self.appBuildNumber = appBuildNumber
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(applicationName, forKey: .applicationName)
        try container.encode(appInstallTime, forKey: .appInstallTime)
        try container.encode(appUpdateTime, forKey: .appUpdateTime)
        try container.encode(appState, forKey: .appState)
        try container.encode(frameworkVersion, forKey: .frameworkVersion)
        try container.encode(frameworkBuildNumber, forKey: .frameworkBuildNumber)
        try container.encode(appVersion, forKey: .appVersion)
        try container.encode(appBuildNumber, forKey: .appBuildNumber)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            applicationName: try container.decode(String.self, forKey: .applicationName),
            appInstallTime: try container.decode(CLong.self, forKey: .appInstallTime),
            appUpdateTime: try container.decode(CLong.self, forKey: .appUpdateTime),
            appState: try container.decode(String.self, forKey: .appState),
            frameworkVersion: try container.decode(String.self, forKey: .frameworkVersion),
            frameworkBuildNumber: try container.decode(String.self, forKey: .frameworkBuildNumber),
            appVersion: try container.decode(String.self, forKey: .appVersion),
            appBuildNumber: try container.decode(String.self, forKey: .appBuildNumber)
        )
    }
}
