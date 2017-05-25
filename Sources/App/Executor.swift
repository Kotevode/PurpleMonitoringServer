//
//  Executor.swift
//  PurpleMonitoringServer
//
//  Created by Mark on 24.05.17.
//
//

import Foundation
import Model

final class Executor {
    
    public var logReceivers = [LogReceiver]()
    
    init() {}
    
    init(logReceivers: [LogReceiver]) {
        self.logReceivers = logReceivers
    }
    
    enum ExecutorError: Error {
        case cannotCreatePipe
        case cannotReadPipe
    }
    
    func execute(command: Command) throws {
        let pipePath = try createPipeFor(program: command.program)
        
        let p = Process()
        p.launchPath = command.program.path
        p.arguments = [pipePath]
        p.launch()
        
        guard let filehandle = FileHandle(forReadingAtPath: pipePath) else {
            throw ExecutorError.cannotReadPipe
        }
        filehandle.readabilityHandler = handleLog(handle:)
        
        p.waitUntilExit()
        filehandle.closeFile()
        remove(pipePath.cString(using: .utf8))
    }
    
    func createPipeFor(program: Program) throws -> String {
        let fifoPath = "/tmp/\(Date().timeIntervalSince1970)_" +
        "\(program.name.replacingOccurrences(of: " ", with: ""))"
        guard mkfifo(fifoPath.cString(using: .utf8), S_IRWXO | S_IRWXG | S_IRWXU) >= 0 else {
            throw ExecutorError.cannotCreatePipe
        }
        return fifoPath
    }
    
    func handleLog(handle: FileHandle) {
        let sizeData = handle.readData(ofLength: 8)
        let size = sizeData.withUnsafeBytes({ (ptr) -> UInt64 in
            return ptr.pointee
        })
        let messageData = handle.readData(ofLength: Int(size))
        if let message = String(data: messageData, encoding: .utf8) {
            logReceivers.forEach { $0.receive(message: message) }
        }
    }
    
}
