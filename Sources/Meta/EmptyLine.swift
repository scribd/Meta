//
//  EmptyLine.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

public struct EmptyLine: Node {
    public let swiftString: String = " "
    
    public init() {
        // no-op
    }
}

extension EmptyLine: VariableValue {}
extension EmptyLine: FunctionBodyMember {}
extension EmptyLine: TypeBodyMember {}
extension EmptyLine: FileBodyMember {}
