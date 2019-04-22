//
//  Property.swift
//  Meta
//
//  Created by Théophane Rupin on 3/4/19.
//

public struct Property: Node {
    
    public var accessLevel: AccessLevel = .default

    public let variable: Variable
    
    public var value: VariableValue?
    
    public init(variable: Variable) {
        self.variable = variable
    }
    
    public func with(accessLevel: AccessLevel) -> Property {
        var _self = self
        _self.accessLevel = accessLevel
        return _self
    }
    
    public func with(value: VariableValue?) -> Property {
        var _self = self
        _self.value = value
        return _self
    }
}

extension Property: TypeBodyMember {}

public struct ProtocolProperty: Node {
    
    public let name: String
    
    public let type: TypeIdentifier
    
    public var setter = false
    
    public init(name: String, type: TypeIdentifier) {
        self.name = name
        self.type = type
    }
    
    public func with(setter: Bool) -> ProtocolProperty {
        var _self = self
        _self.setter = setter
        return _self
    }
}

extension ProtocolProperty: TypeBodyMember {}

public struct ComputedProperty: Node {
    
    public var accessLevel: AccessLevel = .default

    public let variable: Variable
    
    public var body: [FunctionBodyMember] = []
    
    public init(variable: Variable) {
        self.variable = variable
    }
    
    public func with(accessLevel: AccessLevel) -> ComputedProperty {
        var _self = self
        _self.accessLevel = accessLevel
        return _self
    }
    
    public func with(body: [FunctionBodyMember]) -> ComputedProperty {
        var _self = self
        _self.body = body
        return _self
    }
    
    public func adding(member: FunctionBodyMember?) -> ComputedProperty {
        var _self = self
        _self.body += [member].compactMap { $0 }
        return _self
    }
    
    public func adding(members: [FunctionBodyMember]) -> ComputedProperty {
        var _self = self
        _self.body += members
        return _self
    }
}

extension ComputedProperty: TypeBodyMember {}

// MARK: - MetaSwiftConvertible

extension Property {
    
    public var swiftString: String {
        let value = self.value?.swiftString.prefixed(" = ") ?? .empty
        return "\(accessLevel.swiftString.suffixed(" "))\(variable.swiftString)\(value)"
    }
}

extension ProtocolProperty {
    
    public var swiftString: String {
        return "var \(name): \(type.swiftString) { get\(setter ? " set" : .empty) }"
    }
}

extension ComputedProperty {
    
    public var swiftString: String {
        return """
        \(accessLevel.swiftString.suffixed(" "))\(variable.with(immutable: false).swiftString) {
        \(body.map { $0.swiftString }.indented)
        }
        """
    }
}
