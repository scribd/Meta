//
//  PlainCode.swift
//  Meta
//
//  Created by Théophane Rupin on 4/17/19.
//

public struct PlainCode: Hashable, Node {
    
    public let code: String
    
    public init(code: String) {
        self.code = code
    }
}

extension PlainCode: VariableValue {}
extension PlainCode: FunctionBodyMember {}
extension PlainCode: TypeBodyMember {}
extension PlainCode: FileBodyMember {}
extension PlainCode: AssignmentVariable {}

public struct MetaCode: Hashable, MetaSwiftConvertible, CustomStringConvertible {
    
    public let indentation: Int
    
    public let metaElements: [MetaSwiftConvertible]
    
    public init(indentation: Int = 0, meta: MetaSwiftConvertible) {
        self.indentation = indentation
        self.metaElements = [meta]
    }
    
    public init(indentation: Int = 0, meta: [MetaSwiftConvertible]) {
        self.indentation = indentation
        self.metaElements = meta
    }
}

// MARK: - MetaSwiftString

extension PlainCode {
    
    public var swiftString: String {
        return code
            .components(separatedBy: String.br)
            .map { $0.replacingOccurrences(of: " ", with: "").isEmpty ? " " : String($0) }
            .joined(separator: .br)
    }
}

extension MetaCode {
    
    public var description: String {
        return swiftString
    }

    public var swiftString: String {
        var string = metaElements
            .map { $0.swiftString }
            .indented(indentation)
        if string.isEmpty == false {
            string.removeLast()
        }
        return string
    }
}
