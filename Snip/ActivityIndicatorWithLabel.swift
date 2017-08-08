//
//  ActivityIndicatorWithLabel.swift
//  Snip
//
//  Created by Shao Yie Soh on 8/5/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit

protocol ActivityIndicatorWithLabelDataSource {
    func loadingGif()
}

class ActivityIndicatorWithLabel: UIView {
    
    var images : [UIImage] = [#imageLiteral(resourceName: "cutLoad1R"), #imageLiteral(resourceName: "cutLoad2R"), #imageLiteral(resourceName: "cutLoad3R"), #imageLiteral(resourceName: "cutLoad4R")]
    var progressView = UIImageView()
    
    
    init() {
        var frame = CGRect(x:80,y:115,width:70,height:50)
        self.progressView = UIImageView(frame: frame)
        self.progressView.animationImages = images
        self.progressView.animationDuration = 0.5
        self.progressView.isHidden = false
        super.init(frame: frame)
        self.addSubview(self.progressView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        self.progressView.startAnimating()
        self.isHidden = false
        print("animating")
    }
    
    func stopAnimation() {
        self.progressView.stopAnimating()
        print("done animating")
        self.isHidden = true
    }
    

}
