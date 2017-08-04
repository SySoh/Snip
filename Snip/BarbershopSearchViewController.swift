//
//  BarbershopSearchViewController.swift
//  Snip
//
//  Created by Chase Warren on 7/21/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse

class BarbershopSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var barbershops: [PFObject] = []
    var filteredBarbershops: [PFObject] = []
    
    var parentNavigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBarbershops()
        self.filteredBarbershops = barbershops
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func getBarbershops() {
        let query = PFQuery(className: "Barbershop")
        query.order(byAscending: "name")
        query.includeKey("name")
        query.includeKey("location")
        query.includeKey("picture")
        query.includeKey("ratings")
        query.includeKey("hours")
        query.includeKey("phone")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let objects = objects {
                self.barbershops = objects
                self.filteredBarbershops = objects
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "Error fetching barbershops")
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "BarbershopSearchSegue" {
//            let vc = segue.destination as! BarberShopViewController
//            let cell = sender as! BarbershopSearchCell
//            vc.barberShop = cell.barbershop
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBarbershops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Barbershop Search Cell", for: indexPath) as! BarbershopSearchCell
        let barbershop = self.filteredBarbershops[indexPath.row]
        
        cell.barbershop = barbershop as? Barbershop
        
        // Set Barbershop Name
        let barbershopName = barbershop["name"] as! String
        cell.nameLabel.text = barbershopName
        
        // Set Barbershop Location
        let location = barbershop["location"] as! String
        cell.addressLabel.text = location
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBarbershops = searchText.isEmpty ? barbershops : barbershops.filter { (barbershop: PFObject) -> Bool in
            let name = barbershop["name"] as! String
            let location = barbershop["location"] as! String
            return (name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil) || (location.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
        }
        
        tableView.reloadData()
    }
    
    func didMoveSearch(currentSearchText: String) {
        filteredBarbershops = currentSearchText.isEmpty ? barbershops : barbershops.filter { (barbershop: PFObject) -> Bool in
            let name = barbershop["name"] as! String
            let location = barbershop["location"] as! String
            return (name.range(of: currentSearchText, options: .caseInsensitive, range: nil, locale: nil) != nil) || (location.range(of: currentSearchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let barbershopDetail = storyboard.instantiateViewController(withIdentifier: "barbershopDetail") as! BarberShopViewController
        let barbershop = self.filteredBarbershops[indexPath.row] as? Barbershop
        barbershopDetail.barberShop = barbershop
        parentNavigationController!.pushViewController(barbershopDetail, animated: true)
        barbershopDetail.navigationController?.setNavigationBarHidden(false, animated: true)
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
}
