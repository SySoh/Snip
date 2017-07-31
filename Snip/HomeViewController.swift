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

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
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
    //var isDataLoading = false
    
    
    // outlets
    @IBOutlet weak var mapViewButton: UIButton!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    @IBAction func touchCamera(_ sender: Any) {
    }
    
    @IBAction func touchSearch(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
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
    

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        if offsetY > contentHeight - scrollView.frame.size.height {
//            refresh()
//            self.homeCollectionView.reloadData()
//        }
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            let vc = segue.destination as! DetailViewController
            let cell = sender as! HomeCell
            let indexPath = homeCollectionView.indexPath(for: cell)
            let photo = photoArray[(indexPath?.item)!] as! Photo
            vc.post = photo["post"] as! Post
            vc.photoArray = self.detailArray
            vc.allPhotos = self.photoArray
            vc.photoId = photo.objectId as! String
            }
        if segue.identifier == "MapView" {
            let destVC = segue.destination as! MapViewController
            destVC.shops = self.barbershops as! [Barbershop]
        }
        if segue.identifier == "compose_view" {
            print("goin")
        }
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
    
    
    
    func refresh() {
        //construct PFQuery
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
        
        if (self.navigationController?.isNavigationBarHidden)! {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
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
