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
    
    class func postPost(pictures: [UIImage], barber: Barber, tags: [Tag], price: Int64, caption: String?) {
        var IDforPhoto: String?
        let post = PFObject(className: "Post")
        post["barber"] = barber
        
        if !(tags.isEmpty){
            post["tags"] = tags
        }
        post["price"] = price
        
        if caption == nil {
            post["caption"] = ""
        } else {
            post["caption"] = caption
        }
        
        if PFUser.current() != nil {
            post["user"] = PFUser.current()
        } else {
            post["user"] = NSNull()
        }
        post.saveInBackground { (success, error) in
            if success {
                print("post was posted, now posting pictures")
                IDforPhoto = post.objectId
                postPhoto(pictures: pictures, ID: IDforPhoto)
            } else if let error = error {
                print("problem posting : \(error.localizedDescription)")
            }
        }
        
        
    }
    

    
    class func postPhoto(pictures: [UIImage], ID: String?) {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("objectId")
        query.whereKey("objectId", equalTo: ID ?? "")
        query.getObjectInBackground(withId: ID!, block: { (thisPost: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                for i in 0 ..< pictures.count {
                    let photo = PFObject(className: "Photo")
                    //change this after
                    photo["image"] = getPFFileFromImage(image: pictures[i])
                    
                    if i == 0 {
                        photo["first"] = true
                    } else {
                        photo["first"] = false
                    }
                    
                    photo["post"] = thisPost
                    
                    photo.saveInBackground()
                    
                    print("post and photo successfully saved")
                }
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
