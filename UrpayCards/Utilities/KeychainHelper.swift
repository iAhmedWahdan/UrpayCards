//
//  KeychainHelper.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 06/10/2024.
//

import Foundation
import Security

class KeychainHelper {

    static let shared = KeychainHelper()

    private init() {}

    func save(key: String, data: Data) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : "com.urpay.cardsSDK",
            kSecAttrAccount as String : key,
            kSecValueData as String   : data
        ] as [String : Any]

        // Delete any existing items
        SecItemDelete(query as CFDictionary)

        // Add the new keychain item
        let status = SecItemAdd(query as CFDictionary, nil)

        return status == errSecSuccess
    }

    func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : "com.urpay.cardsSDK",
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ] as [String : Any]

        var dataTypeRef: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            return nil
        }
    }

    func delete(key: String) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : "com.urpay.cardsSDK",
            kSecAttrAccount as String : key
        ] as [String : Any]

        let status = SecItemDelete(query as CFDictionary)

        return status == errSecSuccess
    }

    func clearAll() {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : "com.urpay.cardsSDK"
        ] as [String : Any]

        SecItemDelete(query as CFDictionary)
    }
}
