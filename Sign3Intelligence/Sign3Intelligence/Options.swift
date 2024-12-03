//
//  Options.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation


public class Options: Codable{
    private(set) var clientId: String
    private(set) var clientSecret: String
    private(set) var sessionId: String?
    private(set) var environment: Environment
    private(set) var phoneNumber: String?
    private(set) var phoneInputType: PhoneInputType?
    private(set) var otpInputType: OtpInputType?
    private(set) var userId: String?
    private(set) var userEventType: UserEventType?
    private(set) var merchantId: String?
    private(set) var additionalAttributes: [String: String]
    
    private init(
        clientId: String,
        clientSecret: String,
        sessionId: String?,
        environment: Environment,
        phoneNumber: String?,
        phoneInputType: PhoneInputType?,
        otpInputType: OtpInputType?,
        userId: String?,
        userEventType: UserEventType?,
        merchantId: String?,
        additionalAttributes: [String: String]
    ) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.sessionId = sessionId
        self.environment = environment
        self.phoneNumber = phoneNumber
        self.phoneInputType = phoneInputType
        self.otpInputType = otpInputType
        self.userId = userId
        self.userEventType = userEventType
        self.merchantId = merchantId
        self.additionalAttributes = additionalAttributes
    }
    
    
    public class Builder {
        private var clientId: String?
        private var clientSecret: String?
        private var sessionId: String?
        private var environment: Environment = Environment.PROD
        private var phoneNumber: String?
        private var phoneInputType: PhoneInputType?
        private var otpInputType: OtpInputType?
        private var userId: String?
        private var userEventType: UserEventType?
        private var merchantId: String?
        private var additionalAttributes: [String: String] = [:]
        
        // Explicitly make the initializer public
        public init() {}
        
        public func setClientId(_ clientId: String) -> Builder {
            self.clientId = clientId
            return self
        }
        
        public func setClientSecret(_ clientSecret: String) -> Builder {
            self.clientSecret = clientSecret
            return self
        }
        
        func setSessionId(_ sessionId: String?) -> Builder {
            self.sessionId = sessionId
            return self
        }
        
        public func setEnvironment(_ environment: Environment) -> Builder {
            self.environment = environment
            return self
        }
        
        public func setPhoneNumber(_ phoneNumber: String?) -> Builder {
            self.phoneNumber = phoneNumber
            return self
        }
        
        public func setPhoneInputType(_ phoneInputType: PhoneInputType?) -> Builder {
            self.phoneInputType = phoneInputType
            return self
        }
        
        public func setOtpInputType(_ otpInputType: OtpInputType?) -> Builder {
            self.otpInputType = otpInputType
            return self
        }
        
        public func setUserId(_ userId: String?) -> Builder {
            self.userId = userId
            return self
        }
        
        public func setUserEventType(_ userEventType: UserEventType?) -> Builder {
            self.userEventType = userEventType
            return self
        }
        
        public func setMerchantId(_ merchantId: String?) -> Builder {
            self.merchantId = merchantId
            return self
        }
        
        public func setAdditionalAttributes(_ additionalAttributes: [String: String]) -> Builder {
            self.additionalAttributes = additionalAttributes
            return self
        }
        
        public func build() -> Options {
            return Options(
                clientId: clientId ?? "",
                clientSecret: clientSecret ?? "",
                sessionId: sessionId,
                environment: environment,
                phoneNumber: phoneNumber,
                phoneInputType: phoneInputType,
                otpInputType: otpInputType,
                userId: userId,
                userEventType: userEventType,
                merchantId: merchantId,
                additionalAttributes: additionalAttributes
            )
        }
    }
    
    public func toBuilder() -> Builder {
        return Builder()
            .setClientId(clientId)
            .setClientSecret(clientSecret)
            .setSessionId(sessionId)
            .setEnvironment(environment)
            .setPhoneNumber(phoneNumber)
            .setPhoneInputType(phoneInputType)
            .setOtpInputType(otpInputType)
            .setUserId(userId)
            .setUserEventType(userEventType)
            .setMerchantId(merchantId)
            .setAdditionalAttributes(additionalAttributes)
    }
}
