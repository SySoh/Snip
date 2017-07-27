//
//  SearchViewController.swift
//  Snip
//
//  Created by Chase Warren on 7/13/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import PageMenu

class SearchViewController: UIViewController, CAPSPageMenuDelegate {
    
    var pageMenu: CAPSPageMenu?
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        let tagsController: UIViewController = storyboard.instantiateViewController(withIdentifier: "tagSearch")
        tagsController.title = "TAGS"
        controllerArray.append(tagsController)
        
        let barbersController: UIViewController = storyboard.instantiateViewController(withIdentifier: "barberSearch")
        barbersController.title = "BARBERS"
        controllerArray.append(barbersController)
        
        let barbershopsController: UIViewController = storyboard.instantiateViewController(withIdentifier: "barbershopSearch")
        barbershopsController.title = "BARBERSHOPS"
        controllerArray.append(barbershopsController)
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(0.0),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1),
            .scrollAnimationDurationOnMenuItemTap(250)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 64.0, self.view.frame.width, self.view.frame.height - 64.0), pageMenuOptions: parameters)
        
        self.searchBar.delegate = tagsController as? UISearchBarDelegate
        pageMenu?.delegate = self
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        self.searchBar.delegate = controller as? UISearchBarDelegate
        // Update each view controller with previously entered search text
        if controller.title == "TAGS" {
            let tagsController = controller as! TagSearchViewController
            tagsController.didMoveSearch(currentSearchText: self.searchBar.text!)
        } else if controller.title == "BARBERS" {
            let barbersController = controller as! BarberSearchViewController
            barbersController.didMoveSearch(currentSearchText: self.searchBar.text!)
        } else if controller.title == "BARBERSHOPS" {
            let barbershopsController = controller as! BarbershopSearchViewController
            barbershopsController.didMoveSearch(currentSearchText: self.searchBar.text!)
        }
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
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
