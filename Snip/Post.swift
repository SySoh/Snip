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

