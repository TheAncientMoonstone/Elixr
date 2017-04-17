//
//  Message.swift
//  Elixr
//
//  Created by Timothy Richardson on 16/4/17.
//  Copyright © 2017 Timothy Richardson. All rights reserved.
//


import Foundation
import JSQMessagesViewController

class Message: NSObject, JSQMessageData {


    var senderID_:String!
    var senderDisplayName_: String!
    var date_: Date
    var isMediaMessage_: Bool
    var hash_: UInt = 0
    var text_: String
    var imageUrl_: String?
    
    init(senderID: String, senderDisplayName: String?, isMediaMessage: Bool, hash: Int, text: String, imageUrl: String) {
        self.senderID_ = senderID
        self.senderDisplayName_ = senderDisplayName
        self.date_ = Date()
        self.isMediaMessage_ = isMediaMessage
        self.hash_ = UInt(hash)
        self.text_ = text
    }
    
    func senderId() -> String! {
        return senderID_;
    }
    
    func senderDisplayName() -> String! {
        return senderDisplayName_;
    }
    
    func date() -> Date {
        return date_;
    }
    
    func isMediaMessage() -> Bool {
        return isMediaMessage_;
    }
    
    func messageHash() -> UInt {
        return messageHash();
    }
    
    func text() -> String! {
        return text_;
    }
    
    func imageUrl() -> String? {
        return imageUrl_;
    }
    
    
}
