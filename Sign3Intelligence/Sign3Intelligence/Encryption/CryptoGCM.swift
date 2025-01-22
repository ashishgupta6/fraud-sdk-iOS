//
//  CryptoGCM.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 15/09/24.
//

import Foundation
import CryptoKit
import CommonCrypto

import Foundation
import CryptoKit

enum CryptoGCMError: Error {
    case keyNotInitialized
}

class CryptoGCM {
    public static let AES_KEY_SIZE = 32
    public static let GCM_IV_LENGTH = 12
    public static let GCM_TAG_LENGTH = 16
    public static let ALGORITHM = "AES/GCM/NoPadding"
    public static let GET_IV_HEADER = "tenant-id"
    private static var key: SymmetricKey?
    
    internal static func getIvHeader() -> Data {
        var iv = Data(count: GCM_IV_LENGTH)
        _ = iv.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, GCM_IV_LENGTH, $0.baseAddress!)
        }
        return iv
    }

    static func initialize(_ password: String, _ salt: String) throws {
        let derivedKey = try getKeyFromPassword(password: password, salt: salt)
        key = SymmetricKey(data: derivedKey) // Convert to SymmetricKey
    }

    private static func getKeyFromPassword(password: String, salt: String) throws -> Data {
        let saltData = Data(salt.utf8)
        var keyData = Data(count: 32) // 32 bytes for AES-256
        let keyDataCount = keyData.count
        let saltDataCount = saltData.count

        let result = keyData.withUnsafeMutableBytes { keyBytes in
            saltData.withUnsafeBytes { saltBytes in
                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password, password.utf8.count,
                    saltBytes.baseAddress!, saltDataCount,
                    CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),
                    65536,
                    keyBytes.baseAddress!.assumingMemoryBound(to: UInt8.self), keyDataCount
                )
            }
        }
        guard result == kCCSuccess else {
            throw NSError(domain: "KeyDerivationError", code: Int(result), userInfo: nil)
        }
        return keyData
    }

    static func encrypt(_ plaintext: String, _ IV: Data) throws -> String {
        // Ensure the encryption key is initialized
        guard let key = key else { throw CryptoGCMError.keyNotInitialized }
        
        // Convert the plaintext into Data
        guard let plaintextData = plaintext.data(using: .utf8) else {
            throw NSError(domain: "EncryptionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid plaintext string"])
        }
        
        // Ensure the IV is the correct size
        guard IV.count == 12 else {
            throw NSError(domain: "EncryptionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "IV must be 12 bytes for AES-GCM"])
        }
        
        // Create a Nonce from the IV
        let nonce = try AES.GCM.Nonce(data: IV)
        
        // Encrypt the data
        let sealedBox = try AES.GCM.seal(plaintextData, using: key, nonce: nonce)
        
        // Combine ciphertext and tag
        let combinedData = sealedBox.ciphertext + sealedBox.tag
        
        // Return the Base64-encoded string
        return combinedData.base64EncodedString()
    }

    static func decrypt(ciphertextBase64: String, nonceBase64: String) -> String? {
        // Decode Base64 inputs
        guard let nonceData = Data(base64Encoded: nonceBase64),
              let ciphertextData = Data(base64Encoded: ciphertextBase64) else {
            print("Failed to decode Base64 inputs")
            return nil
        }

        guard let nonce = try? AES.GCM.Nonce(data: nonceData) else {
            print("Invalid nonce")
            return nil
        }

        do {
            // Create SealedBox from ciphertext and tag
            let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertextData.dropLast(16), tag: ciphertextData.suffix(16))

            // Decrypt data
            let plaintextData = try AES.GCM.open(sealedBox, using: key!)
            return String(data: plaintextData, encoding: .utf8)
        } catch {
            print("Decryption failed: \(error)")
            return nil
        }
    }
}
