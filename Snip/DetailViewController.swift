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

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var photo: PFObject?
    var post: Post?
    var price: Int?
    var tagsArray: [String]?
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
    @IBOutlet weak var barberConstantLabel: UILabel!
    @IBOutlet weak var priceConstantLabel: UILabel!
    @IBOutlet weak var barbershopLabel: UILabel!
    @IBOutlet weak var barberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    var photoArray: [PFObject]? = []
    var tagArray: [Tag]? = []
    var tagNameArray: [String]! = []

    
    @IBAction func pressDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        self.postImageView.image = self.postImage
        //self.postImageView.loadInBackground()
        let post = photo!["post"] as! Post
        let barber = post["barber"] as! Barber
        print(barber)
        let tagArray = post["tags"] as! [Tag]
        let tag = tagArray[0] as! Tag
        print(tagArray)
        for tag in tagArray {
            self.tagNameArray.append(tag.name!)
            print(tagNameArray)
        }
        self.barbershop = barber["barbershop"] as! Barbershop
        
        
        
        print(post["price"])
        
        self.dateLabel.text = "\(post.createdAt!)"
        self.barberLabel.text = barber["name"] as! String
        self.barbershopLabel.text = barbershop?["name"] as? String
        self.priceLabel.text = "\(post["price"]!)"
        
        }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(tagsArray)
        //return tagsArray!.count
        return tagNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! DetailCell
        let tag = self.tagsArray?[indexPath.item]
        cell.tagLabel.text = tagNameArray[indexPath.item]
        print(tag)
        return cell
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShopView" {
            let destVC = segue.destination as! BarberShopViewController
            destVC.barberShop = self.barbershop
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
