//
//  HomeCell.swift
//  Snip
//
//  Created by Cameryn Boyd on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeCell: UICollectionViewCell {
    
    //post variables
    var postId: String?
    var user: User?
    var barberId: String?
    var barber: Barber?
    var barbershop: Barbershop?
    var photos: [PFFile]?
    var tags: [Tag]?
    var price: Int?
    
    //barber variables
    var name: String?
    var venmo: String?
    var profile_pic: PFFile?
    var barbershopId: String?
    
    //barbershop variables
    var barbershopName: String?
    var picture: PFFile?
    var location: String?
    var phone: String?
    var rating: Int?
    
    //cut image
    @IBOutlet weak var cutImageView: PFImageView!
    
    var photo: PFObject! {
        didSet {
            self.cutImageView.file = photo["image"] as? PFFile
        }
    }
    
    var post: PFObject! {
        didSet {
            postId = post["postId"] as? String
            user = post["user"] as? User
            barberId = post["barberId"] as? String
            barber = post["barber"] as? Barber
            barbershop = post["barbershop"] as? Barbershop
            photos = post["photos"] as? [PFFile]
            tags = post["tags"] as? [Tag]
            price = post["price"] as? Int
        }
    }
    
    var barberObject: PFObject! {
        didSet {
            name = barberObject["name"] as? String
            venmo = barberObject["venmo"] as? String
            profile_pic = barberObject["profile_pic"] as? PFFile
            barbershopId = barberObject["barbershopId"] as? String
        }
    }
    
    var barbershopObject: PFObject! {
        didSet {
            barbershopName = barbershopObject["barbershopName"] as? String
            picture = barbershopObject["picture"] as? PFFile
            location = barbershopObject["location"] as? String
//            phone = bar
        }
    }
}
