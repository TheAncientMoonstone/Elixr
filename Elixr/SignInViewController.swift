//
//  SignInViewController.swift
//  Elixr
//
//  Created by Timothy Richardson on 28/11/16.
//  Copyright © 2016 Timothy Richardson. All rights reserved.
//

import UIKit
import AWSMobileHubHelper
import FBSDKCoreKit
import FBSDKLoginKit

class SignInViewController: UIViewController {
    
        var didSignInObserver: AnyObject!
        var passwordAuthenticationCompletion: AWSTaskCompletionSource<AnyObject>?
    
    // Support declarations for the Sign In UI.
    // UI Text Fields
    @IBOutlet weak var customUserIdField: UITextField!
    @IBOutlet weak var customPasswordField: UITextField!
    // UI Support Buttons
    @IBOutlet weak var customCreateNewAccountButton: UIButton!
    @IBOutlet weak var customForgotUserPasswordButton: UIButton!
    @IBOutlet weak var customSignInProviderButton: UIButton!
    // Third party provider login buttons.
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Sign in loading")
        
        didSignInObserver =  NotificationCenter.default.addObserver(forName: NSNotification.Name.AWSIdentityManagerDidSignIn,
        object: AWSIdentityManager.defaultIdentityManager(),
        queue: OperationQueue.main,
        using: {(note: Notification) -> Void in
        // perform successful login actions here
        })
        
        
        // Custom UI Setup.
        // These selectors will move to different view controllers, depending on the button pressed.
        // Allows the user to sign in with their facebook account.
<<<<<<< Updated upstream
      
//Vivek : In storyboard you've already changed the class for facebook button to FBSDKLoginButton, it has inbuilt onClick method. So, there's no need to add custom code for log in.
        
        //facebookLoginButton.addTarget(self, action: #selector(self.handleFacebookLogin), for: .touchUpInside)
      
=======
        // facebookLoginButton.addTarget(self, action: #selector(self.handleFacebookLogin), for: .touchUpInside)
>>>>>>> Stashed changes
        // Signs the user in.
        customSignInProviderButton.addTarget(self, action: #selector(self.handleCustomSignIn), for: .touchUpInside)
        // This allows the user to recover their password to their account.
        customForgotUserPasswordButton.addTarget(self, action: #selector(self.handleUserPoolForgotPassword), for: .touchUpInside)
        // This allows the user to sign up for their own custom account.
        customCreateNewAccountButton.addTarget(self, action: #selector(self.handleUserPoolSignUp), for: .touchUpInside)
        
        
        // This adds a done button to dismiss the Keyboard.
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        customUserIdField.inputAccessoryView = toolBar
        customPasswordField.inputAccessoryView = toolBar
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(didSignInObserver)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleFacebookLogin() {
        // Facebook login permissions can be optionally set, but must be set
        // before the user can authenticate.
        AWSFacebookSignInProvider.sharedInstance().setPermissions(["public_profile", "email", "user_friends"]);
        handleLoginWithSignInProvider(signInProvider: AWSFacebookSignInProvider.sharedInstance())
        // If user has been successfully authenticated they can now move on to the app.
    }
 
    // MARK: - Utility Methods
    func handleLoginWithSignInProvider(signInProvider: AWSSignInProvider) {
        /*
        Before Editing
        AWSIdentityManager.defaultIdentityManager().loginWithSign(signInProvider, completionHandler:
            {(result, error) -> Void in
                if error == nil {
                    /* If no error reported by the Sign in Provider, discard the sign in view controller */
                    DispatchQueue.main.async(execute: {
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    })
                }
                print("Login with signin provider result = \(result), error = \(error)")
        }
        */
        
        // After Editing
        AWSIdentityManager.defaultIdentityManager().loginWithSign(signInProvider, completionHandler: {(result, error) -> Void in
            if error == nil {
                /* If no error reported by the Sign in provider, discard the sign in view controller */
                DispatchQueue.main.async(execute: {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                })
            }
            print("Login with sign in provider result = \(result), error =\(error)")
        })
    }
    
    // The user has logged out with their facebook account.
    func handleFacebookLogOut() {
        print("User has logged out...")
    }
    
    // Allows the user to return to the previous view controller.
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Adds function to the 'Done' button.
    func doneClicked() {
        view.endEditing(true)
    }
}
