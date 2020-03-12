//
//  Reference.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

public enum ReferenceName: Hashable, MetaSwiftConvertible {
    case `init`
    case `self`
    case print
    case map
    case flatMap
    case compactMap
    case `super`
    case custom(String)
}

public enum Reference: Hashable, MetaSwiftConvertible, Node {
    case type(TypeIdentifier)
    case _name(ReferenceName, plateforms: [String])
    case tuple(Tuple)
    case unwrap
    case `try`
    case optionalTry
    case `throw`
    case block(FunctionBody)
    case `as`
    case none
    indirect case dot(Reference, Reference)
    indirect case assemble(Reference, Reference)
    
    public static func named(_ name: String, plateforms: [String] = []) -> Reference {
        return ._name(.custom(name), plateforms: plateforms)
    }
    
    public static func named(_ name: ReferenceName, plateforms: [String] = []) -> Reference {
        return ._name(name, plateforms: plateforms)
    }
    
    public static func call(_ tuple: Tuple = Tuple()) -> Reference {
        return .tuple(tuple)
    }
    
    public var array: [Reference] {
        switch self {
        case .type,
             ._name,
             .tuple,
             .unwrap,
             .try,
             .optionalTry,
             .throw,
             .block,
             .as:
            return [self]
        case .none:
            return []
        case .dot(let lhs, let rhs),
             .assemble(let lhs, let rhs):
            return lhs.array + rhs.array
        }
    }
    
    public var isTry: Bool {
        switch self {
        case .try:
            return true
        default:
            return false
        }
    }
    
    public var isThrow: Bool {
        switch self {
        case .throw:
            return true
        default:
            return false
        }
    }
}

extension Reference: VariableValue {}
extension Reference: FunctionBodyMember {}
extension Reference: AssignmentVariable {}
extension Reference: CrossPlateformVariableValue {}

public func | (_ lhs: Reference, _ rhs: Reference) -> Reference {
    return .assemble(lhs, rhs)
}

public func + (_ lhs: Reference, _ rhs: Reference) -> Reference {
    return .dot(lhs, rhs)
}

public prefix func + (_ reference: Reference) -> Reference {
    return .dot(.none, reference)
}

// MARK: - MetaSwiftConvertible

extension ReferenceName {
    
    public var swiftString: String {
        switch self {
        case .`init`:
            return "init"
        case .`self`:
            return "self"
        case .print:
            return "print"
        case .map:
            return "map"
        case .flatMap:
            return "flatMap"
        case .compactMap:
            return "compactMap"
        case .super:
            return "super"
        case .custom(let value):
            return value
        }
    }
}

// MARK: - CrossPlateformVariableValue

extension Reference {
    
    var plateforms: [String] {
        switch self {
        case .tuple(let tuple):
            return tuple.plateforms + tuple.parameters.flatMap { $0.plateforms }
        case ._name(_, let plateforms):
            return plateforms
        case .dot(let lhs, let rhs),
             .assemble(let lhs, let rhs):
            return lhs.plateforms + rhs.plateforms
        default:
            return []
        }
    }
    
    func filtering(for includedPlateforms: [String]) -> Reference? {
        switch self {
        case .tuple(let tuple):
            let includedPlateformsSet = Set(includedPlateforms)
            guard tuple.plateforms.isEmpty || includedPlateformsSet.intersection(tuple.plateforms).isEmpty == false else {
                return nil
            }
            
            return .tuple(tuple
                .with(parameters: tuple.parameters.lazy
                    .filter {
                        $0.plateforms.isEmpty || includedPlateformsSet.intersection($0.plateforms).isEmpty == false
                }
                .map { $0.with(plateforms: []) })
                .with(plateforms: []))
            
        case ._name(let name, let plateforms):
            let includedPlateformsSet = Set(includedPlateforms)
            guard plateforms.isEmpty || includedPlateformsSet.intersection(plateforms).isEmpty == false else {
                return nil
            }
            return ._name(name, plateforms: [])
            
        case .dot(let lhs, let rhs):
            guard let lhs = lhs.filtering(for: includedPlateforms), let rhs = rhs.filtering(for: includedPlateforms) else {
                return nil
            }
            return .dot(lhs, rhs)

        case .assemble(let lhs, let rhs):
            guard let lhs = lhs.filtering(for: includedPlateforms), let rhs = rhs.filtering(for: includedPlateforms) else {
                return nil
            }
            return .assemble(lhs, rhs)

        default:
            return self
        }
    }
}

extension Reference {
    
    public var internalSwiftString: String {
        switch self {
        case .dot(let lhs, let rhs):
            return "\(lhs.swiftString).\(rhs.swiftString)"
        case .assemble(let lhs, let rhs):
            return "\(lhs.swiftString)\(rhs.swiftString)"
        case .type(let type):
            return type.swiftString
        case ._name(let name, _):
            return name.swiftString
        case .tuple(let tuple):
            return tuple.swiftString
        case .unwrap:
            return "?"
        case .try:
            return "try "
        case .optionalTry:
            return "try? "
        case .throw:
            return "throw "
        case .block(let block):
            return block.swiftString.prefixed(" ")
        case .as:
            return " as "
        case .none:
            return ""
        }
    }
    
    public var swiftString: String {
                
        let plateforms = Set(self.plateforms).sorted()
        guard plateforms.isEmpty == false else {
            return internalSwiftString
        }
        
        var platformCombinations = plateforms.combinationsWithoutRepetition
        platformCombinations.removeFirst()
        if platformCombinations.count > 1 {
            platformCombinations.removeLast()
        }
        let referenceCombinations = platformCombinations.compactMap { plateforms in
            filtering(for: plateforms).flatMap { (plateforms, $0) }
        }
        
        return "#if " + referenceCombinations
            .enumerated()
            .map { index, element in
                let includedPlateforms = element.0
                let reference = element.1
                let isLast = index == platformCombinations.count - 1
                return """
                \(includedPlateforms.map { "os(\($0))" }.joined(separator: " || "))
                \(reference.internalSwiftString)
                \(isLast ? "#else" : "#elseif ")
                """
            }.joined() + """
            
            \(filtering(for: [])?.internalSwiftString ?? "")
            #endif
            """
    }
}

