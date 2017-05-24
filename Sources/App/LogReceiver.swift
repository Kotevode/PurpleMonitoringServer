//
//  LogReceiver.swift
//  PurpleMonitoringServer
//
//  Created by Mark on 24.05.17.
//
//

import Foundation

protocol LogReceiver {
    
    func receive(message: String)
    
}
