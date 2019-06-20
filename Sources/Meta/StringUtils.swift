//
//  StringUtils.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

import Foundation

extension String {
    static let br: String = "\n"
    static let tab: String = "    "
    static let empty: String = ""
    static let doubleQuote: String = "\""
    static let openingSquareBracket: String = "["
    static let closingSquareBracket: String = "]"

    static func br(_ count: Int) -> String {
        return String.br.repeat(count)
    }

    var br: String {
        return self + .br
    }
    
    static func tab(_ count: Int) -> String {
        return String.tab.repeat(count)
    }
    
    func tab(_ count: Int) -> String {
        return self + .tab(count)
    }
    
    var tab: String {
        return self + .tab(0)
    }
    
    func `repeat`(_ count: Int) -> String {
        return (0..<count).map { _ in self }.joined(separator: .empty)
    }
    
    func wrapped(_ before: String, _ after: String? = nil, compact: Bool = true) -> String {
        let after = after ?? before
        return isEmpty && compact ? .empty : "\(before)\(self)\(after)"
    }
    
    func prefixed(_ prefix: String) -> String {
        return isEmpty ? .empty : "\(prefix)\(self)"
    }
    
    func suffixed(_ suffix: String) -> String {
        return isEmpty ? .empty : "\(self)\(suffix)"
    }
    
    var indented: String {
        return split(separator: Character(.br)).map { String($0) }.indented
    }
    
    var cleaned: String {
        return components(separatedBy: String.br)
            .map { $0.replacingOccurrences(of: " ", with: "").isEmpty ? .empty : String($0) }
            .joined(separator: .br)
    }
}

extension Sequence where Element == String {
    
    func assemble(separator: String) -> String {
        return compactMap { string in
            if string.isEmpty { return nil }
            if string == " " { return .empty }
            return string
        }.joined(separator: separator)
    }
    
    func br(_ count: Int) -> String {
        return assemble(separator: .br(count))
    }
    
    var br: String {
        return self.br(1)
    }
    
    func indented(_ count: Int) -> String {
        return map { elements in
            elements.split(separator: Character(.br)).joined(separator: String.br.tab(count))
        }.assemble(separator: String.br.tab(count)).wrapped(.tab(count), .br)
    }
    
    var indented: String {
        return self.indented(1)
    }
}
