//
//  DoCatch.swift
//  Meta
//
//  Created by Théophane Rupin on 3/25/19.
//

public struct Catch: MetaSwiftConvertible {
    
    public let assignment: Assignment?
    
    public var body: [FunctionBodyMember] = []
    
    public init(assignment: Assignment? = nil) {
        self.assignment = assignment
    }
    
    public func adding(member: FunctionBodyMember?) -> Catch {
        var _self = self
        _self.body += [member].compactMap { $0 }
        return _self
    }
    
    public func adding(members: [FunctionBodyMember]) -> Catch {
        var _self = self
        _self.body += members
        return _self
    }
    
    public func with(body: [FunctionBodyMember]) -> Catch {
        var _self = self
        _self.body += body
        return _self
    }
}

public struct Do: Node {
  
    public let body: [FunctionBodyMember]
    
    public var catches: [Catch]

    public init(body: [FunctionBodyMember], catch: Catch) {
        self.body = body
        self.catches = [`catch`]
    }
    
    public init(body: [FunctionBodyMember], catches: [Catch]) {
        self.body = body
        self.catches = catches
    }
}

extension Do: FunctionBodyMember {}

// MARK: - MetaSwiftConvertible

extension Catch {
    
    public var swiftString: String {
        let assignment = self.assignment?.swiftString.suffixed(" ") ?? .empty
        let body = self.body.map { $0.swiftString }.indented
        return """
        catch \(assignment){
        \(body)
        }
        """
    }
}

extension Do {
    
    public var swiftString: String {
        let body = self.body.map { $0.swiftString }.indented
        let catches = self.catches.map { $0.swiftString }.joined(separator: " ")
        return """
        do {
        \(body)
        } \(catches)
        """
    }
}
