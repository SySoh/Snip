//
//  MapViewController.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/25/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import MapKit
import Parse
import ParseUI


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, MKAnnotationViewDelegate {
    
    var shops: [Barbershop] = []
    var manager = CLLocationManager()
    var currentLoc: CLLocation?
    var region = MKCoordinateRegion()

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
        self.map.showsUserLocation = true
        manager.delegate = self
        getShopLocations()
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLoc = location
            map.setCenter((currentLoc?.coordinate)!, animated: true)
            region.center = (currentLoc?.coordinate)!
            region.span.latitudeDelta = 1
            region.span.longitudeDelta = 1
            map.setRegion(region, animated: true)
            print("Found user's location: \(location)")
        }
    }
    
    
    func getShopLocations() {
        let query = PFQuery(className: "Barbershop")
        query.includeKey("geopoint")
        query.findObjectsInBackground { (objects, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.shops = objects as! [Barbershop]
                for shop in self.shops {
                    let annotation = MKAnnotation?
                    annotation.title = shop.name
                    annotation.coordinate.latitude = (shop.geopoint?.latitude)!
                    annotation.coordinate.longitude = (shop.geopoint?.longitude)!
                    self.map.addAnnotation(annotation)
                    print("Adding")
                    print(shop)
                }
            }
            
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
