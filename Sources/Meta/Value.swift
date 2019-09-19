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
            var expression = String()
            values.dropLast().forEach { expression.append("\n\($0.swiftString),") }
            let newlineOperator = values.isEmpty ? String() : "\n"
            expression.append("\(newlineOperator)\(values.last?.swiftString ?? String())")
            return expression.wrapped(.openingSquareBracket, "\(newlineOperator)\(String.closingSquareBracket)", compact: false)
        }
    }
}
