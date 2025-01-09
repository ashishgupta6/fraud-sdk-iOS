//
//  SdkError.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 13/12/24.
//

import Foundation


internal struct SdkError: Codable {
    var eventName: String = "sdk_error-iOS"
    let name:String
    let exceptionMsg: String
    let requestId: String?
    var createdAtInMillis: CLong = CLong(Int64(Date().timeIntervalSince1970) * 1000)
    var clientId: String = Sign3IntelligenceInternal.sdk?.options?.clientId ?? "unknown"
    var sessionId: String = Sign3IntelligenceInternal.sdk?.appSessionId ?? "unknown"
    var frameworkVersionName: String = Bundle(for: Sign3SDK.self).infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    var frameworkVersionCode: String = Bundle(for: Sign3SDK.self).infoDictionary?["CFBundleVersion"] as? String ?? ""
    
    enum CodingKeys: String, CodingKey {
        case eventName = "eventName"
        case name = "name"
        case exceptionMsg = "exceptionMsg"
        case requestId = "requestId"
        case createdAtInMillis = "createdAtInMillis"
        case clientId = "clientId"
        case sessionId = "sessionId"
        case frameworkVersionName = "frameworkVersionName"
        case frameworkVersionCode = "frameworkVersionCode"
    }
}
