//
//  ConfigManager.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

internal struct ConfigManager {
    static let shared = ConfigManager()
    
    private static var config: Config?
    
    static var isCronEnabled: Bool {
        guard let continuousIntegrationConfig = config?.continuousIntegrationConfig else { return false }
        return continuousIntegrationConfig.enabled && continuousIntegrationConfig.cronEnabled
    }
    
    static var isAppStateEnabled: Bool {
        guard let continuousIntegrationConfig = config?.continuousIntegrationConfig else { return false }
        return continuousIntegrationConfig.enabled && continuousIntegrationConfig.appResumeEnabled
    }
    
    static var callOnStart: Bool {
        guard let continuousIntegrationConfig = config?.continuousIntegrationConfig else { return false }
        return continuousIntegrationConfig.enabled && continuousIntegrationConfig.callOnStart
    }
    
    static var isContinuousIntegrationOn: Bool {
        return config?.continuousIntegrationConfig.enabled ?? false
    }
    
    static var knownDangerousAppsPackages: [String] {
        return config?.knownDangerousAppsPackages?.isEmpty == false ? config?.knownDangerousAppsPackages ?? [] : Config.getDefault().knownDangerousAppsPackages ?? []
    }
    
    static var knownRootCloakingPackages: [String] {
        return config?.knownRootCloakingPackages?.isEmpty == false ? config?.knownRootCloakingPackages ?? [] : Config.getDefault().knownRootCloakingPackages ?? []
    }
    
    static var remoteAppPackage: [String] {
        return config?.remoteAppPackage?.isEmpty == false ? config?.remoteAppPackage ?? [] : Config.getDefault().remoteAppPackage ?? []
    }
    
    static var mixPanelKey: String {
        return config?.mixPanelKey ?? Config.getDefault().mixPanelKey ?? Bundle.main.infoDictionary?["MixpanelKey"] as? String ?? ""
    }
    
    static var fetchSignals: Bool {
        return config?.fetchSignals ?? false
    }
    
    static var latLongThreshold: Float {
        return config?.latLongThreshold ?? Config.getDefault().latLongThreshold ?? 0.0
    }
    
    static var memoryThreshold: Int64 {
        return config?.memoryThreshold ?? Config.getDefault().memoryThreshold ?? 0
    }
    
    static var hasList: [String] {
        return config?.hashKeyList?.isEmpty == false ? config?.hashKeyList ?? [] : Config.getDefault().hashKeyList ?? []
    }
    
    static var isPushFunctionalMatricEnabled: Bool {
        return config?.isPushFunctionalMatricEnabled ?? false
    }
    
    static var isWorkManagerEnabled: Bool {
        guard let continuousIntegrationConfig = config?.continuousIntegrationConfig else { return false }
        return continuousIntegrationConfig.isWorkManagerEnabled && config?.isWorkManagerEnabled ?? false
    }
    
    static func initConfig() {
        Api.shared.getConfig { resource in
            switch resource.status {
            case .success:
                if let configResponse = resource.data {
                    self.config = configResponse
                    Log.i("TAG_Response: ", "\(String(describing: self.config))")
                }
            case .error:
                Log.i("TAG_Error: ", "\(resource.message ?? "Unknown error")")
                self.config = Config.getDefault()
            case .loading:
                Log.i("TAG_Config: ", "Loading Config")
            }
        }
    }
    
    static func getConfig() -> Config {
        return config ?? Config.getDefault()
    }
}
