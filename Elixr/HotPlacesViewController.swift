//
//  HotPlacesViewController.swift
//  Elixr
//
//  Created by Timothy Richardson on 2/3/17.
//  Copyright © 2017 Timothy Richardson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HotPlacesViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // Setup the location services delegate in this class.
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
