//
//  NextComposeViewController.swift
//  Snip
//
//  Created by Chase Warren on 8/7/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import CoreLocation
import SwiftHEXColors

class NextComposeViewController: UIViewController, BarberShopPickDelegate, BarberPickDelegate, UITextViewDelegate {
    
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var shopChoosingButton: UIButton!
    @IBOutlet weak var barberChoosingButton: UIButton!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var charCount: UILabel!
    
    //shopList is the list of all barber shops in the system, passed to the BarberShopPicker view.
    var shopList: [Barbershop] = []
    //The barberlist to pass to the BarberPicker view
    var barberList: [Barber] = []
    //The barbershop object to be passed into the post function
    var barbershop: Barbershop?
    //The barber object to be passed into the post function
    var barber: Barber?
    
    var pictures: [UIImage] = []
    var tagReuse: [Tag] = []
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className: "User")
        query.includeKey("objectId")
        query.getFirstObjectInBackground { (resultUser, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.user = resultUser as? User
            }
        }
        
        barberShopQuery()
        barberQuery()
        
        
        captionTextView.delegate = self
        
        if barbershop == nil {
            barberChoosingButton.isEnabled = false
            barberChoosingButton.backgroundColor = UIColor.lightGray
        }
        
        captionTextView.text = "Have anything to say about this haircut?"
        captionTextView.textColor = UIColor.lightGray
        captionTextView.layer.cornerRadius = 10
        captionTextView.layer.borderColor = UIColor(hexString: "#FFFCF2")?.cgColor
        captionTextView.layer.borderWidth = 0.5
        
        shopChoosingButton.layer.cornerRadius = 10
        barberChoosingButton.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func barberShopQuery(){
        let query = PFQuery(className:"Barbershop")
        query.includeKey("objectId")
        query.order(byAscending: "name")
        query.findObjectsInBackground { (
            shops: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.shopList = shops as! [Barbershop]
            }
        }
        
    }
    
    func barberQuery(){
        let query = PFQuery(className:"Barber")
        query.includeKey("objectId")
        query.order(byAscending: "name")
        query.includeKey("barber.barbershop")
        query.findObjectsInBackground { ( barbers: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.barberList = barbers as! [Barber]
            }
        }
    }
    
    func didChooseBarberShop(barberShopName: Barbershop) {
        shopChoosingButton.setTitle(barberShopName.name, for: .normal)
        self.barbershop = barberShopName
        barberChoosingButton.isEnabled = true
        barberChoosingButton.backgroundColor = UIColor(hex: "FCFCFC")
    }
    
    func didChooseBarber(barberName: Barber) {
        barberChoosingButton.setTitle(barberName.name, for: .normal)
        self.barber = barberName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            captionTextView.text = ""
            captionTextView.textColor = UIColor(hex:"F5EDDA")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Have anything to say about this haircut?"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        charCount.text = String(describing: (300 - captionTextView.text.characters.count))
        if captionTextView.text.characters.count > 300 {
            charCount.textColor = UIColor.red
        } else {
            charCount.textColor = UIColor.gray
        }
    }
    
    @IBAction func makePost(_ sender: Any) {
        let alertController = UIAlertController(title: "One or more fields were left empty", message: "Please fill out all fields", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"OK", style: .cancel) {(UIAlertAction) in }
        alertController.addAction(cancelAction)
        let alertLengthController = UIAlertController(title: "Caption is too long", message: "Please keep your caption under 300 characters", preferredStyle: .alert)
        alertLengthController.addAction(cancelAction)
        
        if ((barbershop == nil) || (barber == nil) || (priceText.text?.isEmpty)! || tagReuse.isEmpty){
            present(alertController, animated: true)
        } else if (captionTextView.text.characters.count > 300){
            present(alertLengthController, animated: true)
        } else {
            //            let image = pictureView.image!
            
            //redo post function
            Post.postPost(pictures: self.pictures, barber: self.barber!, tags: tagReuse, price: Int64(priceText.text!)!, caption: captionTextView.text)
            dismiss(animated: true, completion: nil)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "BarberShopSegue") {
            let destVC = segue.destination as! BarberShopPickViewController
            destVC.delegate = self
            destVC.barberShopList = self.shopList
        } else if (segue.identifier == "BarberPick") {
            let destVC = segue.destination as! BarberPickViewController
            destVC.delegate = self
            for barber in self.barberList {
                if barbershop?.objectId == barber.barbershop?.objectId {
                    destVC.barberList.append(barber)
                }
            }
        }
    }
}
