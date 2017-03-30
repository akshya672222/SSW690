//
//  ViewController.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 31/01/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate, WebServicesDelegate{

    //Text fields
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    //Labels
    @IBOutlet weak var lblUsernameBottom: UILabel!
    @IBOutlet weak var lblPasswordBottom: UILabel!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    @IBOutlet weak var constraintViewTextFieldBottom: NSLayoutConstraint!
    
    var accessory_view = UIView();
    var textFieldActive = UITextField();
    var btnPrev = UIButton();
    var btnNext = UIButton();
    var btnDone = UIButton();
    let global = GlobalFunction();
    
    let webServiceObj = WebServices()
    

    var tField: UITextField!
    
    func configurationTextField(textField: UITextField!){
        textField.placeholder = "Enter your email."
        tField = textField
    }
    
    func handleCancel(alertView: UIAlertAction!){
        self.tField.text = "";
    }
    
    func handleDone(alertView: UIAlertAction){
        var message = String();
        if global.isValidEmail(testStr: self.tField.text! as String) {
            global.addIndicatorView()
            webServiceObj.forgot_password(email: self.tField.text! as String)
        }else{
            message = "PLEASE ENTER A VALID STUDENT EMAIL ADDRESS.";
            let alertV = UIAlertController(title: "RESET PASSWORD",
                                           message: message,
                                           preferredStyle: .alert)
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed")
            })
            alertV.addAction(alertOKAction)
            self.present(alertV, animated: true, completion:nil)
        }
        self.tField.text = "";
    }
    
    var alert = UIAlertController(title: "RESET PASSWORD", message: "ENTER YOUR EMAIL TO RECEIVE RESET PASSWORD LINK.", preferredStyle: .alert)
    
    
    func didFinishWithError(method: String, errorMessage: String) {
        global.removeIndicatorView()
        let alertV = UIAlertController(title: "ERROR", message: errorMessage, preferredStyle: .alert)
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
            print("OK Button Pressed")
        })
        alertV.addAction(alertOKAction)
        self.present(alertV, animated: true, completion: nil)
    }

    var cat_data_Array = Array<Any>()
    var user_data_obj = UserData()
    
    func didFinishSuccessfully(method: String, dictionary: NSDictionary) {
        print(dictionary)
        if method == webServiceObj.method_login{
            global.userdefaults.set(true, forKey: "isLogin")
            global.userdefaults.set(webServiceObj.stringEncrypt(string: textFieldPassword.text!), forKey: "password")
            global.userdefaults.set(textFieldUsername.text!, forKey: "username")
            let categoryArray = dictionary["categories"] as! NSArray
            let userDict = dictionary["user"] as! NSDictionary
            
            for categories in categoryArray{
                let cat_dict = categories as! NSDictionary
                let category_data_obj = CategoryData.init(Category_id: cat_dict["category_id"] as? Int, Category_name: cat_dict["category_name"] as? String)
                cat_data_Array.append(category_data_obj)
            }
            
            user_data_obj = UserData.init(email: userDict["email"] as? String, profile_picpath: userDict["profile_picpath"] as? String, user_fname: userDict["user_fname"] as? String, user_id: userDict["user_id"] as? Int, user_lname: userDict["user_lname"] as? String)
            
            self.performSegue(withIdentifier: "home", sender: btnLogin)
        }else if method == webServiceObj.method_forgot_password{
            global.removeIndicatorView()
            let message = "LINK HAS BEEN SENT TO YOUR EMAIL ADDRESS.";
            let alertV = UIAlertController(title: "RESET PASSWORD",
                                           message: message,
                                           preferredStyle: .alert)
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed")
            })
            alertV.addAction(alertOKAction)
            self.present(alertV, animated: true, completion:nil)
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        
        if textFieldUsername.text == ""{
            let alertV = UIAlertController(title: "ERROR", message: "ENTER YOUR EMAIL ADDRESS.", preferredStyle: .alert)
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed")
            })
            alertV.addAction(alertOKAction)
            self.present(alertV, animated: true, completion: nil)
            return
        }
        if textFieldPassword.text == ""{
            let alertV = UIAlertController(title: "ERROR", message: "ENTER YOUR PASSWORD.", preferredStyle: .alert)
            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                print("OK Button Pressed")
            })
            alertV.addAction(alertOKAction)
            self.present(alertV, animated: true, completion: nil)
            return
        }
        if !global.isValidEmail(testStr: textFieldUsername.text!){
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
        webServiceObj.loginUser(email: textFieldUsername.text!, password: textFieldPassword.text!, token: "")
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "home"{
            
            let destinationVC:HomeViewController = segue.destination as! HomeViewController
            
            //set properties on the destination view controller
            destinationVC.category_data_array = cat_data_Array
            destinationVC.user_data = user_data_obj
            
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "home"{
            return false
        }
        return true
    }
    
    
    @IBAction func forgotMeClicked(_ sender: Any) {
    
        self.present(alert, animated: true, completion: nil)
        
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
        if textFieldActive == textFieldUsername {
            bringTextFieldDown(textField: textFieldActive);
        }else if textFieldActive == textFieldPassword{
            textFieldPassword.resignFirstResponder();
            textFieldUsername.becomeFirstResponder();
        }
    }
    
    func goToNextTextField() {
        if textFieldActive == textFieldPassword{
            bringTextFieldDown(textField: textFieldActive);
        }else if textFieldActive == textFieldUsername{
            textFieldUsername.resignFirstResponder();
            textFieldPassword.becomeFirstResponder();
        }
    }

    func doneTyping() {
        bringTextFieldDown(textField: textFieldActive);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webServiceObj.webServiceDelegate = self
        
        textFieldUsername.delegate = self;
        textFieldPassword.delegate = self;

        if global.isKeyPresentInUserDefaults(key: "username"){
            textFieldUsername.text = global.userdefaults.value(forKey: "username") as! String?
        }
        if global.isKeyPresentInUserDefaults(key: "password"){
            textFieldPassword.text = webServiceObj.stringDecrypt(string: (global.userdefaults.value(forKey: "password") as! String?)!)
        }
        if global.isKeyPresentInUserDefaults(key: "isLogin"){
            global.addIndicatorView()
            webServiceObj.loginUser(email: textFieldUsername.text!, password: textFieldPassword.text!, token: "")
        }
        
        global.appDelegate.vcObj = self
        
        lblPasswordBottom.backgroundColor = global.redColor;
        lblUsernameBottom.backgroundColor = UIColor.black;
        
        btnLogin.layer.cornerRadius = 2.0;
        btnLogin.layer.masksToBounds = true;

        btnSignUp.layer.cornerRadius = 2.0;
        btnSignUp.layer.masksToBounds = true;

        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler:handleDone))
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        global.removeIndicatorView();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bringTextFieldDown(textField : UITextField) {
        textField.resignFirstResponder();
        view.layoutIfNeeded();
        constraintViewTextFieldBottom.constant = 0;
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
        
        if textField == textFieldUsername {
            UIView.transition(with: lblUsernameBottom, duration: 1.0, options: UIViewAnimationOptions.transitionCurlUp, animations: {
                self.lblUsernameBottom.backgroundColor = UIColor.black;
            }, completion: nil);
            UIView.transition(with: lblPasswordBottom, duration: 1.0, options: UIViewAnimationOptions.transitionCurlDown, animations: {
                self.lblPasswordBottom.backgroundColor = self.global.redColor;
            }, completion: nil);
        }else{
            UIView.transition(with: lblUsernameBottom, duration: 1.0, options: UIViewAnimationOptions.transitionCurlDown, animations: {
                self.lblUsernameBottom.backgroundColor = self.global.redColor;
            }, completion: nil);
            UIView.transition(with: lblPasswordBottom, duration: 1.0, options: UIViewAnimationOptions.transitionCurlUp, animations: {
                self.lblPasswordBottom.backgroundColor = UIColor.black;
            }, completion: nil);
        }
        
        view.layoutIfNeeded();
        constraintViewTextFieldBottom.constant = 165;
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded();
        });

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bringTextFieldDown(textField: textField);
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }

}

