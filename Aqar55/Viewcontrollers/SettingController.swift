//
//  SettingController.swift
//  AQAR55
//
//  Created by lion on 01/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit
import DropDown

class SettingController: UIViewController {

   
    @IBOutlet var switchNotification: UISwitch!
    @IBOutlet weak var aboutUsView: UIView!
    
    @IBOutlet weak var termsConditionsView: UIView!
    
    @IBOutlet weak var txtApplanguage: UITextField!
    
    @IBOutlet weak var btnAppLanguage: UIButton!
    
    @IBOutlet weak var txtSpeakLanguage: UITextField!
    
    @IBOutlet weak var btnSpeakLangugae: UIButton!
    
    @IBOutlet weak var btnCurrency: UIButton!
    
    @IBOutlet weak var txtCurrency: UITextField!
    
   
    @IBOutlet weak var btnMeasurement: UIButton!
    
    @IBOutlet weak var txtMeasurement: UITextField!
    
    let speakLangArr = ["English","Arabic"]
    let appLangArr = ["English","Arabic"]
    let currencyArr = ["USD","AED","SAR","Bond"]
    let measurementArr = ["Meter","CM","Inch","Feet","Yard"]
    
    var dropDownTag = 0
    let dropDown = DropDown()
    
    var globalDataDict = NSDictionary()
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switchNotification.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        let tapAbout = UITapGestureRecognizer(target: self, action: #selector(aboutUsTapped(gesture:)))
        self.aboutUsView.addGestureRecognizer(tapAbout)
        let tapTerms = UITapGestureRecognizer(target: self, action: #selector(termsConditionsTapped(gesture:)))
        self.termsConditionsView.addGestureRecognizer(tapTerms)
        
        apiCallForGetUserSetting()
        
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
                
                self.txtApplanguage.text = "\(item)"
            }
            else{
                
                self.txtSpeakLanguage.text = "\(item)"
            }
            
            self.apiCallForUpdateSetting()
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @objc func aboutUsTapped(gesture:UIGestureRecognizer){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUSController") as! AboutUSController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func termsConditionsTapped(gesture:UIGestureRecognizer){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermConditionsController") as! TermConditionsController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLogOutTapped(_ sender: UIButton) {
        
        self.apiCallForLogout()
    }
    
    
    @IBAction func tap_measurementBtn(_ sender: Any) {
        
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
    
    @IBAction func tap_speakLanguageBtn(_ sender: Any) {
        
        dropDownTag = 3
        dropDown.dataSource = speakLangArr
        dropDown.anchorView = btnSpeakLangugae
        dropDown.show()
    }
    
    @IBAction func tap_appLanguageBtn(_ sender: Any) {
        
        dropDownTag = 2
        dropDown.dataSource = appLangArr
        dropDown.anchorView = btnAppLanguage
        dropDown.show()
    }
    
    
    func updateElement(){
        
        txtCurrency.text = globalDataDict.object(forKey: "currency") as? String ?? ""
        txtApplanguage.text = globalDataDict.object(forKey: "appLanguage") as? String ?? ""
        txtSpeakLanguage.text = globalDataDict.object(forKey: "speakLanguage") as? String ?? ""
        txtMeasurement.text = globalDataDict.object(forKey: "measurement") as? String ?? ""
        
        let notiStatus = globalDataDict.object(forKey: "notification") as? Bool ?? false
        
        if notiStatus{
            
            switchNotification.isOn = true
        }
        else{
            
            switchNotification.isOn = false
        }
        
        switchNotification.addTarget(self, action: #selector(self.switchValueChanged(sender:)), for: UIControl.Event.valueChanged)
        
    }
    
    
    @objc func switchValueChanged(sender:UISwitch){
        
        var switchState = Bool()
        
        if sender.isOn{
            
            switchState = true
        }
        else{
            
            switchState = false
        }
        
        print(switchState)
        
        self.apiCallForUpdateNotificationStatus(status: switchState)
    }
    
}


extension SettingController{
    
    func apiCallForLogout(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForSignout as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        CommonClass.sharedInstance.redirectToLoginForExpiredToken()
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToLoginForExpiredToken()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
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
    
    
    func apiCallForGetUserSetting(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetSetting as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let dict = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            self.globalDataDict = dict
                            self.updateElement()
                        }
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToLoginForExpiredToken()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                    }
                }
                else{
                    
                   self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    func apiCallForUpdateNotificationStatus(status:Bool){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","notification":status] as [String : Any]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForChangeNotiStatus as NSString, method_type: methodType.post, params: param as! [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                           CommonClass.sharedInstance.redirectToLoginForExpiredToken()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                    }
                }
                else{
                    
                     self.navigationController?.popViewController(animated: true)
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            self.navigationController?.popViewController(animated: true)
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
    
    func apiCallForUpdateSetting(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["currency":txtCurrency.text!,"measurement":txtMeasurement.text!,"appLanguage":txtApplanguage.text!,"speakLanguage":txtSpeakLanguage.text!,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForUpdateSetting as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        let data = receivedData.object(forKey: "Data") as? NSDictionary ?? [:]
                        
                        let currency = data.object(forKey: "currency") as? String ?? ""
                        
                        UserDefaults.standard.set("\(currency)", forKey: "GlobalCurrency")
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            CommonClass.sharedInstance.redirectToLoginForExpiredToken()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
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
