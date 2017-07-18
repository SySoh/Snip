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
    var fullTagList: [PFObject] = []
    var selectedTags = Set<Tag>()
    var tagList: [String] = []
    

    @IBOutlet  var collectionView: UICollectionView!
    
    var delegate: TagsViewDelegate?
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didFinish(_ sender: Any) {
        print(delegate)
        delegate?.didChooseTags(tags: selectedTags)
        dismiss(animated: true, completion: nil)
    }

    
    func addString(string: String) {
        tagList.append(string)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.sizeToFit()
        
//        collectionView.allowsMultipleSelection = true
//        collectionView.allowsSelection = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.dataSource = self
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        if fullTagList.count > 0 {
            cell.tagName.text = fullTagList[indexPath.item].object(forKey: "name") as! String
        cell.layer.cornerRadius = 50
        cell.clipsToBounds = true
            if cell.isSelected {
                cell.tagName.backgroundColor = UIColor.cyan
            }
        }
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selectin")
         let cell = collectionView.cellForItem(at: indexPath) as! TagCell
        cell.tagName.backgroundColor = UIColor.blue
        for tag in fullTagList {
            if tag["name"] as? String == cell.returnTag() {
                print(tag["name"])
                let newTag = Tag()
                newTag.name = tag["name"] as? String
                newTag.tagId = tag.objectId as! String
                selectedTags.insert(newTag)
                print("added!")
            }
        }
        
        
    }
    

//    func collectionView( _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        print("selecting")
//        if let selectedItems = collectionView.indexPathsForSelectedItems {
//            if selectedItems.contains(indexPath) {
//                collectionView.deselectItem(at: indexPath, animated: true)
//                return false
//            }
//        }
//        return true
//    }

    
   
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fullTagList.count
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destVC = segue.destination as! ComposeViewController
//        let source = sender as! UIButton
//        
//    }

 

}
