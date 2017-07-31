//
//  UserSnipsViewController.swift
//  Snip
//
//  Created by Cameryn Boyd on 7/28/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserSnipsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //    @IBOutlet weak var userImageView: UIImageView!
    //    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var snipsCollectionView: UICollectionView!
    
    var photoArray: [PFObject] = []
    var allPhotos: [PFObject] = []
    var photo: Photo?
    var user: Bool?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userSnips" {
            let detailViewController = segue.destination as! DetailViewController
            let cell = sender as! SavedPostCell
            let indexPath = snipsCollectionView.indexPath(for: cell)
            let photo = self.photoArray[(indexPath?.item)!] as! Photo
            //detailViewController.barber = cell.barber
            let post = photo["post"] as! Post
            detailViewController.post = post
            detailViewController.photoArray = self.allPhotos
            //detailViewController.photoId = photo.objectId as! String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        snipsCollectionView.delegate = self
        snipsCollectionView.dataSource = self
        
        let query = PFQuery(className: "Photo")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        query.includeKey("first")
        query.includeKey("objectId")
        query.includeKey("post")
        query.includeKey("post.barber")
        query.includeKey("post.barber.barbershop")
        query.includeKey("post.tags")
        query.limit = 30
        //fetch data asynchronously
        query.findObjectsInBackground { (objects, error: Error?) in
            if let photos = objects {
                self.allPhotos = objects!
                let photo = photos.first as! Photo
                let post = photo["post"] as! Post
                for photoOb in photos {
                    self.photo = photoOb as! Photo
                    self.user = self.photo!["user"] as! Bool
                    if self.user == true {
                        self.photoArray.append(self.photo!)
                    }
                }
                self.snipsCollectionView.reloadData()
            }
        }
        let refreshcontrol = UIRefreshControl()
        refreshcontrol.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        self.snipsCollectionView.addSubview(refreshcontrol)
        self.snipsCollectionView.alwaysBounceVertical = true
        //add refresh control to the table view
        self.snipsCollectionView.insertSubview(refreshcontrol, at: 0)
        
        // Do any additional setup after loading the view.
    }
    
    func refresh() {
        
        //construct PFQuery
        let query = PFQuery(className: "Photo")
        let defaults=UserDefaults.standard
        if let lastUpdateDate=defaults.object(forKey: "lastUpdateDate") as? NSDate {
            query.whereKey("updatedAt",greaterThan:lastUpdateDate)
        }
        
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        query.includeKey("first")
        query.includeKey("objectId")
        query.includeKey("post")
        query.includeKey("post.barber")
        query.includeKey("post.barber.barbershop")
        query.includeKey("post.tags")
        query.limit = 30
        //fetch data asynchronously
        query.findObjectsInBackground { (objects, error: Error?) in
            if objects != nil && objects?.isEmpty == false {
                let photos = objects
                print(objects?.isEmpty)
                defaults.set(NSDate(),forKey:"lastUpdateDate")
                self.allPhotos = objects!
                let photo = photos?.first as! Photo
                let post = photo["post"] as! Post
                for photoOb in photos! {
                    self.photo = photoOb as! Photo
                    self.user = self.photo!["user"] as! Bool
                    if self.user == true {
                        self.photoArray.append(self.photo!)
                    }
                }
                self.snipsCollectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userSnipCell", for: indexPath) as! SavedPostCell
        let photo = photoArray[indexPath.item]
        let media = photo["image"] as? PFFile
        media?.getDataInBackground { (backgroundData: Data?, error: Error?) in
            if let backgroundData = backgroundData {
                cell.userSnipImageView.contentMode = .scaleAspectFill
                cell.userSnipImageView.clipsToBounds = true
                cell.userSnipImageView.image = UIImage(data: backgroundData)
            }
        }
        return cell
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
