//
//  File.swift
//  PurpleMonitoringServer
//
//  Created by Mark on 25.05.17.
//
//

import Vapor
import FluentProvider

public final class Node: Model {
    
    public let storage = Storage()
    public var hostName: String
    public var coreNumber: UInt

    public init(hostName: String, coreNumber: UInt) {
        self.hostName = hostName
        self.coreNumber = coreNumber
    }
    
    public init(row: Row) throws {
        hostName = try row.get("hostName")
        coreNumber = try row.get("coreNumber")
    }
    
    public func makeRow() throws -> Row {
        var row = Row()
        try row.set("hostName", hostName)
        try row.set("coreNumber", coreNumber)
        return row
    }
    
}

extension Node: Preparation {
    
    public static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (creator) in
            creator.id()
            creator.string("hostName",
                           unique: true)
            creator.int("coreNumber")
        })
    }
    
    public static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

extension Node: JSONConvertible {
    
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("hostName", hostName)
        try json.set("coreNumber", coreNumber)
        return json
    }
    
    public convenience init(json: JSON) throws {
        self.init(
            hostName: try json.get("hostName"),
            coreNumber: try json.get("coreNumber"))
    }
    
}

extension Node: NodeInitializable {

    public convenience init(node: Vapor.Node) throws {
        self.init(
            hostName: try node.get("hostName"),
            coreNumber: try node.get("coreNumber")
        )
    }
    
}
