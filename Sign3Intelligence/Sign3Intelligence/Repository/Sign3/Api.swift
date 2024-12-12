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
            let byteArray = gzip(jsonData, COMPRESSION_STREAM_ENCODE)
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
                rawBody = try CryptoGCM.encrypt(byteArray?.base64EncodedString() ?? "", iv)
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
                issimulatorDetected: dataRequest.deviceParams.iOSDataRequest.simulator,
                isJailbroken: dataRequest.deviceParams.iOSDataRequest.jailBroken,
                isVpnEnabled: dataRequest.deviceParams.iOSDataRequest.isVpn,
                isGeoSpoofed: dataRequest.deviceParams.iOSDataRequest.isGeoSpoofed,
                isAppTamperedL: dataRequest.deviceParams.iOSDataRequest.isAppTampering,
                isHooked: dataRequest.deviceParams.iOSDataRequest.hooking,
                isProxyDetected: dataRequest.deviceParams.iOSDataRequest.proxy,
                isMirroredScreenDetected: dataRequest.deviceParams.iOSDataRequest.mirroredScreen,
                gpsLocation: GPSLocation(
                    latitude: dataRequest.deviceParams.networkData.networkLocation.latitude,
                    longitude: dataRequest.deviceParams.networkData.networkLocation.longitude,
                    altitude: dataRequest.deviceParams.networkData.networkLocation.altitude
                )
            )
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
            let byteArray = gzip(jsonData, COMPRESSION_STREAM_ENCODE)
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
                rawBody = try CryptoGCM.encrypt(byteArray?.base64EncodedString() ?? "", iv)
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
                issimulatorDetected: dataRequest.deviceParams.iOSDataRequest.simulator,
                isJailbroken: dataRequest.deviceParams.iOSDataRequest.jailBroken,
                isVpnEnabled: dataRequest.deviceParams.iOSDataRequest.isVpn,
                isGeoSpoofed: dataRequest.deviceParams.iOSDataRequest.isGeoSpoofed,
                isAppTamperedL: dataRequest.deviceParams.iOSDataRequest.isAppTampering,
                isHooked: dataRequest.deviceParams.iOSDataRequest.hooking,
                isProxyDetected: dataRequest.deviceParams.iOSDataRequest.proxy,
                isMirroredScreenDetected: dataRequest.deviceParams.iOSDataRequest.mirroredScreen,
                gpsLocation: GPSLocation(
                    latitude: dataRequest.deviceParams.networkData.networkLocation.latitude,
                    longitude: dataRequest.deviceParams.networkData.networkLocation.longitude,
                    altitude: dataRequest.deviceParams.networkData.networkLocation.altitude
                )
            )
            completion(Resource.success(intelligenceResponse))
        } catch {
            let errorMessage = "Failed to encode request data: \(error.localizedDescription)"
            completion(Resource.error(errorMessage))
        }
    }

    
    private func gzip(_ data: Data, _ operation: compression_stream_operation) -> Data? {
        let streamPointer = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1)
        defer { streamPointer.deallocate() }

        var stream = streamPointer.pointee
        var status = compression_stream_init(&stream, operation, Algorithm.zlib.rawValue)
        guard status == COMPRESSION_STATUS_OK else { return nil }

        defer { compression_stream_destroy(&stream) }

        let bufferSize = 64 * 1024
        let destinationPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { destinationPointer.deallocate() }

        var outputData = Data()
        data.withUnsafeBytes { (sourcePointer: UnsafeRawBufferPointer) in
            guard let sourceBaseAddress = sourcePointer.baseAddress else { return }

            stream.src_ptr = sourceBaseAddress.assumingMemoryBound(to: UInt8.self)
            stream.src_size = data.count

            repeat {
                stream.dst_ptr = destinationPointer
                stream.dst_size = bufferSize

                status = compression_stream_process(&stream, Int32(COMPRESSION_STREAM_FINALIZE.rawValue))

                switch status {
                case COMPRESSION_STATUS_OK, COMPRESSION_STATUS_END:
                    let outputSize = bufferSize - stream.dst_size
                    outputData.append(destinationPointer, count: outputSize)
                default:
                    return
                }
            } while status == COMPRESSION_STATUS_OK
        }

        return status == COMPRESSION_STATUS_END ? outputData : nil
    }
}
