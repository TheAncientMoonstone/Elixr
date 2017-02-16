//
//  JeevesChatViewController.swift
//  Elixr
//
//  Created by Timothy Richardson on 16/2/17.
//  Copyright © 2017 Timothy Richardson. All rights reserved.
//

import UIKit

class JeevesChatViewController: UIViewController, UITableViewDelegate,
    UITableViewDataSource, UITextViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var lblNewsBanner: UILabel!
    @IBOutlet weak var lblOtherUserActivitiy: UILabel!
    @IBOutlet weak var tvMessageEditor: UITextView!
    @IBOutlet weak var conBottomEditor: NSLayoutConstraint!
    
    let nickname = String()
    let chatMessages = [[String: AnyObject]]()
    var bannerLabelTimer = Timer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: Selector(("handlekeyboardDidShowNotification:")), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: Selector(("handleKeyboardDidHideNotifcation:")), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: Selector(("handleConnectedUserUpdateNotification:")), name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: Selector(("handleDisconnectedUserUpdatenotification")), name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: Selector(("handleUserTypingNotification")), name: NSNotification.Name(rawValue: "userTypingNotification"), object: nil)
        
        let swipeGestureRecogniser =
            UISwipeGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        swipeGestureRecogniser.direction = UISwipeGestureRecognizerDirection.down
        swipeGestureRecogniser.delegate = self
        view.addGestureRecognizer(swipeGestureRecogniser)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
         configureTableView()
         configureNewsBannerLabel()
         configureOtherUserActivityLabel()
         
         tvMessageEditor.delegate = self
        */
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:- Send button action.
    @IBAction func sendMessage(_ sender: Any) {
        
    }
    
    // Mark:- Custom UI methods.
    
    func configureTableView() {
        tblChat.delegate = self
        tblChat.dataSource = self
        tblChat.register(UINib(nibName: "ChatCell", bundle: nil),
                         forCellReuseIdentifier: "idCellChat")
        tblChat.estimatedRowHeight = 90.0
        tblChat.rowHeight = UITableViewAutomaticDimension
        tblChat.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func configureNewsBannerLabel() {
        lblNewsBanner.layer.cornerRadius = 15.0
        lblNewsBanner.clipsToBounds = true
        lblNewsBanner.alpha = 0.0
    }
    
    func configureOtherUserActivityLabel() {
        lblOtherUserActivitiy.isHidden = true
        lblOtherUserActivitiy.text = ""
    }
    
    func handleKeyboardDidShowNotification(notfication: Notification) {
        if let userInfo = notfication.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as?
                NSValue)?.cgRectValue {
                conBottomEditor.constant = keyboardFrame.size.height
                view.layoutIfNeeded()
            }
        }
    }
    
    func handleKeyboardDidHideNotification(notification: Notification) {
        conBottomEditor.constant = 0
        view.layoutIfNeeded()
    }
    
    func scrollToBottom() {
        let delay = 0.1 * Double(NSEC_PER_SEC)
        
        dispatch_after(DispatchTime.now(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay)), DispatchQueue.main) { () -> Void in
            if self.chatMessages.count > 0 {
                let lastRowIndexPath = NSIndexPath(forRow: self.chatMessages.count - 1, inSection: 0)
                self.tblChat.scrollToRowAtIndexPath(lastRowIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
        }
    }
    
    func showBannerLabelAnimated() {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.lblNewsBanner.alpha = 1.0
        }) { (finished) -> Void in
            self.bannerLabelTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: Selector(("hiddenBannerLabel")), userInfo: nil, repeats: false)
        }
    }
    
    func hideBannerLabel() {
        if bannerLabelTimer != nil {
            bannerLabelTimer.invalidate()
            bannerLabelTimer = nil
        }
        
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.lblNewsBanner.alpha = 0.0
            
            }) { (finished) -> Void in
        }
    }
    
    func dismissKeyboard() {
        if tvMessageEditor.isFirstResponder {
            tvMessageEditor.resignFirstResponder()
        }
    }
    
    func handleConnectedUserUpdateNotification(notification: Notification) {
        let connectedUserInfo = notification.object as! [String: AnyObject]
        let connectedUserNickname = connectedUserInfo["nickname"] as? String
        lblNewsBanner.text = "User \(connectedUserNickname!.uppercased()) has now connected.)"
        showBannerLabelAnimated()
    }
    
    func handleDisconnectedUserUpdateNotification(notification: Notification) {
        let disconnectedUserNickname = notification.object as! String
        lblNewsBanner.text = "User \(disconnectedUserNickname.uppercased()) has now left the chat."
        showBannerLabelAnimated()
    }
    
    func handleUserTypingNotification(notification: Notification) {
        if let typingUsersDicitionary = notification.object as? [String: AnyObject] {
            var names = ""
            var totalTypingUsers = 0
            for (typingUser, _) in typingUsersDicitionary {
                if typingUser != nickname {
                    names = (names == "") ? typingUser : "\(names), \(typingUser)"
                    totalTypingUsers += 1
                }
            }
            
            if totalTypingUsers > 0 {
                let verb = (totalTypingUsers == 1) ? "is" : "are"
                lblOtherUserActivitiy.text = "\(names) \(verb) now typing a message..."
                lblOtherUserActivitiy.isHidden = false
            }
            else {
                lblOtherUserActivitiy.isHidden = true
            }
        }
    }
    
    // MARK:- UITableView Delegate and Datasource Methods.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellChat", forIndexPath: indexPath) as! ChatCell
        
        let currentChatMessage = chatMessages[indexPath.row]
        let senderNickname = currentChatMessage["nickname"] as! String
        let message = currentChatMessage["message"] as! String
        let messageDate = currentChatMessage["date"] as! String
        
        if senderNickname == nickname {
            cell.lblChatMessage.textAlignment = NSTextAlignment.right
            cell.lblMessageDetails.textAlignment = NSTextAlignment.right
            cell.lblChatMessage.textColor = lblNewsBanner.backgroundColor
        }
        
        cell.lblChatMessage.text = message
        cell.lblMessageDetails.text = "by \(senderNickname.uppercased()) @ \(messageDate)"
        
        cell.lblChatMessage.textColor() = UIColor.darkGray
        
        return cell
    }
    
    // Mark: - UITextViewDelegate Methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // Code goes here
        
        return true
    }
    
    // UIGestureRecognizerDelegate Methods
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
