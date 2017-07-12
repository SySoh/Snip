//
//  ComposeViewController.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse

class ComposeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource  {
    
    var tagList: [Tag] = []
    
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBAction func locationToggle(_ sender: Any) {
    }

    @IBOutlet weak var shopNameText: UITextField!
    @IBOutlet weak var barberNameText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBAction func addPhoto(_ sender: Any) {
        choosePic()
    }
    
    @IBAction func makePost(_ sender: Any) {
        Post.postPost(pictures: pictureView.image!, barber: barberNameText.text!, barbershop: shopNameText.text!, tags: tagList, price: priceText.text as! Int)
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
            cell.tagName.text = "Hello"
            //Once we have more tags, I'm going to have it fill in with all possible tags.
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
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
