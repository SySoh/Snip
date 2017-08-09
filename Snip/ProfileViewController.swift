//  ProfileViewController.swift
//  Snip
//
//  Created by Cameryn Boyd on 7/18/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import RSKPlaceholderTextView

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var whiteBorderImageView: UIImageView!
    @IBOutlet weak var profileImageVIew: PFImageView!

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var barbershopImageView: PFImageView!
    @IBOutlet weak var shopConstantLabel: UILabel!
    @IBOutlet weak var barbershopLabel: UILabel!
    @IBOutlet weak var venmoImageView: UIImageView!

    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionView: UICollectionView!

    var photoArray: [PFObject] = []
    var allPhotos: [PFObject] = []
    var photo: PFObject!
    var barberName: String?
    var barbershopName: String!
    var venmo: String!
    var profileImage: UIImage!
    var tag: Tag!
    var tagArray: [Tag]!
    var tagNameSet: Set<String> = Set()
    var tagNameArray: [String] = []
    var posts: [Post]!
    var post: Post!
    var barbers: [Barber]!
    var barber: Barber!
    var barberId: String!
    var filteredPhotos: [PFObject]?
    var barbershop: Barbershop?
    
    @IBAction func onVenmo(_ sender: Any) {
        venmo = barber["venmo"] as? String
        let url_string = "http://www.venmo.com/" + venmo
        if let url = URL(string: url_string), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileDetailSegue" {
            let detailViewController = segue.destination as! DetailViewController
            let cell = sender as! HomeCell
            let indexPath = postCollectionView.indexPath(for: cell)
            let photo = self.photoArray[(indexPath?.item)!] as! Photo
            //detailViewController.barber = cell.barber
            let post = photo["post"] as! Post
            onlyWithPost(post: post)
            detailViewController.post = post
            detailViewController.filteredPhotos = self.filteredPhotos
            detailViewController.photoId = photo.objectId as! String
            //detailViewController.photo = photo as! Photo
            
        } else if segue.identifier == "profileTagSegue" {
            let vc = segue.destination as! TSRViewController
            let cell = sender as! TagCell
            let indexPath = tagCollectionView.indexPath(for: cell)
            vc.tagTitle.title = self.tagNameArray[(indexPath?.item)!]
            vc.tag = cell.tagObject
            //detailViewController.photo = photo as! Photo
        }
        
        if segue.identifier == "shop_view" {
            print("sending")
            let destVC = segue.destination as! BarberShopViewController
            destVC.barberShop = barber["barbershop"] as! Barbershop
        }
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

    override func viewDidLoad() {
        super.viewDidLoad()
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.alwaysBounceVertical = false
        self.view.addSubview(postCollectionView)
        self.view.addSubview(tagCollectionView)
        
        venmoImageView.layer.cornerRadius = 6
        venmoImageView.clipsToBounds = true

        self.profileImageVIew.file = (barber["profile_pic"] as! PFFile)
        self.profileImageVIew.loadInBackground()
        
        if barbershop == nil {
            barbershop = barber["barbershop"] as? Barbershop
        }
    
        self.barbershopImageView.contentMode = .scaleAspectFill
        self.barbershopImageView.clipsToBounds = true
        self.barbershopImageView.file = barbershop?.picture
        
        let gradient = CAGradientLayer()
        gradient.frame = barbershopImageView.frame
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        barbershopImageView.layer.insertSublayer(gradient, at: 0)
        
        self.barbershopImageView.loadInBackground()
        
        if barbershopName == nil || barbershopName == "" {
            barbershopName = barbershop?["name"] as? String
        }
        
        self.barbershopLabel.text = barbershopName
        barberName = barber["name"] as? String
        self.usernameLabel.text = barberName
        
        // Make profile pic circular
        profileImageVIew.layer.masksToBounds = false
        profileImageVIew.layer.cornerRadius = profileImageVIew.frame.height/2
        profileImageVIew.clipsToBounds = true
        
        whiteBorderImageView.layer.cornerRadius = profileImageVIew.frame.height/2
        whiteBorderImageView.clipsToBounds = true



        let query = PFQuery(className: "Post")
        query.whereKey("barber", equalTo: self.barber)
        query.includeKey("tags")
        query.includeKey("barber")
        query.includeKey("barber.name")
        query.includeKey("barber.barbershop")
        query.includeKey("barber.profile_pic")
        query.includeKey("barber.barbershop.picture")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if objects != nil {
                query.whereKey("tags", containedIn: objects!)
                self.posts = objects as! [Post]
                for postOb in self.posts {
                    self.post = postOb as! Post
                    self.tagArray = self.post.tags!
                    for tagOb in self.tagArray {
                        self.tagNameSet.insert("\(tagOb.name!)")
                        self.tagArray.append(tagOb)
                    }
                }

                let secondQuery = PFQuery(className: "Photo")
                secondQuery.whereKey("post", containedIn: objects!)
                secondQuery.includeKey("first")
                secondQuery.includeKey("favorited")
                secondQuery.includeKey("objectId")
                secondQuery.includeKey("post")
                secondQuery.includeKey("post.barber")
                secondQuery.includeKey("post.price")
                secondQuery.includeKey("post.barber.barbershop")
                secondQuery.includeKey("post.tags")
                secondQuery.findObjectsInBackground { (secondObjects: [PFObject]?, error: Error?) in
                    if secondObjects != nil {
                        let photos = secondObjects
                        for photoOb in photos! {
                            let photo = photoOb as! Photo
                            let first = photo["first"] as! Bool
                            if first == true {
                                self.photoArray.append(photo)
                            }
                            self.photo = photoOb as! Photo
                        }
                        self.allPhotos = secondObjects as! [Photo]
                        
                        self.postCollectionView.reloadData()
                        self.tagCollectionView.reloadData()


                    } else {
                        print(error?.localizedDescription)
                    }
                }
            }
            if let layout = self.tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
        }
        let refreshcontrol = UIRefreshControl()
        refreshcontrol.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        self.postCollectionView.addSubview(refreshcontrol)
        self.postCollectionView.alwaysBounceVertical = true
        self.tagCollectionView.addSubview(refreshcontrol)
        //add refresh control to the table view
        self.tagCollectionView.insertSubview(refreshcontrol, at: 0)
        self.postCollectionView.insertSubview(refreshcontrol, at: 0)


    }
    
    func refresh() {
        
        //construct PFQuery
        let query = PFQuery(className: "Post")
        let defaults=UserDefaults.standard
        
        if let lastUpdateDate=defaults.object(forKey: "lastUpdateDate") as? NSDate {
            query.whereKey("updatedAt",greaterThan:lastUpdateDate)
        }
        query.whereKey("barber", equalTo: self.barber)
        query.includeKey("tags")
        query.includeKey("barber")
        query.includeKey("barber.name")
        query.includeKey("barber.barbershop")
        query.includeKey("barber.profile_pic")
        //fetch data asynchronously
        query.findObjectsInBackground { (objects, error: Error?) in
            if objects != nil {
                defaults.set(NSDate(),forKey:"lastUpdateDate")
                query.whereKey("tags", containedIn: objects!)
                self.posts = objects as! [Post]
                for postOb in self.posts {
                    self.post = postOb as! Post
                    self.tagArray = self.post.tags as! [Tag]
                    for tagOb in self.tagArray {
                        self.tagNameSet.insert("\(tagOb.name!)")
                    }
                }
                
                let secondQuery = PFQuery(className: "Photo")
                secondQuery.whereKey("post", containedIn: objects!)
                secondQuery.includeKey("first")
                secondQuery.includeKey("favorited")
                secondQuery.includeKey("objectId")
                secondQuery.includeKey("post")
                secondQuery.includeKey("post.barber")
                secondQuery.includeKey("post.price")
                secondQuery.includeKey("post.barber.barbershop")
                secondQuery.includeKey("post.tags")
                
                //                secondQuery.includeKey("tag")
                secondQuery.findObjectsInBackground { (secondObjects: [PFObject]?, error: Error?) in
                    if secondObjects != nil && secondObjects?.isEmpty == false {
                        defaults.set(NSDate(),forKey:"lastUpdateDate")
                        let photos = secondObjects
                        for photoOb in photos! {
                            let photo = photoOb as! Photo
                            let first = photo["first"] as! Bool
                            if first == true {
                                self.photoArray.insert(photo, at: 0)
                            }
                            self.photo = photoOb as! Photo
                                                   }
                        //self.photoArray = secondObjects as! [Photo]
                        
                        self.postCollectionView.reloadData()
                        self.tagCollectionView.reloadData()
                        
                    } else {
                        print(error?.localizedDescription)
                    }
                }
                //                self.photoArray = photos
                self.postCollectionView.reloadData()
                self.tagCollectionView.reloadData()
            }
        }
    }
    
    //refresh control function
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        refresh()
        refreshControl.endRefreshing()
    }
    
    func onlyWithPost(post: Post) {
        let postID = post.objectId!
        self.filteredPhotos = self.allPhotos.filter { (photo: PFObject) -> Bool in
            let photoPost = photo["post"] as! Post
            let photoPostID = photoPost.objectId!
            return photoPostID == postID
        }
        
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.postCollectionView {
            let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! HomeCell
            let photo = self.photoArray[indexPath.item]
            let media = photo["image"] as? PFFile
            media?.getDataInBackground { (backgroundData: Data?, error: Error?) in
                if let backgroundData = backgroundData {
                    postCell.profileCutImageView.contentMode = .scaleAspectFill
                    postCell.profileCutImageView.clipsToBounds = true
                    postCell.profileCutImageView.image = UIImage(data: backgroundData)
                }
            }
            return postCell

        } else {
            let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagCell
            self.tagNameArray = Array(tagNameSet)
            tagCell.tagObject = self.tagArray[indexPath.item] as! Tag
            tagCell.profileTagLabel.text = self.tagNameArray[indexPath.item]
            tagCell.layer.cornerRadius = 15
            tagCell.profileTagLabel.adjustsFontSizeToFitWidth = true
            return tagCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.postCollectionView {
            return self.photoArray.count
        }
        //return tagNameArray.count
        return self.tagNameSet.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
