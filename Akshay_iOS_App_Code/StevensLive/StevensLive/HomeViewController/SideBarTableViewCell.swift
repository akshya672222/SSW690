//
//  SideBarTableViewCell.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 27/02/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import Foundation
import UIKit

class SideBarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblSideBarMenuItem: UILabel!
    
    @IBOutlet weak var constraintViewSelectionTrailingSpace: NSLayoutConstraint! //default for not selection = 278 else = 30
    
}
