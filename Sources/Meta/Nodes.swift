//
//  TypeBody.swift
//  Meta
//
//  Created by Théophane Rupin on 3/3/19.
//

public protocol Node: MetaSwiftConvertible {}
public protocol VariableValue: Node {}
public protocol FunctionBodyMember: Node {}
public protocol TypeBodyMember: Node {}
public protocol FileBodyMember: Node {}
public protocol AssignmentVariable: Node {}
