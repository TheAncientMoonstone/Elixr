//
//  UserPoolNewPasswordViewController.swift
//  Elixr
//
//  Created by Timothy Richardson on 29/11/16.
//  Copyright © 2016 Timothy Richardson. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider


class UserPoolNewPasswordViewController: UIViewController {
    
    var user: AWSCognitoIdentityUser?
    @IBOutlet weak var updatedPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // This adds a done button to dismiss the Keyobard.
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        updatedPassword.inputAccessoryView = toolBar
    }
    
    @IBAction func UpdatedPassword(_ sender: Any) {
        guard let updatedPassword = self.updatedPassword.text, !updatedPassword.isEmpty else {
            
            showAlert(title: "Password Field Empty", message: "Please enter a password")
            return
        }
        
        // Confirm forgot password with input from UI.
        self.user?.confirmForgotPassword(updatedPassword, password: self.updatedPassword.text!).continue({[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else {return nil}
            DispatchQueue.main.async(execute: {
                if let error = task.error {

                self?.showAlert(title: "Error", message: error as! String)
                
                } else {
                    
                    self?.showAlert(title: "Password reset complete", message: "Password reset was successful")
                    strongSelf.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            })
            return nil
        })
    }
    // Cancel button to return to the previous view controller.
    @IBAction func cancelButton(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
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
