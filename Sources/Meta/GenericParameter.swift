//
//  GenericParameter.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

public struct GenericParameter: MetaSwiftConvertible {
    
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}

// MARK: - MetaSwiftConvertible

extension GenericParameter {
    
    public var swiftString: String {
        return name
    }
}
