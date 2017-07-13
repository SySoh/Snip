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
    
    //cut image
    @IBOutlet weak var cutImageView: PFImageView!
    
    var photo: PFObject! {
        didSet {
            self.cutImageView.file = photo["image"] as? PFFile
        }
    }
}
