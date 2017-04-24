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
    // ChatScript Server instance declared with URL and port required.
    func setupChatScript() {
        ChatScriptSocket = SocketIOManager(url: "http://ec2-52-64-166-153.ap-southeast-2.compute.amazonaws.com:1024")
        
        // Capture the last 25 - 50 of chat bubbles in the conversation.
        // To either be declared here or elsewhere.
        // So if it has already been declared don't worry about this! XD
        
    }
    
    // MARK:- View Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        automaticallyScrollsToMostRecentMessage = true
        
        
        //Added by Vivek : Start
        self.senderId = messages.first?.senderID_
        self.senderDisplayName = messages.first?.senderDisplayName_
        //Added by Vivek : End
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
        // But in all seriousness - this may caused by a broken URL so don't panic.
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
    
    // MARK:- Buttons & UI.
    // Some shit goes here...
    // WHIZ!, BANG, KAPOW!
    
    // MARK:- Collection Views.
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    /* override */ func collectionView(_ collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAt indexPath: IndexPath!) -> JSQMessagesBubbleImage {
        let message = messages[indexPath.item]
        
        if message.senderId() == senderId {
            return JSQMessagesBubbleImage(messageBubble: outgoingBubbleImageView!.messageBubbleImage, highlightedImage: outgoingBubbleImageView!.messageBubbleHighlightedImage)
        }
        return JSQMessagesBubbleImage(messageBubble: incomingBubbleImageView!.messageBubbleHighlightedImage, highlightedImage: incomingBubbleImageView!.messageBubbleHighlightedImage)
    }
    
    /* override */ func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAt indexPath: IndexPath!) -> JSQMessagesAvatarImage! {
        let message = messages[indexPath.item]
        return avatars[message.senderId()]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.senderId() == self.senderId {
            cell.textView.textColor = UIColor.black
        } else {
            cell.textView.textColor = UIColor.white
        }
        
        let attributes: [String:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor!, NSUnderlineStyleAttributeName: 1 as AnyObject]
        cell.textView.linkTextAttributes = attributes
        
        return cell
    }
    
    
    // Reveal the usernames above the the bubbles.
     /* override */ func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let message = messages[indexPath.item];
        
        // Sent by the user?
        if message.senderId() == senderId {
            return nil;
        }
        
        // Same as previous sender??
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId() == message.senderId() {
                return nil;
            }
        }
        return NSAttributedString(string: message.senderId())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        if self.senderId == messages[indexPath.row].senderID_ {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .green)
        }else{
            return bubbleFactory?.incomingMessagesBubbleImage(with: .blue)
        }
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        return NSAttributedString(string: messages[indexPath.row].senderDisplayName_)
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
}
