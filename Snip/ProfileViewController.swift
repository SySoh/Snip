//
//  ProfileViewController.swift
//  Snip
//
//  Created by Cameryn Boyd on 7/18/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageVIew: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var favShopConstantLabel: UILabel!
    @IBOutlet weak var favBarberConstantLabel: UILabel!
    @IBOutlet weak var favShopLabel: UILabel!
    @IBOutlet weak var favBarberLabel: UILabel!
    @IBOutlet weak var venmoConstantLabel: UILabel!
    @IBOutlet weak var venmoLabel: UILabel!
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
