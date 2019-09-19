//
//  Tuple.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

public struct TupleParameter: Hashable, MetaSwiftConvertible {
    
    public let variable: AssignmentVariable?
    
    public let value: VariableValue?
    
    public init(name: String, value: VariableValue) {
        self.variable = Reference.named(name)
        self.value = value
    }

    public init(variable: AssignmentVariable) {
        self.variable = variable
        self.value = nil
    }

    public init(value: VariableValue) {
        self.variable = nil
        self.value = value
    }
}

public struct Tuple: Hashable, Node {
    
    public var parameters: [TupleParameter] = []
    
    public init() {
        // no-op
    }
    
    public func with(parameters: [TupleParameter]) -> Tuple {
        var _self = self
        _self.parameters = parameters
        return _self
    }

    public func adding(parameter: TupleParameter?) -> Tuple {
        var _self = self
        _self.parameters += [parameter].compactMap { $0 }
        return _self
    }
    
    public func adding(parameters: [TupleParameter]) -> Tuple {
        var _self = self
        _self.parameters += parameters
        return _self
    }
}

extension Tuple: FileBodyMember {}
extension Tuple: FunctionBodyMember {}
extension Tuple: VariableValue {}

// MARK: - MetaSwiftConvertible

extension TupleParameter {
    
    public var swiftString: String {
        let variable = self.variable?.swiftString ?? .empty
        let value = self.value?.swiftString ?? .empty
        return [variable, value].assemble(separator: ": ")
    }
}

extension Tuple {
    
    public var swiftString: String {
        let parameters = self.parameters.map { $0.swiftString }.joined(separator: ", ")
        
        if self.parameters.count > 4 || parameters.count > 80 {
            let parameters = self.parameters
                .map { $0.swiftString }
                .joined(separator: ",".br)
                .indented
        
            return """
            (
            \(parameters)
            )
            """
        } else {
            return "(\(parameters))"
        }
    }
}
