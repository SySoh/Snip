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


class BarberShopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var shopImage: PFImageView!
    @IBOutlet weak var nameLabel: UINavigationItem!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var ratingStars: CosmosView!
    
    
    @IBOutlet weak var callImageView: UIImageView!
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var location: CLLocationCoordinate2D?
    
    @IBOutlet weak var barberCollectionView: UICollectionView!
    
    var barbers: [Barber] = []
    var selectedBarber: Barber?
    
    //Whoever segues to this page needs to pass in a barbershop.
    var barberShop: Barbershop?
    
    
    @IBAction func onCall(_ sender: Any) {
        let phone = barberShop?.phone as! String
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(hex: "FFFFFF"), NSFontAttributeName: UIFont.init(name: "Open Sans", size: 18.0)!]
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(CGFloat(0.0), for: .default)
        
        callImageView.layer.cornerRadius = 24
        callImageView.clipsToBounds = true
        
        map.isZoomEnabled = true
        queryForBarbers()
        nameLabel.title = barberShop?.name as! String
        barberCollectionView.dataSource = self
        barberCollectionView.delegate = self
        barberCollectionView.reloadData()
        shopImage.file = barberShop?.picture
        shopImage.loadInBackground()
        ratingStars.rating = aveRating(ratings:(barberShop?.ratings)!)
        latitude = barberShop?.geopoint?.latitude
        longitude = barberShop?.geopoint?.longitude
        location = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
        
        let phone = barberShop?.phone as! String
        let num = String(format: "(%@) %@ - %@",
                         phone.substring(with: phone.index(phone.startIndex, offsetBy: 0) ..< phone.index(phone.startIndex, offsetBy: 3)),
                         phone.substring(with: phone.index(phone.startIndex, offsetBy: 3) ..< phone.index(phone.startIndex, offsetBy: 6)),
                         phone.substring(with: phone.index(phone.startIndex, offsetBy: 6) ..< phone.index(phone.startIndex, offsetBy: 10))
        )
        phoneLabel.text = num
        var annotation = MKPointAnnotation()
        annotation.title = barberShop?.location as! String
        annotation.coordinate = location!
        var locationSpan = MKCoordinateSpan()
        locationSpan.latitudeDelta = 0.1
        locationSpan.longitudeDelta = 0.1
        
        let locationRegion = MKCoordinateRegionMake(location!, locationSpan)
        
        map.addAnnotation(annotation)
        map.setRegion(locationRegion, animated: true)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(hex: "FFFFFF"), NSFontAttributeName: UIFont.init(name: "Blessed Day", size: 42.0)!]
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(CGFloat(10.0), for: .default)
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
        self.barberCollectionView.reloadData()
    }
        
        }
        print("ya reloadin?")
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = barberCollectionView.dequeueReusableCell(withReuseIdentifier: "barberCell", for: indexPath) as! BarberCollectionViewCell
        cell.barber = barbers[indexPath.item]
        print("fillin out pics")
        let file = barbers[indexPath.item].profile_pic as! PFFile
        file.getDataInBackground { (photoData, error: Error?) in
            cell.barberPic.layer.cornerRadius = cell.frame.size.width / 2
            cell.layer.cornerRadius = 25
            cell.barberPic.image = UIImage(data: photoData!)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedBarber = barbers[indexPath.item]
    }
    
    @IBAction func clickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func aveRating(ratings: [Double]) -> Double {
        var average: Double = 0.0
        for num in ratings {
            average += num
        }
        average = average / Double(ratings.count)
        return average
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfile" {
        let source = sender as! BarberCollectionViewCell
        let destVC = segue.destination as! ProfileViewController
        destVC.barber = source.barber
        destVC.barberName = source.barber?.name
        destVC.venmo = source.barber?.venmo
        destVC.barbershopName = barberShop?.name
        }
    }
}
