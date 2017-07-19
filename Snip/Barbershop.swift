//
//  Barbershop.swift
//  Snip
//
//  Created by Cameryn Boyd on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import Foundation
import Parse

class Barbershop: PFObject, PFSubclassing {
    @NSManaged var name: String?
    @NSManaged var picture: PFFile?
    @NSManaged var location: String?
    @NSManaged var hours: String?
    @NSManaged var phone: String?
    var rating: Int?
    //var updatedAt: Date?
    
    class func parseClassName() -> String {
        return "Barbershop"
    }
}
