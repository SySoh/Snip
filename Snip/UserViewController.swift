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
    var photo: Photo?
    var favorited: Bool?


    override func viewDidLoad() {
        super.viewDidLoad()
        savedCollectionView.delegate = self
        savedCollectionView.dataSource = self

        let query = PFQuery(className: "Photo")
        query.order(byDescending: "createdAt")
        query.includeKey("favorited")
        query.includeKey("post.barber")
        query.includeKey("post.barber.barbershop")
        query.includeKey("post.tags")
        query.limit = 30
        //fetch data asynchronously
        query.findObjectsInBackground { (objects, error: Error?) in
            if let photos = objects {
                let photo = photos.first as! Photo
                let post = photo["post"] as! Post
                for photoOb in photos {
                    self.photo = photoOb as! Photo
                    self.favorited = self.photo!["favorited"] as! Bool
                    if self.favorited == true {
                        self.photoArray.append(self.photo!)
                    }
                }

                self.savedCollectionView.reloadData()


            }
        }

        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
