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
    public var tagId: String?
    public var name: String?
    
    class func parseClassName() -> String {
        return "Tag"
    }
    
    
}
