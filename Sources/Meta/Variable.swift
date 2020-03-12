//
//  VariableDecl.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

public enum VariableKind: String, MetaSwiftConvertible {
    case `lazy`
    case `weak`
    case none = ""
    
    public static let `default`: VariableKind = .none
}

public struct Variable: Hashable, MetaSwiftConvertible {

    public let name: String
    
    public var type: TypeIdentifier?
    
    public var kind: VariableKind = .default
    
    public var immutable = true
    
    public var `static` = false
    
    public var `as` = false
    
    public var plateforms: [String] = []
    
    public init(name: String) {
        self.name = name
    }
    
    public func with(type: TypeIdentifier?) -> Variable {
        var _self = self
        _self.type = type
        return _self
    }
    
    public func with(kind: VariableKind) -> Variable {
        var _self = self
        _self.kind = kind
        return _self
    }
    
    public func with(immutable: Bool) -> Variable {
        var _self = self
        _self.immutable = immutable
        return _self
    }
    
    public func with(static: Bool) -> Variable {
        var _self = self
        _self.static = `static`
        return _self
    }
    
    public func with(as: Bool) -> Variable {
        var _self = self
        _self.as = `as`
        return _self
    }
    
    public var reference: Reference {
        return ._name(.custom(name), plateforms: [])
    }
}

public struct Assignment: Hashable, Node {
    
    public var variables: [AssignmentVariable] = []
    
    public let value: VariableValue
    
    public var plateforms: [String] = []

    public init(variable: AssignmentVariable, value: VariableValue) {
        self.variables = [variable]
        self.value = value
    }
    
    public func adding(variable: AssignmentVariable?) -> Assignment {
        var _self = self
        _self.variables += [variable].compactMap { $0 }
        return _self
    }
    
    public func adding(variables: [AssignmentVariable]) -> Assignment {
        var _self = self
        _self.variables += variables
        return _self
    }
}

extension Array: VariableValue, Node where Element: FunctionBodyMember {}
extension Variable: FileBodyMember {}
extension Variable: FunctionBodyMember {}
extension Variable: TypeBodyMember {}
extension Variable: AssignmentVariable {}
extension Variable: CrossPlateformMember {}
extension Assignment: FunctionBodyMember {}
extension Assignment: CrossPlateformMember {}

// MARK: - MetaSwiftConvertible

extension Variable {
    
    public var internalSwiftString: String {
        let kind = self.kind.swiftString.suffixed(" ")
        let typePrefix = self.as ? " as " : ": "
        let type = self.type?.swiftString.prefixed(typePrefix) ?? .empty
        let `static` = self.static ? "static " : .empty
        let immutable = self.immutable ? "let" : "var"
        return "\(`static`)\(kind)\(immutable) \(name)\(type)"
    }
}

extension Assignment {
    
    public var internalSwiftString: String {
        var variables = self.variables.map { $0.swiftString }.joined(separator: ", ")
        if self.variables.count > 1 {
           variables = variables.wrapped("(", ")")
        }
        return "\(variables) = \(value.swiftString.trimmingCharacters(in: .whitespaces))"
    }
}
