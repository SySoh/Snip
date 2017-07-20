//
//  BarberSearchViewController.swift
//  Snip
//
//  Created by Chase Warren on 7/20/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class BarberSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var barbers: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getTags()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func getTags() {
        let query = PFQuery(className: "Barber")
        query.order(byDescending: "createdAt")
        query.includeKey("name")
        query.includeKey("profile_pic")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let objects = objects {
                self.barbers = objects
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "Error fetching tags")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Barber Search Cell", for: indexPath) as! BarberSearchCell
        let barber = self.barbers[indexPath.row]
        
        // Set Barber Name
        let barberName = barber["name"] as! String
        cell.nameLabel.text = barberName
        
        // Set Barber Profile Picture
        let profile_pic = barber["profile_pic"] as? PFFile
        profile_pic?.getDataInBackground { (backgroundData: Data?, erro: Error?) in
            if let backgroundData = backgroundData {
                cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2
                cell.profileImage.contentMode = .scaleAspectFill
                cell.profileImage.image = UIImage(data: backgroundData)
            }
        }
        
        // Set Number of Cuts
        let query = PFQuery(className: "Post")
        query.whereKey("barber", equalTo: barber)
        query.countObjectsInBackground { (count: Int32, error: Error?) in
            if error == nil {
                cell.cutLabel.text = "\(count)" + " cuts"
            }
        }
        
        return cell
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
