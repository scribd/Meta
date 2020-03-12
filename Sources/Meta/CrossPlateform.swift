//
//  CrossPlateform.swift
//  Meta
//
//  Created by Théophane Rupin on 3/12/20.
//

import Foundation

public protocol CrossPlateformMember {
    
    var plateforms: [String] { get set }
    
    var internalSwiftString: String { get }
}

public extension CrossPlateformMember {
    
    func with(plateforms: [String]) -> Self {
        var _self = self
        _self.plateforms = plateforms
        return _self
    }
    
    func adding(plateform: String) -> Self {
        var _self = self
        _self.plateforms.append(plateform)
        return _self
    }
}

public extension CrossPlateformMember where Self: MetaSwiftConvertible {

    var swiftString: String {
        guard plateforms.isEmpty == false else {
            return internalSwiftString
        }
        
        return """
        #if \(plateforms.map { "os(\($0))" }.joined(separator: " || "))
        \(internalSwiftString)
        #endif
        """
    }
}

protocol CrossPlateformVariableValue {
    
    var plateforms: [String] { get }
    
    func filtering(for includedPlateforms: [String]) -> Self?
}

// MARK: - Utils

extension Array where Element: Hashable {
    
    var combinationsWithoutRepetition: [[Element]] {
        guard isEmpty == false else { return [[]] }
        
        return Array(self[1...])
            .combinationsWithoutRepetition
            .flatMap { [$0, [self[0]] + $0] }
    }
}
