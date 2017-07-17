//
//  TagsViewController.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/12/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse

class TagsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TagCellDelegate {
    var fullTagList: [PFObject] = []
    var selectedTags: [PFObject] = []
    var tagList: [String] = []
    
    @IBOutlet  var collectionView: UICollectionView!
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func addString(tagCell: TagCell) {
        tagList.append((tagCell.tagName.titleLabel?.text)!)
        performSegue(withIdentifier: "composeView", sender: tagCell)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.reloadData()
        collectionView.sizeToFit()
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
            cell.tagName.setTitle(fullTagList[indexPath.item].object(forKey: "name") as? String, for: .normal)
        cell.layer.cornerRadius = 50
        cell.clipsToBounds = true
            if cell.isSelected {
                cell.tagName.backgroundColor = UIColor.blue
            }
        }
        return cell
        
    }
    func collectionView( collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            }
        }
        return true
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ComposeViewController
        let source = sender as! UIButton
        
    }
 

}
