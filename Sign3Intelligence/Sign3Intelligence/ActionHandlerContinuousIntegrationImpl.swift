//
//  ActionHandlerContinuousIntegrationImpl.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 12/12/24.
//

import Foundation


internal class ActionHandlerContinuousIntegrationImpl {

    private let sign3Intelligence: Sign3IntelligenceInternal
    
    init(sign3Intelligence: Sign3IntelligenceInternal) {
        self.sign3Intelligence = sign3Intelligence
    }
    
    func handle(source: ActionContextSource) async {
        let sessionId = sign3Intelligence.appSessionId
        let requestId = Utils.getRequestID()
        let sourceString = String(describing: source)
        
        var dataCreationService = sign3Intelligence.dataCreationService
        
        do {
            if !sign3Intelligence.isReady {
                try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
                if !sign3Intelligence.isReady {
                    Log.e("Ingestion:", "SDK was not initialized")
                    return
                }
            }
        }catch {
            Log.e("Ingestion:", error.localizedDescription)
        }
        
        let deviceParams = await dataCreationService.getDeviceParams()
        
        guard let options = sign3Intelligence.options else {
            Log.e("getClientParams", "Option is nil")
            return
        }
        let clientParams = ClientParams.fromOptions(options)
        
        let deviceParamsHash = DataHashUtil.generateHash(deviceParams, sign3Intelligence)
        Log.i("Old Hash:", sign3Intelligence.payloadHash.description)
        Log.i("New Hash:", deviceParamsHash.description)
        
        let includeExtraOptions = isExtraOptionChanged(clientParams)

        let shouldHitApi = shouldHitApi(deviceParamsHash,includeExtraOptions)

        if shouldHitApi {
            Log.i("Doing API Call:", shouldHitApi.description)
            let dataRequest = DataRequest(
                requestId: requestId,
                sessionId: sessionId,
                deviceParams: deviceParams,
                clientParams: clientParams
            )
            
            Api.shared.ingestion(dataRequest, sign3Intelligence, sourceString) { result in
                switch result.status {
                case .success:
                    if let responseData = result.data {
                        Utils.updateData(
                            response: responseData,
                            sign3Intelligence: self.sign3Intelligence,
                            deviceParams: deviceParams,
                            deviceParamsHash: deviceParamsHash,
                            clientParams: clientParams
                        )
                        Log.i("Ingestion:", Utils.convertToJson(responseData))
                    }
                case .error:
                    Log.e("Ingestion:", result.message ?? "demo")
                    Utils.pushEventMetric(
                        EventMetric(
                            timeRequiredInMs: Int64(Date().timeIntervalSince1970) * 1000,
                            status: false,
                            source: sourceString,
                            errorMessage: result.message,
                            requestId: requestId,
                            eventName: String(describing: ActionContextEvent.ERROR)
                        )
                    )
                    Utils.pushSdkError(SdkError(name: "Ingestion", exceptionMsg: result.message ?? "", requestId: requestId))
                case .loading: break
                    /// Do something
                }
            }
        }
    }
    
    
    private func shouldHitApi(_ currentDeviceParamsHash: Int, _ includeExtraOptions: Bool) -> Bool {
        return sign3Intelligence.payloadHash != currentDeviceParamsHash ||
        includeExtraOptions ||
        sign3Intelligence.currentIntelligence == nil ||
        sign3Intelligence.locationThresholdReached ||
        sign3Intelligence.memoryThresholdReached
    }

    
    private func isExtraOptionChanged(_ clientParams: ClientParams) -> Bool {
        return DataHashUtil.generateHash(clientParams) !=
               DataHashUtil.generateHash(sign3Intelligence.sentClientParams)
    }
}
