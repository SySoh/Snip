//
//  TagsViewController.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse

@objc protocol TagsViewDelegate {
    func didChooseTags(tags: Set<Tag>)
}

class TagsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Variables
    
    var fullTagList: [Tag] = []
    var selectedTags = Set<Tag>()
    var tagList: [String] = []
    var delegate: TagsViewDelegate?
    
    
    
    //Outlets and actions
    
    @IBOutlet  var collectionView: UICollectionView!
    
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didFinish(_ sender: Any) {
        delegate?.didChooseTags(tags: selectedTags)
        dismiss(animated: true, completion: nil)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.dataSource = self
        collectionView.reloadData()
    }

    
//Collectionview setup
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        if fullTagList.count > 0 {
            cell.tagName.text = fullTagList[indexPath.item].object(forKey: "name") as! String
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        cell.backgroundColor = UIColor(hex:"FFFFFF")
        cell.tagObject = fullTagList[indexPath.item]
            if selectedTags.contains(cell.tagObject!) {
                cell.backgroundColor = UIColor(hex:"F5EDDA")
            }
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fullTagList.count
    }
//End collectionview setup
    
    
//Selection work
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let cell = collectionView.cellForItem(at: indexPath) as! TagCell
        let tag = cell.tagObject
        if selectedTags.contains(tag!){
            selectedTags.remove(tag!)
            cell.backgroundColor = UIColor(hex:"FFFFFF")
            cell.tagName.textColor = UIColor.black
        } else {
        selectedTags.insert(tag!)
            cell.backgroundColor = UIColor(hex:"F5EDDA")
        }
        
    }
   
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        
    }
    
    


 

}
