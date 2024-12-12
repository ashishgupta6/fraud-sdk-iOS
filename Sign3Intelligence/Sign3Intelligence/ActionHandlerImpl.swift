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
            listener.onError(error: IntelligenceError(requestId: requestId, errorMessage: error.localizedDescription))
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
        
        guard let options = sign3Intelligence.options else {
            Log.e("getClientParams", "Option is nil")
            return
        }
        let clientParams = ClientParams.fromOptions(options)
        
        let deviceParamsHash = DataHashUtil.generateHash(deviceParams, sign3Intelligence)
        Log.i("New Hash_:", deviceParamsHash.description)
        
        
        var dataRequest = DataRequest(
            requestId: requestId,
            sessionId: sessionId,
            deviceParams: deviceParams,
            clientParams: clientParams
        )
        
        Api.shared.getScore(&dataRequest, sign3Intelligence, source) { result in
            switch result.status {
            case .success:
                if let responseData = result.data {
                    Log.i("Get Score:", Utils.convertToJson(responseData))
                    Utils.updateData(
                        response: responseData,
                        sign3Intelligence: self.sign3Intelligence,
                        deviceParams: deviceParams,
                        deviceParamsHash: deviceParamsHash,
                        clientParams: clientParams
                    )
                    listener.onSuccess(response: responseData)
                }
            case .error:
                let intelligenceError = IntelligenceError( requestId: requestId, errorMessage: "Sign3 Server Error")
                listener.onError(error: intelligenceError)
                Log.i("Get Score:", result.message ?? "demo")
                Utils.pushEventMetric(
                    EventMetric(
                        timeRequiredInMs: Int64(Date().timeIntervalSince1970) * 1000,
                        status: false,
                        source: source,
                        errorMessage: result.message,
                        requestId: requestId,
                        eventName: String(describing: ActionContextEvent.ERROR)
                    )
                )
            case .loading: break
                /// Do something
            }
        }
    }
}

