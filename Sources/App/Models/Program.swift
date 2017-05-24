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

final class Program: Model {
    
    let storage = Storage()
    var name: String
    var path: String
    var description: String?
    
    init(name: String, path: String, description: String?) {
        self.name = name
        self.path = path
        self.description = description
    }
    
    init(row: Row) throws {
        name = try row.get("name")
        path = try row.get("path")
        description = try row.get("description")
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("path", path)
        try row.set("description", description)
        return row
    }
    
}

extension Program: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (creator) in
            creator.id()
            creator.string("name")
            creator.string("path")
            creator.string("description",
                           length: nil,
                           optional: true,
                           unique: false,
                           default: nil)
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
}

extension Program: JSONConvertible {
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("name", name)
        try json.set("path", path)
        try json.set("description", description)
        return json
    }
    
    convenience init(json: JSON) throws {
        self.init(
            name: try json.get("name"),
            path: try json.get("path"),
            description: try json.get("description")
        )
    }
    
}

extension Program: NodeConvertible {
    
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("id", id)
        try node.set("name", name)
        try node.set("path", path)
        return node
    }
    
    convenience init(node: Node) throws {
        self.init (
            name: try node.get("name"),
            path: try node.get("path"),
            description: try node.get("description")
        )
    }
    
}

extension Program: ResponseRepresentable {}
