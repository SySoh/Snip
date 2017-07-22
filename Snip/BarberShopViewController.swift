//
//  BarberShopViewController.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/20/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MapKit

class BarberShopViewController: UIViewController {
    
    @IBOutlet weak var shopImage: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var location: CLLocationCoordinate2D?
    
    
    //Whoever segues to this page needs to pass in a barbershop.
    var barberShop: Barbershop?
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.isZoomEnabled = true
        nameLabel.text = barberShop?.name as! String
        shopImage.file = barberShop?.picture
        print(shopImage.file)
        print(barberShop?.picture)
        shopImage.loadInBackground()
        locationLabel.text = barberShop?.location as! String
        phoneLabel.text = barberShop?.phone as! String
        latitude = barberShop?.geopoint?.latitude
        longitude = barberShop?.geopoint?.longitude
        
        location = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
        
        
        var annotation = MKPointAnnotation()
        annotation.title = barberShop?.name as! String
        annotation.coordinate = location!
        var locationSpan = MKCoordinateSpan()
        locationSpan.latitudeDelta = 0.1
        locationSpan.longitudeDelta = 0.1
        
        let locationRegion = MKCoordinateRegionMake(location!, locationSpan)
        
        map.addAnnotation(annotation)
        map.setRegion(locationRegion, animated: true)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
