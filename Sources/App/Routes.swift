import Vapor
import Model

final class Routes: RouteCollection {
    func build(_ builder: RouteBuilder) throws {
        
        builder.socket("execute") { rq, ws in
            
            ws.onText = { ws, text in
                do {
                    let command = try Command(json: JSON(bytes: text.makeBytes()))
                    let executor = Executor(
                        logReceivers: [
                            WebSocketLogReceiver(webSocket: ws)
                        ]
                    )
                    try executor.execute(command: command)
                    try ws.close()
                } catch Command.CommandError.wrongJSON {
                    try ws.close(statusCode: 4000, reason: "Cannot parse command from JSON")
                } catch Command.CommandError.programNotFound(let id) {
                    try ws.close(statusCode: 4000, reason: "Program \(id) not found")
                } catch let e {
                    try ws.close(statusCode: 4000, reason: e.localizedDescription)
                }
            }
            
        }
        
        try builder.resource("available", ProgramController.self)
    }
}

/// Since Routes doesn't depend on anything
/// to be initialized, we can conform it to EmptyInitializable
///
/// This will allow it to be passed by type.
extension Routes: EmptyInitializable { }
