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

//    @IBAction func didTap(_ sender: Any) {
//        delegate!.addString(tagCell: self)
//       tagName.backgroundColor = UIColor.green
//    }
//    
    var tagObject: Tag?
    var delegate: TagCellDelegate?
    @IBOutlet weak var tagName: UILabel!
    
    func returnTag() -> String? {
        return tagName.text;
    }
                
    
}
