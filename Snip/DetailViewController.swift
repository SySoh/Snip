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
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel?
    @IBOutlet weak var barbershopLabel: UILabel!
    @IBOutlet weak var barberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var photoArray: [PFObject]?
    var filteredPhotos: [PFObject]?
    
    var detailView: DetailViewController!
    //homeCell:
    
    var tagArray: [Tag]? = []
    var tagNameArray: [String]! = []
    var allPhotos: [PFObject]! = []
    var firstPhoto: PFObject?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func pressSave(_ sender: Any) {
        if (firstPhoto?["favorited"] as! Bool){
            print("unfavoriting")
            favoriteButton.isEnabled = false
            self.firstPhoto?["favorited"] = false
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favor"), for: .normal)
            firstPhoto?.saveInBackground(block: { (success, error: Error?) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    self.favoriteButton.isEnabled = true
                }
            })
        } else {
            print("favoriting")
            favoriteButton.isEnabled = false
            self.firstPhoto?["favorited"] = true
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favor_1"), for: .normal)
            firstPhoto?.saveInBackground(block: { (success, error: Error?) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    self.favoriteButton.isEnabled = true
                }
            })
        }
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
            vc.allPhotos = self.allPhotos
        }
        
        if segue.identifier == "ShopView" {
            let destVC = segue.destination as! BarberShopViewController
            destVC.barberShop = self.barbershop
        }
    }
    
    @IBAction func didPressBarberProfile(_ sender: Any) {
        performSegue(withIdentifier: "barberProfileSegue", sender: DetailViewController.self)
    }
    
    override func viewDidLoad() {
        self.setNeedsStatusBarAppearanceUpdate()
        super.viewDidLoad()
        
        //ensure the first photo displays first in the detail view
        for object in filteredPhotos! {
            let photoOb = object as! Photo
            let firstOb = photoOb["first"] as! Bool
            if firstOb == true {
                let index = filteredPhotos?.index(of: photoOb)
                filteredPhotos?.remove(at: index!)
                filteredPhotos?.insert(photoOb, at: 0)
            }
        }

        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        //        onlyWithPost(post: self.post!)
        self.view.addSubview(detailCollectionView)
        self.view.addSubview(photoCollectionView)
        
        self.pageControl.hidesForSinglePage = true

        
        // Make profile pic circular
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        //add the images to an array
        for photoOb in self.filteredPhotos! {
            imageArray?.append(photoOb["image"] as! UIImage)
        }
        
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
        for pic in filteredPhotos! {
            if pic["first"] as! Bool == true {
                firstPhoto = pic
                //check to see if the post was already favorited
                if ((firstPhoto?["favorited"]) != nil) {
                    let favorited = firstPhoto?["favorited"] as! Bool
                        if favorited == true {
                    self.favoriteButton.setImage(#imageLiteral(resourceName: "favor_1"), for: .normal)
                    }
                }

            }
        }
        self.pageControl.numberOfPages = filteredPhotos!.count
        self.pageControl.currentPage = 0
        self.pageControl.updateCurrentPageDisplay()
    }
    
    
    //    func onlyWithPost(post: Post) {
    //        let postID = post.objectId!
    //        self.filteredPhotos = self.photoArray?.filter { (photo: PFObject) -> Bool in
    //            let photoPost = photo["post"] as! Post
    //            let photoPostID = photoPost.objectId!
    //            return photoPostID == postID
    //        }
    //
    //    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == detailCollectionView {
            //return tagsArray!.count
            return tagNameArray.count
        } else {
            return filteredPhotos!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGSize = tagNameArray[indexPath.row].size(attributes: [NSFontAttributeName: UIFont.init(name: "OpenSans-Regular", size: 14.0)!])
        return CGSize(width: size.width, height: detailCollectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == photoCollectionView {
            self.pageControl.currentPage = indexPath.item
            self.pageControl.updateCurrentPageDisplay()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == detailCollectionView {
            let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! DetailCell
            let tag = self.tagsArray?[indexPath.item]
            tagCell.tagLabel.text = tagNameArray[indexPath.item]
            tagCell.layer.cornerRadius = 12
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == detailCollectionView {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tag = self.tagArray?[indexPath.item]
            let tagDetail = storyboard.instantiateViewController(withIdentifier: "tagDetail") as! TSRViewController
            tagDetail.tag = tag
            self.navigationController!.pushViewController(tagDetail, animated: true)
            tagDetail.title = self.tagsArray?[indexPath.item]
            tagDetail.navigationController?.title = self.tagsArray?[indexPath.item]
            tagDetail.navigationController?.setNavigationBarHidden(false, animated: true)
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

