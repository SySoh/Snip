//
//  Photo.swift
//  Snip
//
//  Created by Chase Warren on 7/13/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import Foundation
import Parse

class Photo: PFObject, PFSubclassing {
<<<<<<< HEAD
    @NSManaged var post: Post?
    @NSManaged var image: PFFile?
=======
    var post: Post?
    var image: PFFile?
>>>>>>> 1c5325dd66250dcae8321dced04d4bdea9e7983b
    
    class func parseClassName() -> String {
        return "Photo"
    }

}
