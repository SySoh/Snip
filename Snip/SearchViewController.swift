//
//  SearchViewController.swift
//  Snip
//
//  Created by Chase Warren on 7/13/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var data: [[PFObject]] = []
    var filteredData: [[PFObject]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        self.getData()
        
        filteredData = data
        
        // Do any additional setup after loading the view.
    }
    
    func getData() {
        self.data = []
        self.queryParse(className: "Photo", keys: ["image", "post"])
        self.queryParse(className: "Post", keys: ["user", "barber", "price", "tags"])
        self.queryParse(className: "Barber", keys: ["name", "barbershop", "profile_pic"])
        self.queryParse(className: "Barbershop", keys: ["name", "picture", "location"])
    }
    
    func getFilterables(object: PFObject) -> [String] {
        if object.parseClassName == "Post" {
            object["barber"]
            object["price"]
            object["tags"]
        } else if object.parseClassName == "Barber" {
            
        } else if object.parseClassName == "Barbershop" {
            
        }
        print("No filterables found for \(object.parseClassName) object")
    }
    
    func queryParse(className: String, keys: [String]) {
        let query = PFQuery(className: className)
        query.order(byDescending: "createdAt")
        for key in keys {
            query.includeKey(key)
        }
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let objects = objects {
                self.data.append(objects)
            } else {
                print(error?.localizedDescription ?? "Error getting \(className)s")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData[1].count + filteredData[2].count + filteredData[3]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
