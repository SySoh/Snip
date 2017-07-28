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
import RSKPlaceholderTextView

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var profileImageVIew: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var shopConstantLabel: UILabel!
    @IBOutlet weak var barbershopLabel: UILabel!
    @IBOutlet weak var venmoConstantLabel: UILabel!
    @IBOutlet weak var venmoTextView: UITextView!
    
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
        print(barber)
        self.profileImageVIew.file = barber["profile_pic"] as! PFFile
        self.profileImageVIew.loadInBackground()
        let barbershop = barber["barbershop"] as? Barbershop
        barbershopName = barbershop?["name"] as? String
        self.barbershopLabel.text = barbershopName
        venmo = barber["venmo"] as? String
        self.venmoTextView.text = "venmo.com/" + venmo
        print(self.venmoTextView.text)
        self.usernameLabel.text = barberName
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
                
                let secondQuery = PFQuery(className: "Photo")
                secondQuery.whereKey("post", containedIn: objects!)
                //                secondQuery.includeKey("tag")
                secondQuery.findObjectsInBackground { (secondObjects: [PFObject]?, error: Error?) in
                    if secondObjects != nil {
                        self.photoArray = secondObjects as! [Photo]
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
                tagCell.profileTagLabel.text = self.tagNameArray[indexPath.item]
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
