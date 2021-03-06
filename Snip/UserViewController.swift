//
//  UserViewController.swift
//  Snip
//
//  Created by Cameryn Boyd on 7/26/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var savedCollectionView: UICollectionView!
    
    var photoArray: [PFObject] = []
    var allPhotos: [PFObject] = []
    var photo: Photo!
    var favorited: Bool?
    var filteredPhotos: [PFObject]?
    var parentNavigationController: UINavigationController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedCollectionView.delegate = self
        savedCollectionView.dataSource = self
        
        savedCollectionView.alwaysBounceHorizontal = false
        savedCollectionView.alwaysBounceVertical = true
        savedCollectionView.bounces = true
        
        let query = PFQuery(className: "Photo")
        query.order(byDescending: "createdAt")
        query.includeKey("favorited")
        query.includeKey("objectId")
        query.includeKey("first")
        query.includeKey("post")
        query.includeKey("post.barber")
        query.includeKey("post.barber.barbershop")
        query.includeKey("post.tags")
        //fetch data asynchronously
        query.findObjectsInBackground { (objects, error: Error?) in
            if let photos = objects {
                self.allPhotos = objects!
                let photoTemp = photos.first as! Photo
                let post = photoTemp["post"] as! Post
                for photoOb in photos {
//                    self.photo = photoOb as! Photo
                    self.favorited = photoOb["favorited"] as! Bool
                    if self.favorited == true {
                    print(photoOb)
                    }
                    if self.favorited == true {
                        self.photoArray.append(photoOb)
                    }
                }
                self.savedCollectionView.reloadData()
            }
        }
        let refreshcontrol = UIRefreshControl()
        refreshcontrol.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        self.savedCollectionView.addSubview(refreshcontrol)
        self.savedCollectionView.alwaysBounceVertical = true
        //add refresh control to the table view
        self.savedCollectionView.insertSubview(refreshcontrol, at: 0)
        // Do any additional setup after loading the view.
    }
    
    func onlyWithPost(post: Post) {
        let postID = post.objectId!
        self.filteredPhotos = self.allPhotos.filter { (photo: PFObject) -> Bool in
            let photoPost = photo["post"] as! Post
            let photoPostID = photoPost.objectId!
            return photoPostID == postID
        }
        
    }
    
    func refresh() {
        //construct PFQuery
        let query = PFQuery(className: "Photo")
        let defaults=UserDefaults.standard
        if let lastUpdateDate=defaults.object(forKey: "lastUpdateDate") as? NSDate {
            query.whereKey("updatedAt",greaterThan:lastUpdateDate)
        }
        
        query.order(byDescending: "createdAt")
        query.includeKey("favorited")
        query.includeKey("objectId")
        query.includeKey("first")
        query.includeKey("post")
        query.includeKey("post.barber")
        query.includeKey("post.barber.barbershop")
        query.includeKey("post.tags")
        //fetch data asynchronously
        query.findObjectsInBackground { (objects, error: Error?) in
            if objects != nil && objects?.isEmpty == false {
                let photos = objects
                defaults.set(NSDate(),forKey:"lastUpdateDate")
                self.allPhotos = objects!
                let photo = photos?.first as! Photo
                let post = photo["post"] as! Post
                for photoOb in photos! {
                    self.photo = photoOb as! Photo
                    self.favorited = self.photo!["favorited"] as! Bool
                    if self.favorited == true {
                        self.photoArray.insert(self.photo!, at: 0)
                    }
                }
                self.savedCollectionView.reloadData()
            }
        }
    }
    
    //refresh control function
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        refresh()
        refreshControl.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let photo = self.photoArray[indexPath.item] as! Photo
        let post = photo["post"] as! Post
        let barber = post["barber"] as! Barber
        
        onlyWithPost(post: post)
        
        detailViewController.filteredPhotos = self.filteredPhotos
        detailViewController.post = post
        detailViewController.barber = barber
        
        detailViewController.navigationController?.setNavigationBarHidden(false, animated: true)
        parentNavigationController!.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedPostCell", for: indexPath) as! SavedPostCell
        let photo = photoArray[indexPath.item]
        let media = photo["image"] as? PFFile
        media?.getDataInBackground { (backgroundData: Data?, error: Error?) in
            if let backgroundData = backgroundData {
                cell.savedImageView.contentMode = .scaleAspectFill
                cell.savedImageView.clipsToBounds = true
                cell.savedImageView.image = UIImage(data: backgroundData)
            }
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
