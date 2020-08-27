//
//  SocketConnect.swift
//  Aqar55
//
//  Created by Dacall soft on 25/05/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import Foundation
import UIKit
import SocketIO


class SocketConnect{
    
    static let sharedInstance = SocketConnect()
    
    let manager = SocketManager(socketURL: URL(string: "http://3.17.47.210:30054555")!, config: [.log(true), .compress])
    
    let socket = SocketManager(socketURL: URL(string: "http://3.17.47.210:3005")!, config: [.log(true), .compress]).defaultSocket
    
    var isConnected = false
        
    func connectWithSocket() {
        
        socket.connect()
        socket.on(clientEvent: .connect) {data, ack in
            
            print(data)
            print(ack)
            
            print("socket connected")
            
            self.isConnected = true
        }
    }
    
}


