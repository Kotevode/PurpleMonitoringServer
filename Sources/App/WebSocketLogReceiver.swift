//
//  WebSocketLogReceiver.swift
//  PurpleMonitoringServer
//
//  Created by Mark on 25.05.17.
//
//

import HTTP

class WebSocketLogReceiver: LogReceiver {
    
    var webSocket: WebSocket
    
    init(webSocket: WebSocket) {
        self.webSocket = webSocket
    }
    
    func receive(message: String) {
        do {
            try webSocket.send(message)
        } catch let e {
            debugPrint(e.localizedDescription)
        }
    }
    
}
