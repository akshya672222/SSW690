//
//  UserData.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 29/03/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import Foundation

class UserData{
    
    var email: String?
    var profile_picpath: String?
    var user_fname: String?
    var user_id: Int?
    var user_lname: String?
    var subscription_arr = Array<Int>()
    var reminder_arr = Array<Int>()
    

    init(email: String?, profile_picpath: String?, user_fname: String?, user_id: Int?, user_lname: String?, subscription_arr: Array<Int>, reminder_arr: Array<Int>){
        
        self.email = email
        self.profile_picpath = profile_picpath
        self.user_fname = user_fname
        self.user_id = user_id
        self.user_lname = user_lname
        self.subscription_arr = subscription_arr
        self.reminder_arr = reminder_arr
        
    }
    
    init() {
        self.email = ""
        self.profile_picpath = ""
        self.user_fname = ""
        self.user_id = -1
        self.user_lname = ""
        self.subscription_arr = []
        self.reminder_arr = []
    }

}
