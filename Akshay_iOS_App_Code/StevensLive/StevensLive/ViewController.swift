//
//  ViewController.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 31/01/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController, UITextFieldDelegate{

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
            message = "LINK HAS BEEN SENT TO YOUR EMAIL ADDRESS.";
        }else{
            message = "PLEASE ENTER A VALID STUDENT EMAIL ADDRESS.";
        }
        let alertV = UIAlertController(title: "RESET PASSWORD",
                                   message: message,
                                   preferredStyle: .alert)
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
            print("OK Button Pressed")
        })
        alertV.addAction(alertOKAction)
        self.present(alertV, animated: true, completion:nil)
        self.tField.text = "";
    }
    
    var alert = UIAlertController(title: "RESET PASSWORD", message: "ENTER YOUR EMAIL TO RECEIVE RESET PASSWORD LINK.", preferredStyle: .alert)
    
    
    @IBAction func loginClicked(_ sender: Any) {
        
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
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
        
        textFieldUsername.delegate = self;
        textFieldPassword.delegate = self;
        
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

