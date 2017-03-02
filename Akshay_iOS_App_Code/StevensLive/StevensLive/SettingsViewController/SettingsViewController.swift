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
    
    var accessory_view = UIView();
    var textFieldActive = UITextField();
    var btnPrev = UIButton();
    var btnNext = UIButton();
    var btnDone = UIButton();
    
    
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
        if textFieldActive == textFieldUserFirstName {
            bringTextFieldDown(textField: textFieldActive);
        }else if textFieldActive == textFieldUserLAstName && !viewTextFieldFirstNameHolder.isHidden{
            textFieldUserLAstName.resignFirstResponder();
            textFieldUserFirstName.becomeFirstResponder();
        }else if textFieldActive == textFieldUpdatePassword && !viewTextFieldLastNameHolder.isHidden{
            textFieldUpdatePassword.resignFirstResponder();
            textFieldUserLAstName.becomeFirstResponder();
        }else{
            bringTextFieldDown(textField: textFieldActive);
        }
    }
    
    func goToNextTextField() {
        if textFieldActive == textFieldUserFirstName && !viewTextFieldLastNameHolder.isHidden {
            textFieldUserFirstName.resignFirstResponder();
            textFieldUserLAstName.becomeFirstResponder();
        }else if textFieldActive == textFieldUserLAstName && !viewTextFieldPasswordNameHolder.isHidden{
            textFieldUserLAstName.resignFirstResponder();
            textFieldUpdatePassword.becomeFirstResponder();
        }else if textFieldActive == textFieldUpdatePassword{
            bringTextFieldDown(textField: textFieldActive);
        }else{
            bringTextFieldDown(textField: textFieldActive);
        }
    }
    
    func doneTyping() {
        bringTextFieldDown(textField: textFieldActive);
    }
    
    func bringTextFieldDown(textField : UITextField) {
        textField.resignFirstResponder();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bringTextFieldDown(textField: textField);
        return true;
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        createInputAccessoryView();
        textField.inputAccessoryView = accessory_view;
        textFieldActive = textField;
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bringTextFieldDown(textField: textField);
    }


    @IBAction func saveSettings(_ sender: Any) {
        
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func pickImageClicked(_ sender: Any) {
        
        let alert:UIAlertController=UIAlertController(title: "PICK IMAGE", message: "CHOOSE FROM WHERE YOU WANT TO PICK IMAGE", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default){
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){
            UIAlertAction in
        }
        
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)

    }

    @IBAction func editFirstNameClicked(_ sender: Any) {
        performHideAnimationOnEditViews(view: viewTextFieldFirstNameHolder)
    }

    @IBAction func clearFirstName(_ sender: Any) {
        performCancelAnimationOnEditViews(view: viewTextFieldFirstNameHolder)
    }
    
    @IBAction func editSecondNAme(_ sender: Any) {
        performHideAnimationOnEditViews(view: viewTextFieldLastNameHolder)
    }
    
    @IBAction func clearLastName(_ sender: Any) {
        performCancelAnimationOnEditViews(view: viewTextFieldLastNameHolder)
    }

    @IBAction func editPAssword(_ sender: Any) {
        performHideAnimationOnEditViews(view: viewTextFieldPasswordNameHolder)
    }
    
    @IBAction func clearPassword(_ sender: Any) {
        performCancelAnimationOnEditViews(view: viewTextFieldPasswordNameHolder)
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
        
        textFieldUpdatePassword.delegate = self;
        textFieldUserLAstName.delegate = self;
        textFieldUserFirstName.delegate = self;
    
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
    
    var imagePicker = UIImagePickerController();
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            self .present(imagePicker, animated: true, completion: nil);
        }else{
            let alertV = UIAlertController(title: "ERROR",
                                           message: "DEVICE DOES NOT HAVE ANY CAMERA.",
                                           preferredStyle: .alert);
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed");
            })
            alertV.addAction(alertOKAction);
            self.present(alertV, animated: true, completion:nil);
            
        }
    }
    func openGallary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        self.present(imagePicker, animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil);
        imgViewUserProfilePicture.image = info[UIImagePickerControllerOriginalImage] as? UIImage;
        
        imgViewUserProfilePicture.layer.borderWidth=0.5
        imgViewUserProfilePicture.layer.masksToBounds = false
        imgViewUserProfilePicture.layer.borderColor = UIColor.white.cgColor
        imgViewUserProfilePicture.layer.cornerRadius = imgViewUserProfilePicture.frame.size.height/2
        imgViewUserProfilePicture.clipsToBounds = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil);
    }

    
}
