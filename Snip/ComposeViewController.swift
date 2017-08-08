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

class ComposeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, TagsViewDelegate {
    
    var tagList: [Tag] = []
    var tagReuse: [Tag] = []
    var shopList: [Barbershop] = []
    var barberList: [Barber] = []
    var barbershop: Barbershop?
    var barber: Barber?
    var pictures: [UIImage] = []
    
    var useCamera: Bool = true
    
    var user: User?
    
    @IBOutlet weak var pageControl: UIPageControl!
    //all outlets
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    //All button actions
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        chooseCameraOrAlbum()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = PFQuery(className: "User")
        query.includeKey("objectId")
        query.getFirstObjectInBackground { (resultUser, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.user = resultUser as? User
            }
        }
        
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        tagCollectionView.reloadData()
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        self.pageControl.hidesForSinglePage = false
        self.pageControl.numberOfPages = pictures.count
        self.pageControl.currentPage = 0
        self.pageControl.updateCurrentPageDisplay()
        
        self.view.addSubview(tagCollectionView)
        self.view.addSubview(imageCollectionView)
        self.view.sendSubview(toBack: imageCollectionView)
        
        //Grab info for other view controllers
        getTags()
        
        if let layout = self.tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        tagCollectionView.allowsSelection = true
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == imageCollectionView {
            self.pageControl.currentPage = indexPath.item
            self.pageControl.updateCurrentPageDisplay()
        }
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
    
    func chooseCameraOrAlbum() {
        let chooser = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel) {(UIAlertAction) in }
        chooser.addAction(cancelAction)
        let cameraAction = UIAlertAction(title:"Take photo", style: .default, handler: {(action) in
            self.useCamera = true
            self.choosePic()
        })
        chooser.addAction(cameraAction)
        let albumAction = UIAlertAction(title: "Use photo album", style: .default, handler: {(action) in
            self.useCamera = false
            self.choosePicRoll()
        })
        chooser.addAction(albumAction)
        
        self.present(chooser, animated: true)
    }
    
    func choosePic() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        let alertController = UIAlertController(title: "Camera unavailable", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"OK", style: .cancel) {(UIAlertAction) in }
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func choosePicRoll() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        let alertController = UIAlertController(title: "Photo library unavailable", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"OK", style: .cancel) {(UIAlertAction) in }
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
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        pictures.append(editedImage)
        imageCollectionView.reloadData()
        self.pageControl.numberOfPages = pictures.count
        self.pageControl.updateCurrentPageDisplay()
        dismiss(animated: true, completion: nil)
        
    }
    
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
            cell.pictureView.contentMode = .scaleAspectFill
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
        if collectionView == tagCollectionView {
            tagReuse.remove(at: indexPath.item)
            collectionView.reloadData()
        }
    }
    
    //Data querying work
    func getTags() {
        let query = PFQuery(className: "Tag")
        query.order(byAscending: "name")
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Tag segue
        if segue.identifier == "TagSegue" {
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
        } else {
            let destVC = segue.destination as! NextComposeViewController
            destVC.pictures = self.pictures
            destVC.tagReuse = self.tagReuse
        }
    }
    
}
