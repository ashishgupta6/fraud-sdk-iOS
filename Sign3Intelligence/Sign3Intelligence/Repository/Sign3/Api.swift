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

            do {
//                var stringToEncrypt = "Hello Ashishbdjhs!"
//                let iv = CryptoGCM.getIvHeader()
//                Log.e("RRRRRRR"," encryption started")
//                let encryptedString = try CryptoGCM.encrypt(stringToEncrypt, iv)
//                Log.e("RRRRRRR","encrypted string \(encryptedString)")
//                let decryptedString = try CryptoGCM.decrypt(encryptedString, iv)
//                Log.e("RRRRRRR","\(stringToEncrypt) \(decryptedString)")
        
                // Attempt to retrieve and decode the IV from the headers
                guard let base64Iv = httpResponse.allHeaderFields[CryptoGCM.GET_IV_HEADER] as? String,
                      let receivedIv = Data(base64Encoded: base64Iv) else {
                    print("TAG_Error: Failed to retrieve or decode the IV from headers")
                    completion(.failure(NSError(domain: "IVError", code: -1, userInfo: [NSLocalizedDescriptionKey: "TAG_Failed to retrieve or decode the IV from headers."])))
                    return
                }
                print("TAG_IV: \(receivedIv.base64EncodedString()), \(receivedIv)")
                
                guard let base64KeyEncoded = httpResponse.allHeaderFields[CryptoGCM.GET_SECRET_KEY_ENCODED] as? String,
                      let receivedKey = Data(base64Encoded: base64KeyEncoded) else {
                    print("TAG_Error: Failed to retrieve or decode the key from headers")
                    completion(.failure(NSError(domain: "KeyError", code: -1, userInfo: [NSLocalizedDescriptionKey: "TAG_Failed to retrieve or decode the key from headers."])))
                    return
                }

                // Decrypt the response data using AES-GCM
//                let decryptedData = try CryptoGCM.decrypt(receivedKey ,Data(base64Encoded: responseData.base64EncodedString())!, receivedIv);
                let decryptedData = try CryptoGCM.decryptAESGCM(ciphertextBase64: String(data: responseData, encoding: .utf8) ?? "", keyBase64: base64KeyEncoded ?? "", nonceBase64: base64Iv ?? "");
                print("TAG_Response: \(decryptedData)")
            } catch {
                print("TAG_Decryption Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
        }.resume()
    }

    
}
