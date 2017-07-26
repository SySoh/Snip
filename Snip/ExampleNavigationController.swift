//
//  ExampleNavigationController.swift
//  ESTabBarControllerExample
//
//  Created by lihao on 16/5/16.
//  Copyright © 2016年 Egg Swift. All rights reserved.
//

import UIKit

class ExampleNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UIBarButtonItem.appearance()
        appearance.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0.0, vertical: -60), for: .default)
        self.navigationBar.isTranslucent = true
        self.navigationBar.barTintColor = UIColor.init(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 0.8)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.init(red: 38/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0), NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)]
        self.navigationBar.tintColor = UIColor.init(red: 38/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0)
        self.navigationItem.title = "Example"
    }
    
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
