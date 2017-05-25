//
//  Programm.swift
//  PurpleMonitoringServer
//
//  Created by Mark on 24.05.17.
//
//

import Vapor
import FluentProvider
import HTTP

public final class Program: Model {
    
    public let storage = Storage()
    public var name: String
    public var path: String
    public var description: String?
    
    init(name: String, path: String, description: String?) {
        self.name = name
        self.path = path
        self.description = description
    }
    
    public init(row: Row) throws {
        name = try row.get("name")
        path = try row.get("path")
        description = try row.get("description")
    }

    public func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("path", path)
        try row.set("description", description)
        return row
    }
    
}

extension Program: Preparation {
    
    public static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (creator) in
            creator.id()
            creator.string("name")
            creator.string("path")
            creator.string("description",
                           optional: true)
        })
    }
    
    public static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

extension Program: JSONConvertible {
    
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("name", name)
        try json.set("path", path)
        try json.set("description", description)
        return json
    }
    
    public convenience init(json: JSON) throws {
        self.init(
            name: try json.get("name"),
            path: try json.get("path"),
            description: try json.get("description")
        )
    }
    
}

extension Program: NodeInitializable {
    
    public convenience init(node: Vapor.Node) throws {
        self.init (
            name: try node.get("name"),
            path: try node.get("path"),
            description: try node.get("description")
        )
    }
    
}

extension Program: ResponseRepresentable {}
