//
//  CustomMKAnnotation.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/31/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import MapKit

class CustomMKAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let barbershop: Barbershop
    let coordinate: CLLocationCoordinate2D
    
    
    init(title: String, locationName: String, barbershop: Barbershop, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.barbershop = barbershop
        self.coordinate = coordinate
        
        super.init()
    }

    
    var subtitle: String? {
        return locationName
    }
}
