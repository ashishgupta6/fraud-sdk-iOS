//
//  InstalledAppsRawData.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

internal struct InstalledAppsRawData: Codable {
    let applicationName: String
    let appInstallTime: CLong
    let AppUpdateTime: CLong
    let appState: String
    let frameworkVersion: String
    let frameworkBuildNumber: String
    let appVersion: String
    let appBuildNumber: String
    
    enum CodingKeys: String, CodingKey {
        case applicationName = "a"
        case appInstallTime = "b"
        case AppUpdateTime = "c"
        case appState = "d"
        case frameworkVersion = "e"
        case frameworkBuildNumber = "f"
        case appVersion = "g"
        case appBuildNumber = "h"
    }
}
