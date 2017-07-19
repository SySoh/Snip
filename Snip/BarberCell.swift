//
//  BarberCell.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/19/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class BarberCell: UITableViewCell {

    @IBOutlet weak var barbershopLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var profilePic: PFImageView!
    var barber: Barber?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
