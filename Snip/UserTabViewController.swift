//
//  UserTabViewController.swift
//  Snip
//
//  Created by Chase Warren on 7/28/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import PageMenu

class UserTabViewController: UIViewController, CAPSPageMenuDelegate {
    
    var pageMenu: CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        let userSnipsController: UIViewController = storyboard.instantiateViewController(withIdentifier: "UserSnips")
        userSnipsController.title = "SNIPS"
        controllerArray.append(userSnipsController)
        
        let favoritesController: UIViewController = storyboard.instantiateViewController(withIdentifier: "UserFavorites")
        favoritesController.title = "FAVORITES"
        controllerArray.append(favoritesController)
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(0.0),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1),
            .scrollAnimationDurationOnMenuItemTap(250),
            .scrollMenuBackgroundColor(UIColor(hex: "1D4159"))
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 85.0, self.view.frame.width, self.view.frame.height - 85.0), pageMenuOptions: parameters)
        
        pageMenu?.delegate = self
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.navigationController?.isNavigationBarHidden)! {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
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
