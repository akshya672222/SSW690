//
//  MySubscriptionViewController.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 03/03/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class MySubscriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBAction func backClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil);
        
    }
    
    @IBOutlet weak var tblViewCategories: UITableView!
    
    let categoryList = ["Admissions - Graduate", "Admissions - Undergraduate", "Alumni", "Athletics", "Career Development", "Conferences", "Health & Wellness", "Open to the Public", "Performing & Visual Arts", "Student Life", "Talks & Lectures", "University-wide"] as NSArray;
    
    let global = GlobalFunction();
    var arrayCategorySelected = NSMutableArray();
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: CategoryTableViewCell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell;
        
        if arrayCategorySelected.contains(cell.imageCategorySelected.tag){
            arrayCategorySelected.remove(cell.imageCategorySelected.tag);
            cell.imageCategorySelected.isHidden = true;
        }else{
            arrayCategorySelected.add(cell.imageCategorySelected.tag);
            cell.imageCategorySelected.isHidden = false;
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return categoryList.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! CategoryTableViewCell;
        
        cell.lblCategoryName.text = (categoryList.object(at: indexPath.row) as! NSString) as String;
        
        let font = cell.lblCategoryName.font;
        
        
        if global.isIphone4OrLess() {
            cell.lblCategoryName.font = font?.withSize(14);
        }else if global.isIphone5() {
            cell.lblCategoryName.font = font?.withSize(16);
        }else if global.isIphone6() {
            cell.lblCategoryName.font = font?.withSize(20);
        }else if global.isIphone6P() {
            cell.lblCategoryName.font = font?.withSize(22);
        }
        
        cell.imageCategorySelected.tag = indexPath.row;
        
        if arrayCategorySelected.contains(cell.imageCategorySelected.tag){
            cell.imageCategorySelected.isHidden = false;
        }else{
            cell.imageCategorySelected.isHidden = true;
        }
        
        return cell;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        global.removeIndicatorView();
    }

}
