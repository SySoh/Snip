//
//  BarberShopPickViewController.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/18/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse

@objc protocol BarberShopPickDelegate {
    func didChooseBarberShop(barberShopName: Barbershop)
}

class BarberShopPickViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //Outlets and variables
    
    @IBOutlet weak var tableView: UITableView!
    var barberShopList: [Barbershop] = []
    var delegate: BarberShopPickDelegate?
    
    
    
    //Actions
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Tableview setup

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barberShopList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarberShopCell", for: indexPath) as! BarberShopCell
        cell.nameLabel.text = barberShopList[indexPath.item].object(forKey: "name") as? String
        cell.locationLabel.text = barberShopList[indexPath.item].object(forKey: "location") as? String
        cell.barbershop = barberShopList[indexPath.item]
        return cell
    }
    
    
    
    
    //Selection work
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BarberShopCell
        cell.backgroundColor = UIColor.gray
        print("Chose barbershop!")
        //DelegateWork here
        print(delegate)
        delegate?.didChooseBarberShop(barberShopName: cell.barbershop!)
        dismiss(animated: true, completion: nil)
    }

}
