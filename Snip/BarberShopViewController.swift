//
//  BarberShopViewController.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/20/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import MapKit
import Cosmos
import Parse
import ParseUI


class BarberShopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var shopImage: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var ratingStars: CosmosView!
    
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var location: CLLocationCoordinate2D?
    
    @IBOutlet weak var barberCollectionView: UICollectionView!
    
    var barbers: [Barber] = []
    
    //Whoever segues to this page needs to pass in a barbershop.
    var barberShop: Barbershop?
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.isZoomEnabled = true
        barberCollectionView.dataSource = self
        barberCollectionView.delegate = self
        queryForBarbers()
        nameLabel.text = barberShop?.name as! String
//        shopImage.file = barberShop?.picture
//        shopImage.loadInBackground()
        if barberShop?.location != nil{
            locationLabel.text = barberShop?.location as! String
        } else {
            locationLabel.text = ""
        }
        print(barberShop?.ratings?[0])
        ratingStars.rating = Double((barberShop?.ratings?[0])!)
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
    
    func queryForBarbers() {
    let query = PFQuery(className: "Barber")
        query.whereKey("barbershop", equalTo: barberShop)
        query.findObjectsInBackground { (objects, error) in
    if let error = error {
        print("we have an issue")
        print(error.localizedDescription)
    } else {
        self.barbers = objects as! [Barber]
        print("barber array filled")
        print(self.barbers)
    }
        
        }
    barberCollectionView.reloadData()
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = barberCollectionView.dequeueReusableCell(withReuseIdentifier: "barberCell", for: indexPath) as! BarberCollectionViewCell
        cell.barberPic.file = barbers[indexPath.item].profile_pic
        cell.barberPic.loadInBackground()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barbers.count
    }
    
    @IBAction func clickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
