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
    @IBOutlet weak var btnRememberMe: UIButton!
    
    @IBAction func loginClicked(_ sender: Any) {
        
        
    }
    
    @IBAction func rememberMeClicked(_ sender: Any) {
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldUsername.delegate = self;
        textFieldPassword.delegate = self;
                
        lblPasswordBottom.backgroundColor = UIColor.red;
        lblUsernameBottom.backgroundColor = UIColor.black;
        
        btnLogin.layer.cornerRadius = 2.0;
        btnLogin.layer.masksToBounds = true;
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textFieldUsername {
            UIView.transition(with: lblUsernameBottom, duration: 1.0, options: UIViewAnimationOptions.transitionCurlUp, animations: {
                self.lblUsernameBottom.backgroundColor = UIColor.black;
            }, completion: nil);
            UIView.transition(with: lblPasswordBottom, duration: 1.0, options: UIViewAnimationOptions.transitionCurlDown, animations: {
                self.lblPasswordBottom.backgroundColor = UIColor.red;
            }, completion: nil);

        }else{
            UIView.transition(with: lblUsernameBottom, duration: 1.0, options: UIViewAnimationOptions.transitionCurlDown, animations: {
                self.lblUsernameBottom.backgroundColor = UIColor.red;
            }, completion: nil);
            UIView.transition(with: lblPasswordBottom, duration: 1.0, options: UIViewAnimationOptions.transitionCurlUp, animations: {
                self.lblPasswordBottom.backgroundColor = UIColor.black;
            }, completion: nil);
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }

}

