//
//  CommonHeadersInterceptor.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 13/11/24.
//

import Foundation

internal class HeaderProvider{
    private let clientId: String
    private let clientSecret: String
    
    init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    internal func getCommonHeaders() -> [String: String] {
        return [
            "Content-Type": "text/plain",
            "Authorization": "Basic \(getCredentials())",
            "app-client": "consumer-ios",
            "os-version": "\(UIDevice.current.systemVersion)",
            "app-identifier": Bundle.main.bundleIdentifier ?? "",
            "app-version-code": getAppBuildNumber(),
            "app-version-name": getiOSAppVersion(),
            "sdk-version-code": getFrameworkBuildNumber(),
            "sdk-version-name": getFrameworkVersion(),
            "client-ts-millis": "\(Date().timeIntervalSince1970 * 1000)",
        ]
    }
    
    private func getCredentials() -> String {
        let credentials = "\(clientId):\(clientSecret)"
        return Data(credentials.utf8).base64EncodedString()
    }
    
    
    private func getFrameworkVersion() -> String {
        return Utils.getDeviceSignalsWithoutAsync(
            functionName: "getFrameworkVersion",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let version = Bundle(for: Sign3SDK.self).infoDictionary?["CFBundleShortVersionString"] as? String
                return version ?? "Unknown"
            }
        )
    }
    
    
    private func getiOSAppVersion() -> String {
        return Utils.getDeviceSignalsWithoutAsync(
            functionName: "getiOSAppVersion",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    return version
                } else {
                    return "Unknown"
                }
            }
        )
    }
    
    private func getAppBuildNumber() -> String {
        return Utils.getDeviceSignalsWithoutAsync(
            functionName: "getAppBuildNumber",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                    return buildNumber
                } else {
                    return "Unknown"
                }
            }
        )
    }
    
    private func getFrameworkBuildNumber() -> String {
        return Utils.getDeviceSignalsWithoutAsync(
            functionName: "getFrameworkBuildNumber",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let version = Bundle(for: Sign3SDK.self).infoDictionary?["CFBundleVersion"] as? String
                return version ?? "Unknown"
            }
        )
    }
}
