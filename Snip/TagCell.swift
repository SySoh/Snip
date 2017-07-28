//
//  TagCell.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit

@objc protocol TagCellDelegate {
    func addString(tagCell: TagCell)
}

class TagCell: UICollectionViewCell {
  
    var tagObject: Tag?
    var delegate: TagCellDelegate?
    @IBOutlet weak var tagName: UILabel!
    @IBOutlet weak var profileTagLabel: UILabel!
    
    func returnTag() -> String? {
        return tagName.text;
    }
                
}
