//
//  HomeViewController.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 02/02/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class HomeViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var btnVoiceAssistant: UIButton!
    @IBOutlet weak var btnFilter: UIButton!

    @IBOutlet weak var tblViewEvent: UITableView!
    
    @IBAction func searchClicked(_ sender: Any) {
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
    }
    
    @IBAction func openFilterMenu(_ sender: Any) {
    }
    
    @IBAction func openVoiceAssistant(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventTableViewCell = tableView.dequeueReusableCell(withIdentifier: "event") as! EventTableViewCell;
        
        cell.lblEventName.text = "Snowtubing at Mountain";
        cell.lblEventDayAndTime.text = "Feb, 20, 2017 AT 12:00 PM";
        cell.lblNumberOfAttandee.text = "100+ Attending";
        cell.lblEventCategory.text = "Outdoor, Graduate";
        cell.imgViewEvent.image = #imageLiteral(resourceName: "StevensLogo");
        
        return cell;
    }

}
