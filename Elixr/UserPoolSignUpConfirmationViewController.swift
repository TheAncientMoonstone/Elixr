//
//  UserPoolSignUpConfirmationViewController.swift
//  Elixr
//
//  Created by Timothy Richardson on 30/11/16.
//  Copyright © 2016 Timothy Richardson. All rights reserved.
//

import Foundation
import UIKit
import AWSCognitoIdentityProvider
import Pastel


class UserPoolSignUpConfirmationViewController: UIViewController {

    var sentTo: String?
    var user: AWSCognitoIdentityUser?
    
    @IBOutlet weak var codeSentTo: UILabel!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var confirmationCode: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.Username.text = self.user!.username;
        
        // This adds a done button to dismiss the Keyboard.
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPoint = .bottomLeft
        pastelView.endPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors(colors: [#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1),
                                      #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),
                                      #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1),
                                      #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),
                                      #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),
                                      #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onConfirmButton(_ sender: Any) {
        guard let confirmationCodeValue = self.confirmationCode.text, !confirmationCodeValue.isEmpty else {
            
            self.showAlert(title: "Confirmation code is missing", message: "Please enter a valid confirmation code.")
            
            return
        }
        self.user?.confirmSignUp(self.confirmationCode.text!, forceAliasCreation: true).continueWith (block: {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error {
                self?.showAlert(title: "Error", message: error as! String)
                  
                } else {
                    
                    self?.showAlert(title: "Registration Complete", message: "Registration was successful")
                    strongSelf.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            })
            return nil
        })
    
    }
    
    
    @IBAction func ResendConfirmationCode(_ sender: Any) {
        self.user?.resendConfirmationCode().continueWith (block: {[weak self] (task: AWSTask) -> AnyObject? in
            guard let _ = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error {

                    self?.showAlert(title: "Error", message: error as! String)
                    
                } else if let result = task.result  {
                    
                self?.showAlert(title: "Code Resent", message: "Code has been resent to \(String(describing: result.codeDeliveryDetails?.destination))")
                }
            })
            return nil
        })
    }
    
    @IBAction func CancelButton(_ sender: Any) {
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
