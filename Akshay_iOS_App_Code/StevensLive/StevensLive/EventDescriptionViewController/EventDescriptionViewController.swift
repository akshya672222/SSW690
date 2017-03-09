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
    
    @IBAction func remindMeToEvent(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        global.removeIndicatorView();
    }
}
