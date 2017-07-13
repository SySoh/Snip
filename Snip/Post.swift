//
//  Post.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import Foundation
import Parse

class Post {
    var postId: String?
    var user: User?
    var barber: Barber?
    var photos: [PFFile]?
    var tags: [Tag]?
    var updatedAt: Date?
    var createdAt: Date?
    var price: Int?
    
    class func postPost(pictures: UIImage, barber: String, barbershop: String, tags: [Tag], price: Int) {
        let post = PFObject(className: "Post")
        post["user"] = PFUser.current
       post["photos"] = getPFFileFromImage(image: pictures)
        post["tags"] = tags
        post["price"] = price
        post["user"] = PFUser.current()
        post["barber"] = barber
        
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

