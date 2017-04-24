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

class HomeViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, WebServicesDelegate{

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var btnVoiceAssistant: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    
    @IBOutlet weak var tblViewEvent: UITableView!
    @IBOutlet weak var tblCategories: UITableView!
    
    @IBOutlet weak var lblNoEvents: UILabel!
    
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
    
    var isFilterOpen = false
    var isVoiceOpen = false
    var isViewOpen = false
    var isPrevImageHidden = false
    var isIndexPathVisible = false
    let global = GlobalFunction()
    var webServiceObj = WebServices()
    var origImage = #imageLiteral(resourceName: "Voice") as UIImage
    
    
    var arrayFilteredData = NSMutableArray()
    
    var isFilterEnabled = false
    
    var selectedCategoryId = 0
    var selectedSearchString = ""
    
    let sideMenuItems = ["Home", "My Subscriptions", "My Reminders", "Settings"] as NSArray

    var previousIndexPath = IndexPath()
    var previousIndexPath_sideMenu = IndexPath.init(row: 0, section: 0)
    var fullNameString = String()
    var imagePP = #imageLiteral(resourceName: "UserProfilePicture")
    
// MARK: - data objects
    var page_number = 1
    var event_data_array = NSMutableArray()
    var isWebServiceCalled = false
    
    @IBOutlet weak var constraintSearchBarLeading: NSLayoutConstraint!
    
    @IBOutlet weak var btnBackToMainView: UIButton!
    
    @IBOutlet weak var btnClearSearchTextField: UIButton!
    
    @IBOutlet weak var textFieldSearch: UITextField!

    var accessory_view = UIView()
    var textFieldActive = UITextField()
    var btnPrev = UIButton()
    var btnNext = UIButton()
    var btnDone = UIButton()
    
    var tblCell_reminder = EventTableViewCell()
    

    @IBAction func addReminderClicked(_ sender: Any) {
        
        global.addIndicatorView()
        
        let indexPth = IndexPath.init(row: (sender as AnyObject).tag, section: 0)
        tblCell_reminder = tblViewEvent.cellForRow(at: indexPth) as! EventTableViewCell
        
        var event_data_obj = EventData()
        
        if isFilterEnabled{
            event_data_obj = arrayFilteredData[tblCell_reminder.btnAddReminder.tag] as! EventData
        }else{
            event_data_obj = event_data_array[tblCell_reminder.btnAddReminder.tag] as! EventData
        }

        webServiceObj.add_remove_reminder(user_id: (global.appDelegate.vcObj as! ViewController).user_data_obj.user_id!, event_id:event_data_obj.Event_id!)
        
    }
    
    
    @IBAction func closeSearch(_ sender: Any) {
        textFieldSearch.resignFirstResponder()
        view.layoutIfNeeded()
        constraintSearchBarLeading.constant = 500
        UIView.animate(withDuration: 1.0) { 
            self.view.layoutIfNeeded()
        }
        textFieldSearch.text = ""
    }
    
    @IBAction func clearTextField(_ sender: Any) {
        textFieldSearch.text = ""
        selectedSearchString = ""
        filterEvents(categoryId: selectedCategoryId, string: selectedSearchString)
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        let alertV = UIAlertController(title: "LOGOUT",
                                       message: "Are you sure? You want to Logout.",
                                       preferredStyle: .alert)
        let alertYesAction=UIAlertAction(title:"YES", style: UIAlertActionStyle.destructive,handler: { action in
            self.global.userdefaults.set(false, forKey: "isLogin")
            self.global.userdefaults.synchronize()
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
        closeSideBar()
    }

    @IBAction func closeFilterAndVoiceView(_ sender: Any) {
    
        closeView()
        btnVoiceAssistant.tintColor = global.redColor
        btnFilter.setTitleColor(global.redColor, for: .normal)

        isViewOpen = false
        isFilterOpen = false
        isVoiceOpen = false
        
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        view.layoutIfNeeded()
        constraintSearchBarLeading.constant = 0
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        view.layoutIfNeeded()
        constraintSideBarViewLeading.constant = 0
        constraintBackgroundSidebarTrailing.constant = 0
        UIView.animate(withDuration: 1.0) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func closeSideBar() {
        view.layoutIfNeeded()
        constraintSideBarViewLeading.constant = -280
        constraintBackgroundSidebarTrailing.constant = view.frame.size.width
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func openFilterMenu(_ sender: Any) {
        
        if isViewOpen{
            
            if isVoiceOpen{
                let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
                btnVoiceAssistant.setImage(tintedImage, for: .normal)
                btnVoiceAssistant.tintColor = global.redColor
                btnFilter.setTitleColor(UIColor.gray, for: .normal)
                
                viewFilter.isHidden = false
                
                self.view.layoutIfNeeded()
                constraintViewVoiceTopAlignment.constant = 600
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (True) in
                    self.viewVoiceAssistant.isHidden = true
                })
                
                isViewOpen = true
                isFilterOpen = true
                isVoiceOpen = false
            }else{
                closeView()
                btnFilter.setTitleColor(global.redColor, for: .normal)
                isViewOpen = false
                isFilterOpen = false
                isVoiceOpen = false
            }
        }else{
            openView()
            viewFilter.isHidden = false
            btnFilter.setTitleColor(UIColor.gray, for: .normal)
            isViewOpen = true
            isFilterOpen = true
            isVoiceOpen = false
        }
    }
    
    func openView() {
        self.view.layoutIfNeeded()
        constraintFilterVoiceViewHeight.constant = self.view.frame.height - 250
        constraintViewBackgroundTopSpace.constant = -70
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func closeView() {
        self.view.layoutIfNeeded()
        if global.isIphone4OrLess() {
            constraintFilterVoiceViewHeight.constant = 70
        }else if global.isIphone5() {
            constraintFilterVoiceViewHeight.constant = 80
        }else if global.isIphone6() {
            constraintFilterVoiceViewHeight.constant = 90
        }else if global.isIphone6P() {
            constraintFilterVoiceViewHeight.constant = 100
        }
        constraintViewBackgroundTopSpace.constant = self.view.frame.height-70
        constraintViewVoiceTopAlignment.constant = 600
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        }) { (true) in
            self.viewVoiceAssistant.isHidden = true
            self.viewFilter.isHidden = true
        }
    }
    
    @IBAction func openVoiceAssistant(_ sender: Any) {
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        btnVoiceAssistant.setImage(tintedImage, for: .normal)

        if isViewOpen{
            if isFilterOpen{
                btnFilter.setTitleColor(global.redColor, for: .normal)
                btnVoiceAssistant.tintColor = UIColor.gray
                
                viewVoiceAssistant.isHidden = false
                
                isViewOpen = true
                isFilterOpen = false
                isVoiceOpen = true

                self.view.layoutIfNeeded()
                constraintViewVoiceTopAlignment.constant = 0
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (True) in
                    self.viewFilter.isHidden = true
                })

            }else{
                closeView()
                btnVoiceAssistant.tintColor = global.redColor
                isViewOpen = false
                isFilterOpen = false
                isVoiceOpen = false
            }
        }else{
            self.view.layoutIfNeeded()
            constraintViewVoiceTopAlignment.constant = 0
            openView()
            viewVoiceAssistant.isHidden = false
            btnVoiceAssistant.tintColor = UIColor.gray
            isViewOpen = true
            isFilterOpen = false
            isVoiceOpen = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblCategories {
            let cell: CategoryTableViewCell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
            var cell2 = CategoryTableViewCell()
            
            if previousIndexPath.indices.count > 0 {
                if indexPath == previousIndexPath {
                    if cell.imageCategorySelected.isHidden{
                        cell.imageCategorySelected.isHidden = false
                        isPrevImageHidden = false
                        selectedCategoryId = cell.lblCategoryName.tag
                    }else{
                        cell.imageCategorySelected.isHidden = true
                        isPrevImageHidden = true
                        selectedCategoryId = 0
                    }
                }else{
                    let indexPathArr = tableView.indexPathsForVisibleRows
                    if (indexPathArr?.contains(previousIndexPath))!{
                        cell2 = tableView.cellForRow(at: previousIndexPath) as! CategoryTableViewCell
                        cell.imageCategorySelected.isHidden = false
                        cell2.imageCategorySelected.isHidden = true
                        isIndexPathVisible = false
                        selectedCategoryId = cell.lblCategoryName.tag
                    }else{
                        cell.imageCategorySelected.isHidden = false
                        selectedCategoryId = cell.lblCategoryName.tag
                        isIndexPathVisible = true
                    }
                }
            }else{
                if cell.imageCategorySelected.isHidden{
                    cell.imageCategorySelected.isHidden = false
                    selectedCategoryId = cell.lblCategoryName.tag
                }else{
                    cell.imageCategorySelected.isHidden = true
                    selectedCategoryId = 0
                }
            }
            filterEvents(categoryId: selectedCategoryId, string: selectedSearchString)
            previousIndexPath = indexPath
            
        }else if tableView == tableViewSideBar{
            let cell: SideBarTableViewCell = tableView.cellForRow(at: indexPath) as! SideBarTableViewCell
            let cell2: SideBarTableViewCell = tableView.cellForRow(at: previousIndexPath_sideMenu) as! SideBarTableViewCell
            
            if indexPath.row == previousIndexPath_sideMenu.row {
                // close side bar and do nothing
                closeSideBar()
            }else{
                global.addIndicatorView()
                self.view.layoutIfNeeded()
                cell.constraintViewSelectionTrailingSpace.constant = 30
                cell2.constraintViewSelectionTrailingSpace.constant = 278
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (True) in
                    self.closeSideBar()
                    if indexPath.row == 3{
                        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                        self.present(settingsVC, animated: True, completion: nil)
                    }else if indexPath.row == 1{
                        let mySubscriptionVC = self.storyboard?.instantiateViewController(withIdentifier: "MySubscriptionViewController") as! MySubscriptionViewController
                        self.present(mySubscriptionVC, animated: True, completion: nil)
                    }else if indexPath.row == 2{
                        let myReminderVC = self.storyboard?.instantiateViewController(withIdentifier: "MyReminderViewController") as! MyReminderViewController
                        self.present(myReminderVC, animated: True, completion: nil)
                    }
                    // close side bar and navigate to view
                })
            }
            previousIndexPath_sideMenu = indexPath
        }else if tableView == tblViewEvent{
            let eventDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "EventDescriptionViewController") as! EventDescriptionViewController
            
            if isFilterEnabled {
                eventDetailsVC.Event_data_obj = arrayFilteredData.object(at: indexPath.row) as! EventData
            }else{
                eventDetailsVC.Event_data_obj = event_data_array.object(at: indexPath.row) as! EventData
            }
            
            self.present(eventDetailsVC, animated: true, completion: nil)
        }
    }
    
    func filterEvents(categoryId: Int, string: String) {
        
        let searchString = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let arr = NSMutableArray()
        
        if searchString != "" {
            let predicate = NSPredicate(format: "SELF.Event_name contains[c] %@",searchString) // This will give all element of array which contains search string
            arr.add(predicate)
        }
        if categoryId != 0{
            let predicate = NSPredicate(format: "SELF.Event_category contains[c] %d",categoryId) // This will give all element of array which contains search string
            arr.add(predicate)
        }
        
        if searchString == "" && categoryId == 0 {
            isFilterEnabled = false
            arrayFilteredData.removeAllObjects()
        }else{
            isFilterEnabled = true
            let arr_predicate = arr as NSArray
            let andPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: arr_predicate as! [NSPredicate])
            let arr_filtered = event_data_array.filtered(using: andPredicate) as NSArray
            arrayFilteredData = arr_filtered.mutableCopy() as! NSMutableArray
        }

        view.layoutIfNeeded()
        tblViewEvent.reloadData()
        view.layoutIfNeeded()
        
        isWebServiceCalled = false
        if isRefreshStarted {
            isRefreshStarted = false
            refreshControl.endRefreshing()
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == tblViewEvent{
            if isFilterEnabled{
                if arrayFilteredData.count > 0{
                    lblNoEvents.isHidden = true
                }else{
                    lblNoEvents.isHidden = false
                }
                return arrayFilteredData.count
            }
            
            if event_data_array.count > 0{
                lblNoEvents.isHidden = true
            }else{
                lblNoEvents.isHidden = false
            }

            return event_data_array.count
        }else if tableView == tblCategories{
            return (global.appDelegate.vcObj as! ViewController).cat_data_Array.count
        }else if tableView == tableViewSideBar{
            return sideMenuItems.count
        }
        return 0
    }
    
    func createInputAccessoryView() {
        accessory_view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: 50))
        accessory_view.backgroundColor = UIColor.lightGray
        accessory_view.alpha = 0.8
        
        btnPrev = UIButton.init(type: UIButtonType.custom)
        btnPrev.frame = CGRect.init(x: 0, y: 0, width: 80, height: 50)
        btnPrev.setTitle("Previous", for: UIControlState.normal)
        btnPrev.addTarget(self, action: #selector(ViewController.goToPrevTextField), for: UIControlEvents.touchUpInside)
        
        btnNext = UIButton.init(type: UIButtonType.custom)
        btnNext.frame = CGRect.init(x: 85, y: 0, width: 80, height: 50)
        btnNext.setTitle("Next", for: UIControlState.normal)
        btnNext.addTarget(self, action: #selector(ViewController.goToNextTextField), for: UIControlEvents.touchUpInside)
        
        btnDone = UIButton.init(type: UIButtonType.custom)
        btnDone.frame = CGRect.init(x: view.frame.size.width - 80, y: 0, width: 80, height: 50)
        btnDone.setTitle("Done", for: UIControlState.normal)
        btnDone.addTarget(self, action: #selector(ViewController.doneTyping), for: UIControlEvents.touchUpInside)
        
        accessory_view.addSubview(btnPrev)
        accessory_view.addSubview(btnNext)
        accessory_view.addSubview(btnDone)
    }
    
    func goToPrevTextField() {
        textFieldActive.resignFirstResponder()
    }
    
    func goToNextTextField() {
        textFieldActive.resignFirstResponder()
    }
    
    func doneTyping() {
        textFieldActive.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        createInputAccessoryView()
        textField.inputAccessoryView = accessory_view
        textFieldActive = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        
        selectedSearchString = searchString as String
        filterEvents(categoryId: selectedCategoryId, string: selectedSearchString)
        view.layoutIfNeeded()
        tblViewEvent.reloadData()
        view.layoutIfNeeded()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblViewEvent {
            let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as! EventTableViewCell
            
            var event_data_obj = EventData()
            
            if isFilterEnabled{
                event_data_obj = arrayFilteredData[indexPath.row] as! EventData
            }else{
                event_data_obj = event_data_array[indexPath.row] as! EventData
            }
            
            if !isWebServiceCalled {
                if isFilterEnabled {
                    if indexPath.row > arrayFilteredData.count - 10 {
                        isWebServiceCalled = true
                        webServiceObj.get_events(page_no: page_number+1)
                    }
                }else{
                    if indexPath.row > event_data_array.count - 10 {
                        isWebServiceCalled = true
                        webServiceObj.get_events(page_no: page_number+1)
                    }
                }
            }
            
            cell.lblEventName.text = event_data_obj.Event_name
            cell.lblEventDayAndTime.text = "\(event_data_obj.Event_date!) - \(event_data_obj.Event_time!)"
            cell.lblEventCategory.text = event_data_obj.Event_location
            cell.btnAddReminder.tag = indexPath.row
            
            if (global.appDelegate.vcObj as! ViewController).user_data_obj.reminder_arr.contains(event_data_obj.Event_id!) {
                cell.btnAddReminder.isSelected = true
            }else{
                cell.btnAddReminder.isSelected = false
            }
            
            let font = cell.lblEventCategory.font
            
            if global.isIphone4OrLess() {
                cell.lblEventName.font = font?.withSize(14)
                cell.lblEventDayAndTime.font = font?.withSize(11)
                cell.lblNumberOfAttandee.font = font?.withSize(10)
                cell.lblEventCategory.font = font?.withSize(10)
            }else if global.isIphone5() {
                cell.lblEventName.font = font?.withSize(15)
                cell.lblEventDayAndTime.font = font?.withSize(12)
                cell.lblNumberOfAttandee.font = font?.withSize(11)
                cell.lblEventCategory.font = font?.withSize(11)
            }else if global.isIphone6() {
                cell.lblEventName.font = font?.withSize(16)
                cell.lblEventDayAndTime.font = font?.withSize(13)
                cell.lblNumberOfAttandee.font = font?.withSize(12)
                cell.lblEventCategory.font = font?.withSize(12)
            }else if global.isIphone6P() {
                cell.lblEventName.font = font?.withSize(17)
                cell.lblEventDayAndTime.font = font?.withSize(14)
                cell.lblNumberOfAttandee.font = font?.withSize(13)
                cell.lblEventCategory.font = font?.withSize(13)
            }
            
            return cell
        }else if tableView == tblCategories{
         
            let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! CategoryTableViewCell
            
            let cat_data_obj = (global.appDelegate.vcObj as! ViewController).cat_data_Array[indexPath.row] as! CategoryData
            
            cell.lblCategoryName.text = cat_data_obj.category_name
            cell.lblCategoryName.tag = cat_data_obj.category_id!
            
            let font = cell.lblCategoryName.font
            
            if global.isIphone4OrLess() {
                cell.lblCategoryName.font = font?.withSize(14)
            }else if global.isIphone5() {
                cell.lblCategoryName.font = font?.withSize(16)
            }else if global.isIphone6() {
                cell.lblCategoryName.font = font?.withSize(20)
            }else if global.isIphone6P() {
                cell.lblCategoryName.font = font?.withSize(22)
            }
            
            if previousIndexPath.indices.count > 0 {
                if indexPath == previousIndexPath{
                    if isPrevImageHidden{
                        cell.imageCategorySelected.isHidden = true
                    }else{
                        cell.imageCategorySelected.isHidden = false
                    }
                    if isIndexPathVisible{
                        cell.imageCategorySelected.isHidden = true
                        isIndexPathVisible = false
                    }
                }else{
                    cell.imageCategorySelected.isHidden = true
                }
            }else{
                cell.imageCategorySelected.isHidden = true
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "sidemenu", for: indexPath) as! SideBarTableViewCell
            
            cell.lblSideBarMenuItem.text = (sideMenuItems.object(at: indexPath.row) as! NSString) as String
            if indexPath.row == previousIndexPath_sideMenu.row {
                cell.constraintViewSelectionTrailingSpace.constant = 30
            }else{
                cell.constraintViewSelectionTrailingSpace.constant = 278
            }
            
            return cell
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustConstraint()
        viewFilter.isHidden = true
        viewVoiceAssistant.isHidden = true

        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        btnVoiceAssistant.setImage(tintedImage, for: .normal)
        btnVoiceAssistant.tintColor = global.redColor
        
        textFieldSearch.attributedPlaceholder = NSAttributedString(string: "Type to search...",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        
        lblUserName.text = "\((global.appDelegate.vcObj as! ViewController).user_data_obj.user_fname!) \((global.appDelegate.vcObj as! ViewController).user_data_obj.user_lname!)"
        
        tblViewEvent.addSubview(self.refreshControl)
        
        webServiceObj.webServiceDelegate = self
        webServiceObj.get_events(page_no: page_number)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if fullNameString != "" {
            lblUserName.text = fullNameString
        }
        
        if imagePP != #imageLiteral(resourceName: "UserProfilePicture"){
            imgViewUserProfilePicture.image = imagePP
        }
        
        if imgViewUserProfilePicture.image != #imageLiteral(resourceName: "UserProfilePicture") {
            imgViewUserProfilePicture.layer.borderWidth=0.5
            imgViewUserProfilePicture.layer.masksToBounds = false
            imgViewUserProfilePicture.layer.borderColor = UIColor.white.cgColor
            imgViewUserProfilePicture.layer.cornerRadius = imgViewUserProfilePicture.frame.size.height/2
            imgViewUserProfilePicture.clipsToBounds = true
        }
        
        previousIndexPath_sideMenu.row = 0
        tableViewSideBar.reloadData()
        tblViewEvent.reloadData()
        
    }
    
    func didFinishWithError(method: String, errorMessage: String) {
        
        filterEvents(categoryId: selectedCategoryId, string: selectedSearchString)
        
        global.removeIndicatorView()

    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeViewController.handleRefresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    var isRefreshStarted = false
    
    func handleRefresh() {
        if !isRefreshStarted {
            page_number = 1;
            isRefreshStarted = true
            webServiceObj.get_events(page_no: page_number)
        }
    }
    
    func didFinishSuccessfully(method: String, dictionary: NSDictionary) {
        
        if method == webServiceObj.method_add_remove_reminder {
            
            var event_data_obj = EventData()
            
            if isFilterEnabled{
                event_data_obj = arrayFilteredData[tblCell_reminder.btnAddReminder.tag] as! EventData
            }else{
                event_data_obj = event_data_array[tblCell_reminder.btnAddReminder.tag] as! EventData
            }

            
            var message = String()
            global.removeIndicatorView()

            if tblCell_reminder.btnAddReminder.isSelected{
                tblCell_reminder.btnAddReminder.isSelected = false
                (global.appDelegate.vcObj as! ViewController).user_data_obj.reminder_arr.remove(at: (global.appDelegate.vcObj as! ViewController).user_data_obj.reminder_arr.index(of: event_data_obj.Event_id!)!)
                message = "Reminder removed successfully."
            }else{
                tblCell_reminder.btnAddReminder.isSelected = true
                (global.appDelegate.vcObj as! ViewController).user_data_obj.reminder_arr.append(event_data_obj.Event_id!)
                message = "Reminder added successfully."
            }
            global.removeIndicatorView()

            let alertV = UIAlertController(title: "STEVENS LIVE", message: message, preferredStyle: .alert)
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed")
            })
            alertV.addAction(alertOKAction)
            self.present(alertV, animated: true, completion: nil)

        }else{
            if isRefreshStarted {
                event_data_array.removeAllObjects()
            }
            
            let event_array = dictionary.object(forKey: "events_list") as! Array<Any>
            
            for events in event_array{
                let event_dict = events as! NSDictionary
                let event_id = (event_dict["EventId"] as! NSString).integerValue
                let event_data_obj = EventData.init(Event_id: event_id, Event_category: event_dict["Event_category"] as? Array, Event_date: event_dict["Event_date"] as? String, Event_time: event_dict["Event_time"] as? String, Event_name: event_dict["Event_name"] as? String, Event_location: event_dict["Event_location"] as? String, Event_description: event_dict["Event_description"] as? String)
                
                if !event_data_array.contains(event_data_obj) {
                    event_data_array.add(event_data_obj)
                }
            }
            
            let pg_no = dictionary.value(forKey: "page_number") as! Int
            if pg_no != page_number {
                page_number = pg_no
            }
            
            filterEvents(categoryId: selectedCategoryId, string: selectedSearchString)
        }
        
        global.removeIndicatorView()
    }

    
    func adjustConstraint() {
        self.view.layoutIfNeeded()
        constraintViewBackgroundTopSpace.constant = self.view.frame.height-70
        constraintBackgroundSidebarTrailing.constant = view.frame.size.width
        constraintSideBarViewLeading.constant = -280
        if global.isIphone4OrLess() {
            constraintViewCategoryHeight.constant = 40
            constraintViewFilterTopSpace.constant = 71
            constraintFilterVoiceViewHeight.constant = 70
        }else if global.isIphone5() {
            constraintViewCategoryHeight.constant = 60
            constraintViewFilterTopSpace.constant = 81
            constraintFilterVoiceViewHeight.constant = 80
        }else if global.isIphone6() {
            constraintViewFilterTopSpace.constant = 91
            constraintFilterVoiceViewHeight.constant = 90
        }else if global.isIphone6P() {
            constraintFilterVoiceViewHeight.constant = 100
        }
        constraintViewVoiceTopAlignment.constant = 600
        self.view.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        global.addIndicatorView()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
}
