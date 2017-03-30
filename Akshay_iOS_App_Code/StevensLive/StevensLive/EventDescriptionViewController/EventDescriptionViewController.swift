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

class EventDescriptionViewController: UIViewController{
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }

    let global = GlobalFunction();
    
    @IBOutlet weak var lblEventTitle: UILabel!

    @IBOutlet weak var lblEventDate: UILabel!

    @IBOutlet weak var lblEventTIme: UILabel!
    
    @IBOutlet weak var lblEventLocation: UILabel!
    
    @IBOutlet weak var lblEventCategory: UILabel!
    
    @IBOutlet weak var textViewEventDescription: UITextView!
    
    var Event_data_obj = EventData()
    
    @IBAction func remindMeToEvent(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        lblEventTitle.text = Event_data_obj.Event_name
        lblEventDate.text = Event_data_obj.Event_date
        lblEventTIme.text = Event_data_obj.Event_time
//        lblEventCategory.text =
        
        lblEventLocation.text = Event_data_obj.Event_location
        textViewEventDescription.text = Event_data_obj.Event_description
        
        lblEventCategory.text = ""
        var count = 0
        var str = "" as String;
        for categories in Event_data_obj.Event_category! {
            let cat_id = categories as Int
            for cat in (global.appDelegate.vcObj as! ViewController).cat_data_Array{
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
