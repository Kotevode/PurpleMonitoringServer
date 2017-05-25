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
        case wrongJSON
        case programNotFound(id: Int)
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
                throw CommandError.wrongJSON
        }
        guard let program = try Program.find(id) else {
            throw CommandError.programNotFound(id: id)
        }
        self.init(
            program: program,
            nodes: try nodes.map { try Node(json: $0) }
        )
    }
    
}
