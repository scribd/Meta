//
//  Comment.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

import Foundation

public struct Comment: Hashable, FileBodyMember, TypeBodyMember, FunctionBodyMember {
    
    public let content: String
    
    public let documentation: Bool
    
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

// MARK: - MetaSwiftConvertible

extension Comment {
    
    public var swiftString: String {
        return "\("/".repeat(documentation ? 3 : 2))\(content.isEmpty ? .empty : " ")\(content)"
    }
}
