//
//  Post.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import Foundation
import Parse

class Post: PFObject, PFSubclassing {


    @NSManaged var barber: Barber?
    @NSManaged var tags: [Tag]?
    @NSManaged var user: User?
    @NSManaged var barbershop: Barbershop?
    var photos: [PFFile] = []
    var price: Int?
    
    class func parseClassName() -> String {
        return "Post"
    }
    
    class func postPost(pictures: UIImage, barber: Barber, barbershop: Barbershop, tags: [Tag], price: Int64, caption: String?) {
        let post = PFObject(className: "Post")
        post["barbershop"] = barbershop
        post["barber"] = barber
        
        if !(tags.isEmpty){
            post["tags"] = tags
        }
        post["price"] = price
        
        post["caption"] = caption
        
        if PFUser.current() != nil {
            post["user"] = PFUser.current()
        } else {
            post["user"] = NSNull()
        }
        
        post.saveInBackground()
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("objectId")
        query.getFirstObjectInBackground(block: { (thisPost: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let photo = PFObject(className: "Photo")
                
                photo["image"] = getPFFileFromImage(image: pictures)
                
                photo["post"] = thisPost
                
                photo.saveInBackground()
                
                print("post and photo successfully saved")
            }
        })

        
    }
    
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
}
