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

class JeevesChatViewController: JSQMessagesViewController {
    
    // MARK:- Properties
    
    // Code for Ejabberd backend properties
    // XMPP Framework to be implemented
    
    private let imageURLNotSetKey = "NOTSET"
    
    private var messages: [JSQMessage] = []
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    private var localTyping = false
    
    var isTypeing: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
        }
    }
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    // MARK:- View Lifecylce.
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
    
    // MARK: UI and User Interaction
    // Bubble methods so far...
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
}
