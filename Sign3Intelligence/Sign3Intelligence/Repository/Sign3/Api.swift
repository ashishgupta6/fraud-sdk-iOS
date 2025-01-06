//
//  Api.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 13/11/24.
//

import Foundation
import CryptoKit
import Compression
import struct Foundation.Data

#if os(Linux)
import zlibLinux
#else
import zlib
#endif

internal struct Api{
    internal static let shared = Api()
    private let baseUrl: String?
    private let clientId: String
    private let clientSecret: String
    private let headerProvider: HeaderProvider
    
    private init() {
        self.baseUrl = Sign3IntelligenceInternal.sdk?.keyProvider?.baseUrl
        self.clientId = Sign3IntelligenceInternal.sdk?.options?.clientId ?? ""
        self.clientSecret = Sign3IntelligenceInternal.sdk?.options?.clientSecret ?? ""
        self.headerProvider = HeaderProvider(clientId: clientId, clientSecret: clientSecret)
    }
    
    internal func queryDeviceCheck(deviceToken: String ,completion: @escaping (Resource<String>) -> Void) {
        guard let baseUrl = baseUrl, let url = URL(string: "\(baseUrl)v1/queryBits") else {
            completion(.error("Invalid or missing base URL.", data: ""))
            return
        }
        
        do {
            var request = URLRequest(url: url)
            let iv = CryptoGCM.getIvHeader()
            request.httpMethod = "POST"
            request.addValue(iv.base64EncodedString(), forHTTPHeaderField: CryptoGCM.GET_IV_HEADER)
            request.httpBody = try CryptoGCM.encrypt(deviceToken, iv).data(using: .utf8)
            
            /// Add headers to the request
            headerProvider.getCommonHeaders().forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
            /// Make the network request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.error(error.localizedDescription, data: ""))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(Resource.error("Unexpected response type."))
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        completion(.success(String(data: data, encoding: .utf8)))
                    }else {
                        completion(.error("After API hit no data received"))
                    }
                }else {
                    completion(.error("Device Check Failed: \(httpResponse.statusCode)"))
                }
            }.resume()
        } catch {
            completion(.error(error.localizedDescription, data: ""))
        }
    }
    
    internal func getConfig(completion: @escaping (Resource<Config>) -> Void) {
        guard let baseUrl = baseUrl, let url = URL(string: "\(baseUrl)v1/device/config") else {
            completion(.error("Invalid or missing base URL.", data: Config.getDefault()))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        /// Add headers to the request
        headerProvider.getCommonHeaders().forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        /// Create a semaphore with an initial count of 0, which will block the thread
        let semaphore = DispatchSemaphore(value: 0)
        /// Make the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.error(error.localizedDescription, data: Config.getDefault()))
                semaphore.signal()
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(Resource.error("Unexpected response type."))
                return
            }
            
            if httpResponse.statusCode == 200 {
                guard let httpResponse = response as? HTTPURLResponse,
                      let responseData = data else {
                    completion(.error("Missing or invalid response.", data: Config.getDefault()))
                    semaphore.signal()
                    return
                }
                
                do {
                    /// Attempt to retrieve and decode the IV from the headers
                    guard let base64Iv = httpResponse.allHeaderFields[CryptoGCM.GET_IV_HEADER] as? String,
                          let _ = Data(base64Encoded: base64Iv) else {
                        completion(.error("Failed to retrieve or decode the IV from headers.", data: Config.getDefault()))
                        semaphore.signal()
                        return
                    }
                    
                    /// Decrypt the response
                    guard let decryptedString = CryptoGCM.decrypt(
                        ciphertextBase64: String(data: responseData, encoding: .utf8) ?? "",
                        nonceBase64: base64Iv
                    ) else {
                        completion(.error("Decryption failed.", data: Config.getDefault()))
                        semaphore.signal()
                        return
                    }
                    
                    /// Parse the decrypted JSON into the Config object
                    let jsonData = Data(decryptedString.utf8)
                    let config = try JSONDecoder().decode(Config.self, from: jsonData)
                    completion(.success(config))
                    semaphore.signal()
                } catch {
                    completion(.error(error.localizedDescription, data: Config.getDefault()))
                    /// Signal that the API call is complete
                    semaphore.signal()
                }
            }else {
                completion(.error("Config Failed: \(httpResponse.statusCode)"))
                semaphore.signal()
            }
        }.resume()
        /// Block the current thread until the semaphore is signaled
        semaphore.wait()
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
            headerProvider.getCommonHeaders().forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.error(error.localizedDescription))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(Resource.error("Unexpected response type."))
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    completion(.success(jsonString))
                }else {
                    completion(.error("Push Event Failed: \(httpResponse.statusCode)"))
                }
            }.resume()
        }catch{
            completion(.error(error.localizedDescription))
        }
    }
    
    internal func getScore(_ dataRequest: DataRequest, _ sign3Intelligence: Sign3IntelligenceInternal, _ source: String, completion: @escaping (Resource<IntelligenceResponse>) -> Void) {
        var dataRequest = dataRequest
        do {
            dataRequest.clientParams = Utils.getClientParams(source: source, sign3Intelligence: sign3Intelligence)
            Log.i("ClientParams:", Utils.convertToJson(dataRequest.clientParams))
            
            let jsonData = try JSONEncoder().encode(dataRequest)
            let byteArray = try Utils.gzip(jsonData)
            guard String(data: jsonData, encoding: .utf8) != nil else {
                completion(Resource.error("Failed to convert request data to JSON string"))
                return
            }
            
            let iv = CryptoGCM.getIvHeader()
            
            guard let baseUrl = baseUrl, let url = URL(string: "\(baseUrl)v1/ios/userInsights?cstate=true") else {
                completion(Resource.error("Invalid or missing base URL"))
                return
            }
            
            var rawBody: String?
            do {
                rawBody = try CryptoGCM.encrypt(byteArray.base64EncodedString(), iv)
            } catch {
                completion(Resource.error("Encryption failed: \(error.localizedDescription)"))
                return
            }
            
            guard let body = rawBody else {
                completion(Resource.error("Raw body is nil"))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(iv.base64EncodedString(), forHTTPHeaderField: CryptoGCM.GET_IV_HEADER)
            request.httpBody = body.data(using: .utf8)
            headerProvider.getCommonHeaders().forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            /// Make network request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    let errorMessage = "Network error: \(error.localizedDescription)"
                    completion(Resource.error(errorMessage))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(Resource.error("Unexpected response type."))
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    /// Parse the response and pass the IntelligenceResponse object to the completion handler
                    if let responseData = data {
                        do {
                            /// Attempt to retrieve and decode the IV from the headers
                            guard let base64Iv = httpResponse.allHeaderFields[CryptoGCM.GET_IV_HEADER] as? String,
                                  let _ = Data(base64Encoded: base64Iv) else {
                                completion(.error("Failed to retrieve or decode the IV from headers."))
                                return
                            }
                            
                            /// Decrypt the response
                            guard let decryptedString = CryptoGCM.decrypt(
                                ciphertextBase64: String(data: responseData, encoding: .utf8) ?? "",
                                nonceBase64: base64Iv
                            ) else {
                                completion(.error("Decryption failed."))
                                return
                            }
                            guard let decryptedData = decryptedString.data(using: .utf8) else {
                                return
                            }
                            
                            let intelligenceResponse = try JSONDecoder().decode(IntelligenceResponse.self, from: decryptedData)
                            /// Get Response from RealmDataStorage
                            //            sign3Intelligence.realmDataStorage.fetchIntelligenceFromRealm{ response in
                            //                Log.i("Response From DB", Utils.convertToJson(response))
                            //            }
                            
                            /// Get Response from UserDefault
                            sign3Intelligence.userDefaultsManager.fetchIntelligenceFromUserDefaults { response in
                                Log.i("Response From DB", Utils.convertToJson(response))
                            }
                            completion(Resource.success(intelligenceResponse))
                        } catch {
                            completion(Resource.error("Failed to decode response data: \(error.localizedDescription)"))
                        }
                    } else {
                        completion(Resource.error("Failed to parse response data."))
                    }
                }else {
                    completion(Resource.error("Intelligence failed: \(httpResponse.statusCode)"))
                }
            }.resume()
        } catch {
            let errorMessage = "Failed to encode request data: \(error.localizedDescription)"
            completion(Resource.error(errorMessage))
        }
    }
    
    internal func ingestion(_ dataRequest: DataRequest, _ sign3Intelligence: Sign3IntelligenceInternal, _ source: String, completion: @escaping (Resource<IntelligenceResponse>) -> Void) {
        var dataRequest = dataRequest
        do {
            dataRequest.clientParams = Utils.getClientParams(source: source, sign3Intelligence: sign3Intelligence)
            Log.i("ClientParams:", Utils.convertToJson(dataRequest.clientParams))
            let jsonData = try JSONEncoder().encode(dataRequest)
            let byteArray = try Utils.gzip(jsonData)
            guard String(data: jsonData, encoding: .utf8) != nil else {
                completion(Resource.error("Failed to convert request data to JSON string"))
                return
            }
            
            let iv = CryptoGCM.getIvHeader()
            
            guard let baseUrl = baseUrl, let url = URL(string: "\(baseUrl)v1/ios/ingestion?cstate=true") else {
                completion(Resource.error("Invalid or missing base URL"))
                return
            }
            
            var rawBody: String?
            do {
                rawBody = try CryptoGCM.encrypt(byteArray.base64EncodedString(), iv)
            } catch {
                completion(Resource.error("Encryption failed: \(error.localizedDescription)"))
                return
            }
            
            guard let body = rawBody else {
                completion(Resource.error("Raw body is nil"))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(iv.base64EncodedString(), forHTTPHeaderField: CryptoGCM.GET_IV_HEADER)
            request.httpBody = body.data(using: .utf8)
            headerProvider.getCommonHeaders().forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            /// Make network request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    let errorMessage = "Network error: \(error.localizedDescription)"
                    completion(Resource.error(errorMessage))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(Resource.error("Unexpected response type."))
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    /// Parse the response and pass the IntelligenceResponse object to the completion handler
                    if let responseData = data {
                        do {
                            // Attempt to retrieve and decode the IV from the headers
                            guard let base64Iv = httpResponse.allHeaderFields[CryptoGCM.GET_IV_HEADER] as? String,
                                  let _ = Data(base64Encoded: base64Iv) else {
                                completion(.error("Failed to retrieve or decode the IV from headers."))
                                return
                            }
                            
                            /// Decrypt the response
                            guard let decryptedString = CryptoGCM.decrypt(
                                ciphertextBase64: String(data: responseData, encoding: .utf8) ?? "",
                                nonceBase64: base64Iv
                            ) else {
                                completion(.error("Decryption failed."))
                                return
                            }
                            guard let decryptedData = decryptedString.data(using: .utf8) else {
                                return
                            }
                            let ingestionResponse = try JSONDecoder().decode(IngestionResponse.self, from: decryptedData)
                            
                            let intelligenceResponse = IntelligenceResponse(
                                deviceId: ingestionResponse.deviceId,
                                requestId: ingestionResponse.requestId,
                                simulator: dataRequest.deviceParams.iOSDataRequest.simulator,
                                jailbroken: dataRequest.deviceParams.iOSDataRequest.jailBroken,
                                vpn: dataRequest.deviceParams.iOSDataRequest.isVpn,
                                geoSpoofed: dataRequest.deviceParams.iOSDataRequest.isGeoSpoofed,
                                appTampering: dataRequest.deviceParams.iOSDataRequest.isAppTampering,
                                hooking: dataRequest.deviceParams.iOSDataRequest.hooking,
                                proxy: dataRequest.deviceParams.iOSDataRequest.proxy,
                                mirroredScreen: dataRequest.deviceParams.iOSDataRequest.mirroredScreen,
                                gpsLocation: GPSLocation(
                                    latitude: dataRequest.deviceParams.networkData.networkLocation.latitude,
                                    longitude: dataRequest.deviceParams.networkData.networkLocation.longitude,
                                    altitude: dataRequest.deviceParams.networkData.networkLocation.altitude
                                ),
                                cloned: dataRequest.deviceParams.iOSDataRequest.cloned
                            )
                            /// Store Response in RealmDataStorage
                            //            sign3Intelligence.realmDataStorage.saveIntelligenceResponseToRealm(dataRequest, sign3Intelligence, intelligenceResponse)
                            
                            /// Store Response in UserDefault
                            sign3Intelligence.userDefaultsManager.saveIntelligenceResponseToUserDefaults(dataRequest, sign3Intelligence, intelligenceResponse)
                            
                            completion(Resource.success(intelligenceResponse))
                        } catch {
                            completion(Resource.error("Failed to decode response data: \(error.localizedDescription)"))
                        }
                    } else {
                        completion(Resource.error("Failed to parse response data."))
                    }
                }else {
                    completion(.error("Ingestion Failed: \(httpResponse.statusCode)"))
                }
            }.resume()
        } catch {
            let errorMessage = "Failed to encode request data: \(error.localizedDescription)"
            completion(Resource.error(errorMessage))
        }
    }
    
}
