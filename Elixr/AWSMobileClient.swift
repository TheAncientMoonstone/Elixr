//
//  AWSMobileClient.swift
//  Elixr
//
//  Created by Timothy Richardson on 4/12/16.
//  Copyright © 2016 Timothy Richardson. All rights reserved.
//

import Foundation
import UIKit
import AWSCore
import AWSCognitoIdentityProvider
import AWSMobileHubHelper

class AWSMobileClient: NSObject {
    
    static let sharedInstance = AWSMobileClient()
    private var isInitialized = Bool()
    
    private override init() {
        isInitialized = false
        super.init()
    }
    
    deinit {
        print("Mobile Client is deinitialized. This should not happen.")
    }
    
    func withApplication(application: UIApplication, withURL url: NSURL, withSourceApplication sourceApplication: String?, withAnnotation annotation: AnyObject) -> Bool {
        print("withApplication:withURL")
        AWSIdentityManager.defaultIdentityManager().interceptApplication(application, open: url as URL, sourceApplication: sourceApplication, annotation: annotation)
        
        if (!isInitialized) {
            isInitialized = true
        }
        
        return false;
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        print("applicationDidBecomeActive:")
    }
    
    func didFinishLaunching(application: UIApplication, withOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        print("didFinishLaunching:")
        
        setupUserPool()
        
        let didFinishLaunching = AWSIdentityManager.defaultIdentityManager().interceptApplication(application, didFinishLaunchingWithOptions: launchOptions)
        
        AWSIdentityManager.defaultIdentityManager().resumeSession {result, error in
            print("result = \(result), error = \(error)")
            
            self.isInitialized = true
        }
        
        return didFinishLaunching
    }
    
    func setupUserPool() {
        // Register your user pool configuration
        AWSCognitoUserPoolsSignInProvider.setupUserPool(withId: AWSCognitoUserPoolId, cognitoIdentityUserPoolAppClientId: AWSCognitoUserPoolAppClientId, cognitoIdentityUserPoolAppClientSecret: AWSCognitoUserPoolClientSecret, region: AWSCognitoUserPoolRegion)
        
        AWSSignInProviderFactory.sharedInstance().registerAWSSign(AWSCognitoUserPoolsSignInProvider.sharedInstance(), forKey: AWSCognitoUserPoolsSignInProviderKey)
    }
}
