//
//  Comment.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

import Foundation

public struct Comment: Hashable {
    
    public let content: String
    
    public let documentation: Bool
    
    public var plateforms: [String] = []
    
    init(_ content: String, documentation: Bool = false) {
        self.content = content
        self.documentation = documentation
    }
    
    public static let empty = Comment(.empty)
    
    public static func comment(_ content: String) -> Comment {
        return Comment(content)
    }
    
    public static func documentation(_ content: String) -> Comment {
        return Comment(content, documentation: true)
    }
    
    public static func mark(_ content: String) -> Comment {
        return Comment("MARK: - \(content)")
    }
}

extension Comment: CrossPlateformMember {}
extension Comment: FileBodyMember {}
extension Comment: TypeBodyMember {}
extension Comment: FunctionBodyMember {}

// MARK: - MetaSwiftConvertible

extension Comment {
    
    public var internalSwiftString: String {
        return "\("/".repeat(documentation ? 3 : 2))\(content.isEmpty ? .empty : " ")\(content)"
    }
}
