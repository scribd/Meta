//
//  TypeAlias.swift
//  Meta
//
//  Created by Théophane Rupin on 3/21/19.
//

public struct TypeAliasIdentifier: Hashable, MetaSwiftConvertible {
    
    public let name: TypeIdentifierName

    public var genericParameters: [GenericParameter] = []
    
    public init(name: String) {
        self.name = .custom(name)
    }
    
    public init(name: TypeIdentifierName) {
        self.name = name
    }
    
    public func with(genericParameters: [GenericParameter]) -> TypeAliasIdentifier {
        var _self = self
        _self.genericParameters = genericParameters
        return _self
    }
    
    public func adding(genericParameter: GenericParameter?) -> TypeAliasIdentifier {
        var _self = self
        _self.genericParameters += [genericParameter].compactMap { $0 }
        return _self
    }
    
    public func adding(genericParameters: [GenericParameter]) -> TypeAliasIdentifier {
        var _self = self
        _self.genericParameters += genericParameters
        return _self
    }
}

public struct TypeAlias: Hashable {
    
    public let identifier: TypeAliasIdentifier

    public let values: [TypeIdentifier]

    public var accessLevel: AccessLevel = .default
    
    public var plateforms: [String] = []
    
    public init(identifier: TypeAliasIdentifier, value: TypeIdentifier) {
        self.identifier = identifier
        self.values = [value]
    }
    
    public init(identifier: TypeAliasIdentifier, values: [TypeIdentifier]) {
        self.identifier = identifier
        self.values = values
    }
    
    public func with(accessLevel: AccessLevel) -> TypeAlias {
        var _self = self
        _self.accessLevel = accessLevel
        return _self
    }
}

extension TypeAlias: FileBodyMember {}
extension TypeAlias: TypeBodyMember {}
extension TypeAlias: CrossPlateformMember {}

// MARK: - MetaSwiftConvertible

extension TypeAliasIdentifier {
    
    public var swiftString: String {
        let genericParameters = self.genericParameters
            .map { $0.swiftString }
            .joined(separator: ", ")
            .wrapped("<", ">")

        return "\(name.swiftString)\(genericParameters)"
    }
}

extension TypeAlias {
    
    public var internalSwiftString: String {
        let beforeValues = "\(accessLevel.swiftString.suffixed(" "))typealias \(identifier.swiftString) = "
        var values = self.values
            .map { $0.swiftString }
            .joined(separator: " & ")
        
        if self.values.count > 4 || (beforeValues + values).count > 80 {
            values = self.values
                .map { $0.swiftString }
                .joined(separator: " &".br + " ".repeat(beforeValues.count))
        }
        return "\(beforeValues)\(values)"
    }
}
