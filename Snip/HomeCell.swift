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
    
    @IBOutlet weak var profileCutImageView: PFImageView!
    
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
    @IBOutlet weak var TSRCutImageView: UIImageView!
    
    
    
    
    var photo: PFObject! {
        didSet {
            self.cutImageView.file = photo["image"] as? PFFile
        }
    }
}
