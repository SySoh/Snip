//
//  Tag.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import Foundation
import Parse

class Tag : PFObject, PFSubclassing {
    @NSManaged var name: String?
<<<<<<< HEAD
=======

>>>>>>> 1c5325dd66250dcae8321dced04d4bdea9e7983b
    
    class func parseClassName() -> String {
        return "Tag"
    }
    
    
}
