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
        print(delegate)
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
        cell.layer.cornerRadius = 50
        cell.clipsToBounds = true
            if cell.isSelected {
                cell.tagName.backgroundColor = UIColor.cyan
            }
            cell.tagObject = fullTagList[indexPath.item]
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fullTagList.count
    }
//End collectionview setup
    
    
//Selection work
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selectin")
         let cell = collectionView.cellForItem(at: indexPath) as! TagCell
        let tag = cell.tagObject
        if selectedTags.contains(tag!){
            selectedTags.remove(tag!)
            cell.tagName.backgroundColor = UIColor.white
            cell.tagName.textColor = UIColor.black
        } else {
        selectedTags.insert(tag!)
        cell.tagName.backgroundColor = UIColor.blue
        cell.tagName.textColor = UIColor.white
        }
        
    }
   
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        
    }
    
    


 

}
