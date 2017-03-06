//
//  MyReminderViewController.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 05/03/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class MyReminderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }

    @IBOutlet weak var tblViewEventsReminder: UITableView!
    let global = GlobalFunction();
    var arrayReminders = NSMutableArray();

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblViewEventsReminder{
            let eventDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "EventDescriptionViewController") as! EventDescriptionViewController
            self.present(eventDetailsVC, animated: true, completion: nil);
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as! EventTableViewCell;
        
        cell.lblEventName.text = "Snowtubing at Mountain";
        cell.lblEventDayAndTime.text = "Feb, 20, 2017 AT 12:00 PM";
        cell.lblEventCategory.text = "Debaun Auditorium";
        cell.btnAddReminder.tag = indexPath.row;
        
        if arrayReminders.contains(cell.btnAddReminder.tag) {
            cell.btnAddReminder.isSelected = true;
        }else{
            cell.btnAddReminder.isSelected = false;
        }
        
        let font = cell.lblEventCategory.font;
        
        if global.isIphone4OrLess() {
            cell.lblEventName.font = font?.withSize(14);
            cell.lblEventDayAndTime.font = font?.withSize(11);
            cell.lblNumberOfAttandee.font = font?.withSize(10);
            cell.lblEventCategory.font = font?.withSize(10);
        }else if global.isIphone5() {
            cell.lblEventName.font = font?.withSize(15);
            cell.lblEventDayAndTime.font = font?.withSize(12);
            cell.lblNumberOfAttandee.font = font?.withSize(11);
            cell.lblEventCategory.font = font?.withSize(11);
        }else if global.isIphone6() {
            cell.lblEventName.font = font?.withSize(16);
            cell.lblEventDayAndTime.font = font?.withSize(13);
            cell.lblNumberOfAttandee.font = font?.withSize(12);
            cell.lblEventCategory.font = font?.withSize(12);
        }else if global.isIphone6P() {
            cell.lblEventName.font = font?.withSize(17);
            cell.lblEventDayAndTime.font = font?.withSize(14);
            cell.lblNumberOfAttandee.font = font?.withSize(13);
            cell.lblEventCategory.font = font?.withSize(13);
        }
        
        
        return cell;

    }

}
