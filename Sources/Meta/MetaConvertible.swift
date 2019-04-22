//
//  MetaConvertible.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

import Foundation

public protocol MetaSwiftConvertible {
    var swiftString: String { get }
}

extension RawRepresentable where RawValue == String {
    public var swiftString: String {
        return rawValue
    }
}

extension Array: MetaSwiftConvertible where Element: MetaSwiftConvertible {
    public var swiftString: String {
        return map { $0.swiftString }.joined(separator: .br)
    }
}
