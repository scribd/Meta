//
//  LogicalStatement.swift
//  Meta
//
//  Created by Théophane Rupin on 3/22/19.
//

public enum Operator: String, Hashable, MetaSwiftConvertible {
    case equal = "=="
    case greaterThan = ">"
    case greaterThanOrEqual = ">="
    case lowerThan = "<"
    case lowerThanOrEqual = "<="
    case notEqual = "!="
    case plus = "+"
    case minus = "-"
    case plusEqual = "+="
    case minusEqual = "-="
    case nilCoalescing = "??"
    case constraintImplement = ":"
    case `is` = "is"
    case and = "&&"
    case or = "||"
}

public enum LogicalStatement: Hashable, MetaSwiftConvertible {
    case value(VariableValue)
    indirect case assemble(LogicalStatement, Operator, LogicalStatement)
    indirect case ternary(condition: LogicalStatement, left: LogicalStatement, right: LogicalStatement)
}

extension LogicalStatement: FunctionBodyMember {}
extension LogicalStatement: VariableValue {}

public struct Guard: Hashable, Node {
    
    public var assignments: [Assignment]
    
    public var conditions: [LogicalStatement]
    
    public var body: [FunctionBodyMember] = []
    
    public var plateforms: [String] = []
    
    public init(condition: LogicalStatement) {
        self.conditions = [condition]
        assignments = []
    }
    
    public init(assignment: Assignment) {
        self.assignments = [assignment]
        conditions = []
    }
    
    public func with(assignments: [Assignment]) -> Guard {
        var _self = self
        _self.assignments = assignments
        return _self
    }
    
    public func adding(assignment: Assignment?) -> Guard {
        var _self = self
        _self.assignments += [assignment].compactMap { $0 }
        return _self
    }

    public func adding(assignments: [Assignment]) -> Guard {
        var _self = self
        _self.assignments += assignments
        return _self
    }

    public func with(conditions: [LogicalStatement]) -> Guard {
        var _self = self
        _self.conditions = conditions
        return _self
    }
    
    public func adding(condition: LogicalStatement?) -> Guard {
        var _self = self
        _self.conditions += [condition].compactMap { $0 }
        return _self
    }

    public func adding(conditions: [LogicalStatement]) -> Guard {
        var _self = self
        _self.conditions += conditions
        return _self
    }

    public func with(body: [FunctionBodyMember]) -> Guard {
        var _self = self
        _self.body = body
        return _self
    }
    
    public func adding(member: FunctionBodyMember?) -> Guard {
        var _self = self
        _self.body += [member].compactMap { $0 }
        return _self
    }
    
    public func adding(members: [FunctionBodyMember]) -> Guard {
        var _self = self
        _self.body += members
        return _self
    }
}

extension Guard: FunctionBodyMember {}
extension Guard: CrossPlateformMember {}

public struct ElseIf: Hashable, Node {
    
    public var ifs: [If]
    
    public var body: [FunctionBodyMember] = []
    
    public var plateforms: [String] = []
    
    public init(if: If) {
        ifs = [`if`]
    }
    
    public func with(ifs: [If]) -> ElseIf {
        var _self = self
        _self.ifs = ifs
        return _self
    }

    public func adding(if: If?) -> ElseIf {
        var _self = self
        _self.ifs += [`if`].compactMap { $0 }
        return _self
    }
    
    public func adding(ifs: [If]) -> ElseIf {
        var _self = self
        _self.ifs += ifs
        return _self
    }

    public func with(body: [FunctionBodyMember]) -> ElseIf {
        var _self = self
        _self.body = body
        return _self
    }
    
    public func adding(member: FunctionBodyMember?) -> ElseIf {
        var _self = self
        _self.body += [member].compactMap { $0 }
        return _self
    }
    
    public func adding(members: [FunctionBodyMember]) -> ElseIf {
        var _self = self
        _self.body += members
        return _self
    }
}

extension ElseIf: FunctionBodyMember {}
extension ElseIf: CrossPlateformMember {}

public struct If: Hashable, Node {
    
    public var assignments: [Assignment]
    
    public var conditions: [LogicalStatement]
    
    public var body: [FunctionBodyMember] = []
    
    public var plateforms: [String] = []
    
    public init(condition: LogicalStatement) {
        self.conditions = [condition]
        assignments = []
    }
    
    public init(assignment: Assignment) {
        self.assignments = [assignment]
        conditions = []
    }
    
    public func with(assignments: [Assignment]) -> If {
        var _self = self
        _self.assignments = assignments
        return _self
    }
    
    public func adding(assignment: Assignment?) -> If {
        var _self = self
        _self.assignments += [assignment].compactMap { $0 }
        return _self
    }
    
    public func adding(assignments: [Assignment]) -> If {
        var _self = self
        _self.assignments += assignments
        return _self
    }
    
    public func with(conditions: [LogicalStatement]) -> If {
        var _self = self
        _self.conditions = conditions
        return _self
    }
    
    public func adding(condition: LogicalStatement?) -> If {
        var _self = self
        _self.conditions += [condition].compactMap { $0 }
        return _self
    }
    
    public func adding(conditions: [LogicalStatement]) -> If {
        var _self = self
        _self.conditions += conditions
        return _self
    }
    
    public func with(body: [FunctionBodyMember]) -> If {
        var _self = self
        _self.body = body
        return _self
    }
    
    public func adding(member: FunctionBodyMember?) -> If {
        var _self = self
        _self.body += [member].compactMap { $0 }
        return _self
    }
    
    public func adding(members: [FunctionBodyMember]) -> If {
        var _self = self
        _self.body += members
        return _self
    }
}

extension If: FunctionBodyMember {}
extension If: CrossPlateformMember {}

// MARK: Syntactic Sugar

// MARK: - Equal

public func == (_ lhs: LogicalStatement, _ rhs: LogicalStatement) -> LogicalStatement {
    return .assemble(lhs, .equal, rhs)
}

public func == (_ lhs: LogicalStatement?, _ rhs: LogicalStatement) -> LogicalStatement? {
    if let lhs = lhs {
        return .assemble(lhs, .equal, rhs)
    } else {
        return rhs
    }
}

public func == (_ lhs: Reference, _ rhs: Reference) -> LogicalStatement {
    return .value(lhs) == .value(rhs)
}

public func == (_ lhs: Reference, _ rhs: LogicalStatement) -> LogicalStatement {
    return .value(lhs) == rhs
}

// MARK: - NotEqual

public func != (_ lhs: LogicalStatement, _ rhs: LogicalStatement) -> LogicalStatement {
    return .assemble(lhs, .notEqual, rhs)
}

public func != (_ lhs: LogicalStatement?, _ rhs: LogicalStatement) -> LogicalStatement? {
    if let lhs = lhs {
        return .assemble(lhs, .notEqual, rhs)
    } else {
        return rhs
    }
}

public func != (_ lhs: Reference, _ rhs: Reference) -> LogicalStatement {
    return .value(lhs) != .value(rhs)
}

public func != (_ lhs: Reference, _ rhs: LogicalStatement) -> LogicalStatement {
    return .value(lhs) != rhs
}

// MARK: - GreaterThan

public func > (_ lhs: LogicalStatement, _ rhs: LogicalStatement) -> LogicalStatement {
    return .assemble(lhs, .greaterThan, rhs)
}

public func > (_ lhs: LogicalStatement?, _ rhs: LogicalStatement) -> LogicalStatement? {
    if let lhs = lhs {
        return .assemble(lhs, .greaterThan, rhs)
    } else {
        return rhs
    }
}

public func > (_ lhs: Reference, _ rhs: Reference) -> LogicalStatement {
    return .value(lhs) > .value(rhs)
}

public func > (_ lhs: Reference, _ rhs: LogicalStatement) -> LogicalStatement {
    return .value(lhs) > rhs
}

// MARK: - GreaterThanOrEqual

public func >= (_ lhs: LogicalStatement, _ rhs: LogicalStatement) -> LogicalStatement {
    return .assemble(lhs, .greaterThanOrEqual, rhs)
}

public func >= (_ lhs: LogicalStatement?, _ rhs: LogicalStatement) -> LogicalStatement? {
    if let lhs = lhs {
        return .assemble(lhs, .greaterThanOrEqual, rhs)
    } else {
        return rhs
    }
}

public func >= (_ lhs: Reference, _ rhs: Reference) -> LogicalStatement {
    return .value(lhs) >= .value(rhs)
}

public func >= (_ lhs: Reference, _ rhs: LogicalStatement) -> LogicalStatement {
    return .value(lhs) >= rhs
}

// MARK: - LowerThan

public func < (_ lhs: LogicalStatement, _ rhs: LogicalStatement) -> LogicalStatement {
    return .assemble(lhs, .lowerThan, rhs)
}

public func < (_ lhs: LogicalStatement?, _ rhs: LogicalStatement) -> LogicalStatement? {
    if let lhs = lhs {
        return .assemble(lhs, .lowerThan, rhs)
    } else {
        return rhs
    }
}

public func < (_ lhs: Reference, _ rhs: Reference) -> LogicalStatement {
    return .value(lhs) < .value(rhs)
}

public func < (_ lhs: Reference, _ rhs: LogicalStatement) -> LogicalStatement {
    return .value(lhs) < rhs
}

// MARK: - LowerThanOrEqual

public func <= (_ lhs: LogicalStatement, _ rhs: LogicalStatement) -> LogicalStatement {
    return .assemble(lhs, .lowerThanOrEqual, rhs)
}

public func <= (_ lhs: LogicalStatement?, _ rhs: LogicalStatement) -> LogicalStatement? {
    if let lhs = lhs {
        return .assemble(lhs, .lowerThanOrEqual, rhs)
    } else {
        return rhs
    }
}

public func <= (_ lhs: Reference, _ rhs: Reference) -> LogicalStatement {
    return .value(lhs) <= .value(rhs)
}

public func <= (_ lhs: Reference, _ rhs: LogicalStatement) -> LogicalStatement {
    return .value(lhs) <= rhs
}

// MARK: - Plus

public func + (_ lhs: LogicalStatement, _ rhs: LogicalStatement) -> LogicalStatement {
    return .assemble(lhs, .plus, rhs)
}

public func + (_ lhs: LogicalStatement?, _ rhs: LogicalStatement) -> LogicalStatement? {
    if let lhs = lhs {
        return .assemble(lhs, .plus, rhs)
    } else {
        return rhs
    }
}

public func + (_ lhs: Reference, _ rhs: LogicalStatement) -> LogicalStatement {
    return .value(lhs) + rhs
}

// MARK: - PlusEqual

public func += (_ lhs: LogicalStatement, _ rhs: LogicalStatement) -> LogicalStatement {
    return .assemble(lhs, .plusEqual, rhs)
}

public func += (_ lhs: LogicalStatement?, _ rhs: LogicalStatement) -> LogicalStatement? {
    if let lhs = lhs {
        return .assemble(lhs, .plusEqual, rhs)
    } else {
        return rhs
    }
}

public func += (_ lhs: Reference, _ rhs: Reference) -> LogicalStatement {
    return .value(lhs) += .value(rhs)
}

public func += (_ lhs: Reference, _ rhs: LogicalStatement) -> LogicalStatement {
    return .value(lhs) += rhs
}

// MARK: - Minus

public func - (_ lhs: LogicalStatement, _ rhs: LogicalStatement) -> LogicalStatement {
    return .assemble(lhs, .minus, rhs)
}

public func - (_ lhs: LogicalStatement?, _ rhs: LogicalStatement) -> LogicalStatement? {
    if let lhs = lhs {
        return .assemble(lhs, .minus, rhs)
    } else {
        return rhs
    }
}

public func - (_ lhs: Reference, _ rhs: Reference) -> LogicalStatement {
    return .value(lhs) - .value(rhs)
}

public func - (_ lhs: Reference, _ rhs: LogicalStatement) -> LogicalStatement {
    return .value(lhs) - rhs
}

// MARK: - MinusEqual

public func -= (_ lhs: LogicalStatement, _ rhs: LogicalStatement) -> LogicalStatement {
    return .assemble(lhs, .minusEqual, rhs)
}

public func -= (_ lhs: LogicalStatement?, _ rhs: LogicalStatement) -> LogicalStatement? {
    if let lhs = lhs {
        return .assemble(lhs, .minusEqual, rhs)
    } else {
        return rhs
    }
}

public func -= (_ lhs: Reference, _ rhs: Reference) -> LogicalStatement {
    return .value(lhs) -= .value(rhs)
}

public func -= (_ lhs: Reference, _ rhs: LogicalStatement) -> LogicalStatement {
    return .value(lhs) -= rhs
}

// MARK: - NilCoalescing

public func ?? (_ lhs: LogicalStatement, _ rhs: LogicalStatement) -> LogicalStatement {
    return .assemble(lhs, .nilCoalescing, rhs)
}

public func ?? (_ lhs: LogicalStatement?, _ rhs: LogicalStatement) -> LogicalStatement? {
    if let lhs = lhs {
        return .assemble(lhs, .nilCoalescing, rhs)
    } else {
        return rhs
    }
}

public func ?? (_ lhs: Reference, _ rhs: Reference) -> LogicalStatement {
    return .value(lhs) ?? .value(rhs)
}

public func ?? (_ lhs: Reference, _ rhs: LogicalStatement) -> LogicalStatement {
    return .value(lhs) ?? rhs
}

// MARK: - And

public func && (_ lhs: LogicalStatement, _ rhs: LogicalStatement) -> LogicalStatement {
    return .assemble(lhs, .and, rhs)
}

public func && (_ lhs: LogicalStatement?, _ rhs: LogicalStatement) -> LogicalStatement? {
    if let lhs = lhs {
        return .assemble(lhs, .and, rhs)
    } else {
        return rhs
    }
}

public func && (_ lhs: Reference, _ rhs: Reference) -> LogicalStatement {
    return .value(lhs) && .value(rhs)
}

public func && (_ lhs: Reference, _ rhs: LogicalStatement) -> LogicalStatement {
    return .value(lhs) && rhs
}

// MARK: - Or

public func || (_ lhs: LogicalStatement, _ rhs: LogicalStatement) -> LogicalStatement {
    return .assemble(lhs, .or, rhs)
}

public func || (_ lhs: LogicalStatement?, _ rhs: LogicalStatement) -> LogicalStatement? {
    if let lhs = lhs {
        return .assemble(lhs, .or, rhs)
    } else {
        return rhs
    }
}

public func || (_ lhs: Reference, _ rhs: Reference) -> LogicalStatement {
    return .value(lhs) || .value(rhs)
}

public func || (_ lhs: Reference, _ rhs: LogicalStatement) -> LogicalStatement {
    return .value(lhs) || rhs
}

// MARK: - MetaSwiftConvertible

extension LogicalStatement {
    
    public var swiftString: String {
        switch self {
        case .assemble(let lhs, let op, let rhs):
            return "\(lhs.swiftString) \(op.swiftString) \(rhs.swiftString)"
        case .value(let value):
            return value.swiftString
        case .ternary(let condition, let lhs, let rhs):
            return "\(condition.swiftString) ? \(lhs.swiftString) : \(rhs.swiftString)"
        }
    }
}

extension Guard {
    
    public var internalSwiftString: String {
        let assignments = self.assignments.map { $0.swiftString }
        let conditions = self.conditions.map { $0.swiftString }
        let elements = (assignments + conditions).joined(separator: ", ")
        let body = self.body.map { $0.swiftString }.indented
        
        return """
        guard \(elements) else {
        \(body)
        }
        """
    }
}

extension If {
    
    public var internalSwiftString: String {
        let assignments = self.assignments.map { $0.swiftString }
        let conditions = self.conditions.map { $0.swiftString }
        let elements = (assignments + conditions).joined(separator: ", ")
        let body = self.body.map { $0.swiftString }.indented
        
        return """
        if \(elements) {
        \(body)
        }
        """
    }
}

extension ElseIf {
    
    public var internalSwiftString: String {
        let ifs = self.ifs
            .map { $0.swiftString }
            .joined(separator: " else ")
        
        let body = self.body.map { $0.swiftString }.indented
        
        return """
        \(ifs) else {
        \(body)
        }
        """
    }
}
