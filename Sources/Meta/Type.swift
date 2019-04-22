//
//  Type.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

public enum TypeKind: MetaSwiftConvertible {
    case `struct`
    case `class`(final: Bool)
    case `protocol`
    case `enum`
    
    static let `default`: TypeKind = .class(final: true)
}

public enum TypeIdentifierName: Hashable, MetaSwiftConvertible {
    case string
    case bool
    case int
    case int32
    case int64
    case double
    case float
    case array
    case optional
    case void
    case dictionary
    case data
    case any
    case custom(String)
    indirect case dot(TypeIdentifierName, TypeIdentifierName)
    
    public var string: String {
        switch self {
        case .array:
            return "Array"
        case .bool:
            return "Bool"
        case .double:
            return "Double"
        case .float:
            return "Float"
        case .int:
            return "Int"
        case .int32:
            return "Int32"
        case .int64:
            return "Int64"
        case .optional:
            return "Optional"
        case .string:
            return "String"
        case .void:
            return "Void"
        case .data:
            return "Data"
        case .dictionary:
            return "Dictionary"
        case .any:
            return "Any"
        case .custom(let name):
            return name
        case .dot(let lhs, let rhs):
            return "\(lhs.string).\(rhs.string)"
        }
    }
}

public func + (_ lhs: TypeIdentifierName, _ rhs: TypeIdentifierName) -> TypeIdentifierName {
    return .dot(lhs, rhs)
}

public func + (_ lhs: TypeIdentifierName, _ rhs: String) -> TypeIdentifierName {
    return .dot(lhs, .custom(rhs))
}

public struct TypeIdentifier: Hashable, MetaSwiftConvertible {
    
    public let name: TypeIdentifierName
    
    public var genericParameters: [TypeIdentifier] = []
    
    public var implicitUnwrap: Bool = false
    
    public init(name: String) {
        self.name = .custom(name)
    }
    
    public init(name: TypeIdentifierName) {
        self.name = name
    }
    
    public func with(genericParameters: [TypeIdentifier]) -> TypeIdentifier {
        var _self = self
        _self.genericParameters = genericParameters
        return _self
    }
    
    public func adding(genericParameter: TypeIdentifier?) -> TypeIdentifier {
        var _self = self
        _self.genericParameters += [genericParameter].compactMap { $0 }
        return _self
    }

    public func adding(genericParameters: [TypeIdentifier]) -> TypeIdentifier {
        var _self = self
        _self.genericParameters += genericParameters
        return _self
    }
    
    public func with(implicitUnwrap: Bool) -> TypeIdentifier {
        var _self = self
        _self.implicitUnwrap = implicitUnwrap
        return _self
    }
    
    public static let string = TypeIdentifier(name: .string)
    public static let bool = TypeIdentifier(name: .bool)
    public static let int = TypeIdentifier(name: .int)
    public static let int32 = TypeIdentifier(name: .int32)
    public static let int64 = TypeIdentifier(name: .int64)
    public static let double = TypeIdentifier(name: .double)
    public static let float = TypeIdentifier(name: .float)
    public static let void = TypeIdentifier(name: .void)
    public static let data = TypeIdentifier(name: .data)
    public static let any = TypeIdentifier(name: .any)

    public static func dictionary(key: TypeIdentifier? = nil,
                                  value: TypeIdentifier? = nil) -> TypeIdentifier {

        return TypeIdentifier(name: .dictionary)
            .adding(genericParameter: key)
            .adding(genericParameter: value)
    }
    
    public static func array(element: TypeIdentifier? = nil) -> TypeIdentifier {
        return TypeIdentifier(name: .array)
            .adding(genericParameter: element)
    }
    
    public static func optional(wrapped: TypeIdentifier? = nil) -> TypeIdentifier {
        return TypeIdentifier(name: .optional)
            .adding(genericParameter: wrapped)
    }

    public static func named(_ name: String) -> TypeIdentifier {
        return TypeIdentifier(name: name)
    }
    
    public var reference: Reference {
        return .type(self)
    }
}

public struct Type: FileBodyMember, TypeBodyMember {
    
    public let name: TypeIdentifierName
    
    public var genericParameters: [GenericParameter] = []
    
    public var inheritedTypes: [TypeIdentifier] = []
    
    public var kind: TypeKind = .default

    public var accessLevel: AccessLevel = .default
    
    public var body: [TypeBodyMember] = []
    
    public var constraints: [LogicalStatement] = []

    public init(name: TypeIdentifierName) {
        self.name = name
    }

    public init(identifier: TypeIdentifier) {
        self.name = identifier.name
    }
    
    public func with(kind: TypeKind) -> Type {
        var _self = self
        _self.kind = kind
        return _self
    }
    
    public func with(accessLevel: AccessLevel) -> Type {
        var _self = self
        _self.accessLevel = accessLevel
        return _self
    }
    
    public func with(body: [TypeBodyMember]) -> Type {
        var _self = self
        _self.body = body
        return _self
    }
    
    public func adding(member: TypeBodyMember?) -> Type {
        var _self = self
        _self.body += [member].compactMap { $0 }
        return _self
    }
    
    public func adding(members: [TypeBodyMember]) -> Type {
        var _self = self
        _self.body += members
        return _self
    }
    
    public func adding(inheritedType: TypeIdentifier?) -> Type {
        var _self = self
        _self.inheritedTypes += [inheritedType].compactMap { $0 }
        return _self
    }
    
    public func adding(inheritedTypes: [TypeIdentifier]) -> Type {
        var _self = self
        _self.inheritedTypes += inheritedTypes
        return _self
    }
    
    public func with(inheritedTypes: [TypeIdentifier]) -> Type {
        var _self = self
        _self.inheritedTypes = inheritedTypes
        return _self
    }
    
    public func adding(genericParameter: GenericParameter?) -> Type {
        var _self = self
        _self.genericParameters += [genericParameter].compactMap { $0 }
        return _self
    }
    
    public func adding(genericParameters: [GenericParameter]) -> Type {
        var _self = self
        _self.genericParameters += genericParameters
        return _self
    }
    
    public func with(genericParameters: [GenericParameter]) -> Type {
        var _self = self
        _self.genericParameters = genericParameters
        return _self
    }
    
    public var identifier: TypeIdentifier {
        return TypeIdentifier(name: name)
    }
    
    public func with(constraints: [LogicalStatement]) -> Type {
        var _self = self
        _self.constraints = constraints
        return _self
    }
    
    public func adding(constraint: LogicalStatement?) -> Type {
        var _self = self
        _self.constraints += [constraint].compactMap { $0 }
        return _self
    }
    
    public func adding(constraints: [LogicalStatement]) -> Type {
        var _self = self
        _self.constraints += constraints
        return _self
    }
}

// MARK: - MetaSwiftConvertible

extension TypeKind {
    
    public var swiftString: String {
        switch self {
        case .class(let final):
            return "\(final ? "final " : .empty)class"
        case .enum:
            return "enum"
        case .protocol:
            return "protocol"
        case .struct:
            return "struct"
        }
    }
}

extension TypeIdentifierName {
    
    public var swiftString: String {
        return string
    }
}

extension TypeIdentifier {
    
    public var swiftString: String {
        let genericParameters = self.genericParameters
            .map { $0.swiftString }
            .joined(separator: ", ")
            .wrapped("<", ">")
        
        let implicitUnwrap = self.implicitUnwrap ? "!" : .empty

        return "\(name.swiftString)\(genericParameters)\(implicitUnwrap)"
    }
}

extension Type {
    
    public var swiftString: String {
        let genericParameters = self.genericParameters
            .map { $0.swiftString }
            .joined(separator: ", ")
            .wrapped("<", ">")

        let inheritedTypes = self.inheritedTypes
            .map { $0.swiftString }
            .joined(separator: ", ")
            .prefixed(": ")

        let constraints = self.constraints
            .map { $0.swiftString }
            .joined(separator: ", ")
            .prefixed(" where ")
        
        return """
        \(accessLevel.swiftString.suffixed(" "))\(kind.swiftString) \(name.swiftString)\(genericParameters)\(inheritedTypes)\(constraints) {
        \(body.map { $0.swiftString }.indented)\
        }
        """
    }
}
