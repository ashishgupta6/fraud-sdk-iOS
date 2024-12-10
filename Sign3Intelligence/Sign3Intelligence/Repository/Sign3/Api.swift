//
//  Api.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 13/11/24.
//

import Foundation
import CryptoKit

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
                guard let base64Iv = httpResponse.allHeaderFields[CryptoGCM.GET_IV_HEADER2] as? String,
                      let _ = Data(base64Encoded: base64Iv) else {
                    completion(.error("Failed to retrieve or decode the IV from headers.", data: Config.getDefault()))
                    return
                }
                
                // Decrypt the response
                guard let decryptedString = try CryptoGCM.decryptAESGCM(
                    ciphertextBase64: String(data: responseData, encoding: .utf8) ?? "",
                    keyBase64: base64Iv,
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
}
