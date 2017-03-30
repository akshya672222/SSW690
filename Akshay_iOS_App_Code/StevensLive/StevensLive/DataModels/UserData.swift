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

    init(email: String?, profile_picpath: String?, user_fname: String?, user_id: Int?, user_lname: String?){
        
        self.email = email
        self.profile_picpath = profile_picpath
        self.user_fname = user_fname
        self.user_id = user_id
        self.user_lname = user_lname

    }
    
    init() {
        self.email = ""
        self.profile_picpath = ""
        self.user_fname = ""
        self.user_id = -1
        self.user_lname = ""
    }

}
