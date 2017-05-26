//
//  Utils.swift
//  PurpleMonitoringServer
//
//  Created by Mark on 26.05.17.
//
//

import Foundation
import Model

class Utils {
    
    static func generatePipePath(program: Program) -> String {
        let fifoPath = "/tmp/\(Date().timeIntervalSince1970)_" +
        "\(program.name.replacingOccurrences(of: " ", with: ""))"
        return fifoPath
    }
}
