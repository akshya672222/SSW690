//
//  SettingsViewController.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 01/03/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class SettingsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var viewTopBar: UIView!
    
    @IBOutlet weak var viewEditFirstName: UIView!
    @IBOutlet weak var viewImageHolder: UIView!
    @IBOutlet weak var viewEditLastName: UIView!
    @IBOutlet weak var viewEditPassword: UIView!
    @IBOutlet weak var viewEditPush: UIView!
    @IBOutlet weak var viewShowFirstName: UIView!
    @IBOutlet weak var viewShowLastName: UIView!
    @IBOutlet weak var viewShowPassword: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnPickImage: UIButton!
    
    @IBOutlet weak var imgViewUserProfilePicture: UIImageView!
    @IBOutlet weak var lblUserFirstName: UILabel!
    
    @IBOutlet weak var btnEditUserFirstName: UIButton!
    
    @IBOutlet weak var textFieldUserFirstName: UITextField!
    
    @IBOutlet weak var lblUserLAstName: UILabel!
    
    @IBOutlet weak var textFieldUserLAstName: UITextField!
    
    @IBOutlet weak var btnClearUserFirstName: UIButton!
    
    @IBOutlet weak var lblUserPassword: UILabel!
    
    @IBOutlet weak var textFieldUpdatePassword: UITextField!
    
    let global = GlobalFunction();
    
    @IBOutlet weak var viewTextFieldFirstNameHolder: UIView!
    @IBOutlet weak var viewTextFieldLastNameHolder: UIView!
    @IBOutlet weak var viewTextFieldPasswordNameHolder: UIView!

    
    
    @IBAction func saveSettings(_ sender: Any) {
        
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func pickImageClicked(_ sender: Any) {
    }

    @IBAction func editFirstNameClicked(_ sender: Any) {
        performHideAnimationOnEditViews(view: viewTextFieldFirstNameHolder)
    }

    @IBAction func clearFirstName(_ sender: Any) {
        performCancelAnimationOnEditViews(view: viewTextFieldFirstNameHolder)
    }
    
    @IBAction func editSecondNAme(_ sender: Any) {
    }
    
    @IBAction func clearLastName(_ sender: Any) {
    }

    @IBAction func editPAssword(_ sender: Any) {
    }
    
    @IBAction func clearPassword(_ sender: Any) {
    }
    
    @IBOutlet weak var switch_email: UISwitch!
    
    @IBAction func switchEmail(_ sender: Any) {
    }
    
    @IBOutlet weak var switch_mobile: UISwitch!
    
    @IBAction func switchMobile(_ sender: Any) {
    }
    
    func performHideAnimationOnEditViews(view: UIView) {
        view.isHidden = false;
        view.alpha = 0.0;
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { 
            view.alpha = 1.0;
        }, completion: nil);
    }
    
    func performCancelAnimationOnEditViews(view: UIView) {
        
        textFieldUserLAstName.resignFirstResponder()
        textFieldUserFirstName.resignFirstResponder()
        textFieldUpdatePassword.resignFirstResponder()
        
        view.alpha = 1.0;
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            view.alpha = 0.0;
        }, completion: { (true) in
            view.isHidden = true;
        });
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        global.createShadowOnView(view: viewEditPush, color: UIColor.black, width: 0.0, height: 2.0, shadowOpacity: 1.0, shadowRadius: 1.5);
        global.createShadowOnView(view: viewImageHolder, color: UIColor.black, width: 0.0, height: 2.0, shadowOpacity: 1.0, shadowRadius: 1.5);
        global.createShadowOnView(view: viewEditLastName, color: UIColor.black, width: 0.0, height: 2.0, shadowOpacity: 1.0, shadowRadius: 1.5);
        global.createShadowOnView(view: viewEditPassword, color: UIColor.black, width: 0.0, height: 2.0, shadowOpacity: 1.0, shadowRadius: 1.5);
        global.createShadowOnView(view: viewEditFirstName, color: UIColor.black, width: 0.0, height: 2.0, shadowOpacity: 1.0, shadowRadius: 1.5);
        global.createShadowOnView(view: viewTopBar, color: UIColor.black, width: 0.0, height: 2.0, shadowOpacity: 1.0, shadowRadius: 1.5);

        btnSave.layer.cornerRadius = 2.0;
        btnSave.layer.masksToBounds = true;
        
        lblUserLAstName.text = "AKSHAY"
        lblUserFirstName.text = "EVIL"
        lblUserPassword.text = "*********"
    
        textFieldUserFirstName.attributedPlaceholder = NSAttributedString(string: "FIRST NAME",
                                                                   attributes: [NSForegroundColorAttributeName: UIColor.white])
        textFieldUpdatePassword.attributedPlaceholder = NSAttributedString(string: "PASSWORD",
                                                                          attributes: [NSForegroundColorAttributeName: UIColor.white])
        textFieldUserLAstName.attributedPlaceholder = NSAttributedString(string: "LAST NAME",
                                                                          attributes: [NSForegroundColorAttributeName: UIColor.white])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        global.roundCornerOfView(view: viewShowLastName, cornerRadius: viewShowLastName.frame.size.height/2);
        global.roundCornerOfView(view: viewShowPassword, cornerRadius: viewShowPassword.frame.size.height/2);
        global.roundCornerOfView(view: viewShowFirstName, cornerRadius: viewShowFirstName.frame.size.height/2);

    }
    
}
