//
//  EventData.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 29/03/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import Foundation

class EventData: NSObject{
    
    var Event_id: Int?
    var Event_category: Array<Int>?
    var Event_date: String?
    var Event_time: String?
    var Event_description: String?
    var Event_location: String?
    var Event_name: String?
    
    init(Event_id: Int?,Event_category: Array<Int>?,Event_date: String?,Event_time: String?,Event_name: String?,Event_location: String?,Event_description: String?){
        
        self.Event_id = Event_id
        self.Event_category = Event_category
        self.Event_date = Event_date
        self.Event_time = Event_time
        self.Event_name = Event_name
        self.Event_location = Event_location
        self.Event_description = Event_description
        
    }
    
    override init() {
        super.init()
        self.Event_id = -1
        self.Event_category = []
        self.Event_date = ""
        self.Event_time = ""
        self.Event_name = ""
        self.Event_location = ""
        self.Event_description = ""
    }
    
}
