//
//  GlobalFunction.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 01/02/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import Foundation
import SystemConfiguration
import QuartzCore
import UIKit
import SVProgressHUD

class GlobalFunction{
    
    let redColor = UIColor.init(red: 157.0/255.0, green: 21.0/255.0, blue: 53.0/255.0, alpha: 1.0)
    let userdefaults = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let image_name_str = "user_image.png"
    let keyUsername = "username"
    let keyPassword = "password"
    let keyIsLogin = "isLogin"
    let keyProfilePic = "isProfilePic"
    
    func getVCObj() -> ViewController {
        return appDelegate.vcObj as! ViewController
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return userdefaults.object(forKey: key) != nil
    }
    
    func getDirectoryPath() -> String? {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return dirPath
    }
    
    func saveImage(image: UIImage, image_name: String) -> Bool {
        var image_save = false
        if let dirPath = getDirectoryPath() {
            let writePath = URL(fileURLWithPath: dirPath).appendingPathComponent(image_name)
            deleteImage(delete_path: writePath)
            try! UIImagePNGRepresentation(image)?.write(to: writePath)
            image_save = true
        }
        return image_save
    }
    
    func deleteImage(delete_path: URL){
        do{
            try FileManager.default.removeItem(at: delete_path)
        }catch{
            print("error deleting file!!!")
        }
    }
    
    func getImage(image_name: String) -> UIImage {
        var image = UIImage()
        if let dirPath = getDirectoryPath(){
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(image_name)
            image = UIImage(contentsOfFile: imageURL.path)!
        }
        return image
    }
    
    enum UIUserInterfaceIdiom : Int{
        case Unspecified
        case Phone
        case Pad
    }
    
    struct ScreenSize{
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType{
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    }
    
    func convertToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return NSDictionary()
    }
    
    func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func isIphone4OrLess() -> Bool {
        if DeviceType.IS_IPHONE_4_OR_LESS{
            return true;
        }
        return false;
    }
    func isIphone5() -> Bool {
        if DeviceType.IS_IPHONE_5{
            return true;
        }
        return false;
    }
    func isIphone6() -> Bool {
        if DeviceType.IS_IPHONE_6{
            return true;
        }
        return false;
    }
    func isIphone6P() -> Bool {
        if DeviceType.IS_IPHONE_6P{
            return true;
        }
        return false;
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@stevens.edu"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func createShadowOnView(view: UIView, color: UIColor, width: CGFloat, height: CGFloat, shadowOpacity: CGFloat, shadowRadius: CGFloat) {
        view.layer.masksToBounds = false;
        view.layer.shadowColor = color.cgColor;
        view.layer.shadowOffset = CGSize.init(width: width, height: height);
        view.layer.shadowOpacity = Float(shadowOpacity);
        view.layer.shadowRadius = shadowRadius;
    }
    
    func roundCornerOfView(view: UIView, cornerRadius: CGFloat) {
        view.layer.cornerRadius = cornerRadius;
        view.layer.masksToBounds = false;
    }
    
    func addBorderToView(view: UIView, color: UIColor, width: CGFloat) {
        view.layer.borderWidth = width;
        view.layer.borderColor = color.cgColor; 
    }
    
    func addIndicatorView() {
        UIApplication.shared.beginIgnoringInteractionEvents();
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom);
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat);
        SVProgressHUD.setBackgroundColor(redColor);
        SVProgressHUD.setBackgroundLayerColor(redColor);
        SVProgressHUD.setForegroundColor(UIColor.white);
        SVProgressHUD.show(withStatus: "Please wait...");
    }
    
    func removeIndicatorView() {
        SVProgressHUD.dismiss(withDelay: 0.0);
        UIApplication.shared.endIgnoringInteractionEvents();
    }
    
}
