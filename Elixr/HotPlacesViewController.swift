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

class HotPlacesViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var isFirstTime = true
    
    var locationManager = CLLocationManager()
    let newPin = MKPointAnnotation()
    
    var selectedLocation:LocationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Setup the location services delegate in this class.
        locationManager.delegate = self
        
        // This little method requests the users permission for location services whilst in this view controller.
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestAlwaysAuthorization()
        let alert = UIAlertController(title: "You can change this option in the Settings App", message: "So keep calm your selection is not permanent. 🙂",
                                      preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Create coordinates from the location latitude & longitude.
        var poiCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        poiCoordinates.latitude = CDouble(self.selectedLocation!.latitude!)!
        poiCoordinates.longitude = CDouble(self.selectedLocation!.longitude!)!
        
        // Zoom to the region
        let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(poiCoordinates, 750, 750)
        self.mapView.setRegion(viewRegion, animated: true)
        
        // Plot pin
        let pin: MKPointAnnotation = MKPointAnnotation()
        pin.coordinate = poiCoordinates
        self.mapView.addAnnotation(pin)
        
        // Add title to the pin.
        pin.title = selectedLocation!.name
    }
    
    // Drops the pin on the users current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.removeAnnotation(newPin)
        
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        if(self.isFirstTime) {
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        // Set the region on the map.
        mapView.setRegion(region, animated: true)
        self.isFirstTime = false
        }
        
        newPin.coordinate = location.coordinate
        mapView.addAnnotation(newPin)
        
    }
}
