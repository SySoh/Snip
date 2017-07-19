//
//  DetailCell.swift
//  Snip
//
//  Created by Cameryn Boyd on 7/17/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    var tagArray: [Tag]!
    var tagNameArray: [String]!
    
    var post: PFObject! {
        didSet{
            print(post["tags"])
            self.tagArray = (post["tags"] as? [Tag])!
            for tag in tagArray {
                self.tagNameArray.append("\(tag.name)")
            }
            print(tagNameArray)
        }
        
    }
    
}
