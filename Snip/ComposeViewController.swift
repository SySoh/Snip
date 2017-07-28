//
//  ComposeViewController.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import CoreLocation
import SwiftHEXColors

class ComposeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, TagsViewDelegate, BarberShopPickDelegate, BarberPickDelegate, UITextViewDelegate {
    
    //tagList is used to obtain ALL tags and pass them into the tagView
    var tagList: [Tag] = []
    //tagReuse is used to accumulate selected tags. It will be populated by tagView. Probably by a prepareForSegue.
    var tagReuse: [Tag] = []
    //shopList is the list of all barber shops in the system, passed to the BarberShopPicker view.
    var shopList: [Barbershop] = []
    //The barberlist to pass to the BarberPicker view
    var barberList: [Barber] = []
    //The barbershop object to be passed into the post function
    var barbershop: Barbershop?
    //The barber object to be passed into the post function
    var barber: Barber?
    // Image array
    var pictures: [UIImage] = []
    
    //all outlets
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var shopChoosingButton: UIButton!
    @IBOutlet weak var barberChoosingButton: UIButton!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var pickBarberButton: UIButton!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    
    //All button actions

    
    @IBAction func goBack(_ sender: Any) {
        print("cancel")
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addPhoto(_ sender: Any) {
        choosePic()
    }
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func makePost(_ sender: Any) {
        let alertController = UIAlertController(title: "One or more fields were left empty", message: "Please fill out all fields", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"Okay", style: .cancel) {(UIAlertAction) in }
        alertController.addAction(cancelAction)
        
        if ((barbershop == nil) || (barber == nil) || (priceText.text?.isEmpty)! || tagReuse.isEmpty || pictureView.image == nil){
            present(alertController, animated: true)
        } else {
            let image = pictureView.image!
            
            //redo post function
            Post.postPost(pictures: pictures, barber: self.barber!, tags: tagReuse, price: Int64(priceText.text!)!, caption: captionTextView.text)
            dismiss(animated: true, completion: nil)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        tagCollectionView.reloadData()
        
        captionTextView.delegate = self
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        
        
        self.view.addSubview(tagCollectionView)
        self.view.addSubview(imageCollectionView)
        
        //Grab info for other view controllers
        getTags()
        barberShopQuery()
        barberQuery()
        if barbershop == nil {
            pickBarberButton.isEnabled = false
            pickBarberButton.backgroundColor = UIColor.lightGray
        }
        
        
        //Aesthetics
        captionTextView.text = "Have anything to say about this haircut?"
        captionTextView.textColor = UIColor.lightGray
        tagCollectionView.layer.borderColor = UIColor(hexString: "#FFFCF2")?.cgColor
        tagCollectionView.layer.borderWidth = 1.0
        tagCollectionView.layer.cornerRadius = 10
        captionTextView.layer.cornerRadius = 10
        captionTextView.layer.borderColor = UIColor(hexString: "#FFFCF2")?.cgColor
        captionTextView.layer.borderWidth = 0.5
        tagCollectionView.allowsSelection = true
        shopChoosingButton.layer.cornerRadius = 10
        barberChoosingButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //All delegate functions here
    func didChooseTags(tags: Set<Tag>) {
        tagReuse = Array(tags)
        tagCollectionView.reloadData()
    }
    
    func didChooseBarberShop(barberShopName: Barbershop) {
        shopChoosingButton.setTitle(barberShopName.name, for: .normal)
        self.barbershop = barberShopName
        pickBarberButton.isEnabled = true
        pickBarberButton.backgroundColor = UIColor(hex:0x5983C4)
    }
    
    func didChooseBarber(barberName: Barber) {
        barberChoosingButton.setTitle(barberName.name, for: .normal)
        self.barber = barberName
    }
    
    
    //End delegate functions
    
    
    
    //Image work functions
    
    func choosePic() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        let alertController = UIAlertController(title: "Camera unavailable", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"Okay", style: .cancel) {(UIAlertAction) in }
        alertController.addAction(cancelAction)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            vc.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: {if vc.sourceType == .photoLibrary {
            vc.present(alertController, animated: true)
            }})
        
        
    }
    
    func choosePicRoll() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        let alertController = UIAlertController(title: "Photo library unavailable", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"Okay", style: .cancel) {(UIAlertAction) in }
        alertController.addAction(cancelAction)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        } else {
            
            
            vc.sourceType = .camera
        }
        
        self.present(vc, animated: true, completion: {if vc.sourceType == .camera {
            vc.present(alertController, animated: true)
            }})
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        pictureView.image = editedImage
        pictures.append(editedImage)
        
        imageCollectionView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    
    //End imagework functions
    
    
    
    
    //Start tagView setup
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.tagCollectionView {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
            cell.tagName.text = (tagReuse[indexPath.item].name)
            cell.layer.cornerRadius = 15
            return cell
            
        } else {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.pictureView.image = pictures[indexPath.item]
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.tagCollectionView {
        return tagReuse.count
        } else {
        return pictures.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                tagReuse.remove(at: indexPath.item)
                collectionView.reloadData()
    }


    //Data querying work
    func getTags() {
        let query = PFQuery(className: "Tag")
        query.addDescendingOrder("createdAt")
        query.includeKey("objectId")
        query.findObjectsInBackground { (tags: [PFObject]?, error: Error?) in
            if let error = error {
                print (error.localizedDescription)
            } else {
                if let tags = tags {
                    self.tagList = tags as! [Tag]
                } else {
                    print ("No tags retrieved")
                }
            }
        }
        self.tagCollectionView.reloadData()
    }
    
    func barberShopQuery(){
        let query = PFQuery(className:"Barbershop")
        query.includeKey("objectId")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (
            shops: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.shopList = shops as! [Barbershop]
            }
        }
        
    }
    
    func barberQuery(){
        let query = PFQuery(className:"Barber")
        query.includeKey("objectId")
        query.addDescendingOrder("createdAt")
        query.includeKey("barber.barbershop")
        query.findObjectsInBackground { ( barbers: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.barberList = barbers as! [Barber]
            }
    }
    }
    
    
    //Cancel placeholder text for caption
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            captionTextView.text = ""
            captionTextView.textColor = UIColor.black
        }
    }
 
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "Have anything to say about this haircut?"
                textView.textColor = UIColor.lightGray
            }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Tag segue work
        if segue.identifier == "TagSegue"{
            let destVC = segue.destination as! TagsViewController
            destVC.delegate = self
        for tag in self.tagList {
            if (tag["name"] != nil) {
                destVC.fullTagList.append(tag)
            }
        }
        if !(tagReuse.isEmpty){
            destVC.selectedTags = Set(tagReuse)
        }
            
            //Barbershop segue work
        } else if (segue.identifier == "BarberShopSegue") {
            let destVC = segue.destination as! BarberShopPickViewController
            destVC.delegate = self
            destVC.barberShopList = self.shopList
        } else if (segue.identifier == "BarberPick") {
            let destVC = segue.destination as! BarberPickViewController
            destVC.delegate = self
            for barber in self.barberList {
                if barbershop?.objectId == barber.barbershop?.objectId {
                destVC.barberList.append(barber)
            }
        }
        }
        
            //Barber segue work
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
