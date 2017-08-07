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
    
    var images : [UIImage] = [#imageLiteral(resourceName: "cutLoad1"), #imageLiteral(resourceName: "cutLoad2"), #imageLiteral(resourceName: "cutLoad3"), #imageLiteral(resourceName: "cutLoad4")]
    var progressView = UIImageView()
    
    
    init() {
        var frame = CGRect(x:40,y:60,width:200,height:300)
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
