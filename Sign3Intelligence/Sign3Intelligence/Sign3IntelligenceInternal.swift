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
    internal lazy var actionHandlerContinuousIntegrationImpl = ActionHandlerContinuousIntegrationImpl(sign3Intelligence: self)
    internal lazy var dataCreationService = DataCreationService()
    internal var deviceParam: DeviceParams?
    internal var updateOptionCheck: Bool = false
    private var cronTrigger: CronTrigger? = nil
    internal var availableMemory: CLong? = nil
    internal var totalMemory: CLong? = nil
    internal var memoryThresholdReached: Bool = false
    internal var locationThresholdReached: Bool = false
    internal var currentIntelligence: IntelligenceResponse? = nil
    internal var sentClientParams : ClientParams = ClientParams.empty()
    internal var payloadHash: Int = -1
//    internal var mixpanel: MixpanelInstance? = nil
    
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
    
    internal func initAsync(_ options: Options,_ completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async{
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
                    Utils.pushEventMetric(
                        EventMetric(
                            timeRequiredInMs: Int64(Date().timeIntervalSince1970) * 1000,
                            status: false,
                            source: String(describing: ActionContextSource.INIT),
                            errorMessage: error.localizedDescription,
                            requestId: "",
                            eventName: String(describing: ActionContextEvent.CONFIG)
                        )
                    )
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
        case .STAGING:
            return StagingKeyProvider()
        case .PROD:
            return ProdKeyProvider()
            
        }
    }
    
    /// userInteractive: For UI-critical tasks like animations or instant touch feedback. Too high priority for your framework—avoid using it.
    /// userInitiated: For user-triggered tasks requiring immediate results. Best for your framework if signal collection needs to be fast.
    /// default: Standard priority for generic tasks. Suitable but not optimized for your framework's requirements.
    /// utility: For long-running tasks with lower urgency, energy-efficient. Good for background data collection but not ideal for immediate results.
    /// background: For non-urgent tasks invisible to the user, low priority. Too slow for your framework's needs.
    /// unspecified: Leaves priority to the system; unpredictable. Not recommended for important tasks.
    
    internal func getIntelligence(listener: IntelligenceResponseListener) {
        DispatchQueue.global(qos: .userInitiated).async {
            Task {
                await self.actionHandlerImpl.handle(listener: listener)
            }
        }
    }
    
    internal func initMandatoryParamsAsync() {
        DispatchQueue.global(qos: .userInitiated).async {
            Task{
                if (self.isReady){
                    await self.startMandatoryCalls()
                }
            }
        }
    }
    
    internal func startMandatoryCalls() async {
        /// Init Config
        ConfigManager.initConfig()
        
        /// Cron Start
        if ConfigManager.isCronEnabled {
            cronTrigger = CronTrigger.init(actionHandlerContinuousIntegrationImpl: actionHandlerContinuousIntegrationImpl)
            cronTrigger?.initTrigger()
        }
        
        /// Call On Start
        if ConfigManager.callOnStart {
            await actionHandlerContinuousIntegrationImpl.handle(source: ActionContextSource.INIT)
        }
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
