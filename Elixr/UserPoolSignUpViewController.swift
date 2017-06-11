//
//  UserPoolSignUpViewController.swift
//  Elixr
//
//  Created by Timothy Richardson on 30/11/16.
//  Copyright © 2016 Timothy Richardson. All rights reserved.
//

import Foundation
import UIKit
import AWSMobileHubHelper
import AWSCognitoIdentityProvider
import Pastel

class UserPoolSignUpViewController: UIViewController, UITextFieldDelegate {
    
    var pool: AWSCognitoIdentityUserPool?
    var sentTo: String?
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
        
        // Creates a custom effect on the text boxes on screen.
        Username.backgroundColor = UIColor.clear
        Email.backgroundColor = UIColor.clear
        Password.backgroundColor = UIColor.clear
        
        // Inital declaration of the new delegate implemented in this class.
        Username.delegate = self
        Email.delegate = self
        Password.delegate = self
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
        if let signUpConfirmationViewController = segue.destination as? UserPoolSignUpConfirmationViewController {
            signUpConfirmationViewController.sentTo = self.sentTo
            signUpConfirmationViewController.user = self.pool?.getUser(self.Username.text!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    @IBAction func SignUpButton(_ sender: Any) {
        guard let usernameValue = self.Username.text, !usernameValue.isEmpty,
            let passwordValue = self.Password.text, !passwordValue.isEmpty
            else {
                showAlertBad(title: "Missing required fields", message: "Please enter a username or password.")
                return
        }
        
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        
        if let emailValue = self.Email.text, !emailValue.isEmpty {
            let email = AWSCognitoIdentityUserAttributeType()
            email?.name = "email"
            email?.value = emailValue
            attributes.append(email!)
        }
        
        
        // Sign up the user
        self.pool?.signUp(usernameValue, password: passwordValue, userAttributes: attributes, validationData: nil).continueWith (block: {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                
                if let error = task.error {
                    _ = task.error
                    // Error handling code goes here.
                    self?.showAlertBad(title: "Uh Oh!", message: error.localizedDescription)
                    
                } else if let result = task.result   {
                    // handle the case where user has to confirm his identity via email / SMS
                    if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                        strongSelf.sentTo = result.codeDeliveryDetails?.destination
                        strongSelf.performSegue(withIdentifier: "SignUpConfirmSegue", sender: sender)
                    } else {
                       // Fantastic the user has been able to Sign up!
                        self?.showAlertGood(title: "Registration Complete", message: "Registration was successful.")
                        
                        strongSelf.presentingViewController?.dismiss(animated: true, completion: nil)
                    }
                }
            })
            return nil
        })

    }
    
    // Cancel Button returns to the previous View Controller.
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Utility Methods
    func showAlertBad(title : String, message : String){
        let alert = UIAlertController(title: title, message: "Something has gone wrong.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertGood(title: String, message: String){
        let alert = UIAlertController(title: "Registration Complete", message: "Registration was successful", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Use of the resignation of the first receiver.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Username.resignFirstResponder()
        Password.resignFirstResponder()
        Email.resignFirstResponder()
        return true
    }
}
