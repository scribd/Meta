//
//  Reference.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

public enum ReferenceName: Hashable, MetaSwiftConvertible {
    case `init`
    case `self`
    case print
    case map
    case flatMap
    case compactMap
    case `super`
    case custom(String)
}

public enum Reference: Hashable, MetaSwiftConvertible, Node {
    case type(TypeIdentifier)
    case name(ReferenceName)
    case tuple(Tuple)
    case unwrap
    case `try`
    case optionalTry
    case `throw`
    case block(FunctionBody)
    case `as`
    case none
    indirect case dot(Reference, Reference)
    indirect case assemble(Reference, Reference)
    
    public static func named(_ name: String) -> Reference {
        return .name(.custom(name))
    }
    
    public static func named(_ name: ReferenceName) -> Reference {
        return .name(name)
    }
    
    public static func call(_ tuple: Tuple = Tuple()) -> Reference {
        return .tuple(tuple)
    }
    
    public var array: [Reference] {
        switch self {
        case .type,
             .name,
             .tuple,
             .unwrap,
             .try,
             .optionalTry,
             .throw,
             .block,
             .as:
            return [self]
        case .none:
            return []
        case .dot(let lhs, let rhs),
             .assemble(let lhs, let rhs):
            return lhs.array + rhs.array
        }
    }
    
    public var isTry: Bool {
        switch self {
        case .try:
            return true
        default:
            return false
        }
    }
    
    public var isThrow: Bool {
        switch self {
        case .throw:
            return true
        default:
            return false
        }
    }
}

extension Reference: VariableValue {}
extension Reference: FunctionBodyMember {}
extension Reference: AssignmentVariable {}

public func | (_ lhs: Reference, _ rhs: Reference) -> Reference {
    return .assemble(lhs, rhs)
}

public func + (_ lhs: Reference, _ rhs: Reference) -> Reference {
    return .dot(lhs, rhs)
}

public prefix func + (_ reference: Reference) -> Reference {
    return .dot(.none, reference)
}

// MARK: - MetaSwiftConvertible

extension ReferenceName {
    
    public var swiftString: String {
        switch self {
        case .`init`:
            return "init"
        case .`self`:
            return "self"
        case .print:
            return "print"
        case .map:
            return "map"
        case .flatMap:
            return "flatMap"
        case .compactMap:
            return "compactMap"
        case .super:
            return "super"
        case .custom(let value):
            return value
        }
    }
}

extension Reference {
    
    public var swiftString: String {
        switch self {
        case .dot(let lhs, let rhs):
            return "\(lhs.swiftString).\(rhs.swiftString)"
        case .assemble(let lhs, let rhs):
            return "\(lhs.swiftString)\(rhs.swiftString)"
        case .type(let type):
            return type.swiftString
        case .name(let name):
            return name.swiftString
        case .tuple(let tuple):
            return tuple.swiftString
        case .unwrap:
            return "?"
        case .try:
            return "try "
        case .optionalTry:
            return "try? "
        case .throw:
            return "throw "
        case .block(let block):
            return block.swiftString.prefixed(" ")
        case .as:
            return " as "
        case .none:
            return ""
        }
    }
}

