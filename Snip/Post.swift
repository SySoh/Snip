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
    
    class func postPost(pictures: [UIImage], barber: String, barbershop: String, tags: [Tag], price: Int, completion: PFBooleanResultBlock?) {
//        let post = PFObject(className: "Post")
//        post["user"] = PFUser.current
//        for image in pictures {
//        post["photos"][image.row] = getPFFileFromImage(image: image)
//        }
        
    }
}
