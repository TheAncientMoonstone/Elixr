//
//  AppMainTabOneViewController.swift
//  Elixr
//
//  Created by Timothy Richardson on 8/2/17.
//  Copyright © 2017 Timothy Richardson. All rights reserved.
//

import UIKit
import AWSMobileHubHelper
import AWSCognito
import AWSCognitoIdentityProvider

class AppMainViewController: UIViewController {
    
    // MARK:- Properties.
    var senderDisplayName: String?
    var message: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Adding a sign out button programmatically
        print("Signout button")
        navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(actionSignOut))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionSignOut() {
        
        if (AWSIdentityManager.default().isLoggedIn) {
            AWSIdentityManager.default().logout(completionHandler: { (result, error) in
                if result == nil {
                    self.actionNavigateToSignInView()
                }
            })
        } else {
            self.actionNavigateToSignInView()
        }
        
    }
    
    func actionNavigateToSignInView(){
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Sign In")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
        
    }
    
    // MARK:- Navigation to ChatViewController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        

        if segue.identifier == "SegueChat" {
            let chatVc = segue.destination as! JeevesChatViewController
            
            message.append(Message(senderID: "1", senderDisplayName: "Tim", isMediaMessage: false, hash: 1, text: "Hello Vivek", imageUrl: ""))
            message.append(Message(senderID: "2", senderDisplayName: "Vivek", isMediaMessage: false, hash: 1, text: "Hello Tim", imageUrl: ""))
            
            chatVc.senderDisplayName = senderDisplayName
            chatVc.messages = message

        }

    }
    
    
}
