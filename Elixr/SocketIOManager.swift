//
//  SocketIOManager.swift
//  Elixr
//
//  Created by Timothy Richardson on 14/4/17.
//  Copyright © 2017 Timothy Richardson. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    
    static let sharedInstance = SocketIOManager()
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://ec2-52-64-166-153.ap-southeast-2.compute.amazonaws.com:1025")! as URL)

    override init() {
        super.init()
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
