//
//  Barber.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import Foundation
import Parse

class Barber: PFObject, PFSubclassing {
    var barberId: String?
    var name: String?
    var venmo: String?
    var profile_pic: PFFile?
    
    class func parseClassName() -> String {
        return "Barber"
    }
<<<<<<< HEAD
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
<<<<<<< HEAD




}
=======
>>>>>>> 6936e0f0a2fc9ea4454171452e39d7af551ba08d
=======
}
>>>>>>> 59652d84a75bb520cf1f771e7c644b319772de01
