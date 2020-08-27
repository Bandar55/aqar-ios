//
//  SignUp_VC.swift
//  AQAR55
//
//  Created by lion on 27/02/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import Firebase

class SignUpController: UIViewController {

    
    @IBOutlet weak var txtPhoneNo: UITextField!
    
    @IBOutlet weak var txtCountryCode: UITextField!
    
    @IBOutlet weak var imgFlag: UIImageView!
    
    var countryCodeArray = NSMutableArray()
    var arrayFromPlist = NSMutableArray()
    
    var isForSignup = false
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.set(true, forKey: "NotFirstTime")
        
       // imgFlag.image = UIImage(named: "flagn_966.png")
        
      //  UserDefaults.standard.setValue("+966", forKey: "CountryCode")
        
        loadPlistDataatLoadTime()
       
            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
            {
                for i in 0 ..< self.arrayFromPlist.count
                {
                    if let dic = self.arrayFromPlist.object(at: i) as? NSDictionary
                    {
                        if countryCode == dic.object(forKey: "country_code") as! String
                        {
                        
                            let plusCCode = dic.object(forKey: "country_dialing_code") as? String ?? ""
                            
                           // self.txtCountryCode.text = plusCCode
                            
                            let dialCodeString = dic.object(forKey: "country_dialing_code") as? String ?? ""
                            
                          //  let codeForFlag: String = dialCodeString.trimmingCharacters(in: CharacterSet(charactersIn: "+"))
                            
                          //  let imageName = "flagn"+"_"+"\(codeForFlag).png"
                            
                          //  imgFlag.image = UIImage(named: imageName)
                            
                            UserDefaults.standard.setValue(plusCCode, forKey: "CountryCode")
                            
                        }
                    }
                }
            }
        
        imgFlag.image = UIImage(named: "flagn_966.png")
        
        UserDefaults.standard.setValue("+966", forKey: "CountryCode")
        
    }
    

    @IBAction func btnSubmitAction(_ sender: Any) {
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            checkValidation()
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_countryCodeBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryCodeListVC") as! CountryCodeListVC
        vc.objeCountryListDelegate = self
        present(vc, animated: true, completion: nil)
        
    }
    
}


//MARK:- Custom Method
//MARK:-
extension SignUpController{
    
    func checkValidation(){
        
        var mess = ""
        
        if txtPhoneNo.text == ""{
            
            mess = "Please enter phone number"
        }
        else if txtCountryCode.text == ""{
            
            mess = "Please select country code"
        }
        else if ((txtPhoneNo.text?.length ?? 15 > 14) || (txtPhoneNo.text?.length ?? 7 < 8)){
            
            mess = "Phone number length must be 8 - 14"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            if self.isForSignup{
                
               // sendOtpUsingFirebase()
                
                self.apiCallForCheckSignupUserUserExistance()
               
            }
            else{
                
                //first check user exist in database after that send otp on number.
                
                self.apiCallForCheckUserExistance()
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
    
    func sendOtpUsingFirebase(){
        
        let countryCode = UserDefaults.standard.value(forKey: "CountryCode") as? String ?? ""
        
        let completePhoneNumber = countryCode+txtPhoneNo.text!
        print(completePhoneNumber)
        IJProgressView.shared.showProgressView(view: self.view)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(completePhoneNumber) { (verificationID, error) in
            if let error = error {
                
                IJProgressView.shared.hideProgressView()
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something went wrong", controller: self)
                
                print(error)
                
                return
                
            }else{
                
                IJProgressView.shared.hideProgressView()
                print(verificationID!)
                UserDefaults.standard.set("\(verificationID!)", forKey: "OtpVerification")
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationController") as! VerificationController
                vc.phoneNumber = self.txtPhoneNo.text!
                
                if self.isForSignup{
                    
                    vc.isComing = "ForSignup"
                }
                else{
                    
                    vc.isComing = "ForLogin"
                }
              
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
    }
    
}


extension SignUpController{
    
    func loadPlistDataatLoadTime() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent("countryList.plist")
        let fileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath: path)) {
            
            if let bundlePath = Bundle.main.path(forResource: "countryList", ofType: "plist") {
                let rootArray = NSMutableArray(contentsOfFile: bundlePath)
                print("Bundle RecentSearch.plist file is --> \(String(describing: rootArray?.description))")
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                }
                catch _ {
                    print("Fail to copy")
                }
                print("copy")
            } else {
                print("RecentSearch.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("RecentSearch.plist already exits at path.")
            
        }
        
        let rootarray = NSMutableArray(contentsOfFile: path)
        print("Loaded RecentSearch.plist file is --> \(String(describing: rootarray?.description))")
        let array = NSMutableArray(contentsOfFile: path)
        print(array)
        if let dict = array {
            
            
            let tempArray = array!
            self.arrayFromPlist = tempArray
            var i = 0
            for index in tempArray{
                
                let dic = tempArray.object(at: i) as? NSDictionary
                i = i+1
                let code = dic?.object(forKey: "country_dialing_code") as? String
                
                let trimSring:String = code!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                let countryName = dic?.object(forKey: "country_name") as? String
                let codeString = trimSring+" "+countryName!
                
                self.countryCodeArray.add(codeString)
                
            }
            
        } else {
            print("WARNING: Couldn't create dictionary from RecentSearch.plist! Default values will be used!")
        }
    }
    
}


extension SignUpController:selectedCountry{
    
    func countryInformation(info: NSDictionary) {
        
        print(info)
        
        let code = info.object(forKey: "country_dailing_code") as? String ?? ""
        txtCountryCode.text = code
        txtCountryCode.textAlignment = .center
        
        let dialCodeString = info.object(forKey: "country_dailing_code") as? String
        let codeForFlag: String = dialCodeString!.trimmingCharacters(in: CharacterSet(charactersIn: "+"))
        let imageName = "flagn"+"_"+"\(codeForFlag).png"
        
        imgFlag.image = UIImage(named: imageName)
        
        UserDefaults.standard.setValue(code, forKey: "CountryCode")
        
    }

}



extension String{
    
    var length: Int {
        
        return characters.count
        
    }
}


//MARK:- Webservices
//MARK:-
extension SignUpController{
    
    func apiCallForCheckUserExistance(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["countryCode":txtCountryCode.text!,"mobileNumber":txtPhoneNo.text!]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForCheckExistance as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        self.sendOtpUsingFirebase()
                        
                        //uncomment firebase line before send the build and comment login api here we are using this for simulator
                        
                        //self.apiCallForLogin()
                        
                    }
                    else{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                    }
                }
                else{
                    
                     CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
    
    func apiCallForCheckSignupUserUserExistance(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["countryCode":txtCountryCode.text!,"mobileNumber":txtPhoneNo.text!]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForCheckSignupExist as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        self.sendOtpUsingFirebase()
                        
                    }
                    else{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                    }
                }
                else{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }

    
}




//seprate extension it is unusual making for simulator only to otp problem
extension SignUpController{
    
    func apiCallForLogin(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let countryCode = UserDefaults.standard.value(forKey: "CountryCode") as? String ?? ""
            
            let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String ?? ""
            
            let param = ["countryCode":countryCode,"mobileNumber":txtPhoneNo.text!,"deviceType":"IOS","deviceToken":deviceToken]
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForLogin as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "data") as? NSDictionary{
                            
                            UserDefaults.standard.set(true, forKey: "ISLOGIN")
                            
                            let token = data.object(forKey: "jwtToken") as? String ?? ""
                            
                            UserDefaults.standard.set(token, forKey: "UserAuthorizationToken")
                            
                            let name = data.object(forKey: "fullName") as? String ?? ""
                            
                            let userId = data.object(forKey: "_id") as? String ?? ""
                            
                            let createdTime = data.object(forKey: "created") as? String ?? ""
                            
                            UserDefaults.standard.set(createdTime, forKey: "ProfileCreatedTime")
                            
                            UserDefaults.standard.set(userId, forKey: "UniqueUserId")
                            
                            let currency = data.object(forKey: "currency") as? String ?? ""
                            
                            UserDefaults.standard.set("\(currency)", forKey: "GlobalCurrency")
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomePresentController") as! WelcomePresentController
                            
                            vc.objSignUpDetails = self
                            
                            vc.userName = name
                            
                            self.navigationController?.present(vc, animated: true, completion: nil)
                            
                        }
                        
                    }
                    else{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                    }
                }
                else{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
}



