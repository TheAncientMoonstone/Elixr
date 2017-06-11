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
import Pastel

class SignInViewController: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Hides the top status part.
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide activity indicator on load
        self.activityIndicator.isHidden = true
        
        
        // Do any additional setup after loading the view.
        print("Sign in loading")
        
        didSignInObserver =  NotificationCenter.default.addObserver(forName: NSNotification.Name.AWSIdentityManagerDidSignIn,
        object: AWSIdentityManager.default(),
        queue: OperationQueue.main,
        using: {(note: Notification) -> Void in
        // perform successful login actions here
        })
        
        // Custom UI Setup.
        // These selectors will move to different view controllers, depending on the button pressed.
        // Allows the user to sign in with their facebook account.
        facebookLoginButton?.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)
        // Signs the user in.
        customSignInProviderButton.addTarget(self, action: #selector(handleCustomSignIn), for: .touchUpInside)
        // This allows the user to recover their password to their account.
        customForgotUserPasswordButton.addTarget(self, action: #selector(handleUserPoolForgotPassword), for: .touchUpInside)
        // This allows the user to sign up for their own custom account.
        customCreateNewAccountButton.addTarget(self, action: #selector(handleUserPoolSignUp), for: .touchUpInside)
        
        /*
        // This adds a done button to dismiss the Keyboard.
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        customUserIdField.inputAccessoryView = toolBar
        customPasswordField.inputAccessoryView = toolBar
        */

        // Creates a custom effect on the text boxes on screen.
        customUserIdField.backgroundColor = UIColor.clear
        customPasswordField.backgroundColor = UIColor.clear

        
        // Inital declaration of the new delegate implemented in this class.
        customUserIdField.delegate = self
        customPasswordField.delegate = self
 
    }
    
    // MARK: - Custom Background
    override func viewDidAppear(_ animated: Bool) {
        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1),
                              #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),
                              #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1),
                              #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),
                              #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),
                              #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(didSignInObserver)
    }

    func handleFacebookLogin() {
        // Facebook login permissions can be optionally set, but must be set
        // before the user can authenticate.
        AWSFacebookSignInProvider.sharedInstance().setPermissions(["public_profile", "email", "user_friends"]);
        handleLoginWithSignInProvider(signInProvider: AWSFacebookSignInProvider.sharedInstance())
        
    }
 
    // MARK: - Utility Methods
    func handleLoginWithSignInProvider(signInProvider: AWSSignInProvider) {
        /*
        AWSIdentityManager.defaultIdentityManager().loginWithSign(signInProvider, completionHandler:
            {(result, error) -> Void in
                if error == nil {
                    /* If no error reported by the Sign in Provider, discard the sign in view controller */
                    DispatchQueue.main.async(execute: {
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                    })
                }
                print("Login with signin provider result = \(result), error = \(error)")
        })
         */
        
        activityIndicatorStart()
        
        // After Editing
        AWSIdentityManager.default().login(signInProvider: signInProvider, completionHandler: {(result: Any?, error: Error?) in
            self.activityIndicatorStop()
            
            if error == nil {
                /* If no error reported by the Sign in provider, discard the sign in view controller */
                DispatchQueue.main.async(execute: {
//                    self.presentingViewController?.dismiss(animated: true, completion: nil)
  
                    // Set the key isLoggedIn to true so when the user opens the app,
                    // they are directly redirected to AppMain Storyboard
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.synchronize()
                    
                    // If user has been successfully authenticated they can now move on to the app.
                    let storyboard = UIStoryboard(name: "AppMain", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "NavigationController")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = viewController

                })
            }
            print("Login with sign in provider result = \(String(describing: result)), error =\(String(describing: error))")
        })

    }
    
    // The user has logged out with their facebook account.
    func handleFacebookLogOut() {
        print("User has logged out...")
    }
    
    /*
    // Allows the user to return to the previous view controller.
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    */
    
    /*
    // Adds function to the 'Done' button.
    func doneClicked() {
        view.endEditing(true)
    
    }
    */
    
    // Use of the resignation of the first receiver.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        customUserIdField.resignFirstResponder()
        customPasswordField.resignFirstResponder()
        return true
    }
    
    
    // Method to unhide the activity indicator and start animating
    func activityIndicatorStart(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    
    // Method to stop and hide the activity indicator
    func activityIndicatorStop(){
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
}
