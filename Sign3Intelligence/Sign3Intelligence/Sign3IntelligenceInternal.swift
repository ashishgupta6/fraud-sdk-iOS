//
//  Sign3IntelligenceInternal.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 28/08/24.
//

import Foundation

internal class Sign3IntelligenceInternal{
    internal static var sdk: Sign3IntelligenceInternal?
    internal lazy var userDefaultsManager = UserDefaultsManager()
    internal var options: Options?
    internal var isReady: Bool = false
    internal lazy var appSessionId: String = Utils.getSessionId()
    internal var keyProvider: BaseKey?
    
    internal static func getInstance() -> Sign3IntelligenceInternal {
        if sdk == nil {
            synchronized(Sign3IntelligenceInternal.self) {
                if sdk == nil {
                    sdk = Sign3IntelligenceInternal()
                }
            }
        }
        return sdk!
    }
    
    internal func updateOption(_ updateOption: UpdateOption) {
        do {
            guard let options = self.options else {
                throw NSError(domain: "SDKError", code: 0, userInfo: [NSLocalizedDescriptionKey: "init must be called before using the sdk"])
            }
            
            let phoneNumber = updateOption.phoneNumber == "UNDEFINED" ? options.phoneNumber : updateOption.phoneNumber
            
            let phoneInputType: PhoneInputType? = {
                if updateOption.phoneInputType?.rawValue == "UNDEFINED" {
                    return options.phoneInputType
                } else if let phoneInputType = updateOption.phoneInputType {
                    return PhoneInputType(rawValue: phoneInputType.rawValue)
                }
                return nil
            }()
            
            let otpInputType: OtpInputType? = {
                if updateOption.otpInputType?.rawValue == "UNDEFINED" {
                    return options.otpInputType
                } else if let otpInputType = updateOption.otpInputType {
                    return OtpInputType(rawValue: otpInputType.rawValue)
                }
                return nil
            }()
            
            let userId = updateOption.userId == "UNDEFINED" ? options.userId : updateOption.userId
            
            let userEventType: UserEventType? = {
                if updateOption.userEventType?.rawValue == "UNDEFINED" {
                    return options.userEventType
                } else if let userEventType = updateOption.userEventType {
                    return UserEventType(rawValue: userEventType.rawValue)
                }
                return nil
            }()
            
            let merchantId = updateOption.merchantId == "UNDEFINED" ? options.merchantId : updateOption.merchantId
            
            let additionalAttributes = updateOption.additionalAttributes.isEmpty ? options.additionalAttributes
            : updateOption.additionalAttributes
            
            self.options = options.toBuilder()
                .setPhoneNumber(phoneNumber)
                .setPhoneInputType(phoneInputType)
                .setOtpInputType(otpInputType)
                .setUserId(userId)
                .setUserEventType(userEventType)
                .setMerchantId(merchantId)
                .setAdditionalAttributes(additionalAttributes)
                .build()
            
            Utils.encodeObject(tag: "TAG_UPDATED_OPTIONS", object: self.options)
        }catch{
            Utils.showErrorlogs(tags: "TAG_UPDATED_OPTIONS", value: error.localizedDescription)
        }
    }
    
    internal func getIntelligence(completion: @escaping ([String: Any]) -> Void) {
        var intelligenceData: [String: Any] = [:]
        
        DispatchQueue.global().async {
            Task.detached {
                // Fetching data from the displayAllSignals method
                let data = await DataCreationService.displayAllSignals()
                
                // Merge the data into the intelligenceData dictionary
                intelligenceData.merge(data) { (_, new) in new }
                
                // Call the completion handler on the main thread after the data is collected
                DispatchQueue.main.async {
                    completion(intelligenceData)
                }
            }
        }
    }
    internal func initAsync(_ options: Options,_ completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async{
            let result = self.initialize(options: options)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    internal func initialize(options: Options) -> Bool{
        synchronized(Sign3IntelligenceInternal.self){
            if !isReady{
                do{
                    isReady = try initMandatoryParams(options)
                    initMandatoryParamsAsync()
                }catch{
                    Utils.showErrorlogs(tags: "TAG_SdkInit:", value: error.localizedDescription)
                }
            }
            
        }
        return isReady
    }
    
    internal func initMandatoryParams(_ options: Options) throws -> Bool{
        var isSuccess = false
        self.options = options
        self.options = options.toBuilder().setSessionId(appSessionId).build()
        keyProvider = updateKeyProvider(options)
        //        Utils.encodeObject(tag: "TAG_OPTIONS", object: options)
        //        Utils.showInfologs(tags: "TAG_BASE_URL", value: keyProvider?.baseUrl ?? "demo")
        do{
            try CryptoGCM.initialize(options.clientSecret, options.clientId)
            isSuccess = true
        }catch{
            isSuccess = false
            Utils.showErrorlogs(tags: "TAG_cryptoFailed", value: error.localizedDescription)
            
        }
        return isSuccess
    }
    
    internal func updateKeyProvider(_ options: Options) -> BaseKey{
        switch options.environment{
        case .DEV:
            return DevKeyProvider()
        case .PRE:
            return StagingKeyProvider()
        case .PROD:
            return ProdKeyProvider()
            
        }
    }
    
    internal func initMandatoryParamsAsync() {
        DispatchQueue.global().async {
            if (self.isReady){
                self.startMandatoryCalls()
            }
        }
    }
    
    internal func startMandatoryCalls() {
        //        // Doing API calls
        //        Api.shared.getConfig{result in
        //            switch result {
        //            case .success(let response):
        //                print("Config response:", response)
        //            case .failure(let error):
        //                print("Error:", error.localizedDescription)
        //            }
        //        }
    }
    
    
}

private func synchronized(_ lock: Any, _ closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
