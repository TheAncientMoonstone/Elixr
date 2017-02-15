//
//  MainViewController.swift
//  Elixr
//
//  Created by Timothy Richardson on 28/11/16.
//  Copyright © 2016 Timothy Richardson. All rights reserved.
//

import UIKit
import AWSMobileHubHelper
import FBSDKCoreKit
import FBSDKLoginKit

class MainViewController: UIViewController {
    
    var signInObserver: Any?
    var signOutObserver: Any?
    
    struct Static {
        static let onceToken = 0
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Present the Sign In View Controller.
        presentSignInViewController()
        
        signInObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AWSIdentityManagerDidSignIn, object: AWSIdentityManager.defaultIdentityManager(), queue: OperationQueue.main, using: {[weak self] (note: Notification) -> Void in
            guard let strongSelf = self else { return }
            print ("Sign in observer observed the successful sign in")
            strongSelf.setupRightBarButtonItem()
        })
        
        signOutObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AWSIdentityManagerDidSignOut, object: AWSIdentityManager.defaultIdentityManager(), queue: OperationQueue.main, using: {[weak self] (note: Notification) -> Void in
            guard let strongSelf = self else { return }
            print ("Sign out observed the sucessful sign out observer")
            strongSelf.setupRightBarButtonItem()
        })
        
        setupRightBarButtonItem()
    }
    
    deinit {
        // signInObserver throws "Thread 1: EXC_BAD_INSTRUCTION" error.
        NotificationCenter.default.removeObserver(signInObserver as Any)
        NotificationCenter.default.removeObserver(signOutObserver as Any)
    }
    
    func setupRightBarButtonItem() {
        
        let loginButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = loginButton
        
        if (AWSIdentityManager.defaultIdentityManager().isLoggedIn) {
            
            navigationItem.rightBarButtonItem!.title = NSLocalizedString("Sign Out", comment: "Label for hte logout button.")
            navigationItem.rightBarButtonItem!.action = #selector(MainViewController.handleLogout)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK:- Sign In View Controller.
    // Present the Sign In View Controller.
    func presentSignInViewController() {
        if !AWSIdentityManager.defaultIdentityManager().isLoggedIn {
            let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Sign In")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func handleLogout() {
        if (AWSIdentityManager.defaultIdentityManager().isLoggedIn) {
            AWSIdentityManager.defaultIdentityManager().logout(completionHandler: {(result: AnyObject?, error: NSError?) -> Void in
                self.navigationController!.popToRootViewController(animated: false)
                self.presentSignInViewController()
            } as! (Any?, Error?) -> Void)
            // print("Logout Successful: \(signInProvider.getDisplayName)");
        } else {
            assert(false)
        }
    }
}
