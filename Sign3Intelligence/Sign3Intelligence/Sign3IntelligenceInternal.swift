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
    
    func getIntelligence() {
        DisplayAllSignals.displayAllSignals(deviceSignalsApiImpl, sign3IntelliegnceImpl)
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
                }catch{
                    Utils.showErrorlogs(tags: "TAG_SdkInit:", value: error.localizedDescription)
                }
            }
            
        }
        return isReady
    }
    
    func initMandatoryParams(_ options: Options) throws -> Bool{
        self.options = options
        self.options = options.toBuilder().setSessionId(appSessionId).build()
        keyProvider = updateKeyProvider(options)
        if(self.options != nil){
//            Utils.encodeObject(tag: "TAG_OPTIONS", object: self.options)
//            Utils.showInfologs(tags: "TAG_BASE_URL", value: keyProvider?.baseUrl ?? "demo")
            return true
        }
        return false
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
    
    
    
}

private func synchronized(_ lock: Any, _ closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
