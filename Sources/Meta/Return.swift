//
//  Return.swift
//  Meta
//
//  Created by Théophane Rupin on 3/4/19.
//

public struct Return: Hashable, Node {
    
    public let value: VariableValue
    
    public init(value: VariableValue) {
        self.value = value
    }
}

extension Return: FunctionBodyMember {}

// MARK: - MetaSwiftConvertible

extension Return {
    
    public var internalSwiftString: String {
        return "return \(value.swiftString)"
    }
    
    public var swiftString: String {
        guard let value = value as? VariableValue & CrossPlateformVariableValue else {
            return internalSwiftString
        }
        
        let plateforms = Set(value.plateforms).sorted()
        guard plateforms.isEmpty == false else {
            return internalSwiftString
        }
        
        var platformCombinations = plateforms.combinationsWithoutRepetition
        platformCombinations.removeFirst()
        if platformCombinations.count > 1 {
            platformCombinations.removeLast()
        }
        let valueCombinations = platformCombinations.compactMap { plateforms in
            value.filtering(for: plateforms).flatMap { (plateforms, $0) }
        }
        
        return "#if " + valueCombinations
            .enumerated()
            .map { index, element in
                let includedPlateforms = element.0
                let value = element.1
                let isLast = index == platformCombinations.count - 1
                return """
                \(includedPlateforms.map { "os(\($0))" }.joined(separator: " || "))
                \(Return(value: value).internalSwiftString)
                \(isLast ? "#else" : "#elseif ")
                """
            }.joined() + """
            
            \(value.filtering(for: []).flatMap { Return(value: $0) }?.internalSwiftString ?? "")
            #endif
            """
    }
}
