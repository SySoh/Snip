//
//  ProfileViewController.swift
//  Snip
//
//  Created by Cameryn Boyd on 7/18/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var profileImageVIew: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var shopConstantLabel: UILabel!
    @IBOutlet weak var barbershopLabel: UILabel!
    @IBOutlet weak var venmoConstantLabel: UILabel!
    @IBOutlet weak var venmoLabel: UILabel!
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    var photoArray: [PFObject] = []
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
    
    @IBAction func pressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        self.view.addSubview(postCollectionView)
        self.view.addSubview(tagCollectionView)
        
        self.profileImageVIew.file = barber["profile_pic"] as! PFFile
        self.profileImageVIew.loadInBackground()
        self.barbershopLabel.text = barbershopName
        self.venmoLabel.text = venmo
        self.usernameLabel.text = barberNamez
        //        self.post = photo["post"] as! Post
        //        self.barber = post["barber"] as! Barber
        
        // Do any additional setup after loading the view.
        let query = PFQuery(className: "Post")
        query.whereKey("barber", equalTo: self.barber)
        query.includeKey("tags")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if objects != nil {
                query.whereKey("tags", containedIn: objects!)
                self.posts = objects as! [Post]
                for postOb in self.posts {
                    self.post = postOb as! Post
                    self.tagArray = self.post.tags as! [Tag]
                    for tagOb in self.tagArray {
                        self.tagNameSet.insert("\(tagOb.name!)")
                    }
                }
//                self.post = self.posts.first as! Post
//                self.tagArray = self.post.tags as! [Tag]
                //self.tagArray = self.post["tag"] as! [Tag]
                //for tag in self.tagArray {
                  //  self.tagNameArray.append(tag.name!)
                }
                let secondQuery = PFQuery(className: "Photo")
                secondQuery.whereKey("post", containedIn: objects!)
//                secondQuery.includeKey("tag")
                secondQuery.findObjectsInBackground { (secondObjects: [PFObject]?, error: Error?) in
                    if secondObjects != nil {
                        self.photoArray = secondObjects as! [Photo]
                        self.postCollectionView.reloadData()
                       
//                        self.tagNameArray = self.tagArray["name"] as! String
                        
                        
//                        let tagArray = secondObjects["tag"] as! Tag
//                        self.tagNameArray = tagArray["name"] as! String
                        self.tagCollectionView.reloadData()
                
                    } else {
                        print(error?.localizedDescription)
                    }
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.postCollectionView {
            let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! HomeCell
            let photo = self.photoArray[indexPath.item]
            print("here is the post object")
            let media = photo["image"] as? PFFile
            print("sup")
            print(media)
            //let media = fullPhotoList[indexPath.item] as? PFFile
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
            print(self.tagNameArray)
            tagCell.profileTagLabel.text = self.tagNameArray[indexPath.item]
            print(tag)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
