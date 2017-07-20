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

@objc protocol HomeCellDelegate {
    func didMoveToProfile(HomeCell: HomeCell)
}

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
    
    var delegate: HomeCellDelegate?
    
    //cut image
    @IBOutlet weak var cutImageView: PFImageView!
    
    
    
    
    var photo: PFObject! {
        didSet {
            self.cutImageView.file = photo["image"] as? PFFile
        }
    }
    
//    var post: PFObject! {
//        didSet {
////            self.postId = post["postId"] as? String
//            self.user = post["user"] as? User
////            self.barberId = post["barberId"] as? String
//            self.barber = post["barber"] as? Barber
//            self.barbershop = post["barbershop"] as? Barbershop
//            self.photos = post["photos"] as? [PFFile]
//            self.tags = post["tags"] as? [Tag]
//            self.price = post["price"] as? Int
//        }
//    }
//    
//    var barberObject: PFObject! {
//        didSet {
//            self.name = barberObject["name"] as? String
//            self.venmo = barberObject["venmo"] as? String
//            self.profile_pic = barberObject["profile_pic"] as? PFFile
//            self.barbershopId = barberObject["barbershopId"] as? String
//        }
//    }
//    
//    var barbershopObject: Barbershop! {
//        didSet {
//            self.barbershopName = barbershopObject["name"] as? String
//            self.picture = barbershopObject["picture"] as? PFFile
//            self.location = barbershopObject["location"] as? String
////            phone = bar
//        }
//    }
}
