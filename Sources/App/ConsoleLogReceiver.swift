//
//  ConsoleLogReceiver.swift
//  PurpleMonitoringServer
//
//  Created by Mark on 24.05.17.
//
//

import Foundation

class ConsoleLogReceiver: LogReceiver {
    
    func receive(message: String) {
        debugPrint(message)
    }
    
}
