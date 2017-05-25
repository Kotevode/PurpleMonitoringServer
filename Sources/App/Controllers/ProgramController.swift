//
//  ProgrammController.swift
//  PurpleMonitoringServer
//
//  Created by Mark on 24.05.17.
//
//

import Vapor
import Model

final class ProgramController: ResourceRepresentable {
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try Program.all().makeJSON()
    }
    
    func makeResource() -> Resource<Program> {
        return Resource(
            index: index
        )
    }
    
}

extension ProgramController: EmptyInitializable {}
