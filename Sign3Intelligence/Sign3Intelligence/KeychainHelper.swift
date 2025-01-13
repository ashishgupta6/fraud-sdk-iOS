//
//  KeychainHelper.swift
//  Sign3Intelligence
//
//  Created by Sreyans Bohara on 02/01/25.
//


import Foundation
import Security

internal class KeychainHelper {
    static let shared = KeychainHelper()

    private init() {}
    
    // Save a value to the UserDefaults
    func saveUserDefaults(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    // Delete a value from the UserDefaults
    func deleteUserDefaults(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    // Retrieve a value from the UserDefaults
    func retrieveUserDefaults(key: String) -> String? {
        UserDefaults.standard.string(forKey: key)
    }
    
    func saveDeviceFingerprint(deviceFingerprint: String) -> Bool {
        do {
            let fpKey = "fpInfo"
            let fingerprint = DeviceFingerprint(deviceId: deviceFingerprint)
            guard let jsonString = try String(data: JSONEncoder().encode(fingerprint), encoding: .utf8) else {
                return false
            }
            saveUserDefaults(key: fpKey, value: jsonString)
            save(key: fpKey, value: jsonString)
            return true
        } catch {
            return false
        }
    }
    
    func retrieveDeviceFingerprint() -> DeviceFingerprint? {
        let fpKey = "fpInfo"
        let fpValueFromLocal = retrieveUserDefaults(key: fpKey)
        let fpValueFromKeychain = retrieve(key: fpKey)
        
        if(fpValueFromLocal == nil && fpValueFromKeychain == nil) {
            return nil
        } else if(fpValueFromKeychain == nil) {
            save(key: fpKey, value: fpValueFromLocal ?? "")
            return getDeviceFingerprintObject(fpValueFromLocal)
        }  else if(fpValueFromLocal == nil) {
            saveUserDefaults(key: fpKey, value: fpValueFromKeychain ?? "")
            return getDeviceFingerprintObject(fpValueFromKeychain)
        } else {
            //no such cases -- Need to be modified later
            return getDeviceFingerprintObject(fpValueFromKeychain)
        }
        
    }
    
    private func getDeviceFingerprintObject(_ jsonString: String?) -> DeviceFingerprint? {
        do {
            guard jsonString != nil else { return nil }
            let jsonData = jsonString!.data(using: .utf8) ?? Data()
            return try JSONDecoder().decode(DeviceFingerprint.self, from: jsonData)
        } catch {
            return nil
        }
    }

    // Save a value to the Keychain
    func save(key: String, value: String) -> Bool {
        guard let valueData = value.data(using: .utf8) else { return false }

        // Remove any existing item with the same key
        delete(key: key)

        // Add the new key-value pair
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: valueData
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    // Retrieve a value from the Keychain
    func retrieve(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecSuccess, let data = item as? Data {
            return String(data: data, encoding: .utf8)
        }

        return nil
    }

    // Delete a value from the Keychain
    func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }

    func storeSecureKey(key: String, value: String) -> Bool {
        guard let accessControl = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, // Requires a passcode to be set
            .userPresence, // Requires biometrics or passcode
            nil
        ) else {
            print("Failed to create SecAccessControl")
            return false
        }

        guard let valueData = value.data(using: .utf8) else { return false }

        // Define Keychain item attributes
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: valueData,
            kSecAttrAccessControl as String: accessControl
        ]

        // Add the item to the Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print("Key stored successfully")
            return true
        } else {
            print("Error storing key: \(status)")
            return false
        }
    }
    
    func retrieveSecureKey(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecUseOperationPrompt as String: "Authenticate to access your key"
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecSuccess, let data = item as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            print("Error retrieving key: \(status)")
            return nil
        }
    }
    
    func deleteSecureKey(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }



}
