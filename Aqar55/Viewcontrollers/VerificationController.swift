//
//  Verification_VC.swift
//  AQAR55
//
//  Created by lion on 27/02/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit
import IQKeyboardManager
import FirebaseCore
import Firebase
import FirebaseAuth

class VerificationController: UIViewController {
    
    @IBOutlet weak var view_OTP: VPMOTPView!
    @IBOutlet weak var lblVerificationText: UILabel!
    
    @IBOutlet weak var lblTimer: UILabel!
        
    var enteredOtp: String = ""
    var isComing: String = ""
    
    var counter = 60
    var timer = Timer()
    var phoneNumber = ""
    
    var getOtpStrFromDelegate = ""
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let countryCode = UserDefaults.standard.value(forKey: "CountryCode") as? String ?? ""
        
        lblVerificationText.text = "Sent to \(countryCode)\(phoneNumber)"
        
        initialSetup()
        
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        timer.invalidate()
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func tap_editBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_resendBtn(_ sender: Any) {
        
        view_OTP.initalizeUI()
        
        sendOtpUsingFirebase()
    }
    
}

extension VerificationController{
    
    @objc func timerAction() {
        
        counter -= 1
        
        if counter == -1{
            
            timer.invalidate()
        }
        else{
            
            lblTimer.text = "00:\(counter) sec"
        }
    }
    
    
    func initialSetup(){
        
        lblVerificationText.textAlignment = .justified
        view_OTP.otpFieldsCount = 6
        view_OTP.otpFieldSize = 30.0
        view_OTP.otpFieldEnteredBackgroundColor = UIColor(red: 0/255, green: 1/255, blue: 213/255, alpha: 1.0)
        view_OTP.delegate = self
        view_OTP.initalizeUI()
        view_OTP.endEditing(true)
        
    }
    
    
    func successfullFilledOtp(){
        
        IJProgressView.shared.showProgressView(view: self.view)
        
        sleep(2)
        
        let verificationID = UserDefaults.standard.value(forKey: "OtpVerification") as? String ?? ""
        
        let verificationCode = getOtpStrFromDelegate
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID as! String,
            verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                
                print(error)
                IJProgressView.shared.hideProgressView()
                
                if CommonClass.sharedInstance.isConnectedToNetwork(){
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You have entered wrong OTP", controller: self)
                }
                else{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your Internet Connection", controller: self)
                    
                }
                
                return
            }
            else{
                
                IJProgressView.shared.hideProgressView()
                
                if self.isComing == "ForSignup"{
                    
                    //signup
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpDetailController") as! SignUpDetailController
                    
                    let countryCode = UserDefaults.standard.value(forKey: "CountryCode") as? String ?? ""
                    
                    vc.countryCode = countryCode
                    vc.phoneNumber = self.phoneNumber
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else{
                    
                    //login
                    
                    self.apiCallForLogin()
                }
                
            }
        }
        
    }
    
    
 
}


//MARK:- Custom Method
//MARK:-
extension VerificationController{
    
    func sendOtpUsingFirebase(){
        
        let countryCode = UserDefaults.standard.value(forKey: "CountryCode") as? String ?? ""
        
        let completePhoneNumber = countryCode+phoneNumber
        print(completePhoneNumber)
        IJProgressView.shared.showProgressView(view: self.view)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(completePhoneNumber) { (verificationID, error) in
            if let error = error {
                
                IJProgressView.shared.hideProgressView()
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something went wrong, May be you are not connected to a network", controller: self)
                
                print(error)
                
                return
                
            }else{
                
                IJProgressView.shared.hideProgressView()
                print(verificationID!)
                UserDefaults.standard.set("\(verificationID!)", forKey: "OtpVerification")
                
            }
            
        }
    }
    
}


//MARK:- OTP View Delegate
//MARK:-
extension VerificationController: VPMOTPViewDelegate {
    
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool
    {
        print("Has entered all OTP? \(hasEntered)")
        return true
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        
        self.getOtpStrFromDelegate = "\(otpString)"
        print("OTPString: \(otpString)")

        if self.getOtpStrFromDelegate.length == 6{
            
            self.successfullFilledOtp()
        }
    }
}


//MARK:- Webservices
//MARK:-
extension VerificationController{
    
    func apiCallForLogin(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let countryCode = UserDefaults.standard.value(forKey: "CountryCode") as? String ?? ""
            
            let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String ?? ""
            
            let param = ["countryCode":countryCode,"mobileNumber":phoneNumber,"deviceType":"IOS","deviceToken":deviceToken]
            
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
