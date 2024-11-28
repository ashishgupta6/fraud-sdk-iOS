//
//  DeviceCheckValidator.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 28/11/24.
//

import Foundation
import CryptoKit

internal struct DeviceCheckValidator {
    internal static let teamID = "A8YD7RNP82"
    internal static let keyID = "S23G433686"
    internal static let privateKeyPath = "AuthKey.p8" // Path to your .p8 private key file
    internal static let deviceCheckURL = "https://api.devicecheck.apple.com/v1/update_two_bits"
    
    
    internal static func main(deviceToken: String) {
        Task {
            do {
                Utils.showInfologs(tags: "TAG_TEAM ID", value: "\(teamID)")
                Utils.showInfologs(tags: "TAG_TEAM", value: "\(keyID)")
                Utils.showInfologs(tags: "TAG_DEVICE_TOKEN", value: "\(deviceToken)")
                
                // Generate JWT
                let jwt = try generateJWT()

                // Validate the device
                try await validateDeviceToken(deviceToken: deviceToken, jwt: jwt)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    internal static func loadAuthKey() -> String {
        do {
            // Access the AuthKey.p8 file within the framework's bundle
            let bundle = Bundle(for: Sign3Intelligence.self) // Replace with a class from your framework
            let path = bundle.path(forResource: "AuthKey", ofType: "p8")
            
            guard let filePath = path else {
                throw NSError(domain: "Error: AuthKey.p8 file not found in the framework bundle.", code: -1, userInfo: nil)
            }
            
            let keyContent = try String(contentsOfFile: filePath, encoding: .utf8)
            let privateKeyPEM = keyContent
                .replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
                .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
                .replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
            
            // Ensure the cleaned private key is valid
            guard !privateKeyPEM.isEmpty else {
                throw NSError(domain: "Invalid private key format", code: -1, userInfo: nil)
            }
            
            return privateKeyPEM
        } catch {
            Utils.showInfologs(tags: "TAG_filePath", value: "\(error)")
            return ""
        }
    }
    
    internal static func generateJWT() throws -> String {
        Utils.showInfologs(tags: "TAG_PRIVATE_KEY_PATH", value: loadAuthKey())
        
        guard let privateKeyBytes = Data(base64Encoded: loadAuthKey()) else {
            throw NSError(domain: "Unable to decode private key", code: -1, userInfo: nil)
        }

        // Create the private key from the raw bytes
        let privateKey = try P256.Signing.PrivateKey(rawRepresentation: privateKeyBytes)
    
        
        // Create JWT header
        let header: [String: String] = [
            "alg": "ES256",
            "kid": keyID
        ]
        
        // Create JWT payload
        let currentTime = Date().timeIntervalSince1970
        let payload: [String: Any] = [
            "iss": teamID,
            "iat": Int(currentTime),
            "exp": Int(currentTime + 3600) // Expiration: 1 hour
        ]
        
        // Serialize header and payload to JSON data
        let headerData = try JSONSerialization.data(withJSONObject: header, options: [])
        let payloadData = try JSONSerialization.data(withJSONObject: payload, options: [])
        
        // Base64 URL encode the header and payload
        let headerBase64 = headerData.base64EncodedString().replacingOccurrences(of: "=", with: "")
        let payloadBase64 = payloadData.base64EncodedString().replacingOccurrences(of: "=", with: "")
        
        // Construct the JWT string without signature
        let jwtString = "\(headerBase64).\(payloadBase64)"
        
        // Sign the JWT with the private key
        let signature = try privateKey.signature(for: Data(jwtString.utf8))
        
        // Base64 URL encode the signature
        let signatureBase64 = signature.rawRepresentation.base64EncodedString().replacingOccurrences(of: "=", with: "")
        
        //Print JWT Token
        Utils.showInfologs(tags: "TAG_JWT", value: "\(jwtString).\(signatureBase64)")
        
        // Return the complete JWT
        return "\(jwtString).\(signatureBase64)"
    }
    
    internal static func validateDeviceToken(deviceToken: String, jwt: String) async throws {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let transactionId = UUID().uuidString
        let bit0 = true
        let bit1 = true
        
        // Create request URL
        guard let url = URL(string: deviceCheckURL) else {
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }
        
        // Prepare request body
        let requestBody: [String: Any] = [
            "device_token": deviceToken,
            "timestamp": timestamp,
            "transaction_id": transactionId,
            "bit0": bit0,
            "bit1": bit1
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        
        // Create and configure the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        print("Request Body: \(String(data: jsonData, encoding: .utf8) ?? "")")
        
        // Send the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Handle the response
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Code: \(httpResponse.statusCode)")
            if let responseBody = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseBody)")
            }
        }
    }
}
