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

}


