//
//  UpdateOption.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 15/09/24.
//

import Foundation

public class UpdateOption{
    private(set) var phoneNumber: String?
    private(set) var phoneInputType: PhoneInputType?
    private(set) var otpInputType: OtpInputType?
    private(set) var userId: String?
    private(set) var userEventType: UserEventType?
    private(set) var merchantId: String?
    private(set) var additionalAttributes: [String: String]
    
    private init(
        phoneNumber: String?,
        phoneInputType: PhoneInputType?,
        otpInputType: OtpInputType?,
        userId: String?,
        userEventType: UserEventType?,
        merchantId: String?,
        additionalAttributes: [String: String]
    ) {
        self.phoneNumber = phoneNumber
        self.phoneInputType = phoneInputType
        self.otpInputType = otpInputType
        self.userId = userId
        self.userEventType = userEventType
        self.merchantId = merchantId
        self.additionalAttributes = additionalAttributes
    }
    
    public class Builder {
        private var phoneNumber: String?
        private var phoneInputType: PhoneInputType?
        private var otpInputType: OtpInputType?
        private var userId: String?
        private var userEventType: UserEventType?
        private var merchantId: String?
        private var additionalAttributes: [String: String] = [:]
        
        // Explicitly make the initializer public
        public init() {}
        
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
        
        public func build() -> UpdateOption {
            return UpdateOption(
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
}
