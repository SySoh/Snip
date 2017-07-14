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
    
    func refresh() {
        //construct PFQuery
        let query = PFQuery(className: "Photo")
        query.order(byDescending: "createdAt")
        query.includeKey("image")
        query.includeKey("post")
//        let query = PFQuery(className: "Post")
//        query.order(byDescending: "createdAt")
//        query.includeKey("user")
//        query.includeKey("photos")
//        query.includeKey("barber")
//        query.includeKey("profile_pic")
//        query.includeKey("tags")
        query.limit = 20
        //fetch data asynchronously
        query.findObjectsInBackground { (photos: [PFObject]?, error: Error?) in
            if let photos = photos {
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
