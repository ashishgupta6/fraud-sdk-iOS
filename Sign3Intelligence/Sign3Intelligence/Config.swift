//
//  Config.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

internal struct Config: Codable {
    let continuousIntegrationConfig: ContinuousIntegrationConfig
    let knownDangerousAppsPackages: [String]?
    let knownRootCloakingPackages: [String]?
    let remoteAppPackage: [String]?
    let hashKeyList: [String]?
    let mixPanelKey: String?
    let fetchSignals: Bool?
    let latLongThreshold: Float?
    let memoryThreshold: Int64?
    let isPushFunctionalMatricEnabled: Bool
    let isWorkManagerEnabled: Bool

    // Coding keys for JSON mapping
    enum CodingKeys: String, CodingKey {
        case continuousIntegrationConfig
        case knownDangerousAppsPackages = "knownDangerousAppsPackages"
        case knownRootCloakingPackages = "knownRootCloakingPackages"
        case remoteAppPackage = "remoteAppPackage"
        case hashKeyList = "hashKeyList"
        case mixPanelKey = "mixPanelKey"
        case fetchSignals = "fetchSignals"
        case latLongThreshold = "latLongThreshold"
        case memoryThreshold = "memoryThreshold"
        case isPushFunctionalMatricEnabled = "isPushFunctionalMatricEnabled"
        case isWorkManagerEnabled = "isWorkManagerEnabled"
    }

    static func getDefault() -> Config {
        return Config(
            continuousIntegrationConfig: ContinuousIntegrationConfig(),
            knownDangerousAppsPackages: [],
            knownRootCloakingPackages: [],
            remoteAppPackage: [],
            hashKeyList: [
                "isRooted", "isHooking", "isVpn", "isProxy", "isGeoSpoofed", "isEmulator",
                "androidId", "isAppTampering", "isCloned", "isMirroredScreen", "latitude",
                "longitude", "availableMemory", "simInfoList"
            ],
            mixPanelKey: Bundle.main.object(forInfoDictionaryKey: "MIXPANEL_KEY") as? String,
            fetchSignals: true,
            latLongThreshold: 1000.0, // 1 KM
            memoryThreshold: 3221225472, // 3 GB
            isPushFunctionalMatricEnabled: false,
            isWorkManagerEnabled: false
        )
    }
}

struct ContinuousIntegrationConfig: Codable {
    let enabled: Bool
    let cronEnabled: Bool
    let cronIntervalInSecs: Int
    let appResumeEnabled: Bool
    let callOnStart: Bool
    let isBroadcastEnabled: Bool
    let isWorkManagerEnabled: Bool

    // Coding keys for JSON mapping
    enum CodingKeys: String, CodingKey {
        case enabled
        case cronEnabled = "cronEnabled"
        case cronIntervalInSecs = "cronIntervalInSecs"
        case appResumeEnabled = "appResumeEnabled"
        case callOnStart = "callOnStart"
        case isBroadcastEnabled = "isBroadcastEnabled"
        case isWorkManagerEnabled = "isWorkManagerEnabled"
    }

    init(
        enabled: Bool = true,
        cronEnabled: Bool = true,
        cronIntervalInSecs: Int = 1800, // 30 Min
        appResumeEnabled: Bool = true,
        callOnStart: Bool = true,
        isBroadcastEnabled: Bool = true,
        isWorkManagerEnabled: Bool = false
    ) {
        self.enabled = enabled
        self.cronEnabled = cronEnabled
        self.cronIntervalInSecs = cronIntervalInSecs
        self.appResumeEnabled = appResumeEnabled
        self.callOnStart = callOnStart
        self.isBroadcastEnabled = isBroadcastEnabled
        self.isWorkManagerEnabled = isWorkManagerEnabled
    }
}
