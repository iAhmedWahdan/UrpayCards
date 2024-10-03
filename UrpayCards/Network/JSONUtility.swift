//
//  JSONUtility.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 30/09/2024.
//

import Foundation

// MARK: - Error
public enum JSONUtilityError: Int, Swift.Error {
    case unsupportedType = 999
    case indexOutOfBounds = 900
    case elementTooDeep = 902
    case wrongType = 901
    case notExist = 500
    case invalidJSON = 490
}

extension JSONUtilityError: CustomNSError {
    public static var errorDomain: String {
        return "com.network.JSONUtility"
    }
    
    public var errorCode: Int {
        return self.rawValue
    }
    
    public var errorUserInfo: [String: Any] {
        switch self {
        case .unsupportedType:
            return [NSLocalizedDescriptionKey: "It is an unsupported type."]
        case .indexOutOfBounds:
            return [NSLocalizedDescriptionKey: "Array Index is out of bounds."]
        case .wrongType:
            return [NSLocalizedDescriptionKey: "Couldn't merge, because the JSONs differ in type on top level."]
        case .notExist:
            return [NSLocalizedDescriptionKey: "Dictionary key does not exist."]
        case .invalidJSON:
            return [NSLocalizedDescriptionKey: "JSON is invalid."]
        case .elementTooDeep:
            return [NSLocalizedDescriptionKey: "Element too deep. Increase maxObjectDepth and ensure no reference loop."]
        }
    }
}

// MARK: - JSON Type
public enum Type: Int {
case number, string, bool, array, dictionary, null, unknown
}

// MARK: - JSON Base
public struct JSON {
    
    public init(data: Data, options opt: JSONSerialization.ReadingOptions = []) throws {
        let object: Any = try JSONSerialization.jsonObject(with: data, options: opt)
        self.init(jsonObject: object)
    }
    
    public init(_ object: Any) {
        switch object {
        case let object as Data:
            do {
                try self.init(data: object)
            } catch {
                self.init(jsonObject: NSNull())
            }
        default:
            self.init(jsonObject: object)
        }
    }
    
    public init(parseJSON jsonString: String) {
        if let data = jsonString.data(using: .utf8) {
            self.init(data)
        } else {
            self.init(NSNull())
        }
    }
    
    fileprivate init(jsonObject: Any) {
        self.object = jsonObject
    }
    
    // MARK: - Private members
    fileprivate var rawArray: [Any] = []
    fileprivate var rawDictionary: [String: Any] = [:]
    fileprivate var rawString: String = ""
    fileprivate var rawNumber: NSNumber = 0
    fileprivate var rawNull: NSNull = NSNull()
    fileprivate var rawBool: Bool = false
    
    // MARK: - Public members
    public fileprivate(set) var type: Type = .null
    public fileprivate(set) var error: JSONUtilityError?
    
    public var object: Any {
        get {
            switch type {
            case .array:
                return rawArray
            case .dictionary:
                return rawDictionary
            case .string:
                return rawString
            case .number:
                return rawNumber
            case .bool:
                return rawBool
            default:
                return rawNull
            }
        }
        set {
            error = nil
            switch unwrap(newValue) {
            case let number as NSNumber:
                if number.isBool {
                    type = .bool
                    rawBool = number.boolValue
                } else {
                    type = .number
                    rawNumber = number
                }
            case let string as String:
                type = .string
                rawString = string
            case _ as NSNull:
                type = .null
            case Optional<Any>.none:
                type = .null
            case let array as [Any]:
                type = .array
                rawArray = array
            case let dictionary as [String: Any]:
                type = .dictionary
                rawDictionary = dictionary
            default:
                type = .unknown
                error = JSONUtilityError.unsupportedType
            }
        }
    }
    
    public static var null: JSON {
        return JSON(NSNull())
    }
    
    // MARK: - Convenience properties for extracting values without optionals
    public var stringValue: String {
        return type == .string ? rawString : ""
    }
    
    public var intValue: Int {
        return type == .number ? rawNumber.intValue : 0
    }
    
    public var boolValue: Bool {
        return type == .bool ? rawBool : false
    }
    
    public var arrayValue: [JSON] {
        return type == .array ? rawArray.map { JSON($0) } : []
    }
    
    public var dictionaryValue: [String: JSON] {
        return type == .dictionary ? rawDictionary.mapValues { JSON($0) } : [:]
    }
    
    // MARK: - Subscript support for accessing dictionary values
    public subscript(key: String) -> JSON {
        get {
            if type == .dictionary, let value = rawDictionary[key] {
                return JSON(value)
            }
            return JSON.null
        }
        set {
            if type == .dictionary {
                rawDictionary[key] = newValue.object
            }
        }
    }
}

// MARK: - NSNumber Extension for `isBool` Check
private let trueNumber = NSNumber(value: true)
private let falseNumber = NSNumber(value: false)

extension NSNumber {
    /// Check if NSNumber represents a boolean value
    var isBool: Bool {
        let objCType = String(cString: self.objCType)
        return (self.compare(trueNumber) == .orderedSame && objCType == String(cString: trueNumber.objCType)) ||
        (self.compare(falseNumber) == .orderedSame && objCType == String(cString: falseNumber.objCType))
    }
}

// MARK: - Private method to unwrap object recursively
private func unwrap(_ object: Any) -> Any {
    switch object {
    case let json as JSON:
        return unwrap(json.object)
    case let array as [Any]:
        return array.map(unwrap)
    case let dictionary as [String: Any]:
        var d = dictionary
        dictionary.forEach { pair in
            d[pair.key] = unwrap(pair.value)
        }
        return d
    default:
        return object
    }
}
