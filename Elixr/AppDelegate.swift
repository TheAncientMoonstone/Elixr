//
//  AppDelegate.swift
//  Elixr
//
//  Created by Timothy Richardson on 28/11/16.
//  Copyright © 2016 Timothy Richardson. All rights reserved.
//

import UIKit
import AWSCore
import FBSDKCoreKit
import FBSDKLoginKit
import AWSCognito
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Activates the use of Core Location Services through out the application.
        locationManager.delegate = self as? CLLocationManagerDelegate
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            // If user has been successfully authenticated they can now move on to the app.
            let storyboard = UIStoryboard(name: "AppMain", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "NavigationController")
            window?.rootViewController = viewController
        }
        
        return AWSMobileClient.sharedInstance.didFinishLaunching(application: application, withOptions: launchOptions as [NSObject : AnyObject]?)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        _ = AWSMobileClient.sharedInstance.withApplication(application: application, withURL: url as NSURL, withSourceApplication: sourceApplication, withAnnotation: annotation as AnyObject)

        return FBSDKApplicationDelegate.sharedInstance().application(application, open: (url as NSURL) as URL!, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        AWSMobileClient.sharedInstance.applicationDidBecomeActive(application: application)
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

