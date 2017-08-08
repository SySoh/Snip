//
//  LaunchScreencontrollerViewController.swift
//  Snip
//
//  Created by Shao Yie Soh on 8/7/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit

class LaunchScreencontrollerViewController: UIViewController {

    var loader = ActivityIndicatorWithLabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(loader)
        loader.startAnimation()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
