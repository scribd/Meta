//
//  Function.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

public struct FunctionParameter: Hashable, MetaSwiftConvertible {
    
    public let alias: String?
    
    public let name: String
    
    public let type: TypeIdentifier
    
    public var defaultValue: VariableValue?
    
    public var named: Bool = true
    
    public var `inout`: Bool = false
    
    public init(alias: String? = nil, name: String, type: TypeIdentifier) {
        self.alias = alias
        self.name = name
        self.type = type
    }
    
    public func with(defaultValue: VariableValue?) -> FunctionParameter {
        var _self = self
        _self.defaultValue = defaultValue
        return _self
    }
    
    public func with(named: Bool) -> FunctionParameter {
        var _self = self
        _self.named = named
        return _self
    }
    
    public func with(`inout`: Bool) -> FunctionParameter {
        var _self = self
        _self.inout = `inout`
        return _self
    }
}

public enum FunctionKind: Hashable, MetaSwiftConvertible {
    case _init(convenience: Bool, optional: Bool)
    case `operator`(Operator)
    case named(String)
    
    public static func `init`(convenience: Bool = false,
                              optional: Bool = false) -> FunctionKind {
        return ._init(convenience: convenience, optional: optional)
    }
    
    public static let `init` = FunctionKind.`init`()
}

public struct FunctionBodyParameter: Hashable, MetaSwiftConvertible {
    
    public let name: String?
    
    public let type: TypeIdentifier?
    
    public init(name: String? = nil, type: TypeIdentifier? = nil) {
        self.name = name
        self.type = type
    }
}

public enum FunctionBodyContextKind: Hashable, MetaSwiftConvertible {
    case unowned
    case weak
}

public struct FunctionBodyContext: Hashable, MetaSwiftConvertible {
    
    public let alias: String?
    
    public let name: String
    
    public let kind: FunctionBodyContextKind
    
    public init(alias: String? = nil,
                name: String,
                kind: FunctionBodyContextKind = .unowned) {
        self.alias = alias
        self.name = name
        self.kind = kind
    }
}

public struct FunctionBody: Hashable, MetaSwiftConvertible {
    
    public var members: [FunctionBodyMember] = []
    
    public var parameters: [FunctionBodyParameter] = []
    
    public var context: [FunctionBodyContext] = []
    
    public var resultType: TypeIdentifier?
    
    public var tuple: Tuple?
    
    public init() {
        // no-op
    }
    
    public func with(body: [FunctionBodyMember]) -> FunctionBody {
        var _self = self
        _self.members = body
        return _self
    }
    
    public func adding(member: FunctionBodyMember?) -> FunctionBody {
        var _self = self
        _self.members += [member].compactMap { $0 }
        return _self
    }
    
    public func adding(members: [FunctionBodyMember]) -> FunctionBody {
        var _self = self
        _self.members += members
        return _self
    }
    
    public func with(parameters: [FunctionBodyParameter]) -> FunctionBody {
        var _self = self
        _self.parameters = parameters
        return _self
    }
    
    public func with(resultType: TypeIdentifier?) -> FunctionBody {
        var _self = self
        _self.resultType = resultType
        return _self
    }
    
    public func adding(parameter: FunctionBodyParameter?) -> FunctionBody {
        var _self = self
        _self.parameters += [parameter].compactMap { $0 }
        return _self
    }
    
    public func adding(parameters: [FunctionBodyParameter]) -> FunctionBody {
        var _self = self
        _self.parameters += parameters
        return _self
    }
    
    public func with(tuple: Tuple?) -> FunctionBody {
        var _self = self
        _self.tuple = tuple
        return _self
    }
    
    public func with(context: [FunctionBodyContext]) -> FunctionBody {
        var _self = self
        _self.context = context
        return _self
    }
    
    public func adding(context: FunctionBodyContext?) -> FunctionBody {
        var _self = self
        _self.context += [context].compactMap { $0 }
        return _self
    }
    
    public func adding(context: [FunctionBodyContext]) -> FunctionBody {
        var _self = self
        _self.context += context
        return _self
    }
}

extension FunctionBody: VariableValue {}

public struct Function: Hashable, Node {
    
    public let kind: FunctionKind
    
    public var genericParameters: [GenericParameter] = []
    
    public var parameters: [FunctionParameter] = []
    
    public var accessLevel: AccessLevel = .default
    
    public var constraints: [LogicalStatement] = []
    
    public var body = FunctionBody()
    
    public var resultType: TypeIdentifier?
    
    public var `throws` = false
    
    public var `static` = false
    
    public var override = false
    
    public var objc = false
    
    public init(kind: FunctionKind) {
        self.kind = kind
    }
    
    public func with(genericParameters: [GenericParameter]) -> Function {
        var _self = self
        _self.genericParameters = genericParameters
        return _self
    }
    
    public func adding(genericParameter: GenericParameter?) -> Function {
        var _self = self
        _self.genericParameters += [genericParameter].compactMap { $0 }
        return _self
    }
    
    public func adding(genericParameters: [GenericParameter]) -> Function {
        var _self = self
        _self.genericParameters += genericParameters
        return _self
    }
    
    public func with(parameters: [FunctionParameter]) -> Function {
        var _self = self
        _self.parameters = parameters
        return _self
    }
    
    public func adding(parameter: FunctionParameter?) -> Function {
        var _self = self
        _self.parameters += [parameter].compactMap { $0 }
        return _self
    }
    
    public func adding(parameters: [FunctionParameter]) -> Function {
        var _self = self
        _self.parameters += parameters
        return _self
    }
    
    public func with(accessLevel: AccessLevel) -> Function {
        var _self = self
        _self.accessLevel = accessLevel
        return _self
    }
    
    public func with(body: [FunctionBodyMember]) -> Function {
        var _self = self
        _self.body.members = body
        return _self
    }
    
    public func adding(member: FunctionBodyMember?) -> Function {
        var _self = self
        _self.body.members += [member].compactMap { $0 }
        return _self
    }
    
    public func adding(members: [FunctionBodyMember]) -> Function {
        var _self = self
        _self.body.members += members
        return _self
    }
    
    public func with(constraints: [LogicalStatement]) -> Function {
        var _self = self
        _self.constraints = constraints
        return _self
    }
    
    public func adding(constraint: LogicalStatement?) -> Function {
        var _self = self
        _self.constraints += [constraint].compactMap { $0 }
        return _self
    }
    
    public func adding(constraints: [LogicalStatement]) -> Function {
        var _self = self
        _self.constraints += constraints
        return _self
    }

    public func with(resultType: TypeIdentifier?) -> Function {
        var _self = self
        _self.resultType = resultType
        return _self
    }
    
    public func with(throws: Bool) -> Function {
        var _self = self
        _self.throws = `throws`
        return _self
    }
    
    public func with(static: Bool) -> Function {
        var _self = self
        _self.static = `static`
        return _self
    }
    
    public func with(override: Bool) -> Function {
        var _self = self
        _self.override = override
        return _self
    }
    
    public func with(objc: Bool) -> Function {
        var _self = self
        _self.objc = objc
        return _self
    }
}

extension Function: FileBodyMember {}
extension Function: TypeBodyMember {}

public struct ProtocolFunction: Hashable, Node {
    
    public let name: String
    
    public var genericParameters: [GenericParameter] = []
    
    public var parameters: [FunctionParameter] = []
    
    public var accessLevel: AccessLevel = .default
    
    public var resultType: TypeIdentifier?
    
    public init(name: String) {
        self.name = name
    }

    public func with(genericParameters: [GenericParameter]) -> ProtocolFunction {
        var _self = self
        _self.genericParameters = genericParameters
        return _self
    }
    
    public func adding(genericParameter: GenericParameter?) -> ProtocolFunction {
        var _self = self
        _self.genericParameters += [genericParameter].compactMap { $0 }
        return _self
    }
    
    public func adding(genericParameters: [GenericParameter]) -> ProtocolFunction {
        var _self = self
        _self.genericParameters += genericParameters
        return _self
    }
    
    public func with(parameters: [FunctionParameter]) -> ProtocolFunction {
        var _self = self
        _self.parameters = parameters
        return _self
    }
    
    public func adding(parameter: FunctionParameter?) -> ProtocolFunction {
        var _self = self
        _self.parameters += [parameter].compactMap { $0 }
        return _self
    }
    
    public func adding(parameters: [FunctionParameter]) -> ProtocolFunction {
        var _self = self
        _self.parameters += parameters
        return _self
    }
    
    public func with(resultType: TypeIdentifier?) -> ProtocolFunction {
        var _self = self
        _self.resultType = resultType
        return _self
    }
}

extension ProtocolFunction: TypeBodyMember {}

// MARK: - MetaSwiftConvertible

extension FunctionParameter {
    
    public var swiftString: String {
        let alias = self.alias?.suffixed(" ") ?? .empty
        let named = self.named ? .empty : "_ "
        let defaultValue = self.defaultValue.flatMap { $0.swiftString.prefixed(" = ") } ?? .empty
        let `inout` = self.inout ? "inout " : .empty
        return "\(alias)\(named)\(name): \(`inout`)\(type.swiftString)\(defaultValue)"
    }
}

extension FunctionKind {
    
    public var swiftString: String {
        switch self {
        case ._init(let convenience, let optional):
            return "\(convenience ? "convenience " : .empty)init\(optional ? "?" : .empty)"
        case .operator(let op):
            return "func \(op.swiftString) "
        case .named(let name):
            return "func \(name)"
        }
    }
}

extension FunctionBodyParameter {
    
    public var swiftString: String {
        let name = self.name ?? "_"
        let type = self.type?.swiftString.prefixed(": ") ?? .empty
        return "\(name)\(type)"
    }
}

extension FunctionBodyContextKind {
    
    public var swiftString: String {
        switch self {
        case .unowned:
            return "unowned"
        case .weak:
            return "weak"
        }
    }
}

extension FunctionBodyContext {
    
    public var swiftString: String {
        return "\(kind.swiftString) \(alias?.suffixed(" = ") ?? .empty)\(name)"
    }
}

extension FunctionBody {
    
    public var swiftString: String {
        let parameters = self.parameters
            .map { $0.swiftString }
            .joined(separator: ", ")
        
        let context = self.context
            .map { $0.swiftString }
            .joined(separator: ", ")
            .prefixed("[")
            .suffixed("]")
        
        let resultType = self.resultType?.swiftString ?? .empty
        
        let input = (
            context.prefixed(" ") +
            parameters.prefixed(" ") +
            resultType.prefixed(" -> ")
        ).wrapped("(", ")").suffixed(" in")
        
        let firstMember = members.first?.swiftString ?? .empty
        let canCompress = members.count == 1 &&
            firstMember.contains(String.br) == false &&
            firstMember.count <= 80 &&
            !(members.first is Comment)
        
        if canCompress {
            let member = members.first?.swiftString ?? .empty
            return "{\(input)\(member.wrapped(" "))}\(tuple?.swiftString ?? .empty)"
        } else {
            return """
            {\(input)
            \(members.map { $0.swiftString }.indented)\
            }\(tuple?.swiftString ?? .empty)
            """
        }
    }
}

extension Function {
    
    public var swiftString: String {
        let `static` = self.static ? "static " : .empty
        let objc = self.objc ? "@objc " : .empty
        let accessLevel = self.accessLevel.swiftString.suffixed(" ")
        
        let genericParameters = self.genericParameters
            .map { $0.swiftString }
            .joined(separator: ", ")
            .wrapped("<", ">")
        
        let `throws` = self.throws ? " throws" : .empty
        
        let resultType = self.resultType?.swiftString.prefixed(" -> ") ?? .empty
        
        let constraints = self.constraints
            .map { $0.swiftString }
            .joined(separator: ", ")
            .prefixed(" where ")
        
        let override = self.override ? "override " : .empty

        let beforeParameters = "\(objc)\(accessLevel)\(override)\(`static`)\(kind.swiftString)\(genericParameters)("
        var parameters = self.parameters
            .map { $0.swiftString }
            .joined(separator: ", ")

        let build = {
            return "\(beforeParameters)\(parameters))\(`throws`)\(resultType)\(constraints) \(self.body.swiftString)"
        }

        if self.parameters.count > 4 || build().count > 80 {
            parameters = self.parameters
                .map { $0.swiftString }
                .joined(separator: ",".br + " ".repeat(beforeParameters.count))
        }

        return build()
    }
}

extension ProtocolFunction {
    
    public var swiftString: String {
        let genericParameters = self.genericParameters
            .map { $0.swiftString }
            .joined(separator: ", ")
            .wrapped("<", ">")
        
        let parameters = self.parameters
            .map { $0.swiftString }
            .joined(separator: ", ")
        
        let resultType = self.resultType?.swiftString.prefixed(" -> ") ?? .empty
        
        return "\(accessLevel.swiftString.suffixed(" "))func \(name)\(genericParameters)(\(parameters))\(resultType)"
    }
}
