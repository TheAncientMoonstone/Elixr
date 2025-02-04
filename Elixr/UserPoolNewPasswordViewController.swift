//
//  UserPoolNewPasswordViewController.swift
//  Elixr
//
//  Created by Timothy Richardson on 29/11/16.
//  Copyright © 2016 Timothy Richardson. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider
import Pastel

class UserPoolNewPasswordViewController: UIViewController, UITextFieldDelegate {
    
    var user: AWSCognitoIdentityUser?
    @IBOutlet weak var updatedPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Initial declaration of the new delegate implemented in this class.
        updatedPassword.delegate = self
        
        // Creates a custom effect on the new password field.
        updatedPassword.backgroundColor = UIColor.clear
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
    
    @IBAction func UpdatedPassword(_ sender: Any) {
        guard let updatedPassword = self.updatedPassword.text, !updatedPassword.isEmpty else {
            
            showAlert(title: "Password Field Empty", message: "Please enter a password")
            return
        }
        
        // Confirm forgot password with input from UI.
        self.user?.confirmForgotPassword(updatedPassword, password: self.updatedPassword.text!).continueWith(block: {[weak self] (task: AWSTask) -> AnyObject? in
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
    
    // Use of the resignation of the first responder.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updatedPassword.resignFirstResponder()
        return true
    }
}
