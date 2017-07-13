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
    
<<<<<<< HEAD
<<<<<<< HEAD
    class func parseClassName() -> String {
        return "Post"
=======
    class func postPost(pictures: UIImage, barber: String, barbershop: String, tags: [Tag], price: Int) {
        let post = PFObject(className: "Post")
        post["user"] = PFUser.current
        post["photos"] = getPFFileFromImage(image: pictures)
        post["tags"] = tags
        post["price"] = price
        post["user"] = PFUser.current()
        post["barber"] = barber
>>>>>>> 6936e0f0a2fc9ea4454171452e39d7af551ba08d
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
=======
>>>>>>> 59652d84a75bb520cf1f771e7c644b319772de01




