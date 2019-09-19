//
//  Switch.swift
//  Meta
//
//  Created by Théophane Rupin on 3/8/19.
//

public struct SwitchCaseVariable: Hashable, MetaSwiftConvertible {
    
    public let name: String
    
    public var type: TypeIdentifier?
    
    public init(name: String, as type: TypeIdentifier? = nil) {
        self.name = name
        self.type = type
    }
}

extension SwitchCaseVariable: VariableValue {}

public enum SwitchCaseName: Hashable, MetaSwiftConvertible {
    case `default`
    case custom(String)
}

public struct SwitchCase: Hashable, MetaSwiftConvertible {
    
    public let name: SwitchCaseName?

    public var values: [VariableValue] = []
    
    public var body: [FunctionBodyMember] = []
    
    public init(name: SwitchCaseName? = nil) {
        self.name = name
    }

    public init(name: String) {
        self.name = .custom(name)
    }
    
    public func with(body: [FunctionBodyMember]) -> SwitchCase {
        var _self = self
        _self.body = body
        return _self
    }
    
    public func adding(member: FunctionBodyMember?) -> SwitchCase {
        var _self = self
        _self.body += [member].compactMap { $0 }
        return _self
    }

    public func adding(members: [FunctionBodyMember]) -> SwitchCase {
        var _self = self
        _self.body += members
        return _self
    }
    
    public func with(values: [VariableValue]) -> SwitchCase {
        var _self = self
        _self.values = values
        return _self
    }
    
    public func adding(value: VariableValue?) -> SwitchCase {
        var _self = self
        _self.values += [value].compactMap { $0 }
        return _self
    }

    public func adding(values: [VariableValue]) -> SwitchCase {
        var _self = self
        _self.values += values
        return _self
    }
}

public struct Switch: Hashable, Node {
    
    public let reference: Reference
    
    public var cases: [SwitchCase] = []
    
    public init(reference: Reference) {
        self.reference = reference
    }
    
    public func with(cases: [SwitchCase]) -> Switch {
        var _self = self
        _self.cases = cases
        return _self
    }
    
    public func adding(case: SwitchCase?) -> Switch {
        var _self = self
        _self.cases += [`case`].compactMap { $0 }
        return _self
    }
    
    public func adding(cases: [SwitchCase]) -> Switch {
        var _self = self
        _self.cases += cases
        return _self
    }
}

extension Switch: FunctionBodyMember {}

// MARK: - MetaSwiftString

extension SwitchCaseVariable {
    
    public var swiftString: String {
        return "let \(name)\(type?.swiftString.prefixed(" as ") ?? .empty)"
    }
}

extension SwitchCaseName {
    
    public var swiftString: String {
        switch self {
        case .default:
            return "default"
        case .custom(let name):
            return "case .\(name)"
        }
    }
}

extension SwitchCase {
    
    public var swiftString: String {
        let name = self.name?.swiftString ?? "case "
        var variables = self.values.map { $0.swiftString }.joined(separator: ", ")
        if self.values.count > 1 || self.name != nil {
            variables = variables.wrapped("(", ")")
        }
        let body = self.body.map { $0.swiftString }.indented
        return """
        \(name)\(variables):
        \(body.isEmpty ? "break".tab : body)
        """
    }
}

extension Switch {
    
    public var swiftString: String {
        return """
        switch \(reference.swiftString) {
        \(cases.map { $0.swiftString }.br)
        }
        """
    }
}
