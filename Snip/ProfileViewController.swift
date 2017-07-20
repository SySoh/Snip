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
    var tagNameArray: [String]!
    var posts: [Post]!
    var post: Post!
    var barbers: [Barber]!
    var barber: Barber!
    var barberId: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
        self.profileImageVIew.file = barber["profile_pic"] as! PFFile
        self.profileImageVIew.loadInBackground()
        self.barbershopLabel.text = barbershopName
        self.venmoLabel.text = venmo
        self.usernameLabel.text = barberName
        print(self.usernameLabel.text)
        print(self.barber)
//        self.post = photo["post"] as! Post
//        self.barber = post["barber"] as! Barber

        // Do any additional setup after loading the view.
        let query = PFQuery(className: "Post")
        query.whereKey("barber", equalTo: self.barber)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if objects != nil {
                print(objects)
                let secondQuery = PFQuery(className: "Photo")
                secondQuery.whereKey("post", containedIn: objects!)
                secondQuery.findObjectsInBackground { (secondObjects: [PFObject]?, error: Error?) in
                    if secondObjects != nil {
                        self.photoArray = secondObjects as! [Photo]
                        self.postCollectionView.reloadData()
                    } else {
                        print(error?.localizedDescription)
                    }
                }
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! HomeCell
        let photo = self.photoArray[indexPath.item]
        print("here is the post object")
        let media = photo["image"] as? PFFile
        print("sup")
        print(media)
        //let media = fullPhotoList[indexPath.item] as? PFFile
        media?.getDataInBackground { (backgroundData: Data?, error: Error?) in
            if let backgroundData = backgroundData {
                cell.profileCutImageView.contentMode = .scaleAspectFill
                cell.profileCutImageView.clipsToBounds = true
                cell.profileCutImageView.image = UIImage(data: backgroundData)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoArray.count
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
