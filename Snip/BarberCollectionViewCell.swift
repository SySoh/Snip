//
//  BarberCollectionViewCell.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/26/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class BarberCollectionViewCell: UICollectionViewCell {
    var barber: Barber?
    @IBOutlet weak var barberPic: PFImageView!
}
