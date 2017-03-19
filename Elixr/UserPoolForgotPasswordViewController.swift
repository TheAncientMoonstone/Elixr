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

class UserPoolForgotPasswordViewController: UIViewController {
    
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
        // This adds a done button to dismiss the Keyboard.
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        usernameField.inputAccessoryView = toolBar
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
    
    func doneClicked() {
        view.endEditing(true)
    }
}
