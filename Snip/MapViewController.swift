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


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
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
                    let coord = CLLocationCoordinate2DMake((shop.geopoint?.latitude)!, (shop.geopoint?.longitude)!)
                    let annotation = CustomMKAnnotation(title: shop.name!, locationName: shop.location!, barbershop: shop , coordinate: coord)
                    self.map.addAnnotation(annotation)
                    print("Adding")
                    print(shop)
                }
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CustomMKAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure)
            }
            return view
        }
        return nil
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let thisAnnotation = view.annotation as? CustomMKAnnotation {
        self.performSegue(withIdentifier: "shopFromMap", sender: thisAnnotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !(self.navigationController?.isNavigationBarHidden)! {
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "shopFromMap" {
            let source = sender as! CustomMKAnnotation
            let destVC = segue.destination as! BarberShopViewController
            destVC.barberShop = source.barbershop
        }
    }
 

}
