//
//  ClientParams.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

//internal struct ClientParams: Codable {
//    let phoneNumber: String?
//    let userId: String?
//    let phoneInputType: String?
//    let otpInputType: String?
//    let userEventType: String?
//    let sessionId: String?
//    let merchantId: String?
//    let additionalParams: [String: String]?
//    
//    enum CodingKeys: String, CodingKey {
//        case phoneNumber = "a"
//        case userId = "b"
//        case phoneInputType = "c"
//        case otpInputType = "d"
//        case userEventType = "e"
//        case sessionId = "f"
//        case merchantId = "g"
//        case additionalParams = "h"
//    }
// 
//    static func fromOptions(_ options: Options) -> ClientParams {
//        return ClientParams(
//            phoneNumber: options.phoneNumber,
//            userId: options.userId,
//            phoneInputType: options.phoneInputType?.rawValue,
//            otpInputType: options.otpInputType?.rawValue,
//            userEventType: options.userEventType?.rawValue,
//            sessionId: options.sessionId,
//            merchantId: options.merchantId,
//            additionalParams: options.additionalAttributes
//        )
//    }
//
//    static func fromOptionsInit(_ options: Options) -> ClientParams {
//        return ClientParams(
//            phoneNumber: options.phoneNumber,
//            userId: options.userId,
//            phoneInputType: nil,
//            otpInputType: nil,
//            userEventType: "INIT",
//            sessionId: options.sessionId,
//            merchantId: nil,
//            additionalParams: nil
//        )
//    }
//
//    static func fromOptionsCron(_ options: Options) -> ClientParams {
//        return ClientParams(
//            phoneNumber: options.phoneNumber,
//            userId: options.userId,
//            phoneInputType: nil,
//            otpInputType: nil,
//            userEventType: "OTHERS",
//            sessionId: options.sessionId,
//            merchantId: nil,
//            additionalParams: nil
//        )
//    }
//
//    static func empty() -> ClientParams {
//        return ClientParams(
//            phoneNumber: nil,
//            userId: nil,
//            phoneInputType: nil,
//            otpInputType: nil,
//            userEventType: nil,
//            sessionId: nil,
//            merchantId: nil,
//            additionalParams: nil
//        )
//    }
//}

internal actor ClientParams: Codable {
    let phoneNumber: String?
    let userId: String?
    let phoneInputType: String?
    let otpInputType: String?
    let userEventType: String?
    let sessionId: String?
    let merchantId: String?
    let additionalParams: [String: String]?

    enum CodingKeys: String, CodingKey {
        case phoneNumber = "a"
        case userId = "b"
        case phoneInputType = "c"
        case otpInputType = "d"
        case userEventType = "e"
        case sessionId = "f"
        case merchantId = "g"
        case additionalParams = "h"
    }

    init(
        phoneNumber: String?,
        userId: String?,
        phoneInputType: String?,
        otpInputType: String?,
        userEventType: String?,
        sessionId: String?,
        merchantId: String?,
        additionalParams: [String: String]?
    ) {
        self.phoneNumber = phoneNumber
        self.userId = userId
        self.phoneInputType = phoneInputType
        self.otpInputType = otpInputType
        self.userEventType = userEventType
        self.sessionId = sessionId
        self.merchantId = merchantId
        self.additionalParams = additionalParams
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encodeIfPresent(phoneInputType, forKey: .phoneInputType)
        try container.encodeIfPresent(otpInputType, forKey: .otpInputType)
        try container.encodeIfPresent(userEventType, forKey: .userEventType)
        try container.encodeIfPresent(sessionId, forKey: .sessionId)
        try container.encodeIfPresent(merchantId, forKey: .merchantId)
        try container.encodeIfPresent(additionalParams, forKey: .additionalParams)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            phoneNumber: try container.decodeIfPresent(String.self, forKey: .phoneNumber),
            userId: try container.decodeIfPresent(String.self, forKey: .userId),
            phoneInputType: try container.decodeIfPresent(String.self, forKey: .phoneInputType),
            otpInputType: try container.decodeIfPresent(String.self, forKey: .otpInputType),
            userEventType: try container.decodeIfPresent(String.self, forKey: .userEventType),
            sessionId: try container.decodeIfPresent(String.self, forKey: .sessionId),
            merchantId: try container.decodeIfPresent(String.self, forKey: .merchantId),
            additionalParams: try container.decodeIfPresent([String: String].self, forKey: .additionalParams)
        )
    }

    static func fromOptions(_ options: Options) -> ClientParams {
        return ClientParams(
            phoneNumber: options.phoneNumber,
            userId: options.userId,
            phoneInputType: options.phoneInputType?.rawValue,
            otpInputType: options.otpInputType?.rawValue,
            userEventType: options.userEventType?.rawValue,
            sessionId: options.sessionId,
            merchantId: options.merchantId,
            additionalParams: options.additionalAttributes
        )
    }

    static func fromOptionsInit(_ options: Options) -> ClientParams {
        return ClientParams(
            phoneNumber: options.phoneNumber,
            userId: options.userId,
            phoneInputType: nil,
            otpInputType: nil,
            userEventType: "INIT",
            sessionId: options.sessionId,
            merchantId: nil,
            additionalParams: nil
        )
    }

    static func fromOptionsCron(_ options: Options) -> ClientParams {
        return ClientParams(
            phoneNumber: options.phoneNumber,
            userId: options.userId,
            phoneInputType: nil,
            otpInputType: nil,
            userEventType: "OTHERS",
            sessionId: options.sessionId,
            merchantId: nil,
            additionalParams: nil
        )
    }

    static func empty() -> ClientParams {
        return ClientParams(
            phoneNumber: nil,
            userId: nil,
            phoneInputType: nil,
            otpInputType: nil,
            userEventType: nil,
            sessionId: nil,
            merchantId: nil,
            additionalParams: nil
        )
    }
}

