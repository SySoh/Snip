//
//  ScheduleViewController.swift
//  Snip
//
//  Created by Chase Warren on 7/24/17.
//  Copyright © 2017 Shao Yie Soh. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Parse

class ScheduleViewController: UIViewController {
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ScheduleViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "MM dd yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let today = Date()
        
        var dateComponent = DateComponents()
        dateComponent.day = 7
        let end = Calendar.current.date(byAdding: dateComponent, to: today)
        
        let parameters = ConfigurationParameters(startDate: Date(), endDate: end!)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "Date Cell", for: indexPath) as! DateCell
        cell.dateLabel.text = cellState.text
        return cell
    }

}
