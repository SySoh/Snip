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

class ComposeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, TagsViewDelegate, BarberShopPickDelegate, BarberPickDelegate {
    

    
    
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
    
    
    //all outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var shopChoosingButton: UIButton!
    @IBOutlet weak var shopNameText: UILabel!
    @IBOutlet weak var barberChoosingButton: UIButton!
    @IBOutlet weak var barberNameText: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var pickBarberButton: UIButton!
    
    //All button actions
    @IBAction func locationToggle(_ sender: Any) {
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addPhoto(_ sender: Any) {
        choosePic()
    }
    
    @IBAction func makePost(_ sender: Any) {
        let alertController = UIAlertController(title: "One or more fields were left empty", message: "Please fill out all fields", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"Okay", style: .cancel) {(UIAlertAction) in }
        alertController.addAction(cancelAction)
        
        if ((barbershop == nil) || (barber == nil) || (priceText.text?.isEmpty)! || tagReuse.isEmpty || pictureView.image == nil){
            present(alertController, animated: true)
            print("pop up notif here")
        } else {
            let image = pictureView.image!
            
            //redo post function
            Post.postPost(pictures: image, barber: self.barber!, barbershop: self.barbershop!, tags: tagReuse, price: Int64(priceText.text!)!, caption: captionTextView.text)
            dismiss(animated: true, completion: nil)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.reloadData()
        //Grab info for other view controllers
        getTags()
        barberShopQuery()
        barberQuery()
        if barbershop == nil {
            pickBarberButton.isEnabled = false
            pickBarberButton.titleLabel?.textColor = UIColor.gray
        }
        collectionView.layer.borderColor = UIColor.black.cgColor
        collectionView.layer.borderWidth = 1.0
        captionTextView.layer.borderColor = UIColor.black.cgColor
        captionTextView.layer.borderWidth = 0.5
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //All delegate functions here
    func didChooseTags(tags: Set<Tag>) {
        tagReuse = Array(tags)
        collectionView.reloadData()
    }
    
    func didChooseBarberShop(barberShopName: Barbershop) {
        shopNameText.text = barberShopName.name
        self.barbershop = barberShopName
        pickBarberButton.isEnabled = true
        pickBarberButton.titleLabel?.textColor = UIColor.blue
    }
    
    func didChooseBarber(barberName: Barber) {
        barberNameText.text = barberName.name
        self.barber = barberName
    }
    
    
    //End delegate functions
    
    
    
    //Image work functions
    
    func choosePic() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("Camera Available")
            vc.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            print("Camera not available, so photo lib instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        pictureView.image = editedImage
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //End imagework functions
    
    
    
    
    //Start tagView setup
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
            cell.tagName.text = (tagReuse[indexPath.item].name)
        print(tagReuse[indexPath.item].name)

            return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagReuse.count
    }
    
    //End tagView setup
    

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
        self.collectionView.reloadData()
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
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            print("sending")
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
