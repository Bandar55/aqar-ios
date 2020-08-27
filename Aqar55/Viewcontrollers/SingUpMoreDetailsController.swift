//
//  SingUpMoreDetailsController.swift
//  Aqar55
//
//  Created by Amit Singh on 05/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import DropDown

class SingUpMoreDetailsController: UIViewController {

    @IBOutlet weak var lblTermsAndConditions: UILabel!
    
    @IBOutlet weak var btnCountry: UIButton!
    
    @IBOutlet weak var txtCountry: UITextField!
    
    @IBOutlet weak var btnCurrency: UIButton!
    
    @IBOutlet weak var txtCurrency: UITextField!
    
    @IBOutlet weak var btnMeasurement: UIButton!
    
    @IBOutlet weak var txtMeasurement: UITextField!
    
    @IBOutlet weak var btnAppLanguage: UIButton!
    
    @IBOutlet weak var txtAppLanguage: UITextField!
    
    @IBOutlet weak var btnSpeakLanguage: UIButton!
    
    @IBOutlet weak var txtSpeakLanguage: UITextField!
    
    @IBOutlet weak var btnTerms: UIButton!
    
    
    //last controller passed data
    var name = ""
    var email = ""
    var birthYear = ""
    var gender = ""
    var category = ""
    var subCategory = ""
    var countryCode = ""
    var phoneNo = ""
    //
    
    let speakLangArr = ["English","Arabic"]
    let appLangArr = ["English","Arabic"]
    let currencyArr = ["USD","AED","SAR","Bond"]
    let measurementArr = ["Meter","CM","Inch","Feet","Yard"]
    
    var dropDownTag = 0
    let dropDown = DropDown()
    let connection = webservices()
    
    var termsCheck = true
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string:  "I agree Terms & Conditions")
        
        attributedString.setColorForText("I agree", with: UIColor.black)
            attributedString.setColorForText("Terms & Conditions", with: UIColor(red: 15/255, green: 0/255, blue: 227/255, alpha: 1.0));
        lblTermsAndConditions.attributedText = attributedString
        
        btnTerms.setImage(UIImage(named: "done_tick"), for: .normal)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if self.dropDownTag == 0{
            
                self.txtCurrency.text = "\(item)"
            }
            else if self.dropDownTag == 1{
                
                self.txtMeasurement.text = "\(item)"
            }
            else if self.dropDownTag == 2{
                
                self.txtAppLanguage.text = "\(item)"
            }
            else{
                
                self.txtSpeakLanguage.text = "\(item)"
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func tap_viewTermsAndConditionBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermConditionsController") as! TermConditionsController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomePresentController") as! WelcomePresentController
//        vc.objSignUpDetails = self
//        self.navigationController?.present(vc, animated: true, completion: nil)
        
        checkValidation()
    }
    
    
    @IBAction func tap_termsBtn(_ sender: Any) {
        
        if termsCheck == true{
            
            btnTerms.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
            termsCheck = false
        }
        else{
            
            btnTerms.setImage(UIImage(named: "done_tick"), for: .normal)
            termsCheck = true
        }
    }
    
    @IBAction func tap_speakLanguageBtn(_ sender: Any) {
        
        dropDownTag = 3
        dropDown.dataSource = speakLangArr
        dropDown.anchorView = btnSpeakLanguage
        dropDown.show()
    }
    
    @IBAction func tap_appLanguageBtn(_ sender: Any) {
        
        dropDownTag = 2
        dropDown.dataSource = appLangArr
        dropDown.anchorView = btnAppLanguage
        dropDown.show()
    }
    
    @IBAction func tap_selectMeasurementBtn(_ sender: Any) {
        
        dropDownTag = 1
        dropDown.dataSource = measurementArr
        dropDown.anchorView = btnMeasurement
        dropDown.show()
    }
    
    @IBAction func tap_currencyBtn(_ sender: Any) {
        
        dropDownTag = 0
        dropDown.dataSource = currencyArr
        dropDown.anchorView = btnCurrency
        dropDown.show()
    }
    
    @IBAction func tap_countryBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryCodeListVC") as! CountryCodeListVC
        vc.objeCountryListDelegate = self
        present(vc, animated: true, completion: nil)
        
    }
    
    
    
}
extension NSMutableAttributedString
{
    func setColorForText(_ textToFind: String, with color: UIColor)
    {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor , value: color, range: range)
        }
    }
}


extension SingUpMoreDetailsController:selectedCountry{
    
    func countryInformation(info: NSDictionary) {
        
        print(info)
        
        let countryName = info.object(forKey: "country_name") as? String ?? ""
        self.txtCountry.text = countryName
        
    }
    
}


extension SingUpMoreDetailsController{
    
    func checkValidation(){
        
        var mess = ""
        
        if txtCountry.text == ""{
            
            mess = "Please enter country name"
        }
        else if txtCurrency.text == ""{
            
            mess = "Please select currency"
        }
        else if txtMeasurement.text == ""{
            
            mess = "Please enter measurement"
        }
        else if txtAppLanguage.text == ""{
            
            mess = "Please select app language"
        }
        else if txtSpeakLanguage.text == ""{
            
            mess = "Please select speak language"
        }
        else if termsCheck == false{
            
            mess = "Please check Terms and Conditions"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            self.apiCallForSignup()
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
    func apiCallForSignup(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String ?? ""
            
            let param = ["deviceType":"IOS","deviceToken":deviceToken,"countryCode":countryCode,"mobileNumber":phoneNo,"fullName":name,"category":category,"subCategory":subCategory,"gender":gender,"birthDate":birthYear,"email":email,"country":txtCountry.text!,"currency":txtCurrency.text!,"measurement":txtMeasurement.text!,"appLanguage":txtAppLanguage.text!,"speakLanguage":txtSpeakLanguage.text!]
            
            IJProgressView.shared.showProgressView(view: self.view)

            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForSignup as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
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
