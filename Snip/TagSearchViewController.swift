//
//  TagSearchViewController.swift
//  Snip
//
//  Created by Chase Warren on 7/20/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class TagSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tags: [PFObject] = []
    var filteredTags: [PFObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getTags()
        self.filteredTags = self.tags
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func getTags() {
        let query = PFQuery(className: "Tag")
        query.order(byDescending: "createdAt")
        query.includeKey("name")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let objects = objects {
                self.tags = objects
                self.filteredTags = objects
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "Error fetching tags")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TagSearchSegue" {
            let vc = segue.destination as! TSRViewController
            let cell = sender as! TagSearchCell
            vc.tag = cell.cellTag
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tag Search Cell", for: indexPath) as! TagSearchCell
        let tag = self.filteredTags[indexPath.row]
        cell.cellTag = tag as! Tag
        let tagName = tag["name"] as! String
        cell.tagLabel.text = tagName
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTags = searchText.isEmpty ? tags : tags.filter { (tag: PFObject) -> Bool in
            let name = tag["name"] as! String
            return name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    func didMoveSearch(currentSearchText: String) {
        filteredTags = currentSearchText.isEmpty ? tags : tags.filter { (tag: PFObject) -> Bool in
            let name = tag["name"] as! String
            return name.range(of: currentSearchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
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
