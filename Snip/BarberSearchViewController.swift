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

class BarberSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var barbers: [PFObject] = []
    var filteredBarbers: [PFObject] = []
    
    var parentNavigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBarbers()
        self.filteredBarbers = self.barbers
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func getBarbers() {
        let query = PFQuery(className: "Barber")
        query.order(byAscending: "name")
        query.includeKey("name")
        query.includeKey("barbershop")
        query.includeKey("barbershop.name")
        query.includeKey("profile_pic")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let objects = objects {
                self.barbers = objects
                self.filteredBarbers = objects
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "Error fetching barbers")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBarbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Barber Search Cell", for: indexPath) as! BarberSearchCell
        let barber = self.filteredBarbers[indexPath.row]
        
        cell.barber = barber as? Barber
        
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
        query.includeKey("barber")
        query.whereKey("barber", equalTo: barber)
        query.countObjectsInBackground { (count: Int32, error: Error?) in
            if error == nil {
                cell.cutLabel.text = "\(count)" + " cuts"
            }
        }
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBarbers = searchText.isEmpty ? barbers : barbers.filter { (barber: PFObject) -> Bool in
            let name = barber["name"] as! String
            return name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
    
    func didMoveSearch(currentSearchText: String) {
        filteredBarbers = currentSearchText.isEmpty ? barbers : barbers.filter { (barber: PFObject) -> Bool in
            let name = barber["name"] as! String
            return name.range(of: currentSearchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let barberDetail = storyboard.instantiateViewController(withIdentifier: "barberDetail") as! ProfileViewController
        let barber = self.filteredBarbers[indexPath.row]
        barberDetail.barber = barber as? Barber
        parentNavigationController!.pushViewController(barberDetail, animated: true)
        barberDetail.navigationController?.setNavigationBarHidden(false, animated: true)
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
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
