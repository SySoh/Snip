//
//  HomeViewController.swift
//  Snip
//
//  Created by Cameryn Boyd on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var photoArray: [PFObject] = []
    var fullPhotoList: [PFFile] = []
    var postArray: [PFObject] = []
    var barbershops: [PFObject] = []

    var detailArray: [PFObject]?

    var photo: Photo?
    var post: Post?
    var price: Int?
    var tags: [Tag]?
    var user: User?
    var barber: Barber?
    var barberName: String!
    var venmo: String?
    var profile_pic: PFFile?
    var barbershop: Barbershop?
    var shopName: String?
    var shopPic: PFFile?
    var location: String?
    var phone: String?
    var rating: Int?
    var first: Bool?
    var fullArray: [PFObject]?
    var filteredPhotos: [PFObject]?
    //var isDataLoading = false
    var loader = ActivityIndicatorWithLabel()
    
    
    
    // outlets
    @IBOutlet weak var mapViewButton: UIButton!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.homeCollectionView.addGestureRecognizer(lpgr)
        self.view.addSubview(loader)
        loader.startAnimation()
        let query = PFQuery(className: "Photo")
        query.order(byDescending: "createdAt")
        query.includeKey("first")
        query.includeKey("favorited")
        query.includeKey("objectId")
        query.includeKey("post")
        query.includeKey("post.barber")
        query.includeKey("post.price")
        query.includeKey("post.barber.barbershop")
        query.includeKey("post.tags")
        //fetch data asynchronously

        query.findObjectsInBackground { (objects, error: Error?) in
            if let photos = objects {
                for photoOb in photos {
                    self.photo = photoOb as! Photo
                    self.first = self.photo!["first"] as! Bool
                    if self.first == true {
                        self.photoArray.append(self.photo!)
                    }
                    self.detailArray = photos as! [Photo]
                }
                self.homeCollectionView.reloadData()
                self.loader.stopAnimation()
                
            }
        }
        refresh()
        getShopLocations()
        
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.alwaysBounceVertical = true
        // Do any additional setup after loading the view.
        let refreshcontrol = UIRefreshControl()
        refreshcontrol.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        //add refresh control to the table view
        homeCollectionView.insertSubview(refreshcontrol, at: 0)
        
    }
    
    func onLongPress(_ gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            return
        }
        
        let p = gestureReconizer.location(in: self.homeCollectionView)
        let indexPath = self.homeCollectionView.indexPathForItem(at: p)
        
        if let index = indexPath {
            let cell = self.homeCollectionView.cellForItem(at: index)
            cell?.isHighlighted = true
            // do stuff with your cell, for example print the indexPath
            print(index.row)
        } else {
            print("Could not find index path")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailViewController
        let cell = sender as! HomeCell
        let indexPath = homeCollectionView.indexPath(for: cell)
        let photo = photoArray[(indexPath?.item)!] as! Photo
        let post = photo["post"] as! Post
        onlyWithPost(post: post)
        vc.post = photo["post"] as! Post
        vc.filteredPhotos = self.filteredPhotos
        vc.photoId = photo.objectId as! String
    }
    
    func getShopLocations() {
        let query = PFQuery(className: "Barbershop")
        query.includeKey("geopoint")
        query.findObjectsInBackground { (objects, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.barbershops = objects!
            }
            
        }
    }
    
    func onlyWithPost(post: Post) {
        let postID = post.objectId!
        self.filteredPhotos = self.detailArray?.filter { (photo: PFObject) -> Bool in
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
        query.includeKey("first")
        query.includeKey("favorited")
        query.includeKey("objectId")
        query.includeKey("post")
        query.includeKey("post.barber")
        query.includeKey("post.price")
        query.includeKey("post.barber.barbershop")
        query.includeKey("post.tags")
        //fetch data asynchronously
        query.findObjectsInBackground { (objects, error: Error?) in
            if let photos = objects {
                defaults.set(NSDate(),forKey:"lastUpdateDate")
                for photoOb in photos {
                    self.photo = photoOb as! Photo
                    self.first = self.photo!["first"] as! Bool
                    if self.first == true {
                        self.photoArray.insert(self.photo!, at: 0)
                    }
                    self.detailArray = photos as! [Photo]
                }
//                self.photoArray = photos
                self.homeCollectionView.reloadData()
                

            }
        }
    }
    
    //refresh control function
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        refresh()
        refreshControl.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let photo = self.photoArray[indexPath.item]
        self.first = photo["first"] as! Bool
        let media = photo["image"] as? PFFile
        //let media = fullPhotoList[indexPath.item] as? PFFile
        media?.getDataInBackground { (backgroundData: Data?, error: Error?) in
            if let backgroundData = backgroundData {
                cell.cutImageView.contentMode = .scaleAspectFill
                cell.cutImageView.clipsToBounds = true
                cell.cutImageView.image = UIImage(data: backgroundData)
            }
        }
        //cell.cutImageView.image = UIImage(data: <#T##Data#>)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(hex: "FFFFFF"), NSFontAttributeName: UIFont.init(name: "Blessed Day", size: 42.0)!]
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(CGFloat(10.0), for: .default)
        
        if (self.navigationController?.isNavigationBarHidden)! {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        
        self.tabBarController?.title = "Snip"
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
