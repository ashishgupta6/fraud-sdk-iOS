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
    internal let appSessionId: String = Utils.getSessionId()
    internal var keyProvider: BaseKey?
    internal lazy var actionHandlerImpl = ActionHandlerImpl(sign3Intelligence: self)
    internal lazy var dataCreationService = DataCreationService()
    internal var deviceParam: DeviceParams?
    internal var updateOptionCheck: Bool = false
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
            updateOptionCheck = true
        }catch{
            updateOptionCheck = false
        }
    }
    
    internal func getIntelligence(listener: IntelligenceResponseListener) {
        DispatchQueue.global().async {
            Task.detached {
                await self.actionHandlerImpl.handle(listener: listener)
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
                    Log.e("SdkInit:", error.localizedDescription)
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
        do{
            try CryptoGCM.initialize(options.clientSecret, options.clientId)
            isSuccess = true
        }catch{
            isSuccess = false
            Log.e("cryptoFailed:", error.localizedDescription)
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
        /// Init Config
        ConfigManager.initConfig()
    }
    
    internal func pushEventMetric(_ eventMetric: EventMetric){
        Api.shared.pushEventMetric(eventMetric){resource in
            switch resource.status{
            case .success:
                Log.i("pushEvent: ", "\(String(describing: resource.data))")
                break
            case .error:
                Log.e("pushEvent: ", "\(String(describing: resource.message))")
                break
            case .loading:
                Log.i("pushEvent: ", "\(String(describing: resource.message))")
            }
        }
    }
}

private func synchronized(_ lock: Any, _ closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
