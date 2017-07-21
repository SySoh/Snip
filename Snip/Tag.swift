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
<<<<<<< HEAD
    @NSManaged var name: String?
=======
    @NSManaged var name: String!
>>>>>>> 6bfaf429f089527cbd13fb19f5856a7ea6bef0e7
    
    class func parseClassName() -> String {
        return "Tag"
    }
    
    
}
