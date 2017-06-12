//
//  UserPoolForgotPasswordViewController.swift
//  Elixr
//
//  Created by Timothy Richardson on 29/11/16.
//  Copyright © 2016 Timothy Richardson. All rights reserved.
//

import Foundation
import UIKit
import AWSCognitoIdentityProvider
import AWSMobileHubHelper
import Pastel

class UserPoolForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    var pool: AWSCognitoIdentityUserPool?
    var user: AWSCognitoIdentityUser?
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBAction func ForgotPassword(_ sender: Any) {
        guard let username = self.usernameField.text, !username.isEmpty else {
            showAlert(title: "Missing username", message: "Please enter a username")
            return
        }
        self.user = self.pool?.getUser(self.usernameField.text!)
        self.user?.forgotPassword().continueWith(block: {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else {return nil}
            DispatchQueue.main.async(execute: {
                if let error  = task.error {
                    // 12/6/17 - Tapping forgot password button causes app to throw THREAD 1 - SIGABRT
                    self?.showAlert(title: "Error", message: error as! String)
                } else {
                    strongSelf.shouldPerformSegue(withIdentifier: "NewPasswordSegue", sender: sender)
                }
            })
            return nil
        })
    }
    
    // This button returns the user to the previous view controller.
    @IBAction func CancelButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
        
        // Creates a custom effect on the username field.
        usernameField.backgroundColor = UIColor.clear
        
        // Inital declaration of the new delegate implemented in this class.
        usernameField.delegate = self
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newPasswordViewController = segue.destination as?
            UserPoolNewPasswordViewController {
            newPasswordViewController.user = self.user
        }
    }
    
    // MARK: - Utility Methods
    func showAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Use of the resignation of the first responder.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        return true
    }
}
