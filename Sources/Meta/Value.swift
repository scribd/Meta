//
//  Value.swift
//  Meta
//
//  Created by Théophane Rupin on 3/4/19.
//

import Foundation

public enum Value: Hashable, Node {
    case string(String)
    case int(Int)
    case bool(Bool)
    case float(Float)
    case double(Double)
    case reference(Reference)
    case `nil`
    indirect case array([Value])
}

extension Value: VariableValue {}
extension Value: CrossPlateformVariableValue {}

// MARK: - CrossPlateformVariableValue

extension Value {
    
    var plateforms: [String] {
        switch self {
        case .reference(let reference):
            return reference.plateforms
        case .array(let values):
            return values.flatMap { $0.plateforms }
        default:
            return []
        }
    }
    
    func filtering(for includedPlateforms: [String]) -> Value? {
        switch self {
        case .reference(let reference):
            guard let reference = reference.filtering(for: includedPlateforms) else {
                return nil
            }
            return .reference(reference)

        case .array(let values):
            let values = values.compactMap { $0.filtering(for: includedPlateforms) }
            guard values.isEmpty == false else {
                return nil
            }
            return .array(values)
            
        default:
            return self
        }
    }
}

// MARK: - MetaSwiftConvertible

extension Value {
    
    public var swiftString: String {
        switch self {
        case .string(let value):
            return value.wrapped(.doubleQuote, compact: false)
        case .int(let value):
            return value.description
        case .bool(let value):
            return value ? "true" : "false"
        case .float(let value):
            return value.description
        case .double(let value):
            return value.description
        case .reference(let reference):
            return reference.swiftString
        case .nil:
            return "nil"
        case .array(let values):
            return values
                .lazy
                .map { $0.swiftString }
                .joined(separator: ", ")
                .wrapped(.openingSquareBracket, .closingSquareBracket, compact: false)
        }
    }
}
