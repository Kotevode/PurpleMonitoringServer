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
    var process: Process
    var pipePath: String
    
    init(logReceivers: [LogReceiver], command: Command, mpiexec: String) {
        self.logReceivers = logReceivers
        process = Process()
        process.launchPath = mpiexec
        pipePath = Utils.generatePipePath(program: command.program)
        process.arguments = [
            "-n",
            "4",
            command.program.path,
            pipePath
        ]
    }
    
    enum ExecutorError: Error {
        case terminated(message: String)
    }
    
    func execute() throws {
        try createPipe()
        process.launch()
        guard let filehandle = FileHandle(forReadingAtPath: pipePath) else {
            throw ExecutorError.terminated(message: "Cannot open pipe")
        }
        filehandle.readabilityHandler = handleLog(handle:)
        process.waitUntilExit()
        removePipe()
        if process.terminationReason == .uncaughtSignal {
            throw ExecutorError.terminated(
                message: "Execution aborted with error code \(process.terminationStatus)"
            )
        }
    }
    
    func terminate() {
        process.terminate()
        removePipe()
    }
    
    func createPipe() throws  {
        guard mkfifo(pipePath.cString(using: .utf8), S_IRWXO | S_IRWXG | S_IRWXU) >= 0 else {
            throw ExecutorError.terminated(message: "Cannot create pipe")
        }
    }
    
    func removePipe() {
        remove(pipePath.cString(using: .utf8))
    }
    
    func handleLog(handle: FileHandle) {
        // Считывание 8 байт как размер сообщения
        let sizeData = handle.readData(ofLength: 8)
        let size = sizeData.withUnsafeBytes({ (ptr) -> UInt64 in
            return ptr.pointee
        })
        // Считывание size байт как тело сообщения
        let messageData = handle.readData(ofLength: Int(size))
        if let message = String(data: messageData,
                                encoding: .utf8) {
            // Передача сообщения всем конечным получателям
            logReceivers.forEach { $0.receive(message: message) }
        }
    }
    
}
