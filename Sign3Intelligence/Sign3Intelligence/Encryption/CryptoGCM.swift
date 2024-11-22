//
//  CryptoGCM.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 15/09/24.
//

import Foundation
import CryptoKit
import CommonCrypto

internal class CryptoGCM {
    public static let AES_KEY_SIZE = 256
    public static let GCM_IV_LENGTH = 16
    public static let GCM_TAG_LENGTH = 16
    public static let ALGORITHM = "AES/GCM/NoPadding"
    public static let GET_IV_HEADER = "TENANT-ID"
    private static var key: SymmetricKey?
    
    private enum CryptoGCMError: Error {
        case keyNotInitialized
        case invalidBase64String
        case invalidUTF8Data
    }

    internal static func initialize(_ password: String, _ salt: String) throws {
        let keyData = try getKeyFromPassword(password: password, salt: salt)
        key = SymmetricKey(data: keyData)
    }

    internal static func getIvHeader() -> Data {
        var iv = Data(count: GCM_IV_LENGTH)
        _ = iv.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, GCM_IV_LENGTH, $0.baseAddress!)
        }
        return iv
    }

    private static func getKeyFromPassword(password: String, salt: String) throws -> Data {
        let passwordData = password.data(using: .utf8)!
        let saltData = salt.data(using: .utf8)!
        
        var derivedKeyData = Data(repeating: 0, count: AES_KEY_SIZE)
        let status = derivedKeyData.withUnsafeMutableBytes { derivedKeyBytes in
            saltData.withUnsafeBytes { saltBytes in
                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password,
                    passwordData.count,
                    saltBytes.baseAddress!.assumingMemoryBound(to: UInt8.self),
                    saltData.count,
                    CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),
                    65536,
                    derivedKeyBytes.baseAddress!.assumingMemoryBound(to: UInt8.self),
                    AES_KEY_SIZE
                )
            }
        }
        
        if status != kCCSuccess {
            throw NSError(domain: "KeyDerivationError", code: Int(status), userInfo: nil)
        }
        
        return derivedKeyData
    }

    internal static func encrypt(_ inputString: String, _ IV: Data) throws -> String {
        guard let key = key else { throw CryptoGCMError.keyNotInitialized }
        let inputData = Data(inputString.utf8)
        let sealedBox = try AES.GCM.seal(inputData, using: key, nonce: AES.GCM.Nonce(data: IV))
        return sealedBox.combined!.base64EncodedString()
    }

    internal static func decrypt(_ encryptedString: String, _ IV: Data) throws -> String {
        guard let key = key else { throw CryptoGCMError.keyNotInitialized }
        guard let cipherData = Data(base64Encoded: encryptedString) else { throw CryptoGCMError.invalidBase64String }
        
        let sealedBox = try AES.GCM.SealedBox(combined: cipherData)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else { throw CryptoGCMError.invalidUTF8Data }
        return decryptedString
    }
}
