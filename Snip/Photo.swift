//
//  Photo.swift
//  Snip
//
//  Created by Chase Warren on 7/21/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse

class Photo: PFObject, PFSubclassing {
    @NSManaged var post: Post?
    @NSManaged var image: PFFile?
   

    
    class func parseClassName() -> String {
        return "Photo"
    }
    
}
