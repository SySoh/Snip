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
    @NSManaged var image: PFFile?
    @NSManaged var post: Post?
    
    class func parseClassName() -> String {
        return "Photo"
    }

}
