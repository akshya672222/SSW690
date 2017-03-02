//
//  RegistrationViewController.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 27/02/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class RegistrationViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var textFieldEmail: UITextField!

    @IBOutlet weak var textFieldUsername: UITextField!

    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    
    @IBOutlet weak var textFieldFullName: UITextField!
    
    @IBOutlet weak var imageViewUserProfilePicture: UIImageView!
    
    @IBOutlet weak var constraintTextFieldHolderViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var constraintTextFieldHolderViewTop: NSLayoutConstraint!
    
    var accessory_view = UIView();
    var textFieldActive = UITextField();
    var btnPrev = UIButton();
    var btnNext = UIButton();
    var btnDone = UIButton();
    var global = GlobalFunction();
    
//    var tfEmail = UITextField();
//    var tfFirstName = UITextField();
//    var tfLastName = UITextField();
//    var tfPassword = UITextField();
//    var tfConfirmPassword = UITextField();

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
        if textFieldActive == textFieldEmail {
            bringTextFieldDown(textField: textFieldActive);
        }else if textFieldActive == textFieldUsername{
            textFieldUsername.resignFirstResponder();
            textFieldEmail.becomeFirstResponder();
        }else if textFieldActive == textFieldPassword{
            textFieldPassword.resignFirstResponder();
            textFieldUsername.becomeFirstResponder();
        }else if textFieldActive == textFieldConfirmPassword{
            textFieldConfirmPassword.resignFirstResponder();
            textFieldPassword.becomeFirstResponder();
        }else if textFieldActive == textFieldFullName{
            textFieldFullName.resignFirstResponder();
            textFieldConfirmPassword.becomeFirstResponder();
        }
    }
    
    func goToNextTextField() {
        if textFieldActive == textFieldEmail {
            textFieldEmail.resignFirstResponder();
            textFieldUsername.becomeFirstResponder();
        }else if textFieldActive == textFieldUsername{
            textFieldUsername.resignFirstResponder();
            textFieldPassword.becomeFirstResponder();
        }else if textFieldActive == textFieldPassword{
            textFieldPassword.resignFirstResponder();
            textFieldConfirmPassword.becomeFirstResponder();
        }else if textFieldActive == textFieldConfirmPassword{
            textFieldConfirmPassword.resignFirstResponder();
            textFieldFullName.becomeFirstResponder();
        }else if textFieldActive == textFieldFullName{
            bringTextFieldDown(textField: textFieldActive);
        }
    }
    
    func doneTyping() {
        bringTextFieldDown(textField: textFieldActive);
    }

    func bringTextFieldDown(textField : UITextField) {
        textField.resignFirstResponder();
        view.layoutIfNeeded();
        constraintTextFieldHolderViewTop.constant = 0;
        constraintTextFieldHolderViewBottom.constant = 40;
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded();
        });
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bringTextFieldDown(textField: textField);
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        createInputAccessoryView();
        textField.inputAccessoryView = accessory_view;
        textFieldActive = textField;
        var viewShift = 0;
        if textField == textFieldEmail {
            viewShift = 0;
        }else if textField == textFieldUsername{
            viewShift = 0;
        }else if textField == textFieldPassword{
            viewShift = 80;
        }else if textField == textFieldConfirmPassword{
            viewShift = 120;
        }else if textField == textFieldFullName{
            viewShift = 170;
        }
        view.layoutIfNeeded();
        constraintTextFieldHolderViewTop.constant = -(CGFloat)(viewShift);
        constraintTextFieldHolderViewBottom.constant = CGFloat(viewShift)+40;
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded();
        });
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bringTextFieldDown(textField: textField);
    }
    
    func setBordorColorToTextField(textField: UITextField) {
        textField.layer.borderColor = global.redColor.cgColor;
        textField.layer.borderWidth = 1.0;
        textField.layer.cornerRadius = 2.0;
        textField.layer.masksToBounds = true;
    }
    
    func setLeftView(textField: UITextField) {
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10));
        textField.leftViewMode = UITextFieldViewMode.always;
        textField.leftView = spacerView;
    }
    
    func setFontSize(textField: UITextField) {
        let font = textField.font;
        if global.isIphone4OrLess() {
            textField.font = font?.withSize(8);
        }else if global.isIphone5() {
            textField.font = font?.withSize(11);
        }else if global.isIphone6(){
            textField.font = font?.withSize(14);
        }else if global.isIphone6P(){
            textField.font = font?.withSize(16);
        }
    }
    
    func setupTextFields(textField: UITextField) {
        setBordorColorToTextField(textField: textField);
        setLeftView(textField: textField);
        setFontSize(textField: textField);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldEmail.delegate = self;
        textFieldUsername.delegate = self;
        textFieldPassword.delegate = self;
        textFieldConfirmPassword.delegate = self;
        textFieldFullName.delegate = self;
        
//        var tfEmail = textFieldEmail;
//        var tfFirstName = textFieldUsername;
//        var tfLastName = textFieldPassword;
//        var tfPassword = textFieldConfirmPassword;
//        var tfConfirmPassword = textFieldFullName;

        setupTextFields(textField: textFieldEmail);
        setupTextFields(textField: textFieldUsername);
        setupTextFields(textField: textFieldPassword);
        setupTextFields(textField: textFieldConfirmPassword);
        setupTextFields(textField: textFieldFullName);

        btnRegister.layer.cornerRadius = 2.0;
        btnRegister.layer.masksToBounds = true;
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func backClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil);
        
    }
    
    var imagePicker = UIImagePickerController();

    @IBAction func captureUserImageClicked(_ sender: Any) {
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
        imageViewUserProfilePicture.image = info[UIImagePickerControllerOriginalImage] as? UIImage;
        
        imageViewUserProfilePicture.layer.borderWidth=0.5
        imageViewUserProfilePicture.layer.masksToBounds = false
        imageViewUserProfilePicture.layer.borderColor = UIColor.white.cgColor
        imageViewUserProfilePicture.layer.cornerRadius = imageViewUserProfilePicture.frame.size.height/2
        imageViewUserProfilePicture.clipsToBounds = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil);
    }
    
    
    @IBAction func registerClicked(_ sender: Any) {
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "registerSuccess") {
            //get a reference to the destination view controller
            let destinationVC:HomeViewController = segue.destination as! HomeViewController
            
            //set properties on the destination view controller
            if self.textFieldFullName.text != "" {
                destinationVC.fullNameString = self.textFieldFullName.text! as String;
            }
            if imageViewUserProfilePicture.image != #imageLiteral(resourceName: "UserProfilePicture") {
                destinationVC.imagePP = imageViewUserProfilePicture.image!;
            }
        }
    }
    
}
