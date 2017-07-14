//
//  DetailViewController.swift
//  Snip
//
//  Created by Cameryn Boyd on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailViewController: UIViewController {
    
    //variables
    var post: PFObject!
    var caption: String?
    var price: String!
    var date: Date!
    var profileImage: PFFile!
    var barber: String!
    var barbershop: String!
    var photo: PFObject!
    
    // outlets
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var barbershopConstantLabel: UILabel!
    @IBOutlet weak var barberConstantLabel: UILabel!
    @IBOutlet weak var priceConstantLabel: UILabel!
    @IBOutlet weak var barbershopLabel: UILabel!
    @IBOutlet weak var barberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    
    
    @IBAction func pressDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.profileImageView.file = profileImage
        //self.profileImageView.loadInBackground()

        //self.postImageView.file = photo.image
        //self.postImageView.loadInBackground()
        
        //self.profileImageView.file = post["profile_pic"] as! PFFile
        //self.postImageView.file = post["media"] as? PFFile
        //self.postImageView.loadInBackground()
        //self.captionLabel.text = (post["caption"] as! String)
        //self.dateLabel.text = post["_created_at"] as? String
        //self.barberLabel.text = post["barber"] as? String
        //self.barbershopLabel.text = post["barbershop"] as? String
        //self.priceLabel.text = post["price"] as? String
        

        
        self.dateLabel.text = String(describing: date)
        self.barberLabel.text = barber
        self.barbershopLabel.text = barbershop
        self.priceLabel.text = price
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
