//
//  ProfilePostCell.swift
//  Snip
//
//  Created by Cameryn Boyd on 7/18/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class ProfilePostCell: UICollectionViewCell {
    
    @IBOutlet weak var barberCutImageView: PFImageView!
    
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
    //@IBOutlet weak var cutImageView: PFImageView!
    
    var photo: PFObject! {
        didSet {
            self.barberCutImageView.file = photo["image"] as? PFFile
        }
    }
}
