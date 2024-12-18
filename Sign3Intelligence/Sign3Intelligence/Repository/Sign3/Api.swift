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
    
    
    private init() {
        self.baseUrl = Sign3IntelligenceInternal.sdk?.keyProvider?.baseUrl
        self.clientId = Sign3IntelligenceInternal.sdk?.options?.clientId ?? ""
        self.clientSecret = Sign3IntelligenceInternal.sdk?.options?.clientSecret ?? ""
        self.headerProvider = HeaderProvider(clientId: clientId, clientSecret: clientSecret)
    }
    
    internal func getConfig(completion: @escaping (Result<String, Error>) -> Void) {
        guard let baseUrl = baseUrl, let url = URL(string: "\(baseUrl)v1/device/config") else {
            print("Error: Invalid or missing base URL.")
            completion(.failure(NSError(domain: "URLError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid or missing base URL."])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        headerProvider.getCommonHeaders().forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  let responseData = data else {
                completion(.failure(NSError(domain: "ResponseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing or invalid response."])))
                return
            }
            
            // Log response status and headers
            print("Response Status: \(httpResponse.statusCode)")
            
            // Extract the IV from headers
            guard let ivBase64 = httpResponse.value(forHTTPHeaderField: CryptoGCM.GET_IV_HEADER),
                  let iv = Data(base64Encoded: ivBase64) else {
                let error = NSError(domain: "DecryptionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing or invalid IV header."]);
                completion(.failure(error))
                return
            }
            
            // Log the IV for verification
            print("IV: \(iv.base64EncodedString())")
            
            // Attempt decryption
            do {
                let decryptedString = try
                CryptoGCM.decrypt(responseData.base64EncodedString(), iv)
                completion(.success(decryptedString))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
}
