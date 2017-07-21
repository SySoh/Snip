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
    var isDataLoading = false

    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            refresh()
            self.homeCollectionView.reloadData()
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (!isDataLoading) {
//            //calculate the position fo one screen length before the bottom of the results
//            let scrollViewContentHeight = homeCollectionView.contentSize.height
//            let scrollOffsetThreshold = scrollViewContentHeight - homeCollectionView.bounds.size.height
//            //when the user has scrolled past the threshold, start requesting
//            if(scrollView.contentOffset.y > scrollOffsetThreshold && homeCollectionView.isDragging) {
//                self.isDataLoading = true
//            }
//        }
//    }
    
//    func loadMoreData() {
//        let myRequest = refresh()
//        //configure session so that completion handler is executed on main UI thread
//        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
//        let task: URLSessionDataTask = session.dataTask(with: myRequest) { (data, response, error) in
//            self.isDataLoading = false
//            self.homeCollectionView.reloadData()
//            
//        }
//
//        task.resume()
//    }
//    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            let vc = segue.destination as! DetailViewController
            let cell = sender as! HomeCell
//            print(barberName)
            vc.postImage = cell.cutImageView.image!
            let indexPath = homeCollectionView.indexPath(for: cell)
            let photo = photoArray[(indexPath?.item)!]
            print(photo)
            vc.photo = photo as! Photo
            vc.photoArray = self.photoArray
            print(photoArray)
            }
    }
    
    func refresh() {
        //construct PFQuery
        let query = PFQuery(className: "Photo")
        query.order(byDescending: "createdAt")
        query.includeKey("image")
        query.includeKey("first")
        query.includeKey("post.barber")
        query.includeKey("post.barber.barbershop")
        query.includeKey("post.tags")
        query.limit = 20
        //fetch data asynchronously
        query.findObjectsInBackground { (objects, error: Error?) in
            if let photos = objects {
                let photo = photos.first as! Photo
                let post = photo["post"] as! Post
                for photoOb in photos {
                    self.photo = photoOb as! Photo
                    print(self.photo?["first"])
                    self.first = self.photo!["first"] as! Bool
                    if self.first == true {
                        self.photoArray.append(self.photo!)
                    }
                    
                }
                //self.photoArray = photos
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
        self.first = photo["first"] as! Bool
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
