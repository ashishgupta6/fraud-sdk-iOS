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
        // Create a semaphore with an initial count of 0, which will block the thread
        let semaphore = DispatchSemaphore(value: 0)
        
        do {
            var request = URLRequest(url: url)
            let iv = CryptoGCM.getIvHeader()
            request.httpMethod = "POST"
            request.addValue(iv.base64EncodedString(), forHTTPHeaderField: CryptoGCM.GET_IV_HEADER)
            request.httpBody = try CryptoGCM.encrypt(deviceToken, iv).data(using: .utf8)
            
            // Add headers to the request
            headerProvider.getCommonHeaders().forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
            // Make the network request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.error(error.localizedDescription, data: ""))
                    Log.i("After: ", "After API Hit: ")  // This will log after the error is handled
                    semaphore.signal()  // Signal that the API call is complete
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      let responseData = data else {
                    completion(.error("Missing or invalid response.", data: ""))
                    Log.i("After: ", "After API Hit: \(String(data: data!, encoding: .utf8))")  // Log here for invalid response
                    semaphore.signal()  // Signal that the API call is complete
                    return
                }
                
                
//                // Attempt to retrieve and decode the IV from the headers
//                guard let base64Iv = httpResponse.allHeaderFields[CryptoGCM.GET_IV_HEADER] as? String,
//                      let _ = Data(base64Encoded: base64Iv) else {
//                    completion(.error("Failed to retrieve or decode the IV from headers.", data: ""))
//                    Log.i("After: ", "After API Hit: ")  // Log here if IV decoding fails
//                    semaphore.signal()  // Signal that the API call is complete
//                    return
//                }
//                
//                // Decrypt the response
//                guard let decryptedString = CryptoGCM.decrypt(
//                    ciphertextBase64: String(data: responseData, encoding: .utf8) ?? "",
//                    nonceBase64: base64Iv
//                ) else {
//                    completion(.error("Decryption failed.", data: ""))
//                    Log.i("After: ", "After API Hit: ")  // Log here if decryption fails
//                    semaphore.signal()  // Signal that the API call is complete
//                    return
//                }
//                
//                // Parse the decrypted JSON into the Config object
//                let jsonData = Data(decryptedString.utf8)
                completion(.success(String(data: data!, encoding: .utf8)))
                semaphore.signal()  // Signal that the API call is complete
                
            }.resume() // Start the network request
        } catch {
            completion(.error(error.localizedDescription, data: ""))
            semaphore.signal()  // Signal that the API call is complete
        }
        
        // Block the current thread until the semaphore is signaled
        semaphore.wait()
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
        // Create a semaphore with an initial count of 0, which will block the thread
        let semaphore = DispatchSemaphore(value: 0)
        // Make the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.error(error.localizedDescription, data: Config.getDefault()))
                Log.i("After: ", "After API Hit: ")  // This will log after the error is handled
                semaphore.signal()  // Signal that the API call is complete
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  let responseData = data else {
                completion(.error("Missing or invalid response.", data: Config.getDefault()))
                Log.i("After: ", "After API Hit: ")  // Log here for invalid response
                semaphore.signal()  // Signal that the API call is complete
                return
            }
            
            do {
                // Attempt to retrieve and decode the IV from the headers
                guard let base64Iv = httpResponse.allHeaderFields[CryptoGCM.GET_IV_HEADER] as? String,
                      let _ = Data(base64Encoded: base64Iv) else {
                    completion(.error("Failed to retrieve or decode the IV from headers.", data: Config.getDefault()))
                    Log.i("After: ", "After API Hit: ")  // Log here if IV decoding fails
                    semaphore.signal()  // Signal that the API call is complete
                    return
                }
                
                // Decrypt the response
                guard let decryptedString = CryptoGCM.decrypt(
                    ciphertextBase64: String(data: responseData, encoding: .utf8) ?? "",
                    nonceBase64: base64Iv
                ) else {
                    completion(.error("Decryption failed.", data: Config.getDefault()))
                    Log.i("After: ", "After API Hit: ")  // Log here if decryption fails
                    semaphore.signal()  // Signal that the API call is complete
                    return
                }
                
                // Parse the decrypted JSON into the Config object
                let jsonData = Data(decryptedString.utf8)
                let config = try JSONDecoder().decode(Config.self, from: jsonData)
                completion(.success(config))
                semaphore.signal()  // Signal that the API call is complete
            } catch {
                completion(.error(error.localizedDescription, data: Config.getDefault()))
                semaphore.signal()  // Signal that the API call is complete
            }
        }.resume() // Start the network request
        // Block the current thread until the semaphore is signaled
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
    internal func convertToJson<T: Encodable>(_ object: T) -> String {
        do {
          let jsonData = try JSONEncoder().encode(object)
          if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
          } else {
            Log.e("ConvertToJson", "Failed to convert JSON data to string")
            return ""
          }
        } catch {
          Log.e("ConvertToJson", "Failed to convert object to JSON: \(error)")
          return ""
        }
      }

    internal func getScore(_ dataRequest: inout DataRequest, _ sign3Intelligence: Sign3IntelligenceInternal, _ source: String, completion: @escaping (Resource<IntelligenceResponse>) -> Void) {
        do {
            // Testing purpose (commented out for now)
            // let exampleString = "Ashish Gupta"
            // Log.i("Before Zip", exampleString)
            // let inputData = try JSONEncoder().encode(exampleString)
            // let data = gzip(inputData, COMPRESSION_STREAM_ENCODE)
            // Log.i("Compressed Data", data?.base64EncodedString() ?? "demo")
            // guard let compressedData = Data(base64Encoded: data?.base64EncodedString() ?? "") else { return Resource.error("") }
            // let unzip = gzip(compressedData, COMPRESSION_STREAM_DECODE)
            // let decompressedString = unzip.flatMap { String(data: $0, encoding: .utf8) }
            // Log.i("After Zip", decompressedString ?? "demo")
            dataRequest.clientParams = Utils.getClientParams(source: source, sign3Intelligence: sign3Intelligence)
            Log.i("ClientParams:", Utils.convertToJson(dataRequest.clientParams))
            
            let jsonData = try JSONEncoder().encode(dataRequest)
//            let byteArray = gzip(jsonData, COMPRESSION_STREAM_ENCODE)
            let y = try Utils.gzip(jsonData)
            let yBase64Encoded = y.base64EncodedString()
            let byteArray = try Utils.gzip(jsonData)
            //let decodedCompressedJson = try JSONDecoder().decode(DataRequest.self, from: byteArray ?? Data())
//            let decompressed = zlibDecompress(data: byteArray!)
//            let decodedJsonData = try JSONDecoder().decode(DataRequest.self, from: decompressed!)
//            let convertedData: [UInt8] = [UInt8](byteArray!)
            guard String(data: jsonData, encoding: .utf8) != nil else {
                completion(Resource.error("Failed to convert request data to JSON string"))
                return
            }

            let iv = CryptoGCM.getIvHeader()

            guard let baseUrl = baseUrl, let url = URL(string: "\(baseUrl)v3/userInsights?cstate=true") else {
                completion(Resource.error("Invalid or missing base URL"))
                return
            }

            let rawBody: String
            do {
                let beforeEncrypt = byteArray
                rawBody = try CryptoGCM.encrypt(byteArray.base64EncodedString(), iv)
            } catch {
                completion(Resource.error("Encryption failed: \(error.localizedDescription)"))
                return
            }

            let base64Iv = iv.base64EncodedString()
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(iv.base64EncodedString(), forHTTPHeaderField: CryptoGCM.GET_IV_HEADER.uppercased())
            request.httpBody = rawBody.data(using: .utf8)
            headerProvider.getCommonHeaders().forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }

            // Make network request
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    let errorMessage = "Network error: \(error.localizedDescription)"
//                    completion(Resource.error(errorMessage))
//                    return
//                }
//
//                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                    completion(Resource.error("Invalid response format"))
//                    return
//                }
//
//                // Parse the response and pass the IntelligenceResponse object to the completion handler
//                if let responseData = data {
//                    do {
//                        let intelligenceResponse = try JSONDecoder().decode(IntelligenceResponse.self, from: responseData)
//                        completion(Resource.success(intelligenceResponse))
//                    } catch {
//                        completion(Resource.error("Failed to decode response data: \(error.localizedDescription)"))
//                    }
//                } else {
//                    completion(Resource.error("Failed to parse response data."))
//                }
//            }.resume()
            
            let intelligenceResponse = IntelligenceResponse(
                deviceId: dataRequest.deviceParams.iOSDataRequest.iOSDeviceID,
                requestId: dataRequest.requestId,
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
                )
            )
            /// Get Response from RealmDataStorage
//            sign3Intelligence.realmDataStorage.fetchIntelligenceFromRealm{ response in
//                Log.i("Response From DB", Utils.convertToJson(response))
//            }
            
            /// Get Response from UserDefault
            sign3Intelligence.userDefaultsManager.fetchIntelligenceFromUserDefaults { response in
                Log.i("Response From DB", Utils.convertToJson(response))
            }
            Log.i("Payload Json", Utils.convertToJson(dataRequest))
            completion(Resource.success(intelligenceResponse))
        } catch {
            let errorMessage = "Failed to encode request data: \(error.localizedDescription)"
            completion(Resource.error(errorMessage))
        }
    }
    
    internal func ingestion(_ dataRequest: inout DataRequest, _ sign3Intelligence: Sign3IntelligenceInternal, _ source: String, completion: @escaping (Resource<IntelligenceResponse>) -> Void) {
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

            guard let baseUrl = baseUrl, let url = URL(string: "\(baseUrl)v3/userInsights?cstate=true") else {
                completion(Resource.error("Invalid or missing base URL"))
                return
            }

            let rawBody: String
            do {
                rawBody = try CryptoGCM.encrypt(byteArray.base64EncodedString(), iv)
            } catch {
                completion(Resource.error("Encryption failed: \(error.localizedDescription)"))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(iv.base64EncodedString(), forHTTPHeaderField: CryptoGCM.GET_IV_HEADER)
            request.httpBody = rawBody.data(using: .utf8)
            headerProvider.getCommonHeaders().forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }

            // Make network request
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    let errorMessage = "Network error: \(error.localizedDescription)"
//                    completion(Resource.error(errorMessage))
//                    return
//                }
//
//                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                    completion(Resource.error("Invalid response format"))
//                    return
//                }
//
//                // Parse the response and pass the IntelligenceResponse object to the completion handler
//                if let responseData = data {
//                    do {
//                        let intelligenceResponse = try JSONDecoder().decode(IntelligenceResponse.self, from: responseData)
//                        completion(Resource.success(intelligenceResponse))
//                    } catch {
//                        completion(Resource.error("Failed to decode response data: \(error.localizedDescription)"))
//                    }
//                } else {
//                    completion(Resource.error("Failed to parse response data."))
//                }
//            }.resume()
            
            let intelligenceResponse = IntelligenceResponse(
                deviceId: dataRequest.deviceParams.iOSDataRequest.iOSDeviceID,
                requestId: dataRequest.requestId,
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
                )
            )
            /// Store Response in RealmDataStorage
//            sign3Intelligence.realmDataStorage.saveIntelligenceResponseToRealm(dataRequest, sign3Intelligence, intelligenceResponse)
            
            /// Store Response in UserDefault
            sign3Intelligence.userDefaultsManager.saveIntelligenceResponseToUserDefaults(dataRequest, sign3Intelligence, intelligenceResponse)
    
            completion(Resource.success(intelligenceResponse))
        } catch {
            let errorMessage = "Failed to encode request data: \(error.localizedDescription)"
            completion(Resource.error(errorMessage))
        }
    }
    
}
