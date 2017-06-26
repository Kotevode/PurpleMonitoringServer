import Vapor
import Model

final class Routes: RouteCollection {
    func build(_ builder: RouteBuilder) throws {
        
        builder.socket("execute") { rq, ws in
            
            var executor: Executor?
            
            ws.onText = { ws, text in
                do {
                    // Десериализация полученной команды
                    let command = try Command(json: JSON(bytes: text.makeBytes()))
                    
                    // Инициализация запуска
                    executor = Executor(
                        logReceivers: [
                            WebSocketLogReceiver(webSocket: ws),
                            ConsoleLogReceiver(),
                        ],
                        command: command,
                        mpiexec: "/usr/local/bin/mpiexec"
                    )
                    
                    //
                    try executor!.execute()
                    try ws.close(statusCode: 4000)
                } catch Command.CommandError.initError(let message) {
                    debugPrint(message)
                    try ws.close(statusCode: 4001, reason: message)
                } catch Executor.ExecutorError.terminated(message: let message) {
                    debugPrint(message)
                    try ws.close(statusCode: 4002, reason: message)
                } catch let e {
                    try ws.close(statusCode: 4001, reason: e.localizedDescription)
                }
            }
            
            ws.onClose = { ws, code, reason, _ in
                executor?.terminate()
                if let reason = reason {
                    debugPrint("Connection closed, reason: \(reason)")
                }
            }
            
        }
        
        try builder.resource("programs", ProgramController.self)
    }
}

/// Since Routes doesn't depend on anything
/// to be initialized, we can conform it to EmptyInitializable
///
/// This will allow it to be passed by type.
extension Routes: EmptyInitializable { }
