//
//  ComposeViewController.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse

class ComposeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, TagsViewDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    //tagList is used to obtain ALL tags and pass them into the tagView
    var tagList: [PFObject] = []
    //tagReuse is used to accumulate selected tags. It will be populated by tagView. Probably by a prepareForSegue.
    var tagReuse: [Tag] = []
    
    var shopList: [PFObject] = []
    
        
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var shopChoosingButton: UIButton!
    @IBOutlet weak var shopNameText: UILabel!
    @IBOutlet weak var barberChoosingButton: UIButton!
    @IBOutlet weak var barberNameText: UILabel!
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBAction func locationToggle(_ sender: Any) {
    }


    @IBOutlet weak var priceText: UITextField!
    @IBAction func addPhoto(_ sender: Any) {
        choosePic()
    }
    
    func didChooseTags(tags: Set<Tag>) {
        tagReuse = Array(tags)
    }
    
    @IBAction func makePost(_ sender: Any) {
        let alertController = UIAlertController(title: "One or more fields were left empty", message: "Please fill out all fields", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"Okay", style: .cancel) {(UIAlertAction) in }
        alertController.addAction(cancelAction)
        
        if ((shopNameText.text?.isEmpty)! || (barberNameText.text?.isEmpty)! || (priceText.text?.isEmpty)! || tagReuse.isEmpty || pictureView.image == nil){
            present(alertController, animated: true)
            print("pop up notif here")
        } else {
        let image = pictureView.image!
        Post.postPost(pictures: image, barber: barberNameText.text!, barbershop: shopNameText.text!, tags: tagReuse, price: 10)
        }
    }
    
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
    
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
//        if !(tagReuse.isEmpty) {
            cell.tagName.text = (tagReuse[indexPath.item].name)
        print(tagReuse[indexPath.item].name)
        print(tagReuse[indexPath.item].tagId ?? 0)
//        } else {
//            cell.tagName.text = "No name"
//        }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagReuse.count
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("Console working")
        getTags()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.reloadData()
        //Grab info for other view controllers
        getTags()
        barberShopQuery()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getTags() {
        let query = PFQuery(className: "Tag")
        query.addDescendingOrder("createdAt")
        query.includeKey("objectId")
        query.findObjectsInBackground { (tags: [PFObject]?, error: Error?) in
            if let error = error {
                print (error.localizedDescription)
            } else {
                if let tags = tags {
                    self.tagList = tags
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
                self.shopList = shops!
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
            //Add delegate line here
            destVC.barberShopList = self.shopList
        
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
