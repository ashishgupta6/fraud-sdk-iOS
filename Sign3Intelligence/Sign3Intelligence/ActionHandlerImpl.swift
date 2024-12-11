//
//  ActionHandlerImpl.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/12/24.
//

import Foundation


import Foundation

internal struct ActionHandlerImpl {
    
    private let sign3Intelligence: Sign3IntelligenceInternal
    
    init(sign3Intelligence: Sign3IntelligenceInternal) {
        self.sign3Intelligence = sign3Intelligence
    }
    
    func handle(listener: IntelligenceResponseListener) async {
        let sessionId = sign3Intelligence.appSessionId
        let requestId = Utils.getRequestID()
        Log.i("REQUEST_ID",requestId)
        Log.i("SESSION_ID",sessionId)

        var dataCreationService = sign3Intelligence.dataCreationService
        let source = "GET"
        
        do {
            if !sign3Intelligence.isReady {
                try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
                if !sign3Intelligence.isReady {
                    listener.onError(error: IntelligenceError(requestId: requestId, errorMessage: "SDK was not initialized"))
                    return
                }
            }
        }catch {
            Log.i("ActionHandler", error.localizedDescription)
        }
        
        let deviceParams: DeviceParams
        if ConfigManager.fetchSignals {
            sign3Intelligence.deviceParam = await dataCreationService.getDeviceParams()
            deviceParams = await dataCreationService.getDeviceParams()
        } else {
            if let existingDeviceParam = sign3Intelligence.deviceParam {
                deviceParams = existingDeviceParam
            } else {
                sign3Intelligence.deviceParam = await dataCreationService.getDeviceParams()
                deviceParams = await dataCreationService.getDeviceParams()
            }
        }
        
        let clientParams = Utils.getClientParams(source: source, sign3Intelligence: sign3Intelligence)

        Log.i("ClientParams", Utils.convertToJson(clientParams))
        
        let dataRequest = DataRequest(
            requestId: requestId,
            sessionId: sessionId,
            deviceParams: deviceParams,
            clientParams: clientParams
        )
        
        Api.shared.getScore(
            dataRequest,
            sign3Intelligence,
            source,
            listener: listener
        )
    }
}

