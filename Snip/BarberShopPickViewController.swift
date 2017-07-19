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

    @IBOutlet weak var tableView: UITableView!
    var barberShopList: [Barbershop] = []
    var chosenBarberShop: String = ""
    
    var delegate: BarberShopPickDelegate?
    
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
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarberShopCell", for: indexPath) as! BarberShopCell
        cell.nameLabel.text = barberShopList[indexPath.item].object(forKey: "name") as? String
        cell.locationLabel.text = barberShopList[indexPath.item].object(forKey: "location") as? String
        cell.barbershop = barberShopList[indexPath.item]
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BarberShopCell
        cell.backgroundColor = UIColor.gray
        chosenBarberShop = cell.nameLabel.text ?? "No name"
        print("Chose barbershop!")
        //DelegateWork here
        print(delegate)
        delegate?.didChooseBarberShop(barberShopName: cell.barbershop!)
        dismiss(animated: true, completion: nil)
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
