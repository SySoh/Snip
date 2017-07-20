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

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var photoArray: [PFObject] = []
    var fullPhotoList: [PFFile] = []
    var postArray: [PFObject] = []
    
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

    
    // outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    @IBAction func touchCamera(_ sender: Any) {
    }
    
    @IBAction func touchSearch(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        // Do any additional setup after loading the view.
        let refreshcontrol = UIRefreshControl()
        refreshcontrol.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        //add refresh control to the table view
        homeCollectionView.insertSubview(refreshcontrol, at: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            let vc = segue.destination as! DetailViewController
            let cell = sender as! HomeCell
//            print(barberName)
            vc.postImage = cell.cutImageView.image!
            let indexPath = homeCollectionView.indexPath(for: cell)
            let photo = photoArray[(indexPath?.item)!]
            vc.photo = photo as! Photo
            vc.photoArray = self.photoArray
            }
    }
    
    func refresh() {
        //construct PFQuery
        let query = PFQuery(className: "Photo")
        query.order(byDescending: "createdAt")
        query.includeKey("image")
        query.includeKey("post.barber")
        query.includeKey("post.barber.barbershop")
        query.includeKey("post.tags")
        query.limit = 20
        //fetch data asynchronously
        query.findObjectsInBackground { (objects, error: Error?) in
            if let photos = objects {
//                print("made it here")
                let photo = photos.first as! Photo
                let post = photo["post"] as! Post
//                self.price = post["price"] as! Int
//                self.tags = post["tags"] as! [Tag]
//                //self.user = post["user"] as! User
//                self.barber = post["barber"] as! Barber
//                print(self.barber?["name"])
//                print("ABOVE IS THE NAME")
//                self.barberName = self.barber?["name"] as! String
//                self.venmo = self.barber?["venmo"] as! String
//                self.profile_pic = self.barber?["profile_pic"] as! PFFile
//                self.barbershop = self.barber?["barbershop"] as! Barbershop
//                self.shopName = self.barbershop?["name"] as! String
//                //let shopPic = barbershop["picture"] as! PFFile
//                self.location = self.barbershop?["location"] as! String
//                self.phone = self.barbershop?["phone"] as! String
//                self.rating = self.barbershop?["rating"] as! Int
                //print(barber["name"])
                self.photoArray = photos
                self.homeCollectionView.reloadData()
            } else {
                print(error?.localizedDescription)
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
        print("here is the post object")
        let media = photo["image"] as? PFFile
        //let media = fullPhotoList[indexPath.item] as? PFFile
        media?.getDataInBackground { (backgroundData: Data?, erro: Error?) in
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
