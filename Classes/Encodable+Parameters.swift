//
//  Encodable+Parameters.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 26/09/2024.
//

import Foundation

extension Encodable {
    
    /// Convert Encodable object to dictionary `[String: Any]`
    var parameters: [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            return jsonObject as? [String: Any]
        } catch {
            print("Failed to convert to parameters: \(error)")
            return nil
        }
    }
    
    /// Convert Encodable object to non-empty dictionary `[String: Any]`
    var nonEmptyParameters: [String: Any]? {
        return parameters?.filter { row in
            if let string = row.value as? String {
                return !string.isEmpty
            }
            return true
        }
    }
    
    /// Convert Encodable object to JSON string
    var jsonString: String? {
        do {
            let data = try JSONEncoder().encode(self)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Failed to convert to JSON string: \(error)")
            return nil
        }
    }
}
