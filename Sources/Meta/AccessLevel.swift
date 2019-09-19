//
//  AccessLevel.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

public enum AccessLevel: Hashable, MetaSwiftConvertible {
    case `public`
    case `internal`
    case `private`
    case privateSet
    case `fileprivate`
    case fileprivateSet
    indirect case composite(AccessLevel, AccessLevel)
    case none

    static let `default`: AccessLevel = .none
}

// MARK: - MetaSwidtConvertible

extension AccessLevel {
    
    public var swiftString: String {
        switch self {
        case .public:
            return "public"
        case .internal:
            return "internal"
        case .private:
            return "private"
        case .privateSet:
            return "private(set)"
        case .fileprivate:
            return "fileprivate"
        case .fileprivateSet:
            return "fileprivate(set)"
        case .none:
            return .empty
        case .composite(let lhs, let rhs):
            return [lhs, rhs]
                .map { $0.swiftString }
                .assemble(separator: " ")
        }
    }
}
