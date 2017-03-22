//
//  WebServices.swift
//  StevensLive
//
//  Created by AKSHAY SUNDERWANI on 14/03/17.
//  Copyright © 2017 AKSHAY SUNDERWANI. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit
import Alamofire
import CryptoSwift

extension String {
    func aesEncrypt(key: String, iv: String) throws -> String {
        let data = self.data(using: .utf8)!
        let encrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
    }
    
    func aesDecrypt(key: String, iv: String) throws -> String {
        let data = Data(base64Encoded: self)!
        let decrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }
}

protocol WebServicesDelegate {
    
    func didFinishSuccessfully(method: String, dictionary: NSDictionary)
    func didFinishWithError(method: String, errorMessage: String)
    
}

class WebServices {
    
    var webServiceDelegate: WebServicesDelegate?
    let globalFunction = GlobalFunction()
    
    let key = "n3x3K25Cn4BiNEhg3Ahn14CQG0ez8uju"
    let iv = "3C4549AA4F6B2A6F"
    let url_local = "http://127.0.0.1:5000/"
    let url_web = "http://ec2-35-163-201-39.us-west-2.compute.amazonaws.com/"
    
    let method_login = "login"
    let method_registration = "register"
    let method_event_list = "event_list"
    let method_add_reminder = "add_reminder"
    let method_forgot_password = "forgot_password"

    func stringEncrypt(string : String) -> String {
        var encryptString = String()
        
        encryptString = try! string.aesEncrypt(key: key, iv: iv)
        
        return encryptString
    }
    
    func stringDecrypt(string : String) -> String {
        var decryptString = String()
        
        decryptString = try! string.aesDecrypt(key: key, iv: iv)
        
        return decryptString
    }
    
    func loginUser(email: String, password: String, token: String) {
        
        let parameters: Parameters = [
            "email":email,
            "password":password,
            "token":token
        ]
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(String.init(format: "%@%@", url_local, method_login), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                if !(response.result.error != nil){
                    let dict = response.result.value as! NSDictionary
                    if dict.value(forKey: "status code") != nil{
                        if dict.value(forKey: "status code") as! NSInteger == 200{
                            self.webServiceDelegate?.didFinishSuccessfully(method: self.method_login as String, dictionary: dict)
                        }else{
                            self.webServiceDelegate?.didFinishWithError(method: self.method_login, errorMessage: dict.value(forKey: "message") as! String)
                        }
                    }else{
                        self.webServiceDelegate?.didFinishWithError(method: self.method_login, errorMessage: "Request Error")
                    }
                }else{
                    self.webServiceDelegate?.didFinishWithError(method: self.method_login, errorMessage: (response.result.error?.localizedDescription)!)
                }
                
        }
    }
    
    func registerUser(email: String, first_name: String, last_name: String, password: String, image_name: String? = "",image: UIImage? = nil) {
        
        var postString = String()
        
        postString = String.init(format: "[{\"email\":\"%@\",\"first_name\":\"%@\",\"last_name\":\"%@\",\"password\":\"%@\"}]", email, first_name, last_name, password)
        
        let mutableData = NSMutableData()
        let stringBoundary = "*****"
        let headerBoundary = String.init(format: "multipart/form-data; boundary=%@", stringBoundary)
        
        mutableData.append(String.init(format: "--%@\r\n", stringBoundary).data(using: String.Encoding.ascii)!)
        
        mutableData.append("Content-Disposition: form-data; name=\"data\"\r\n\r\n".data(using: String.Encoding.ascii)!)
        
        mutableData.append(postString.data(using: String.Encoding.ascii)!)
        
        mutableData.append(String.init(format: "\r\n--%@--\r\n", stringBoundary).data(using: String.Encoding.ascii)!)
        
        mutableData.append(String.init(format: "--%@\r\n", stringBoundary).data(using: String.Encoding.ascii)!)
        
        mutableData.append(String.init(format: "--%@\r\n", stringBoundary).data(using: String.Encoding.ascii)!)

        if image_name != "" {
         
            mutableData.append(String.init(format: "Content-Disposition: form-data; name=\"pic_path\"; filename=\"%@.jpeg\"\r\n", image_name!).data(using: String.Encoding.ascii)!)
            
            mutableData.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.ascii)!)
            
            mutableData.append(UIImageJPEGRepresentation(image!, 1.0)!)
            
            let imageSize: Int = UIImageJPEGRepresentation(image!, 1.0)!.count
            print("size of image in KB: %f ", imageSize / 1024)
            
            mutableData.append(String.init(format: "\r\n--%@--\r\n", stringBoundary).data(using: String.Encoding.ascii)!)
            
            mutableData.append(String.init(format: "--%@\r\n", stringBoundary).data(using: String.Encoding.ascii)!)

        }
        
        print()
        
        let url = String.init(format: "%@%@", url_local, method_registration)
//        let url2 = "http://127.0.0.1/test/test.php"

        
        let request = NSMutableURLRequest()
        request.setValue("1.0", forHTTPHeaderField: "API_Version")
        request.setValue("ios", forHTTPHeaderField: "Devicetype")
//        request.setValue("cipher", forHTTPHeaderField: "Cipher")
        request.url = NSURL.init(string: url) as URL?
        request.httpMethod = "POST"
        request.httpBody = mutableData as Data
        request.setValue(headerBoundary, forHTTPHeaderField: "Content-Type")
        let postLength = mutableData.length
        request.setValue(String.init(format: "%d", postLength), forHTTPHeaderField: "Content-Length")
        
    
        if globalFunction.isInternetAvailable() {
            
            let session = URLSession.shared
            session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                // Handle incoming data like you would in synchronous request
                if (error != nil){
                    print(error!)
                    self.webServiceDelegate?.didFinishWithError(method: self.method_registration, errorMessage: (error?.localizedDescription)!)
                }else{
                    print(response!)
                    let reply = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    let dict = self.globalFunction.convertToDictionary(text: reply as! String)! as NSDictionary
                    if dict.value(forKey: "status code") != nil{
                        if dict["status code"] as! Int == 200{
                            self.webServiceDelegate?.didFinishSuccessfully(method: self.method_registration as String, dictionary: dict)
                        }else{
                            self.webServiceDelegate?.didFinishWithError(method: self.method_registration, errorMessage: dict["message"] as! String)
                        }
                    }else{
                        self.webServiceDelegate?.didFinishWithError(method: self.method_registration, errorMessage:"Request Error")
                    }
                }
                
            }.resume()
            
        }
        
    }
    
    func getEventsList(pageNo: Int, lastmodifytime: String) {
        let parameters: Parameters = [
            "pageNo":pageNo,
            "lastmodifytime":lastmodifytime,
        ]
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(String.init(format: "%@%@", url_local, method_event_list), method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                if !(response.result.error != nil){
                    let dict = response.result.value as! NSDictionary
                    if dict.value(forKey: "status code") != nil{
                        if dict.value(forKey: "status code") as! NSInteger == 200{
                            self.webServiceDelegate?.didFinishSuccessfully(method: self.method_event_list as String, dictionary: dict)
                        }else{
                            self.webServiceDelegate?.didFinishWithError(method: self.method_event_list, errorMessage: dict.value(forKey: "message") as! String)
                        }
                    }else{
                        self.webServiceDelegate?.didFinishWithError(method: self.method_event_list, errorMessage: "Request Error")
                    }
                }else{
                    self.webServiceDelegate?.didFinishWithError(method: self.method_event_list, errorMessage: (response.result.error?.localizedDescription)!)
                }
                
        }

    }
    
    func forgot_password(email: String) {
        
        let parameters: Parameters = [
            "email" : email
        ]
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        Alamofire.request(String.init(format: "%@%@", url_local, method_forgot_password), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                if !(response.result.error != nil){
                    let dict = response.result.value as! NSDictionary
                    if dict.value(forKey: "status code") != nil{
                        if dict.value(forKey: "status code") as! NSInteger == 200{
                            self.webServiceDelegate?.didFinishSuccessfully(method: self.method_forgot_password as String, dictionary: dict)
                        }else{
                            self.webServiceDelegate?.didFinishWithError(method: self.method_forgot_password, errorMessage: dict.value(forKey: "message") as! String)
                        }
                    }else{
                        self.webServiceDelegate?.didFinishWithError(method: self.method_forgot_password, errorMessage: "Request Error")
                    }
                }else{
                    self.webServiceDelegate?.didFinishWithError(method: self.method_forgot_password, errorMessage: (response.result.error?.localizedDescription)!)
                }
                
        }
        
    }
    
}
