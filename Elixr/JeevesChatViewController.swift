//
//  JeevesChatViewController.swift
//  Elixr
//
//  Created by Timothy Richardson on 17/2/17.
//  Copyright © 2017 Timothy Richardson. All rights reserved.
//

import UIKit
import Photos
import JSQMessagesViewController
import Alamofire
import SocketIO

class JeevesChatViewController: JSQMessagesViewController {
    
    // MARK:- Properties
    var messages = [Message]()
    var avatars = [String: JSQMessagesAvatarImage]()
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleRed())
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    var senderImageUrl: String!
    var batchMessages = true
    var ref: SocketIOManager!
    
    // Set up the connection to the ChatScript server instance.
    var ChatScriptSocket: SocketIOManager!
    
    // Sets up initial properties to connect to the chatscript server instance.
    func setupChatScript() {
        ChatScriptSocket = SocketIOManager(url: "http://ec2-52-64-166-153.ap-southeast-2.compute.amazonaws.com:1024")
        
        // Capture the last 25 - 50 of chat bubbles in the conversation.
        
        
    }
    
    // MARK:- View Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        automaticallyScrollsToMostRecentMessage = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
    }
    
    
    // MARK:- Avatar Image.
    func setupAvatarImage(_ name: String, imageUrl: String?, incoming: Bool) {
        if let stringUrl = imageUrl {
            if let url = URL(string: stringUrl) {
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
                    let avatarImage = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: diameter)
                    avatars[name] = avatarImage
                    return
                }
            }
        }
        // At point in use something fucks up.... Not my problem, LOL XD!
        setupAvatarImage(name, imageUrl: imageUrl, incoming: incoming)
    }
    
    // MARK:- Avatar Image Color.
    func setupAvatarImageColor(_ name: String, incoming: Bool) {
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        let nameLength = name.characters.count
        let initials : String? = name.substring(to: senderId.index(senderId.startIndex, offsetBy:min(3, nameLength)))
        let userImage = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: initials, backgroundColor: color, textColor: UIColor.black, font: UIFont.systemFont(ofSize: CGFloat(13)), diameter: diameter)
        avatars[name] = userImage

    }
    
    
    // MARK:- Collection Views
    func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAt indexPath: IndexPath!) -> JSQMessagesAvatarImage! {
        let message = messages[indexPath.item]
            return avatars[message.senderId()]
        }
    
}
