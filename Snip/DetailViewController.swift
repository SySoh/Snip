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

class DetailViewController: UIViewController,  HomeCellDelegate {
    
    var photo: PFObject?
    var post: Post?
    var price: Int?
    var tags: [Tag]?
    var user: User?
    var barber: Barber?

    var barberName: String!
    var venmo: String?
    var profile_pic: PFFile?
    var barbershop: Barbershop?
    var shopName: String?
    var shopPic: PFFile?
    var location: String?
    var phone: String?
    var rating: Int?
    var date: Date?

    
    var postImage: UIImage!
    
    var homeViewController: HomeViewController?
    
    // outlets
    @IBOutlet weak var profileImageView: PFImageView!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var barbershopConstantLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel?
    @IBOutlet weak var barbershopLabel: UILabel!
    @IBOutlet weak var barberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    var photoArray: [PFObject]? = []
    //homeCell:

    
    @IBAction func pressDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didPressBarberProfile(_ sender: Any) {
        performSegue(withIdentifier: "barberProfileSegue", sender: DetailViewController.self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "barberProfileSegue" {
//            let vc = segue.destination as! ProfileViewController
//            let cell = sender as! HomeCell
//            let photo = photoArray
//            vc.photo = photo
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.postImageView.image = self.postImage
        //self.postImageView.loadInBackground()
        let post = photo!["post"] as! Post
        let barber = post["barber"] as! Barber
        let barbershop = barber["barbershop"] as! Barbershop
        
        print(barbershop)
        
        self.dateLabel.text = "\(post.createdAt!)"
        self.barberLabel.text = barber["name"] as! String
        self.barbershopLabel.text = barbershop["name"] as? String
        self.priceLabel.text = "$" + "\(post["price"]!)"
        if post["caption"] != nil {
        self.captionLabel?.text = post["caption"] as! String
        } else{
            self.captionLabel?.text = ""
        }
        
    }
    
    func didMoveToProfile(HomeCell: HomeCell) {
        performSegue(withIdentifier: "barberProfileSegue", sender: HomeCell)
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
