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
    public static let GET_IV_HEADER2 = "tenant-id"
    public static let GET_IV_HEADER = "tenant-id".uppercased()
    public static let GET_SECRET_KEY_ENCODED = "GET_SECRET_KEY_ENCODED";
    public static let GET_SECRET_KEY_ENCODED2 = "GET_SECRET_KEY_ENCODED".lowercased();
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

    static func encrypt2(_ inputString: String, _ IV: Data) -> String? {
        do {
            let key = key
            let inputData = Data(inputString.utf8)
            
            // Use the SymmetricKey and IV for encryption
            let sealedBox = try AES.GCM.seal(inputData, using: key!, nonce: AES.GCM.Nonce(data: IV))
        
            return sealedBox.combined!.base64EncodedString()
        } catch {
            print(error)
            return nil
        }
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


    static func decrypt(_ encryptedString: String?, _ IV: Data) throws -> String? {
        guard let key = key else { throw CryptoGCMError.keyNotInitialized }
        guard let combinedData = Data(base64Encoded: encryptedString ?? "") else {
            throw NSError(domain: "DecryptionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid base64 string"])
        }
        let nonce = try AES.GCM.Nonce(data: IV)
        let ciphertext = combinedData.dropLast(GCM_TAG_LENGTH)
        let tag = combinedData.suffix(GCM_TAG_LENGTH)
        
        
        let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        return String(data: decryptedData, encoding: .utf8)
    }
    
    static func decrypt(_ keyData: Data, _ encryptedString: Data, _ IV: Data) throws -> String? {
        //guard let key = key else { throw CryptoGCMError.keyNotInitialized }
        let combinedData = encryptedString
        let key = SymmetricKey(data: keyData)
        let nonce = try AES.GCM.Nonce(data: IV)
        let ciphertext = combinedData.dropLast(GCM_TAG_LENGTH)
        let tag = combinedData.suffix(GCM_TAG_LENGTH)
        
        
        let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
        let decryptedData = try AES.GCM.open(sealedBox, using: SymmetricKey(data: key))
        return String(data: decryptedData, encoding: .utf8)
    }

    static func decryptAESGCM(ciphertextBase64: String, keyBase64: String, nonceBase64: String) -> String? {
        // Decode Base64 inputs
        guard let keyData = Data(base64Encoded: keyBase64),
              let nonceData = Data(base64Encoded: nonceBase64),
              let ciphertextData = Data(base64Encoded: ciphertextBase64) else {
            print("Failed to decode Base64 inputs")
            return nil
        }

        // Create SymmetricKey and AES.GCM.Nonce
        let key = SymmetricKey(data: keyData)
        guard let nonce = try? AES.GCM.Nonce(data: nonceData) else {
            print("Invalid nonce")
            return nil
        }

        do {
            // Create SealedBox from ciphertext and tag
            let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertextData.dropLast(16), tag: ciphertextData.suffix(16))

            // Decrypt data
            let plaintextData = try AES.GCM.open(sealedBox, using: key)
            return String(data: plaintextData, encoding: .utf8)
        } catch {
            print("Decryption failed: \(error)")
            return nil
        }
    }
    
    
}


//internal class CryptoGCM {
//    public static let AES_KEY_SIZE = 32
//    public static let GCM_IV_LENGTH = 16
//    public static let GCM_TAG_LENGTH = 16
//    public static let ALGORITHM = "AES/GCM/NoPadding"
//    public static let GET_IV_HEADER = "TENANT-ID"
//    private static var key: SymmetricKey?
//    
//    private enum CryptoGCMError: Error {
//        case keyNotInitialized
//        case invalidBase64String
//        case invalidUTF8Data
//    }
//
//    internal static func initialize(_ password: String, _ salt: String) throws {
//        let keyData = try getKeyFromPassword(password: password, salt: salt)
//        key = SymmetricKey(data: keyData)
//    }
//
//    internal static func getIvHeader() -> Data {
//        var iv = Data(count: GCM_IV_LENGTH)
//        _ = iv.withUnsafeMutableBytes {
//            SecRandomCopyBytes(kSecRandomDefault, GCM_IV_LENGTH, $0.baseAddress!)
//        }
//        return iv
//    }
//
//    
//    private static func getKeyFromPassword(password: String, salt: String) throws -> Data {
//        
//        
//        let passwordData = password.data(using: .utf8)!
//        let saltData = salt.data(using: .utf8)!
//        
//        var derivedKey = Data(count: AES_KEY_SIZE)
//        derivedKey.withUnsafeMutableBytes { derivedKeyBytes in
//            saltData.withUnsafeBytes { saltBytes in
//                guard let saltBaseAddress = saltBytes.baseAddress,
//                      let derivedBaseAddress = derivedKeyBytes.baseAddress else {
//                    Log.e("EEEEEEEE", "Invalid Buffer Pointers")
//                    return
//                }
//
//                let result = CCKeyDerivationPBKDF(
//                    CCPBKDFAlgorithm(kCCPBKDF2),
//                    password,
//                    password.utf8.count,
//                    saltBaseAddress.assumingMemoryBound(to: UInt8.self),
//                    saltData.count,
//                    CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),
//                    65536,
//                    derivedBaseAddress.assumingMemoryBound(to: UInt8.self),
//                    AES_KEY_SIZE
//                )
//
//                if result != kCCSuccess {
//                    Log.e("EEEEEEEE", "Key derivation failed with error code: \(result)")
////                    print("Key derivation failed with error code: \(result)")
//                }
//            }
//        }
//
//        
////        var derivedKeyData = Data(repeating: 0, count: AES_KEY_SIZE / 8)
////        let status = derivedKeyData.withUnsafeMutableBytes { derivedKeyBytes in
////            saltData.withUnsafeBytes { saltBytes in
////                CCKeyDerivationPBKDF(
////                    CCPBKDFAlgorithm(kCCPBKDF2),
////                    password,
////                    passwordData.count,
////                    saltBytes.baseAddress!.assumingMemoryBound(to: UInt8.self),
////                    saltData.count,
////                    CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),
////                    65536,
////                    derivedKeyBytes.baseAddress!.assumingMemoryBound(to: UInt8.self),
////                    AES_KEY_SIZE
////                )
////            }
////        }
//        
////        if status != kCCSuccess {
////            throw NSError(domain: "KeyDerivationError", code: Int(status), userInfo: nil)
////        }
//        
//        return derivedKey
//    }
//
//    internal static func encrypt(_ inputString: String, _ IV: Data) throws -> String {
//        guard let key = key else { throw CryptoGCMError.keyNotInitialized }
//        let inputData = Data(inputString.utf8)
//        let sealedBox = try AES.GCM.seal(inputData, using: key, nonce: AES.GCM.Nonce(data: IV))
//        return sealedBox.combined?.base64EncodedString() ?? ""
//    }
//
//
////    func encrypt(inputString: String, key: Data, iv: Data) throws -> String {
////        let inputData = Data(inputString.utf8)
////        var cryptLength = inputData.count + kCCBlockSizeAES128
////        var cryptData = Data(count: cryptLength)
////
////        var tagData = Data(count: 16) // GCM tag length is 16 bytes
////        let keyLength = kCCKeySizeAES256 // 256-bit key size
////
////        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
////            tagData.withUnsafeMutableBytes { tagBytes in
////                inputData.withUnsafeBytes { inputBytes in
////                    key.withUnsafeBytes { keyBytes in
////                        iv.withUnsafeBytes { ivBytes in
////                            CCCryptorGCM(
////                                CCOperation(kCCEncrypt),
////                                CCAlgorithm(kCCAlgorithmAES),
////                                keyBytes.baseAddress, keyLength,
////                                ivBytes.baseAddress, iv.count,
////                                nil, 0, // AAD is nil in this case
////                                inputBytes.baseAddress, inputData.count,
////                                cryptBytes.baseAddress,
////                                tagBytes.baseAddress, tagData.count
////                            )
////                        }
////                    }
////                }
////            }
////        }
////
////        guard status == kCCSuccess else {
////            throw NSError(domain: "EncryptionError", code: Int(status), userInfo: nil)
////        }
////
////        // Append the tag to the ciphertext
////        cryptData.append(tagData)
////
////        // Convert encrypted data to Base64 string
////        return cryptData.base64EncodedString()
////    }
//
//
//    internal static func decrypt(_ encryptedString: String, _ IV: Data) throws -> String {
//        guard let key = key else { throw CryptoGCMError.keyNotInitialized }
//        guard let cipherData = Data(base64Encoded: encryptedString) else { throw CryptoGCMError.invalidBase64String }
//        
//        let sealedBox = try AES.GCM.SealedBox(combined: cipherData)
//        let decryptedData = try AES.GCM.open(sealedBox, using: key)
//        
//        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else { throw CryptoGCMError.invalidUTF8Data }
//        return decryptedString
//    }
//}
