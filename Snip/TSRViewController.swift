//
//  TSRViewController.swift
//  Snip
//
//  Created by Chase Warren on 7/21/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse

class TSRViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tagLabel: UILabel!
    
    var photos: [PFObject] = []
    var photo: PFObject?
    var tag: Tag?
    var posts: [Post]?
    var post: Post?
    var detailArray: [PFObject]?
    var allPhotos: [PFObject] = []
    var filteredPhotos: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(hex: "FFFFFF"), NSFontAttributeName: UIFont.init(name: "Open Sans", size: 18.0)!]
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let query = PFQuery(className: "Post")
        query.whereKey("tags", equalTo: self.tag)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if objects != nil {
                let secondQuery = PFQuery(className: "Photo")
                
                secondQuery.whereKey("post", containedIn: objects!)
                secondQuery.whereKey("first", equalTo: true)
                
                secondQuery.includeKey("first")
                secondQuery.includeKey("objectId")
                secondQuery.includeKey("favorited")
                secondQuery.includeKey("post.barber")
                secondQuery.includeKey("post.price")
                secondQuery.includeKey("post.barber.barbershop")
                secondQuery.includeKey("post.tags")
                
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
    
    func onlyWithPost(post: Post) {
        let postID = post.objectId!
        self.filteredPhotos = self.allPhotos.filter { (photo: PFObject) -> Bool in
            let photoPost = photo["post"] as! Post
            let photoPostID = photoPost.objectId!
            return photoPostID == postID
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailViewController
        let cell = sender as! HomeCell
        vc.postImage = cell.TSRCutImageView.image!
        let indexPath = collectionView.indexPath(for: cell)
        let photo = self.photos[(indexPath?.item)!] as! Photo
        let post = photo["post"] as! Post
        queryAllPhotos()
        onlyWithPost(post: post)
        vc.post = photo["post"] as! Post
        vc.filteredPhotos = self.filteredPhotos
        vc.photoId = photo.objectId! as String
    }
    
    func queryAllPhotos() {
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
                self.allPhotos = photos
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
