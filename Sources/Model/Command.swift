//
//  ExecuteCommand.swift
//  PurpleMonitoringServer
//
//  Created by Mark on 24.05.17.
//
//

import JSON

public final class Command {
    
    public enum CommandError: Error {
        case initError(message: String)
    }
    
    public var program: Program
    public var nodes: [Node]
    
    init(program: Program, nodes: [Node]) {
        self.program = program
        self.nodes = nodes
    }
    
}

extension Command: JSONInitializable {
    
    public convenience init(json: JSON) throws {
        guard
            let id = json["program"]?.int,
            let nodes = json["nodes"]?.array else {
                throw CommandError.initError(
                    message: "Cannot parse json: \(json)")
        }
        guard let program = try Program.find(id) else {
            throw CommandError.initError(message: "Program \(id) not found ")
        }
        self.init(
            program: program,
            nodes: try nodes.map { try Node(json: $0) }
        )
    }
    
}
