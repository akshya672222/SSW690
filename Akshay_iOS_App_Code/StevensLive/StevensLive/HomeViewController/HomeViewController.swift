//
//  HomeViewController.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 02/02/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class HomeViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var btnVoiceAssistant: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    
    @IBOutlet weak var tblViewEvent: UITableView!
    @IBOutlet weak var tblCategories: UITableView!
    
    @IBOutlet weak var viewBackgroundForFilterAndVoice: UIView!
    
    @IBOutlet weak var constraintViewBackgroundTopSpace: NSLayoutConstraint!
    @IBOutlet weak var constraintFilterVoiceViewHeight: NSLayoutConstraint!

    @IBOutlet weak var constraintViewCategoryHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constraintViewFilterTopSpace: NSLayoutConstraint!
    @IBOutlet weak var viewFilter: UIView!
    
    @IBOutlet weak var viewVoiceAssistant: UIView!
    
    @IBOutlet weak var constraintViewVoiceTopAlignment: NSLayoutConstraint!
    
    @IBOutlet weak var constrantViewFilterTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var constraintViewFilteringLeading: NSLayoutConstraint!
    
    @IBOutlet weak var constraintViewVoiceTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var constraintViewVoiceLeading: NSLayoutConstraint!
    
    // side bar work
    @IBOutlet weak var viewBackgroundForSideBar: UIView!
    
    @IBOutlet weak var constraintBackgroundSidebarTrailing: NSLayoutConstraint! //default = width
    
    @IBOutlet weak var constraintSideBarViewLeading: NSLayoutConstraint! //default = -280
    
    @IBOutlet weak var imgViewUserProfilePicture: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var btnLogout: UIButton!
    
    @IBOutlet weak var tableViewSideBar: UITableView!
    // side bar work ends
    
    
    var isFilterOpen = false;
    var isVoiceOpen = false;
    var isViewOpen = false;
    var isPrevImageHidden = false;
    var isIndexPathVisible = false;
    let global = GlobalFunction();
    var origImage = #imageLiteral(resourceName: "Voice") as UIImage;
    let categoryList = ["Admissions - Graduate", "Admissions - Undergraduate", "Alumni", "Athletics", "Career Development", "Conferences", "Health & Wellness", "Open to the Public", "Performing & Visual Arts", "Student Life", "Talks & Lectures", "University-wide"] as NSArray;
    var arrayFilteredData = NSMutableArray();
    let sideMenuItems = ["Home", "My Subscriptions", "Settings"] as NSArray;

    var previousIndexPath = IndexPath();
    var previousIndexPath_sideMenu = IndexPath.init(row: 0, section: 0);
    var fullNameString = String();
    var imagePP = #imageLiteral(resourceName: "UserProfilePicture");
    
    @IBOutlet weak var constraintSearchBarLeading: NSLayoutConstraint!
    
    @IBOutlet weak var btnBackToMainView: UIButton!
    
    @IBOutlet weak var btnClearSearchTextField: UIButton!
    
    @IBOutlet weak var textFieldSearch: UITextField!

    var accessory_view = UIView();
    var textFieldActive = UITextField();
    var btnPrev = UIButton();
    var btnNext = UIButton();
    var btnDone = UIButton();

    @IBAction func closeSearch(_ sender: Any) {
        textFieldSearch.resignFirstResponder();
        view.layoutIfNeeded();
        constraintSearchBarLeading.constant = 500;
        UIView.animate(withDuration: 1.0) { 
            self.view.layoutIfNeeded();
        };
    }
    
    @IBAction func clearTextField(_ sender: Any) {
        textFieldSearch.text = "";
        arrayFilteredData.removeAllObjects();
        print(arrayFilteredData)
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        let alertV = UIAlertController(title: "LOGOUT",
                                       message: "Are you sure? You want to Logout.",
                                       preferredStyle: .alert)
        let alertYesAction=UIAlertAction(title:"YES", style: UIAlertActionStyle.destructive,handler: { action in
            self.performSegue(withIdentifier: "logoutseague", sender: self)
        })
        let alertNoAction=UIAlertAction(title:"NO", style: UIAlertActionStyle.default,handler: { action in
            print("No Button Pressed")
        })
        alertV.addAction(alertNoAction)
        alertV.addAction(alertYesAction)
        
        self.present(alertV, animated: true, completion:nil)
    }
    
    @IBAction func sideBarClose(_ sender: Any) {
        closeSideBar();
    }

    @IBAction func closeFilterAndVoiceView(_ sender: Any) {
    
        closeView();
        btnVoiceAssistant.tintColor = global.redColor;
        btnFilter.setTitleColor(global.redColor, for: .normal);

        isViewOpen = false;
        isFilterOpen = false;
        isVoiceOpen = false;
        
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        view.layoutIfNeeded();
        constraintSearchBarLeading.constant = 0;
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded();
        };
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        view.layoutIfNeeded();
        constraintSideBarViewLeading.constant = 0;
        constraintBackgroundSidebarTrailing.constant = 0;
        UIView.animate(withDuration: 1.0) { 
            self.view.layoutIfNeeded();
        };
    }
    
    func closeSideBar() {
        view.layoutIfNeeded();
        constraintSideBarViewLeading.constant = -280;
        constraintBackgroundSidebarTrailing.constant = view.frame.size.width;
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded();
        };
    }
    
    @IBAction func openFilterMenu(_ sender: Any) {
        
        if isViewOpen{
            
            if isVoiceOpen{
                let tintedImage = origImage.withRenderingMode(.alwaysTemplate);
                btnVoiceAssistant.setImage(tintedImage, for: .normal);
                btnVoiceAssistant.tintColor = global.redColor;
                btnFilter.setTitleColor(UIColor.gray, for: .normal);
                
                viewFilter.isHidden = false;
                
                self.view.layoutIfNeeded();
                constraintViewVoiceTopAlignment.constant = 600;
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.layoutIfNeeded();
                }, completion: { (True) in
                    self.viewVoiceAssistant.isHidden = true;
                });
                
                isViewOpen = true;
                isFilterOpen = true;
                isVoiceOpen = false;
            }else{
                closeView();
                btnFilter.setTitleColor(global.redColor, for: .normal);
                isViewOpen = false;
                isFilterOpen = false;
                isVoiceOpen = false;
            }
        }else{
            openView()
            viewFilter.isHidden = false;
            btnFilter.setTitleColor(UIColor.gray, for: .normal);
            isViewOpen = true;
            isFilterOpen = true;
            isVoiceOpen = false;
        }
    }
    
    func openView() {
        self.view.layoutIfNeeded();
        constraintFilterVoiceViewHeight.constant = self.view.frame.height - 250;
        constraintViewBackgroundTopSpace.constant = -70;
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded();
        };
    }
    
    func closeView() {
        self.view.layoutIfNeeded();
        if global.isIphone4OrLess() {
            constraintFilterVoiceViewHeight.constant = 70;
        }else if global.isIphone5() {
            constraintFilterVoiceViewHeight.constant = 80;
        }else if global.isIphone6() {
            constraintFilterVoiceViewHeight.constant = 90;
        }else if global.isIphone6P() {
            constraintFilterVoiceViewHeight.constant = 100;
        }
        constraintViewBackgroundTopSpace.constant = self.view.frame.height-70;
        constraintViewVoiceTopAlignment.constant = 600;
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded();
        }) { (true) in
            self.viewVoiceAssistant.isHidden = true;
            self.viewFilter.isHidden = true;
        };
    }
    
    @IBAction func openVoiceAssistant(_ sender: Any) {
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate);
        btnVoiceAssistant.setImage(tintedImage, for: .normal);

        if isViewOpen{
            if isFilterOpen{
                btnFilter.setTitleColor(global.redColor, for: .normal);
                btnVoiceAssistant.tintColor = UIColor.gray;
                
                viewVoiceAssistant.isHidden = false;
                
                isViewOpen = true;
                isFilterOpen = false;
                isVoiceOpen = true;

                self.view.layoutIfNeeded();
                constraintViewVoiceTopAlignment.constant = 0;
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.layoutIfNeeded();
                }, completion: { (True) in
                    self.viewFilter.isHidden = true;
                });

            }else{
                closeView();
                btnVoiceAssistant.tintColor = global.redColor;
                isViewOpen = false;
                isFilterOpen = false;
                isVoiceOpen = false;
            }
        }else{
            self.view.layoutIfNeeded();
            constraintViewVoiceTopAlignment.constant = 0;
            openView();
            viewVoiceAssistant.isHidden = false;
            btnVoiceAssistant.tintColor = UIColor.gray;
            isViewOpen = true;
            isFilterOpen = false;
            isVoiceOpen = true;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblCategories {
            let cell: CategoryTableViewCell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell;
            var cell2 = CategoryTableViewCell();
            
            if previousIndexPath.indices.count > 0 {
                if indexPath == previousIndexPath {
                    if cell.imageCategorySelected.isHidden{
                        cell.imageCategorySelected.isHidden = false;
                        isPrevImageHidden = false;
                    }else{
                        cell.imageCategorySelected.isHidden = true;
                        isPrevImageHidden = true;
                    }
                }else{
                    let indexPathArr = tableView.indexPathsForVisibleRows;
                    if (indexPathArr?.contains(previousIndexPath))!{
                        cell2 = tableView.cellForRow(at: previousIndexPath) as! CategoryTableViewCell;
                        cell.imageCategorySelected.isHidden = false;
                        cell2.imageCategorySelected.isHidden = true;
                        isIndexPathVisible = false;
                    }else{
                        cell.imageCategorySelected.isHidden = false;
                        isIndexPathVisible = true;
                    }
                }
            }else{
                if cell.imageCategorySelected.isHidden{
                    cell.imageCategorySelected.isHidden = false;
                }else{
                    cell.imageCategorySelected.isHidden = true;
                }
            }

            previousIndexPath = indexPath;
            
        }else if tableView == tableViewSideBar{
            let cell: SideBarTableViewCell = tableView.cellForRow(at: indexPath) as! SideBarTableViewCell;
            let cell2: SideBarTableViewCell = tableView.cellForRow(at: previousIndexPath_sideMenu) as! SideBarTableViewCell;
            
            if indexPath.row == previousIndexPath_sideMenu.row {
                // close side bar and do nothing
                closeSideBar();
            }else{
                self.view.layoutIfNeeded();
                cell.constraintViewSelectionTrailingSpace.constant = 30;
                cell2.constraintViewSelectionTrailingSpace.constant = 278;
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.layoutIfNeeded();
                }, completion: { (True) in
                    self.closeSideBar();
                    if indexPath.row == 2{
                        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                        self.present(settingsVC, animated: True, completion: nil);
                    }
                    // close side bar and navigate to view
                });
            }
            previousIndexPath_sideMenu = indexPath;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == tblViewEvent{
            return 10;
        }else if tableView == tblCategories{
            return categoryList.count;
        }else if tableView == tableViewSideBar{
            return sideMenuItems.count;
        }
        return 0;
    }
    
    func createInputAccessoryView() {
        accessory_view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: 50));
        accessory_view.backgroundColor = UIColor.lightGray;
        accessory_view.alpha = 0.8;
        
        btnPrev = UIButton.init(type: UIButtonType.custom);
        btnPrev.frame = CGRect.init(x: 0, y: 0, width: 80, height: 50);
        btnPrev.setTitle("Previous", for: UIControlState.normal);
        btnPrev.addTarget(self, action: #selector(ViewController.goToPrevTextField), for: UIControlEvents.touchUpInside);
        
        btnNext = UIButton.init(type: UIButtonType.custom);
        btnNext.frame = CGRect.init(x: 85, y: 0, width: 80, height: 50);
        btnNext.setTitle("Next", for: UIControlState.normal);
        btnNext.addTarget(self, action: #selector(ViewController.goToNextTextField), for: UIControlEvents.touchUpInside);
        
        btnDone = UIButton.init(type: UIButtonType.custom);
        btnDone.frame = CGRect.init(x: view.frame.size.width - 80, y: 0, width: 80, height: 50);
        btnDone.setTitle("Done", for: UIControlState.normal);
        btnDone.addTarget(self, action: #selector(ViewController.doneTyping), for: UIControlEvents.touchUpInside);
        
        accessory_view.addSubview(btnPrev);
        accessory_view.addSubview(btnNext);
        accessory_view.addSubview(btnDone);
    }
    
    func goToPrevTextField() {
        textFieldActive.resignFirstResponder();
    }
    
    func goToNextTextField() {
        textFieldActive.resignFirstResponder();
    }
    
    func doneTyping() {
        textFieldActive.resignFirstResponder();
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        createInputAccessoryView();
        textField.inputAccessoryView = accessory_view;
        textFieldActive = textField;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let string1 = string
        let string2 = textFieldSearch.text
        var finalString = ""
        if string.characters.count > 0 { // if it was not delete character
            finalString = string2! + string1
        }else if (string2?.characters.count)! > 0{ // if it was a delete character
            finalString = String(string2!.characters.dropLast())
        }
        filteredArray(searchString: finalString as NSString)// pass the search String in this method
        return true
    }
    
    func filteredArray(searchString:NSString){// we will use NSPredicate to find the string in array
        let predicate = NSPredicate(format: "SELF contains[c] %@",searchString) // This will give all element of array which contains search string
        //let predicate = NSPredicate(format: "SELF BEGINSWITH %@",searchString)// This will give all element of array which begins with search string (use one of them)
        let arr = categoryList.filtered(using: predicate) as NSArray;
        arrayFilteredData = arr.mutableCopy() as! NSMutableArray
        print(arrayFilteredData)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblViewEvent {
            let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as! EventTableViewCell;
            
            cell.lblEventName.text = "Snowtubing at Mountain";
            cell.lblEventDayAndTime.text = "Feb, 20, 2017 AT 12:00 PM";
            cell.lblNumberOfAttandee.text = "100+ Attending";
            cell.lblEventCategory.text = "Debaun Auditorium";
            cell.imgViewEvent.image = #imageLiteral(resourceName: "StevensLogo");
            
            let font = cell.lblEventCategory.font;
            
            if global.isIphone4OrLess() {
                cell.lblEventName.font = font?.withSize(14);
                cell.lblEventDayAndTime.font = font?.withSize(11);
                cell.lblNumberOfAttandee.font = font?.withSize(10);
                cell.lblEventCategory.font = font?.withSize(10);
            }else if global.isIphone5() {
                cell.lblEventName.font = font?.withSize(15);
                cell.lblEventDayAndTime.font = font?.withSize(12);
                cell.lblNumberOfAttandee.font = font?.withSize(11);
                cell.lblEventCategory.font = font?.withSize(11);
            }else if global.isIphone6() {
                cell.lblEventName.font = font?.withSize(16);
                cell.lblEventDayAndTime.font = font?.withSize(13);
                cell.lblNumberOfAttandee.font = font?.withSize(12);
                cell.lblEventCategory.font = font?.withSize(12);
            }else if global.isIphone6P() {
                cell.lblEventName.font = font?.withSize(17);
                cell.lblEventDayAndTime.font = font?.withSize(14);
                cell.lblNumberOfAttandee.font = font?.withSize(13);
                cell.lblEventCategory.font = font?.withSize(13);
            }
            
            
            return cell;
        }else if tableView == tblCategories{
         
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
            
            if previousIndexPath.indices.count > 0 {
                if indexPath == previousIndexPath{
                    if isPrevImageHidden{
                        cell.imageCategorySelected.isHidden = true;
                    }else{
                        cell.imageCategorySelected.isHidden = false;
                    }
                    if isIndexPathVisible{
                        cell.imageCategorySelected.isHidden = true;
                        isIndexPathVisible = false;
                    }
                }else{
                    cell.imageCategorySelected.isHidden = true;
                }
            }else{
                cell.imageCategorySelected.isHidden = true;
            }
            
            return cell;
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "sidemenu", for: indexPath) as! SideBarTableViewCell;
            
            cell.lblSideBarMenuItem.text = (sideMenuItems.object(at: indexPath.row) as! NSString) as String;
            if indexPath.row == previousIndexPath_sideMenu.row {
                cell.constraintViewSelectionTrailingSpace.constant = 30;
            }else{
                cell.constraintViewSelectionTrailingSpace.constant = 278;
            }
            
            return cell;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustConstraint();
        viewFilter.isHidden = true;
        viewVoiceAssistant.isHidden = true;

        let tintedImage = origImage.withRenderingMode(.alwaysTemplate);
        btnVoiceAssistant.setImage(tintedImage, for: .normal);
        btnVoiceAssistant.tintColor = global.redColor;
        
        textFieldSearch.attributedPlaceholder = NSAttributedString(string: "Type to search...",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if fullNameString != "" {
            lblUserName.text = fullNameString;
        }
        
        if imagePP != #imageLiteral(resourceName: "UserProfilePicture"){
            imgViewUserProfilePicture.image = imagePP;
        }
        
        if imgViewUserProfilePicture.image != #imageLiteral(resourceName: "UserProfilePicture") {
            imgViewUserProfilePicture.layer.borderWidth=0.5
            imgViewUserProfilePicture.layer.masksToBounds = false
            imgViewUserProfilePicture.layer.borderColor = UIColor.white.cgColor
            imgViewUserProfilePicture.layer.cornerRadius = imgViewUserProfilePicture.frame.size.height/2
            imgViewUserProfilePicture.clipsToBounds = true
        }
        
        previousIndexPath_sideMenu.row = 0;
        tableViewSideBar.reloadData();
    }
    
    func adjustConstraint() {
        self.view.layoutIfNeeded();
        constraintViewBackgroundTopSpace.constant = self.view.frame.height-70;
        constraintBackgroundSidebarTrailing.constant = view.frame.size.width;
        constraintSideBarViewLeading.constant = -280;
        if global.isIphone4OrLess() {
            constraintViewCategoryHeight.constant = 40;
            constraintViewFilterTopSpace.constant = 71;
            constraintFilterVoiceViewHeight.constant = 70;
        }else if global.isIphone5() {
            constraintViewCategoryHeight.constant = 60;
            constraintViewFilterTopSpace.constant = 81;
            constraintFilterVoiceViewHeight.constant = 80;
        }else if global.isIphone6() {
            constraintViewFilterTopSpace.constant = 91;
            constraintFilterVoiceViewHeight.constant = 90;
        }else if global.isIphone6P() {
            constraintFilterVoiceViewHeight.constant = 100;
        }
        constraintViewVoiceTopAlignment.constant = 600;
        self.view.layoutIfNeeded();
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
}
