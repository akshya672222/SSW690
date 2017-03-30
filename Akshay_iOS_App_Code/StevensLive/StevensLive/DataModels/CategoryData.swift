//
//  CategoryData.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 29/03/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import Foundation

class CategoryData{
    
    var category_id: Int?
    var category_name: String?
    
    init(Category_id: Int?, Category_name: String?){
        
        self.category_id = Category_id
        self.category_name = Category_name
        
    }
    
    init() {
        self.category_id = -1
        self.category_name = ""
    }

}
