//
//  Api.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 13/11/24.
//

import Foundation
import CryptoKit
import Compression

internal struct Api{
    internal static let shared = Api()
    private let baseUrl: String?
    private let clientId: String
    private let clientSecret: String
    private let headerProvider: HeaderProvider
    private static let CONFIG_MAX_RETRY_COUNT = 3
    
    private init() {
        self.baseUrl = Sign3IntelligenceInternal.sdk?.keyProvider?.baseUrl
        self.clientId = Sign3IntelligenceInternal.sdk?.options?.clientId ?? ""
        self.clientSecret = Sign3IntelligenceInternal.sdk?.options?.clientSecret ?? ""
        self.headerProvider = HeaderProvider(clientId: clientId, clientSecret: clientSecret)
    }
    
    internal func getConfig(completion: @escaping (Resource<Config>) -> Void) {
        guard let baseUrl = baseUrl, let url = URL(string: "\(baseUrl)v1/device/config") else {
            completion(.error("Invalid or missing base URL.", data: Config.getDefault()))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add headers to the request
        headerProvider.getCommonHeaders().forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Make the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.error(error.localizedDescription, data: Config.getDefault()))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  let responseData = data else {
                completion(.error("Missing or invalid response.", data: Config.getDefault()))
                return
            }
            
            do {
                // Attempt to retrieve and decode the IV from the headers
                guard let base64Iv = httpResponse.allHeaderFields[CryptoGCM.GET_IV_HEADER] as? String,
                      let _ = Data(base64Encoded: base64Iv) else {
                    completion(.error("Failed to retrieve or decode the IV from headers.", data: Config.getDefault()))
                    return
                }
                
                // Decrypt the response
                guard let decryptedString = CryptoGCM.decrypt(
                    ciphertextBase64: String(data: responseData, encoding: .utf8) ?? "",
                    nonceBase64: base64Iv
                ) else {
                    completion(.error("Decryption failed.", data: Config.getDefault()))
                    return
                }
                
                // Parse the decrypted JSON into the Config object
                let jsonData = Data(decryptedString.utf8)
                let config = try JSONDecoder().decode(Config.self, from: jsonData)
                completion(.success(config))
            } catch {
                completion(.error(error.localizedDescription, data: Config.getDefault()))
            }
        }.resume()
    }
    
    internal func pushEventMetric(_ eventMetric: EventMetric, completion: @escaping (Resource<String>) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(eventMetric)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                return
            }
            
            guard let baseUrl = baseUrl, let url = URL(string: "\(baseUrl)v1/analytics") else {
                completion(.error("Invalid or missing base URL."))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonString.data(using: .utf8)
            // Add headers to the request
            headerProvider.getCommonHeaders().forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.error(error.localizedDescription))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                    completion(.error("HTTP Error: \(statusCode)"))
                    return
                }
                
                completion(.success(jsonString))
            }.resume()
        }catch{
            completion(.error(error.localizedDescription))
        }
    }
    
    internal func getScore(_ dataRequest: DataRequest, _ sign3Intelligence: Sign3IntelligenceInternal, _ source: String, listener: IntelligenceResponseListener) {
        do {
            let jsonData = try JSONEncoder().encode(dataRequest)
            let payloadJson = Utils.convertToJson(dataRequest)
            let byteArray = jsonData.base64EncodedString()
//            let byteArray = gzip(payloadJson)
            
//            Log.i("PATLOADJSON",payloadJson)
            Log.i("PATLOADJSON2",jsonData.description)
            
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                let errorObj = IntelligenceError(requestId: dataRequest.requestId, errorMessage: "Failed to convert request data to JSON string")
                listener.onError(error: errorObj)
                return
            }
            
            let iv = CryptoGCM.getIvHeader()
            
            guard let baseUrl = baseUrl, let url = URL(string: "\(baseUrl)v3/userInsights?cstate=false") else {
                let errorObj = IntelligenceError(requestId: dataRequest.requestId, errorMessage: "Invalid or missing base URL")
                listener.onError(error: errorObj)
                return
            }
//            let rawBody: String
//            do {
//                rawBody = try CryptoGCM.encrypt(byteArray, iv)
//            } catch {
//                let errorObj = IntelligenceError(requestId: dataRequest.requestId, errorMessage: "Encryption failed: \(error.localizedDescription)")
//                listener.onError(error: errorObj)
//                return
//            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(iv.base64EncodedString(), forHTTPHeaderField: CryptoGCM.GET_IV_HEADER)
//            request.httpBody = rawBody.data(using: .utf8)
            request.httpBody = jsonData
            headerProvider.getCommonHeaders().forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    let errorMessage = "Network error: \(error.localizedDescription)"
                    let errorObj = IntelligenceError(requestId: dataRequest.requestId, errorMessage: errorMessage)
                    listener.onError(error: errorObj)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    let errorObj = IntelligenceError(requestId: dataRequest.requestId, errorMessage: "Invalid response format")
                    listener.onError(error: errorObj)
                    return
                }
                
                // Parse the response and pass the IntelligenceResponse object to the listener
                if let responseData = data {
                    do {
                        let intelligenceResponse = try JSONDecoder().decode(IntelligenceResponse.self, from: responseData)
                        listener.onSuccess(response: intelligenceResponse)
                    } catch {
                        let errorObj = IntelligenceError(requestId: dataRequest.requestId, errorMessage: "Failed to decode response data: \(error.localizedDescription)")
                        listener.onError(error: errorObj)
                    }
                } else {
                    let errorObj = IntelligenceError(requestId: dataRequest.requestId, errorMessage: "Failed to parse response data.")
                    listener.onError(error: errorObj)
                }
            }.resume()
            
//            /// For testing purpose
//            let intelligenceResponse = IntelligenceResponse(
//                deviceId: dataRequest.deviceParams.iOSDataRequest.iOSDeviceID,
//                requestId: dataRequest.requestId,
//                issimulatorDetected: dataRequest.deviceParams.iOSDataRequest.simulator,
//                isJailbroken: dataRequest.deviceParams.iOSDataRequest.jailBroken,
//                isVpnEnabled: dataRequest.deviceParams.iOSDataRequest.isVpn,
//                isGeoSpoofed: dataRequest.deviceParams.iOSDataRequest.isGeoSpoofed,
//                isAppTamperedL: dataRequest.deviceParams.iOSDataRequest.isAppTampering,
//                isHooked: dataRequest.deviceParams.iOSDataRequest.hooking,
//                isProxyDetected: dataRequest.deviceParams.iOSDataRequest.proxy,
//                isMirroredScreenDetected: dataRequest.deviceParams.iOSDataRequest.mirroredScreen
//            )
//            listener.onSuccess(response: intelligenceResponse)
        }catch{
            let errorMessage = "Failed to encode request data: \(error.localizedDescription)"
            let errorObj = IntelligenceError(requestId: dataRequest.requestId, errorMessage: errorMessage)
            listener.onError(error: errorObj)
        }
    }

    
}
