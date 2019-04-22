//
//  File.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

public struct Import: MetaSwiftConvertible {
    
    public let name: String
    
    public let testable: Bool
    
    public init(name: String, testable: Bool = false) {
        self.name = name
        self.testable = testable
    }
}

public struct File: MetaSwiftConvertible {
    
    public let name: String

    public var header: [Comment] = []

    public var imports: [Import] = []

    public var body: [FileBodyMember] = []
    
    public init(name: String) {
        self.name = name
    }
    
    public func with(header: [Comment]) -> File {
        var _self = self
        _self.header = header
        return _self
    }
    
    public func adding(import: Import?) -> File {
        var _self = self
        _self.imports += [`import`].compactMap { $0 }
        return _self
    }
    
    public func adding(imports: [Import]) -> File {
        var _self = self
        _self.imports += imports
        return _self
    }
    
    public func with(imports: [Import]) -> File {
        var _self = self
        _self.imports = imports
        return _self
    }
    
    public func adding(member: FileBodyMember?) -> File {
        var _self = self
        _self.body += [member].compactMap { $0 }
        return _self
    }
    
    public func adding(members: [FileBodyMember]) -> File {
        var _self = self
        _self.body += members
        return _self
    }
    
    public func with(body: [FileBodyMember]) -> File {
        var _self = self
        _self.body = body
        return _self
    }
}

// MARK: - MetaSwiftConvertible

extension Import {
    
    public var swiftString: String {
        return "\(testable ? "@testable " : .empty)import \(name)"
    }
}

extension File {
    
    public var swiftString: String {
        return [
            header.swiftString,
            imports.map { $0.swiftString }.br,
            body.map { $0.swiftString }.br
        ].br(2).br.cleaned
    }
}
