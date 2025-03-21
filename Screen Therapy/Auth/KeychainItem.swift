//
//  KeychainItem.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/20/25.
//


import Foundation
import Security

struct KeychainItem {
    static let service = "com.777..Screen-Therapy" // Replace with your app's Bundle ID

    static func saveUserIdentifier(_ userIdentifier: String) {
        guard let data = userIdentifier.data(using: .utf8) else { return }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: "appleID",
            kSecValueData: data
        ]
        
        SecItemDelete(query as CFDictionary) // Remove any existing entry
        SecItemAdd(query as CFDictionary, nil) // Add new entry
    }

    static func currentUserIdentifier() -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: "appleID",
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    static func deleteUserIdentifier() {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: "appleID"
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
