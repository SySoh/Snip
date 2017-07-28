//
//  TSRViewController.swift
//  Snip
//
//  Created by Chase Warren on 7/21/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse

class TSRViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tagLabel: UILabel!
    
    var photos: [PFObject] = []
    var photo: PFObject?
    var tag: Tag?
    var posts: [Post]?
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.tagLabel.text = self.tag?.name
        let query = PFQuery(className: "Post")
        query.whereKey("tags", equalTo: self.tag)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if objects != nil {
                let secondQuery = PFQuery(className: "Photo")
                secondQuery.whereKey("post", containedIn: objects!)
                secondQuery.findObjectsInBackground { (secondObjects: [PFObject]?, error: Error?) in
                    if secondObjects != nil {
                        self.photos = secondObjects as! [Photo]
                        self.collectionView.reloadData()
                        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TSRCell", for: indexPath) as! HomeCell
        let photo = self.photos[indexPath.item]
        let media = photo["image"] as? PFFile
        media?.getDataInBackground { (backgroundData: Data?, error: Error?) in
            if let backgroundData = backgroundData {
                cell.TSRCutImageView.contentMode = .scaleAspectFill
                cell.TSRCutImageView.clipsToBounds = true
                cell.TSRCutImageView.image = UIImage(data: backgroundData)
            }
        }
        return cell
    }
    
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
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
