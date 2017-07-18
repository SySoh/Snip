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
    @NSManaged var user: User?
    @NSManaged var barber: Barber?
    @NSManaged var barbershop: Barbershop?
    var photos: [PFFile]?
    var tags: [Tag]?
    var price: Int?
    
    class func parseClassName() -> String {
        return "Post"
    }
    
    class func postPost(pictures: UIImage, barber: String, barbershop: String, tags: [Tag], price: Int) {
        let post = PFObject(className: "Post")
        if !(tags.isEmpty){
            post["tags"] = tags
        }
        post["price"] = price
        
        if PFUser.current() != nil {
            post["user"] = PFUser.current()
        } else {
            post["user"] = NSNull()
        }
        
        post["barber"] = barber
        
        let photo = PFObject(className: "Photo")
        
        photo["image"] = getPFFileFromImage(image: pictures)
        
        photo["post"] = post.objectId
        
        photo.saveInBackground()
        post.saveInBackground()
        
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
