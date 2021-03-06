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

class RegistrationViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WebServicesDelegate{

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
    let webServiceObj = WebServices()
    var is_profile_pic = Bool()
    var user_image = UIImage()
    
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
        
        webServiceObj.webServiceDelegate = self
        
        textFieldEmail.delegate = self;
        textFieldUsername.delegate = self;
        textFieldPassword.delegate = self;
        textFieldConfirmPassword.delegate = self;
        textFieldFullName.delegate = self;
        
        setupTextFields(textField: textFieldEmail);
        setupTextFields(textField: textFieldUsername);
        setupTextFields(textField: textFieldPassword);
        setupTextFields(textField: textFieldConfirmPassword);
        setupTextFields(textField: textFieldFullName);

        btnRegister.layer.cornerRadius = 2.0;
        btnRegister.layer.masksToBounds = true;
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        global.removeIndicatorView();
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
        var removePic = UIAlertAction()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){
            UIAlertAction in
        }
        
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        if is_profile_pic {
            removePic = UIAlertAction(title: "Remove Image", style: UIAlertActionStyle.default, handler: { UIAlertAction in
                self.imageViewUserProfilePicture.image = #imageLiteral(resourceName: "UserProfilePicture")
                self.is_profile_pic = false
            })
            alert.addAction(removePic)
        }
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
        
        is_profile_pic = true
        
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
    
    
    func didFinishWithError(method: String, errorMessage: String) {
        global.removeIndicatorView()
        let alertV = UIAlertController(title: "ERROR", message: errorMessage, preferredStyle: .alert)
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
            print("OK Button Pressed")
        })
        alertV.addAction(alertOKAction)
        self.present(alertV, animated: true, completion: nil)
    }
    
    
//    var cat_data_Array = Array<Any>()
//    var user_data_obj = UserData()
    
    func didFinishSuccessfully(method: String, dictionary: NSDictionary) {
        print(dictionary)
        if method == webServiceObj.method_registration {
            if is_profile_pic{
                let pathArray = [global.getDirectoryPath()!, global.image_name_str]
                let filePath = URL(string: pathArray.joined(separator: "/"))
                if global.saveImage(image: imageViewUserProfilePicture.image!, image_name: global.image_name_str){
                    global.userdefaults.set(true, forKey: global.keyProfilePic)
                }else{
                    global.userdefaults.set(false, forKey: global.keyProfilePic)
                }
                print(filePath!)
            }else{
                global.userdefaults.set(false, forKey: global.keyProfilePic)
            }
            global.userdefaults.set(webServiceObj.stringEncrypt(string: textFieldConfirmPassword.text!), forKey: global.keyPassword)
            global.userdefaults.set(textFieldEmail.text!, forKey: global.keyUsername)
            global.userdefaults.synchronize()
            let alertV = UIAlertController(title: "STEVENS LIVE", message: dictionary["message"] as? String, preferredStyle: .alert)
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                self.global.addIndicatorView()
                self.webServiceObj.loginUser(email: self.textFieldEmail.text!, password: self.textFieldConfirmPassword.text!, token: "")
            })
            alertV.addAction(alertOKAction)
            global.removeIndicatorView()
            self.present(alertV, animated: true, completion: nil)
        }else if method == webServiceObj.method_login{
            global.userdefaults.set(true, forKey: global.keyIsLogin)
            global.userdefaults.synchronize()
            let categoryArray = dictionary["categories"] as! NSArray
            let userDict = dictionary["user"] as! NSDictionary
            let subscription_array = dictionary["Subscription"] as! Array<Int>
            let reminder_array = dictionary["Reminders"] as! Array<Int>

            (global.getVCObj()).cat_data_Array = Array<Any>()
            (global.getVCObj()).user_data_obj = UserData()

            for categories in categoryArray{
                let cat_dict = categories as! NSDictionary
                let category_data_obj = CategoryData.init(Category_id: cat_dict["category_id"] as? Int, Category_name: cat_dict["category_name"] as? String)
                (global.getVCObj()).cat_data_Array.append(category_data_obj)
            }
            
            (global.getVCObj()).user_data_obj = UserData.init(email: userDict["email"] as? String, profile_picpath: userDict["profile_picpath"] as? String, user_fname: userDict["user_fname"] as? String, user_id: userDict["user_id"] as? Int, user_lname: userDict["user_lname"] as? String, subscription_arr: subscription_array, reminder_arr: reminder_array, is_profile_pic: is_profile_pic)
                        
            self.performSegue(withIdentifier: "registerSuccess", sender: btnRegister)
        }
    }

    
    @IBAction func registerClicked(_ sender: Any) {
        if textFieldEmail.text == ""{
            let alertV = UIAlertController(title: "ERROR", message: "ENTER YOUR EMAIL ADDRESS.", preferredStyle: .alert)
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed")
            })
            alertV.addAction(alertOKAction)
            self.present(alertV, animated: true, completion: nil)
            return
        }
        if textFieldUsername.text == ""{
            let alertV = UIAlertController(title: "ERROR", message: "ENTER YOUR FIRST NAME.", preferredStyle: .alert)
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed")
            })
            alertV.addAction(alertOKAction)
            self.present(alertV, animated: true, completion: nil)
            return
        }
        if textFieldPassword.text == ""{
            let alertV = UIAlertController(title: "ERROR", message: "ENTER YOUR LAST NAME.", preferredStyle: .alert)
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed")
            })
            alertV.addAction(alertOKAction)
            self.present(alertV, animated: true, completion: nil)
            return
        }
        if textFieldConfirmPassword.text == ""{
            let alertV = UIAlertController(title: "ERROR", message: "ENTER YOUR PASSWORD.", preferredStyle: .alert)
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed")
            })
            alertV.addAction(alertOKAction)
            self.present(alertV, animated: true, completion: nil)
            return
        }
        if textFieldFullName.text == ""{
            let alertV = UIAlertController(title: "ERROR", message: "PLEASE CONFIRM YOUR PASSWORD.", preferredStyle: .alert)
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed")
            })
            alertV.addAction(alertOKAction)
            self.present(alertV, animated: true, completion: nil)
            return
        }
        if textFieldConfirmPassword.text != textFieldFullName.text {
            let alertV = UIAlertController(title: "ERROR", message: "BOTH PASSWORD DOESN'T MATCH.", preferredStyle: .alert)
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed")
            })
            alertV.addAction(alertOKAction)
            self.present(alertV, animated: true, completion: nil)
            return
        }
        if !global.isValidEmail(testStr: textFieldEmail.text!){
            let alertV = UIAlertController(title: "ERROR", message: "PLEASE ENTER VALID STEVENS EMAIL ADDRESS.", preferredStyle: .alert)
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed")
            })
            alertV.addAction(alertOKAction)
            self.present(alertV, animated: true, completion: nil)
            return
        }
        if !global.isInternetAvailable(){
            let alertV = UIAlertController(title: "ERROR", message: "PROBLEM CONNECTING INTERNET, PLEASE CHECK YOUR INTERNET CONNECTION AND TRY AGAIN.", preferredStyle: .alert)
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed")
            })
            alertV.addAction(alertOKAction)
            self.present(alertV, animated: true, completion: nil)
            return
        }
        global.addIndicatorView();
        webServiceObj.registerUser(email: textFieldEmail.text!, first_name: textFieldUsername.text!, last_name: textFieldPassword.text!, password: textFieldConfirmPassword.text!)

//        webServiceObj.registerUser(email: textFieldEmail.text!, first_name: textFieldUsername.text!, last_name: textFieldPassword.text!, password: textFieldConfirmPassword.text!, image_name: image_name, image: imageViewUserProfilePicture.image)

    
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "registerSuccess" {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
}
