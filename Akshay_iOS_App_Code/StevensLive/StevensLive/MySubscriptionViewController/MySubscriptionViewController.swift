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

class MySubscriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WebServicesDelegate{
    
    
    @IBAction func backClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil);
        
    }
    
    @IBOutlet weak var tblViewCategories: UITableView!
    
    @IBAction func save_Subscription(_ sender: Any) {
        global.addIndicatorView()
        web_service_obj.add_remove_subscriptions(subscription_arr: arrayCategorySelected as! Array<Any>, user_id: (global.getVCObj()).user_data_obj.user_id!)
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
    
    func didFinishSuccessfully(method: String, dictionary: NSDictionary) {
        print(dictionary)
        (global.getVCObj()).user_data_obj.subscription_arr.removeAll()
        (global.getVCObj()).user_data_obj.subscription_arr = arrayCategorySelected as! Array<Int>
        global.removeIndicatorView()
    }

    
    let global = GlobalFunction();
    var arrayCategorySelected = NSMutableArray();
    let web_service_obj = WebServices()
    
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
        return (global.getVCObj()).cat_data_Array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! CategoryTableViewCell;
        
        let cat_array = (global.getVCObj()).cat_data_Array as NSArray
        
        let cat_data = cat_array.object(at: indexPath.row) as! CategoryData
        
        cell.lblCategoryName.text = cat_data.category_name
        
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
        
        cell.imageCategorySelected.tag = cat_data.category_id!;
        
        if arrayCategorySelected.contains(cell.imageCategorySelected.tag){
            cell.imageCategorySelected.isHidden = false;
        }else{
            cell.imageCategorySelected.isHidden = true;
        }
        
        return cell;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        web_service_obj.webServiceDelegate = self
        
        arrayCategorySelected.addObjects(from: (global.getVCObj()).user_data_obj.subscription_arr)
        
        tblViewCategories.layoutIfNeeded()
        tblViewCategories.reloadData()
        tblViewCategories.layoutIfNeeded()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        global.removeIndicatorView();
    }

}
