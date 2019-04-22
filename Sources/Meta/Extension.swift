//
//  Extension.swift
//  Meta
//
//  Created by Théophane Rupin on 3/4/19.
//

public struct Extension: Node {
    
    public let name: TypeIdentifierName
    
    public var body: [TypeBodyMember] = []
    
    public var accessLevel: AccessLevel = .default
    
    public var inheritedTypes: [TypeIdentifier] = []
    
    public var constraints: [LogicalStatement] = []

    public init(name: String) {
        self.name = .custom(name)
    }
    
    public init(type: TypeIdentifier) {
        self.name = type.name
    }
    
    public func with(body: [TypeBodyMember]) -> Extension {
        var _self = self
        _self.body = body
        return _self
    }
    
    public func adding(member: TypeBodyMember?) -> Extension {
        var _self = self
        _self.body += [member].compactMap { $0 }
        return _self
    }
    
    public func adding(members: [TypeBodyMember]) -> Extension {
        var _self = self
        _self.body += members
        return _self
    }
    
    public func with(accessLevel: AccessLevel) -> Extension {
        var _self = self
        _self.accessLevel = accessLevel
        return _self
    }
    
    public func adding(inheritedType: TypeIdentifier?) -> Extension {
        var _self = self
        _self.inheritedTypes += [inheritedType].compactMap { $0 }
        return _self
    }
    
    public func adding(inheritedTypes: [TypeIdentifier]) -> Extension {
        var _self = self
        _self.inheritedTypes += inheritedTypes
        return _self
    }
    
    public func with(inheritedTypes: [TypeIdentifier]) -> Extension {
        var _self = self
        _self.inheritedTypes = inheritedTypes
        return _self
    }
    
    public func with(constraints: [LogicalStatement]) -> Extension {
        var _self = self
        _self.constraints = constraints
        return _self
    }
    
    public func adding(constraint: LogicalStatement?) -> Extension {
        var _self = self
        _self.constraints += [constraint].compactMap { $0 }
        return _self
    }
    
    public func adding(constraints: [LogicalStatement]) -> Extension {
        var _self = self
        _self.constraints += constraints
        return _self
    }
}

extension Extension: FileBodyMember {}

// MARK: - MetaSwiftConvertible

extension Extension {
    
    public var swiftString: String {
        let inheritedTypes = self.inheritedTypes
            .map { $0.swiftString }
            .joined(separator: ", ")
            .prefixed(": ")
        
        let constraints = self.constraints
            .map { $0.swiftString }
            .joined(separator: ", ")
            .prefixed(" where ")

        return """
        \(accessLevel.swiftString.suffixed(" "))extension \(name.swiftString)\(inheritedTypes)\(constraints) {
        \(body.map { $0.swiftString }.indented)\
        }
        """
    }
}
