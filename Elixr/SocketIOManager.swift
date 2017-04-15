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
    
    // Establishes connection to the server.
    func establishConnection() {
        socket.connect()
    }
    
    // Closes the connection to the server.
    func closeConnection() {
        socket.disconnect()
    }
    
    // Sends the nickname to the server.
    func connectToServerWithNickname(nickname: String, completionHandler: (_ userList: [[String: AnyObject]]?) -> Void) {
        socket.emit("connectUser", with: nickname)
        
    }
}
