//
//  LocationModel.swift
//  Elixr
//
//  Created by Timothy Richardson on 8/7/17.
//  Copyright © 2017 Timothy Richardson. All rights reserved.
//

import UIKit
import Foundation

class LocationModel: NSObject {
    
    // Properties 
    var name: String?
    var address: String?
    var latitude: String?
    var longitude: String?
    
    // Empty constructor
    override init() { }

    // Construct with @name, @address, @latitude and @longitude.
    init(name: String, address: String, latitude: String, longitude: String) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // Print the object's current state
    override var description: String {
        
        return "Name: \(String(describing: name)), Address:\(String(describing: address)), Latitude: \(String(describing: latitude)), Longitude: \(String(describing: longitude))"
    }
}
