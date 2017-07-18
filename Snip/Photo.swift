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
    var post: Post?
    var image: PFFile?
    
    class func parseClassName() -> String {
        return "Photo"
    }

}
