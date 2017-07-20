//
//  BarberPickViewController.swift
//  Snip
//
//  Created by Shao Yie Soh on 7/18/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

@objc protocol BarberPickDelegate {
    func didChooseBarber(barberName: Barber)
}

class BarberPickViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets and variables
    @IBOutlet weak var tableView: UITableView!
    var barberList: [Barber] = []
    var chosenBarber: Barber?
    var delegate: BarberPickDelegate?
    var barberShop: Barbershop?
    
    
    //Actions
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Tableview setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarberCell", for: indexPath) as! BarberCell
        cell.nameLabel.text = barberList[indexPath.item].object(forKey: "name") as? String
        let imageURL = barberList[indexPath.item].object(forKey: "profile_pic") as? PFFile
        cell.profilePic.file = imageURL
        cell.profilePic.loadInBackground()
        cell.barber = barberList[indexPath.item]
        chosenBarber = barberList[indexPath.item]
        return cell
    }
    
    
    //Selection work
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BarberCell
        cell.backgroundColor = UIColor.gray
        print("chose barber!")
        delegate?.didChooseBarber(barberName: cell.barber!)
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
