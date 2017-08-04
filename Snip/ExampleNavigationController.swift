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
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor(hex: "1D4159")
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(hex: "FFFFFF"), NSFontAttributeName: UIFont.init(name: "Blessed Day", size: 42.0)!]
        self.navigationBar.setTitleVerticalPositionAdjustment(CGFloat(10.0), for: .default)
        self.navigationBar.tintColor = UIColor(hex: "FFFFFF")
        self.navigationItem.title = "Example"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
