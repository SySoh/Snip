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
    var postId: String?
    var user: User?
    var barber: Barber?
    var photos: [PFFile]?
    var tags: [Tag]?
//    var updatedAt: Date?
//    var createdAt: Date?
    var price: Int?
    
    class func parseClassName() -> String {
        return "Post"
    }
    
    class func postPost(pictures: UIImage, barber: String, barbershop: String, tags: [Tag], price: Int) {
        let post = PFObject(className: "Post")
        post["user"] = PFUser.current
        post["tags"] = tags
        post["price"] = price
        post["user"] = PFUser.current()
        post["barber"] = barber
<<<<<<< HEAD
        
        post.saveInBackground()
        
=======
>>>>>>> 92cdc9ec26cec6b2127a624ac1b46b1028cb28ec
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
