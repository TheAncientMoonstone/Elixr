//
//  SignInViewControllerExtensions.swift
//  Elixr
//
//  Created by Timothy Richardson on 29/11/16.
//  Copyright © 2016 Timothy Richardson. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider
import AWSMobileHubHelper

extension SignInViewController {
    
    func handleCustomSignIn() {
        AWSCognitoUserPoolsSignInProvider.sharedInstance().setInteractiveAuthDelegate(self)
        self.handleLoginWithSignInProvider(signInProvider: AWSCognitoUserPoolsSignInProvider.sharedInstance())
        
        // Set the key isLoggedIn to true so when the user opens the app,
        // they are directly redirected to AppMain Storyboard
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        
        let storyboard = UIStoryboard(name: "AppMain", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NavigationController")
        self.present(viewController, animated: true, completion: nil);
    }
    
    func handleUserPoolSignUp() {
        let storyboard = UIStoryboard(name: "UserPools", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SignUp")
            self.present(viewController, animated: true, completion: nil);
    }
    
    func handleUserPoolForgotPassword() {
        let storyboard = UIStoryboard(name: "UserPools", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ForgotPassword")
            self.present(viewController, animated: true, completion: nil);
    }
}

extension SignInViewController: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    
    private func startPasswordAuthentication() -> SignInViewController {
        return self 
    }
    
    
    func didCompletePasswordAuthenticationSetepWithError(error: NSError?) {
        if let error = error {
            DispatchQueue.main.async(execute: {

                let alert = UIAlertController(title: error.userInfo["__type"] as? String, message: error.userInfo["message"] as? String, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
 
}

extension SignInViewController: AWSCognitoUserPoolsSignInHandler {
    
    func handleUserPoolSignInFlowStart() {
        guard let username = self.customUserIdField.text, !username.isEmpty,
            let password = self.customPasswordField.text, !password.isEmpty else {
                DispatchQueue.main.async(execute: {
                    let alert = UIAlertController(title: "Missing UserName / Password", message: "Please enter a valid user name / password.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
                return
        }
        
        self.passwordAuthenticationCompletion?.set(result: AWSCognitoIdentityPasswordAuthenticationDetails.self)
    }
}
