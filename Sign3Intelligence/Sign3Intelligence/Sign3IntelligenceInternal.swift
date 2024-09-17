//
//  Sign3IntelligenceInternal.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 28/08/24.
//

import Foundation

class Sign3IntelligenceInternal{
    static var sdk: Sign3IntelligenceInternal?
    lazy var deviceSignalsApiImpl = DeviceSignalsApiImpl()
    lazy var sign3IntelliegnceImpl = Sign3IntelligenceSdkApiImpl()
    lazy var deviceSignalsViewModel = DeviceSignalsViewModel(deviceSignalsApi: DeviceSignalsApiImpl())
    lazy var userDefaultsManager = UserDefaultsManager()
    var options: Options?
    var isReady: Bool = false
    public func getDeviceSignalsViewModel() -> DeviceSignalsViewModel? {
        return deviceSignalsViewModel
    }
    lazy var appSessionId: String = Utils.getSessionId()
    var keyProvider: BaseKey?


    
    static func getInstance() -> Sign3IntelligenceInternal {
        if sdk == nil {
            synchronized(Sign3IntelligenceInternal.self) {
                if sdk == nil {
                    sdk = Sign3IntelligenceInternal()
                }
            }
        }
        return sdk!
    }
    
    func updateOption(_ updateOption: UpdateOption) {
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
    
    func getIntelligence() {
        DataCreationService.displayAllSignals(deviceSignalsApiImpl, sign3IntelliegnceImpl)
    }
    
    func initAsync(_ options: Options,_ completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async{
            let result = self.initialize(options: options)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func initialize(options: Options) -> Bool{
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
    
    func initMandatoryParams(_ options: Options) throws -> Bool{
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
    
    func updateKeyProvider(_ options: Options) -> BaseKey{
        switch options.environment{
        case .DEV:
            return DevKeyProvider()
        case .PRE:
            return StagingKeyProvider()
        case .PROD:
            return ProdKeyProvider()
            
        }
    }
    
    func initMandatoryParamsAsync() {
        DispatchQueue.global().async {
            if (self.isReady){
                self.startMandatoryCalls()
            }
        }
    }
    
    func startMandatoryCalls() {
//        do{
//            // Doing API calls
//        }catch{
//            Utils.showErrorlogs(tags: "TAG_mandatoryCallsFailed", value: error.localizedDescription)
//        }
    }
    
    
}

private func synchronized(_ lock: Any, _ closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
