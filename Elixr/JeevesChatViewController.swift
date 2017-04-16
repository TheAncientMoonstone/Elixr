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
    var avatars = Dictionary<String, UIImage>()
    
    // MARK:- View Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
    }

    /*
     
    // MARK:- Incoming and Outgoing Message Bubbles.
    func incomingMessagesBubbleImage(with color: UIColor) -> JSQMessagesBubbleImage {
      let incomingMessageBubbleImageView = UIColor.jsq_messageBubbleRed()

        return nil
    }
    
    func outgoingMessagesBubbleImage(with color: UIColor) -> JSQMessagesBubbleImage {
        let outgoingMessageBubbleImageView = UIColor.jsq_messageBubbleBlue()
        
        return nil
    }
 
    // MARK:- User Avatar Images.
    func setupAvatarImage(_ name: String, imageUrl: String?, incoming: Bool) {
        if let stringUrl = imageUrl {
            if let url = URL(string: stringUrl) {
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
                    let avatarImage = JSQMessagesAvatarImageFactory.avatar(with: image, diameter: diameter)
                    avatars[name] = avatarImage
                    
                    return
                }
            }
        }
        // At some point something is bound to go wrong, and fails to get the image.
        setupAvatarImage(name, imageUrl: <#String?#>, incoming: incoming)
    }
     
    */
    
}
