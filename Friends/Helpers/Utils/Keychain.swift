//
//  KeychainWrapper.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import Foundation

enum KeychainError: Error {
    case saveError(status: OSStatus)
    case retrieveError(status: OSStatus)
    case unhandledError(status: OSStatus)
}

nonisolated struct Keychain {
    static func set<T: Encodable>(_ value: T,_ key: String) throws {
        let data = try JSONEncoder().encode(value)
        
        _ = delete(key) // delete before saving
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveError(status: status)
        }
    }
    
    static func get<T: Decodable>(_ key: String) throws -> T? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            return nil
        }
        guard status == errSecSuccess, let data = item as? Data else {
            throw KeychainError.retrieveError(status: status)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    static func delete(_ key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
