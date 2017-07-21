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
    var profile_pic: UIImage?
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

    var detailView: DetailViewController!
    //homeCell:

    var tagArray: [Tag]? = []
    var tagNameArray: [String]! = []


    
    @IBAction func pressDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "barberProfileSegue" {
            let vc = segue.destination as! ProfileViewController
            vc.barberName = self.barberLabel.text
            vc.barbershopName = self.barbershopLabel.text
            vc.venmo = self.venmo
            print("venmo")
            print(self.venmo)
            vc.barber = self.barber
            print("profile pic")
            print("here is the profile pic^")
            //vc.photoArray = self.photoArray
            //print(self.photoArray)
            //vc.tagNameArray = self.tagNameArray
            
            
            
        }
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
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        self.postImageView.image = self.postImage
        //self.postImageView.loadInBackground()
        self.post = photo!["post"] as! Post
        print("post")
        print(post)
        self.barber = self.post?["barber"] as! Barber
        print("barber")
        print(barber)
        self.tagArray = post?["tags"] as! [Tag]
        print("tagarray")
        print(tagArray)
//        let tag = tagArray[0] as! Tag
//        print(tagArray)
        for tag in tagArray! {
            self.tagNameArray.append(tag.name!)
            print(tagNameArray)
        }

        self.barbershop = self.barber?["barbershop"] as! Barbershop
        

        print(self.barbershop)
        print(post?["price"])
        
        self.dateLabel.text = "\(self.post?.createdAt!)"
        self.barberLabel.text = self.barber?["name"] as! String
        self.barbershopLabel.text = self.barbershop?["name"] as? String
        self.priceLabel.text = "$" + "\(self.post?["price"]!)"
        self.venmo = self.barber?["venmo"] as? String
        print(self.barber?["profile_pic"])
        print("above is the image")
        self.profileImageView.file = barber?["profile_pic"] as! PFFile
        self.profileImageView.loadInBackground()
        print(self.barber?["profile_pic"])
        print("here is the image^")
        if post?["caption"] != nil {
        self.captionLabel?.text = post?["caption"] as! String
        } else{
            self.captionLabel?.text = ""
        }
        
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
