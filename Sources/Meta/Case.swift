//
//  Case.swift
//  Meta
//
//  Created by Théophane Rupin on 3/8/19.
//

public struct CaseParameter: Hashable, MetaSwiftConvertible {
    
    public let name: String?
    
    public let type: TypeIdentifier
    
    public init(name: String? = nil, type: TypeIdentifier) {
        self.name = name
        self.type = type
    }
}

public struct Case: Hashable, Node {
    
    public let name: String
    
    public var parameters: [CaseParameter] = []
    
    public var value: Value?
    
    public init(name: String) {
        self.name = name
    }
    
    public func with(parameters: [CaseParameter]) -> Case {
        var _self = self
        _self.parameters = parameters
        return _self
    }
    
    public func adding(parameter: CaseParameter?) -> Case {
        var _self = self
        _self.parameters += [parameter].compactMap { $0 }
        return _self
    }
    
    public func adding(parameters: [CaseParameter]) -> Case {
        var _self = self
        _self.parameters += parameters
        return _self
    }
    
    public func with(value: Value?) -> Case {
        var _self = self
        _self.value = value
        return _self
    }
}

extension Case: TypeBodyMember {}

// MARK: - MetaSwiftConvertible

extension CaseParameter {
    
    public var swiftString: String {
        let name = self.name ?? .empty
        return "\(name.suffixed(": "))\(type.swiftString)"
    }
}

extension Case {

    public var swiftString: String {
        let parameters = self.parameters.map { $0.swiftString }.joined(separator: ", ").wrapped("(", ")")
        let value = self.value?.swiftString ?? .empty
        return "case \(name)\(parameters)\(value.prefixed(" = "))"
    }
}
