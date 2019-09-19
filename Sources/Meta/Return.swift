//
//  Return.swift
//  Meta
//
//  Created by Théophane Rupin on 3/4/19.
//

public struct Return: Hashable, Node {
    
    public let value: VariableValue
    
    public init(value: VariableValue) {
        self.value = value
    }
}

extension Return: FunctionBodyMember {}

// MARK: - MetaSwiftConvertible

extension Return {
    
    public var swiftString: String {
        return "return \(value.swiftString)"
    }
}
