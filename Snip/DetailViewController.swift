//
//  DetailViewController.swift
//  Snip
//
//  Created by Cameryn Boyd on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailViewController: UIViewController {
    
    //variables
    var post: PFObject!
    var postId: String?
    var caption: String?
    var price: String?
    var date: Date!
    var profileImage: PFFile!
    var barber: String!
    var barbershop: String!
    var photo: PFObject!
    var photoId: String?
    
    // outlets
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var barbershopConstantLabel: UILabel!
    @IBOutlet weak var barberConstantLabel: UILabel!
    @IBOutlet weak var priceConstantLabel: UILabel!
    @IBOutlet weak var barbershopLabel: UILabel!
    @IBOutlet weak var barberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    var photoArray: [PFObject]? = []

    
    @IBAction func pressDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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

            } else {
                print(error?.localizedDescription)
            }
        }
        
        self.dateLabel.text = String(describing: self.date)
        self.barberLabel.text = self.barber
        self.barbershopLabel.text = self.barbershop
        self.priceLabel.text = self.price
        
        if let date = self.post.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: date)
            print(dateString) // Prints: Jun 28, 2017, 2:08 PM
            
            self.dateLabel.text = dateString
            }
            
        

    
        
        //self.profileImageView.file = profileImage
        //self.profileImageView.loadInBackground()

        //self.postImageView.file = photo.image
        //self.postImageView.loadInBackground()
        
        //self.profileImageView.file = post["profile_pic"] as! PFFile
        //self.postImageView.file = post["media"] as? PFFile
        //self.postImageView.loadInBackground()
        //self.captionLabel.text = (post["caption"] as! String)
        //self.dateLabel.text = post["_created_at"] as? String
        //self.barberLabel.text = post["barber"] as? String
        //self.barbershopLabel.text = post["barbershop"] as? String
        //self.priceLabel.text = post["price"] as? String
        

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
