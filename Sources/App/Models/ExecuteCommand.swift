//
//  ExecuteCommand.swift
//  PurpleMonitoringServer
//
//  Created by Mark on 24.05.17.
//
//

import Vapor

final class ExecuteCommand {
    
    var program: Program
    var nodes: [ExecutingNode]
    
    init(program: Program, nodes: [ExecutingNode]) {
        self.program = program
        self.nodes = nodes
    }
    
}

extension ExecuteCommand: JSONInitializable {
    
    convenience init(json: JSON) throws {
        guard
            let id = json["program"]?.int,
            let nodes = json["nodes"]?.array else {
                throw Abort(.badRequest, reason: "Wrong command, id and nodes needed")
        }
        guard let program = try Program.find(id) else {
            throw Abort(.notFound, reason: "Program not found")
        }
        self.init(
            program: program,
            nodes: try nodes.map { try ExecutingNode(json: $0) }
        )
    }
    
}
