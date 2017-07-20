//
//  ProfileViewController.swift
//  Snip
//
//  Created by Cameryn Boyd on 7/18/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageVIew: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var shopConstantLabel: UILabel!
    @IBOutlet weak var favBarberConstantLabel: UILabel!
    @IBOutlet weak var barbershopLabel: UILabel!
    @IBOutlet weak var favBarberLabel: UILabel!
    @IBOutlet weak var venmoConstantLabel: UILabel!
    @IBOutlet weak var venmoLabel: UILabel!
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    var photoArray: [PFObject]!
    var photo: PFObject!
    var barberName: String!
    var barbershopName: String!
    var venmo: String!
    var profileImage: UIImage!
    var tagNameArray: [String]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImageVIew.image = profileImage
        //self.profileImageVIew.loadInBackground()
        self.barbershopLabel.text = barbershopName
        self.venmoLabel.text = venmo
        self.usernameLabel.text = barberName

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
