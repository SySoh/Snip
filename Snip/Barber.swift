//
//  Barber.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import Foundation
import Parse

class Barber: NSObject {
    var barberId: String?
    var name: String?
    var venmo: String?
    var profile_pic: PFFile?
    var updatedAt: Date? 
    var createdAt: Date?
    
    init(pfObject: PFObject) {
        barberId = pfObject["barberId"] as? String
        name = pfObject["name"] as? String
        venmo = pfObject["venmo"] as? String
        profile_pic = pfObject["profile_pic"] as? PFFile
        updatedAt = pfObject["updatedAt"] as? Date
        createdAt = pfObject["createdAt"] as? Date
    }
    
//    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
//        //create parse object PFObject
//        let post = PFObject(className: "Post")
//        //add relevant fields to the object
//        post["media"] = getPFFileFromImage(image: image) // PFFile column type
//        post["author"] = PFUser.current() // Pointer column type that points to PFUser
//        post["caption"] = caption ?? ""
//        post["likesCount"] = 0
//        post["commentsCount"] = 0
//        //post["profile_pic"] = #imageLiteral(resourceName: "gradient")
        
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
        print("post was saved")
    }

    
}



