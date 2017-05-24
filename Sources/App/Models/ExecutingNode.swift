//
//  File.swift
//  PurpleMonitoringServer
//
//  Created by Mark on 25.05.17.
//
//

import Vapor

final class ExecutingNode {
    
    var host: String
    var processCount: UInt

    init(host: String, processCount: UInt) {
        self.host = host
        self.processCount = processCount
    }
    
}

extension ExecutingNode: JSONInitializable {
    
    convenience init(json: JSON) throws {
        self.init(
            host: try json.get("host"),
            processCount: try json.get("processCount"))
    }
    
}
