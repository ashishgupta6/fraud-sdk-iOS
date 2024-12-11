//
//  ClientParams.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation

internal struct ClientParams: Codable {
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
