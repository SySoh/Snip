//
//  DetailViewController.swift
//  Snip
//
//  Created by Cameryn Boyd on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI



class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var photo: Photo?
    var post: Post?
    var price: Int?
    var tagsArray: [String]?
    var user: User?
    var barber: Barber?
    
    var barberName: String!
    var venmo: String?
    var profile_pic: UIImage?
    var barbershop: Barbershop?
    var shopName: String?
    var shopPic: PFFile?
    var location: String?
    var phone: String?
    var rating: Int?
    var date: Date!
    var imageArray: [UIImage]?
    var image: UIImage?
    var photoId: String?
    
    
    var postImage: UIImage!
    
    var homeViewController: HomeViewController?
    
    // outlets
    
    @IBOutlet weak var profileImageView: PFImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var barbershopConstantLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel?
    @IBOutlet weak var barbershopLabel: UILabel!
    @IBOutlet weak var barberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var photoArray: [PFObject]?
    var filteredPhotos: [PFObject]?
    
    var detailView: DetailViewController!
    //homeCell:
    
    var tagArray: [Tag]? = []
    var tagNameArray: [String]! = []
    
    
    @IBAction func pressSave(_ sender: Any) {
        let query = PFQuery(className: "Photo")
        
        query.findObjectsInBackground(block: { (objects : [PFObject]?, error: Error?) -> Void in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                self.photo?["favorited"] = true
                self.photo?.saveInBackground()
            }
        })
        
    }
    
    @IBAction func pressDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "barberProfileSegue" {
            let vc = segue.destination as! ProfileViewController
            vc.barberName = self.barberLabel.text
            vc.barbershopName = self.barbershopLabel.text
            vc.venmo = self.venmo
            vc.barber = self.barber
        }
        
        if segue.identifier == "ShopView" {
            let destVC = segue.destination as! BarberShopViewController
            destVC.barberShop = self.barbershop
            //destVC.locationLabel.text = self.location
            
        }
    }
    
    @IBAction func didPressBarberProfile(_ sender: Any) {
        performSegue(withIdentifier: "barberProfileSegue", sender: DetailViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("made it here")
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        onlyWithPost(post: self.post!)
        self.view.addSubview(detailCollectionView)
        self.view.addSubview(photoCollectionView)
        
        // Make profile pic circular
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
       
        for photoOb in self.filteredPhotos! {
            imageArray?.append(photoOb["image"] as! UIImage)
        }
//        self.photoId = self.photo?.objectId as! String
        self.barber = self.post?["barber"] as! Barber
        self.tagArray = self.post?["tags"] as! [Tag]
        for tag in self.tagArray! {
            self.tagNameArray.append(tag.name!)
        }
        self.date = self.post?.createdAt!
        self.price = self.post?["price"] as! Int
        self.barbershop = self.barber?["barbershop"] as! Barbershop
        self.dateLabel.text = "\(self.date.getElapsedInterval())"
        self.barberLabel.text = self.barber?["name"] as! String
        self.barbershopLabel.text = self.barbershop?["name"] as? String
        self.location = self.barbershop?["location"] as? String
        self.priceLabel.text = "$" + "\(self.price!)"
        self.venmo = self.barber?["venmo"] as? String
        self.profileImageView.file = barber?["profile_pic"] as! PFFile
        self.profileImageView.loadInBackground()
        if post?["caption"] != nil {
            self.captionLabel?.text = post?["caption"] as! String
        } else{
            self.captionLabel?.text = ""
        }
        
        if let layout = self.detailCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        if let secondLayout = self.photoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                secondLayout.scrollDirection = .horizontal
            }
    }
    
    
    func onlyWithPost(post: Post) {
        let postID = post.objectId!
        self.filteredPhotos = self.photoArray?.filter { (photo: PFObject) -> Bool in
            let photoPost = photo["post"] as! Post
            let photoPostID = photoPost.objectId!
            return photoPostID == postID
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == detailCollectionView {
            //return tagsArray!.count
            return tagNameArray.count
        } else {
            return filteredPhotos!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == detailCollectionView {
            let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! DetailCell
            let tag = self.tagsArray?[indexPath.item]
            tagCell.tagLabel.text = tagNameArray[indexPath.item]
            return tagCell
        } else {
            let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! DetailPostCell
            let photo = self.filteredPhotos?[indexPath.item]
            let media = photo?["image"] as? PFFile
            media?.getDataInBackground { (backgroundData: Data?, error: Error?) in
                if let backgroundData = backgroundData {
                    photoCell.postImageView.contentMode = .scaleAspectFill
                    photoCell.postImageView.clipsToBounds = true
                    photoCell.postImageView.image = UIImage(data: backgroundData)
                }
            }
            return photoCell
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Date {
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "YEAR AGO" :
                "\(year)" + " " + "YEARS AGO"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "MONTH AGO" :
                "\(month)" + " " + "MONTHS AGO"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "DAY AGO" :
                "\(day)" + " " + "DAYS AGO"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "HOUR AGO" :
                "\(hour)" + " " + "HOURS AGO"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "MINUTE AGO" :
                "\(minute)" + " " + "MINUTES AGO"
        } else {
            return "A MOMENT AGO"
        }
        
    }
}

