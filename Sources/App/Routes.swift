import Vapor

final class Routes: RouteCollection {
    func build(_ builder: RouteBuilder) throws {
        
        builder.socket("execute") { rq, ws in
            
            ws.onText = { ws, text in
                do {
                    let command = try ExecuteCommand(json: JSON(bytes: text.makeBytes()))
                    let executor = Executor(
                        logReceivers: [
                            WebSocketLogReceiver(webSocket: ws)
                        ]
                    )
                    try executor.execute(command: command)
                    try ws.close()
                } catch let e {
                    debugPrint(e.localizedDescription)
                    try ws.close(statusCode: 32, reason: e.localizedDescription)
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
