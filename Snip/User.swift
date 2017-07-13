//
//  User.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import Foundation
import Parse

class User: PFObject, PFSubclassing {
    var userId: String?
    var username: String?
    var password: String?
    var email: String?
    var profile_pic: PFFile?
    //var createdAt: Date?
    //var updatedAt: Date?
    
    class func parseClassName() -> String {
        return "User"
    }
    
}
