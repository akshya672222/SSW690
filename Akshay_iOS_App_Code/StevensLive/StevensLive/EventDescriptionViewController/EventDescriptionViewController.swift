//
//  EventDescriptionViewController.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 03/03/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class EventDescriptionViewController: UIViewController, WebServicesDelegate{
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }

    @IBOutlet weak var btnRemindMe: UIButton!
    
    let global = GlobalFunction();
    let webServicesObj = WebServices();
    
    @IBOutlet weak var lblEventTitle: UILabel!

    @IBOutlet weak var lblEventDate: UILabel!

    @IBOutlet weak var lblEventTIme: UILabel!
    
    @IBOutlet weak var lblEventLocation: UILabel!
    
    @IBOutlet weak var lblEventCategory: UILabel!
    
    @IBOutlet weak var textViewEventDescription: UITextView!
    
    var Event_data_obj = EventData()
    
    @IBAction func remindMeToEvent(_ sender: Any) {
        global.addIndicatorView()
        webServicesObj.add_remove_reminder(user_id: (global.getVCObj()).user_data_obj.user_id!, event_id: Event_data_obj.Event_id!)
    }
    
    func didFinishWithError(method: String, errorMessage: String) {
        global.removeIndicatorView()
        let alertV = UIAlertController(title: "ERROR", message: errorMessage, preferredStyle: .alert)
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
            print("OK Button Pressed")
        })
        alertV.addAction(alertOKAction)
        self.present(alertV, animated: true, completion: nil)
    }
    
    //    var cat_data_Array = Array<Any>()
    //    var user_data_obj = UserData()
    
    func didFinishSuccessfully(method: String, dictionary: NSDictionary) {
        print(dictionary)
        var message = String()
        if btnRemindMe.titleLabel?.text == "REMIND ME" {
            btnRemindMe.setTitle("REMOVE REMINDER", for: .normal)
            (global.getVCObj()).user_data_obj.reminder_arr.append(Event_data_obj.Event_id!)
            message = "Reminder added successfully."
            
        }else{
            btnRemindMe.setTitle("REMIND ME", for: .normal)
            (global.getVCObj()).user_data_obj.reminder_arr.remove(at: (global.getVCObj()).user_data_obj.reminder_arr.index(of: Event_data_obj.Event_id!)!)
            message = "Reminder removed successfully."
        }
        global.removeIndicatorView()
        let alertV = UIAlertController(title: "STEVENS LIVE", message: message, preferredStyle: .alert)
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
            print("OK Button Pressed")
        })
        alertV.addAction(alertOKAction)
        self.present(alertV, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        lblEventTitle.text = Event_data_obj.Event_name
        lblEventDate.text = Event_data_obj.Event_date
        lblEventTIme.text = Event_data_obj.Event_time
        lblEventLocation.text = Event_data_obj.Event_location
        textViewEventDescription.text = Event_data_obj.Event_description
        
        if (global.getVCObj()).user_data_obj.reminder_arr.contains(Event_data_obj.Event_id!) {
            btnRemindMe.setTitle("REMOVE REMINDER", for: .normal)
        }
        
        webServicesObj.webServiceDelegate = self
        
        lblEventCategory.text = ""
        var count = 0
        var str = "" as String;
        for categories in Event_data_obj.Event_category! {
            let cat_id = categories as Int
            for cat in (global.getVCObj()).cat_data_Array{
                let cat_data_obj = cat as! CategoryData
                if cat_data_obj.category_id == cat_id{
                    if count == 0 {
                        str = str.appendingFormat("%@", cat_data_obj.category_name!)
                    }else{
                        str = str.appendingFormat(",%@", cat_data_obj.category_name!)
                    }
                }
            }
            count = count + 1
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        global.removeIndicatorView();
    }
}
