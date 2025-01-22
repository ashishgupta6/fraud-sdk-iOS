//
//  SdkError.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 13/12/24.
//

import Foundation

//
//internal struct SdkError: Codable {
//    var eventName: String = "sdk_error-iOS"
//    let name:String
//    let exceptionMsg: String
//    let requestId: String?
//    var createdAtInMillis: CLong = CLong(Int64(Date().timeIntervalSince1970) * 1000)
//    var clientId: String = Sign3IntelligenceInternal.sdk?.options?.clientId ?? "unknown"
//    var sessionId: String = Sign3IntelligenceInternal.sdk?.appSessionId ?? "unknown"
//    var frameworkVersionName: String = Bundle(for: Sign3SDK.self).infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
//    var frameworkVersionCode: String = Bundle(for: Sign3SDK.self).infoDictionary?["CFBundleVersion"] as? String ?? ""
//    
//    enum CodingKeys: String, CodingKey {
//        case eventName = "eventName"
//        case name = "name"
//        case exceptionMsg = "exceptionMsg"
//        case requestId = "requestId"
//        case createdAtInMillis = "createdAtInMillis"
//        case clientId = "clientId"
//        case sessionId = "sessionId"
//        case frameworkVersionName = "frameworkVersionName"
//        case frameworkVersionCode = "frameworkVersionCode"
//    }
//}

internal actor SdkError: Codable {
    var eventName: String = "sdk_error-iOS"
    let name: String
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

    init(eventName: String = "sdk_error-iOS", name: String, exceptionMsg: String, requestId: String?, createdAtInMillis: CLong = CLong(Int64(Date().timeIntervalSince1970) * 1000), clientId: String = Sign3IntelligenceInternal.sdk?.options?.clientId ?? "unknown", sessionId: String = Sign3IntelligenceInternal.sdk?.appSessionId ?? "unknown", frameworkVersionName: String = Bundle(for: Sign3SDK.self).infoDictionary?["CFBundleShortVersionString"] as? String ?? "", frameworkVersionCode: String = Bundle(for: Sign3SDK.self).infoDictionary?["CFBundleVersion"] as? String ?? "") {
        self.eventName = eventName
        self.name = name
        self.exceptionMsg = exceptionMsg
        self.requestId = requestId
        self.createdAtInMillis = createdAtInMillis
        self.clientId = clientId
        self.sessionId = sessionId
        self.frameworkVersionName = frameworkVersionName
        self.frameworkVersionCode = frameworkVersionCode
    }

    nonisolated func encode(to encoder: Encoder) throws {
        Task {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try await container.encode(eventName, forKey: .eventName)
            try await container.encode(name, forKey: .name)
            try await container.encode(exceptionMsg, forKey: .exceptionMsg)
            try await container.encode(requestId, forKey: .requestId)
            try await container.encode(createdAtInMillis, forKey: .createdAtInMillis)
            try await container.encode(clientId, forKey: .clientId)
            try await container.encode(sessionId, forKey: .sessionId)
            try await container.encode(frameworkVersionName, forKey: .frameworkVersionName)
            try await container.encode(frameworkVersionCode, forKey: .frameworkVersionCode)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let eventName = try container.decode(String.self, forKey: .eventName)
        let name = try container.decode(String.self, forKey: .name)
        let exceptionMsg = try container.decode(String.self, forKey: .exceptionMsg)
        let requestId = try container.decode(String?.self, forKey: .requestId)
        let createdAtInMillis = try container.decode(CLong.self, forKey: .createdAtInMillis)
        let clientId = try container.decode(String.self, forKey: .clientId)
        let sessionId = try container.decode(String.self, forKey: .sessionId)
        let frameworkVersionName = try container.decode(String.self, forKey: .frameworkVersionName)
        let frameworkVersionCode = try container.decode(String.self, forKey: .frameworkVersionCode)
        self.init(eventName: eventName, name: name, exceptionMsg: exceptionMsg, requestId: requestId, createdAtInMillis: createdAtInMillis, clientId: clientId, sessionId: sessionId, frameworkVersionName: frameworkVersionName, frameworkVersionCode: frameworkVersionCode)
    }
}

