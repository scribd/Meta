//
//  Property.swift
//  Meta
//
//  Created by Théophane Rupin on 3/4/19.
//

public struct Property: Hashable, Node {
    
    public var accessLevel: AccessLevel = .default
    
    public var objc = false
    
    public var `static` = false
    
    public let variable: Variable
    
    public var value: VariableValue?
    
    
    public init(variable: Variable) {
        self.variable = variable
    }
    
    public func with(accessLevel: AccessLevel) -> Property {
        var _self = self
        _self.accessLevel = accessLevel
        return _self
    }
    
    public func with(objc: Bool) -> Property {
        var _self = self
        _self.objc = objc
        return _self
    }
    
    public func with(static: Bool) -> Property {
        var _self = self
        _self.static = `static`
        return _self
    }
    
    public func with(value: VariableValue?) -> Property {
        var _self = self
        _self.value = value
        return _self
    }
}

extension Property: TypeBodyMember {}

public struct ProtocolProperty: Hashable, Node {
    
    public let name: String
    
    public let type: TypeIdentifier
    
    public var setter = false
    
    public init(name: String, type: TypeIdentifier) {
        self.name = name
        self.type = type
    }
    
    public func with(setter: Bool) -> ProtocolProperty {
        var _self = self
        _self.setter = setter
        return _self
    }
}

extension ProtocolProperty: TypeBodyMember {}

public struct ComputedProperty: Hashable, Node {
    
    public var accessLevel: AccessLevel = .default
    
    public var objc = false
    
    public let variable: Variable
    
    public var body: [FunctionBodyMember] = []
    
    public init(variable: Variable) {
        self.variable = variable
    }
    
    public func with(accessLevel: AccessLevel) -> ComputedProperty {
        var _self = self
        _self.accessLevel = accessLevel
        return _self
    }
    
    public func with(objc: Bool) -> ComputedProperty {
        var _self = self
        _self.objc = objc
        return _self
    }
    
    public func with(body: [FunctionBodyMember]) -> ComputedProperty {
        var _self = self
        _self.body = body
        return _self
    }
    
    public func adding(member: FunctionBodyMember?) -> ComputedProperty {
        var _self = self
        _self.body += [member].compactMap { $0 }
        return _self
    }
    
    public func adding(members: [FunctionBodyMember]) -> ComputedProperty {
        var _self = self
        _self.body += members
        return _self
    }
}

extension ComputedProperty: TypeBodyMember {}

public struct GetterSetter: Hashable, Node {
    
    public var accessLevel: AccessLevel = .default
    
    public let variable: Variable
    
    public var getterBody: [FunctionBodyMember]?
    
    public var setterBody: [FunctionBodyMember]?
    
    public init(variable: Variable) {
        self.variable = variable
    }
    
    public func with(accessLevel: AccessLevel) -> GetterSetter {
        var _self = self
        _self.accessLevel = accessLevel
        return _self
    }
    
    public func with(getter body: [FunctionBodyMember]?) -> GetterSetter {
        var _self = self
        _self.getterBody = body
        return _self
    }
    
    public func adding(getterMember: FunctionBodyMember?) -> GetterSetter {
        var _self = self
        _self.getterBody = (_self.getterBody ?? []) + [getterMember].compactMap { $0 }
        return _self
    }
    
    public func adding(getterMember: [FunctionBodyMember]) -> GetterSetter {
        var _self = self
        _self.getterBody = (_self.getterBody ?? []) + getterMember
        return _self
    }
    
    public func with(setter body: [FunctionBodyMember]?) -> GetterSetter {
        var _self = self
        _self.setterBody = body
        return _self
    }
    
    public func adding(setterMember: FunctionBodyMember?) -> GetterSetter {
        var _self = self
        _self.setterBody = (_self.setterBody ?? []) + [setterMember].compactMap { $0 }
        return _self
    }
    
    public func adding(setterMember: [FunctionBodyMember]) -> GetterSetter {
        var _self = self
        _self.setterBody = (_self.setterBody ?? []) + setterMember
        return _self
    }
}

extension GetterSetter: TypeBodyMember {}

// MARK: - MetaSwiftConvertible

extension Property {
    
    public var swiftString: String {
        let objc = self.objc ? "@objc " : .empty
        let `static` = self.static ? "static " : .empty
        let value = self.value?.swiftString.prefixed(" = ") ?? .empty
        return "\(objc)\(`static`)\(accessLevel.swiftString.suffixed(" "))\(variable.swiftString)\(value)"
    }
}

extension ProtocolProperty {
    
    public var swiftString: String {
        return "var \(name): \(type.swiftString) { get\(setter ? " set" : .empty) }"
    }
}

extension ComputedProperty {
    
    public var swiftString: String {
        let objc = self.objc ? "@objc " : .empty
        return """
        \(objc)\(accessLevel.swiftString.suffixed(" "))\(variable.with(immutable: false).swiftString) {
        \(body.map { $0.swiftString }.indented)
        }
        """
    }
}

extension GetterSetter {
    
    public var swiftString: String {
        
        let getter: String
        if let getterBody = getterBody {
            getter = """
            get {
            \(getterBody.map {$0.swiftString }.indented)
            }
            """
        } else {
            getter = .empty
        }
        
        let setter: String
        if let setterBody = setterBody {
            setter = """
            
            set {
            \(setterBody.map {$0.swiftString }.indented)
            }
            """
        } else {
            setter = .empty
        }
        
        return """
        \(accessLevel.swiftString.suffixed(" "))\(variable.with(immutable: false).swiftString) {
        \(getter.indented)\(setter.indented)
        }
        """
    }
}
