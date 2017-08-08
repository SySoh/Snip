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
    @IBOutlet weak var nameLabel: UILabel!
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
        let phone = barberShop?.phone!
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
        
//        callImageView.layer.cornerRadius = callImageView.frame.height / 2
        callImageView.layer.cornerRadius = 6
        callImageView.clipsToBounds = true
        
        map.isZoomEnabled = true
        queryForBarbers()
        
        nameLabel.text = barberShop?.name
        nameLabel.adjustsFontSizeToFitWidth = true
        
        barberCollectionView.dataSource = self
        barberCollectionView.delegate = self
        barberCollectionView.alwaysBounceVertical = false
        barberCollectionView.alwaysBounceHorizontal = true
        barberCollectionView.reloadData()
        
        shopImage.file = barberShop?.picture
        shopImage.contentMode = .scaleAspectFill
        shopImage.clipsToBounds = true
        shopImage.loadInBackground()
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect.init(x: 0.0, y: 0.0, width: 375.0, height: 96.0)
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        shopImage.layer.insertSublayer(gradient, at: 0)
        
        let gradient_2 = CAGradientLayer()
        gradient_2.frame = CGRect.init(x: 0.0, y: 52.0, width: 375.0, height: 148.0)
        gradient_2.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        shopImage.layer.insertSublayer(gradient_2, at: 0)

        
        ratingStars.rating = aveRating(ratings:(barberShop?.ratings)!)
        latitude = barberShop?.geopoint?.latitude
        longitude = barberShop?.geopoint?.longitude
        location = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
        
        let phone = (barberShop?.phone as! String)
        let num = String(format: "(%@) %@-%@",
                         phone.substring(with: phone.index(phone.startIndex, offsetBy: 0) ..< phone.index(phone.startIndex, offsetBy: 3)),
                         phone.substring(with: phone.index(phone.startIndex, offsetBy: 3) ..< phone.index(phone.startIndex, offsetBy: 6)),
                         phone.substring(with: phone.index(phone.startIndex, offsetBy: 6) ..< phone.index(phone.startIndex, offsetBy: 10))
        )
        phoneLabel.text = num
        let annotation = MKPointAnnotation()
        annotation.title = barberShop?.location!
        annotation.coordinate = location!
        var locationSpan = MKCoordinateSpan()
        locationSpan.latitudeDelta = 0.1
        locationSpan.longitudeDelta = 0.1
        
        let locationRegion = MKCoordinateRegionMake(location!, locationSpan)
        
        map.addAnnotation(annotation)
        map.setRegion(locationRegion, animated: true)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.init(hex: "1D4159")
    }
    
    func queryForBarbers() {
        let query = PFQuery(className: "Barber")
        query.includeKey("barbershop.picture")
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
