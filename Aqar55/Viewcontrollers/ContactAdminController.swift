//
//  ContactAdminController.swift
//  AQAR55
//
//  Created by lion on 01/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit
import DropDown

class ContactAdminController: UIViewController {

    
    
    @IBOutlet weak var txtReason: UITextField!
    
    @IBOutlet weak var btnReason: UIButton!
    
    @IBOutlet weak var txtview: UITextView!
    
    @IBOutlet weak var btnWrongPrice: UIButton!
    
    @IBOutlet weak var btnWrongLocation: UIButton!
    
    @IBOutlet weak var btnImpoliteResponse: UIButton!
    
    @IBOutlet weak var btnExpireAd: UIButton!
    
    @IBOutlet weak var btnOther: UIButton!
    
    
    var reasonArr = ["Seems like fake profiles of user","Seems like fake properties ","Other"]
    
    let dropDown = DropDown()
    let connection = webservices()
    
    var wrongPriceBool = false
    var wrongLocationBool = false
    var impoliteResponseBool = false
    var expireAdBool = false
    var otherBool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtview.text = "Enter Details"
        txtview.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.txtReason.text = "\(item)"
        }
    }
    
    
    @IBAction func tap_reasonBtn(_ sender: Any) {
        
        dropDown.dataSource = reasonArr
        dropDown.anchorView = btnReason
        dropDown.show()
    }
    
    
    @IBAction func btnChatAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PreviousChatAdminController") as! PreviousChatAdminController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        checkValidation()
        
    }
    
    
    @IBAction func tap_OtherBtn(_ sender: Any) {
        
        if otherBool == false{
            
            otherBool = true
            btnOther.setImage(UIImage(named: "done_tick"), for: .normal)
        }
        else{
            
            otherBool = false
            btnOther.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
        }
    }
    
    @IBAction func tap_wrongLocationBtn(_ sender: Any) {
        
        if wrongLocationBool == false{
            
            wrongLocationBool = true
            btnWrongLocation.setImage(UIImage(named: "done_tick"), for: .normal)
        }
        else{
            
            wrongLocationBool = false
            btnWrongLocation.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
        }
    }
    
    @IBAction func tap_impoliteResponseBtn(_ sender: Any) {
        
        if impoliteResponseBool == false{
            
            impoliteResponseBool = true
            btnImpoliteResponse.setImage(UIImage(named: "done_tick"), for: .normal)
        }
        else{
            
            impoliteResponseBool = false
            btnImpoliteResponse.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
        }
    }
    
    @IBAction func tap_expireAdBtn(_ sender: Any) {
        
        if expireAdBool == false{
            
            expireAdBool = true
            btnExpireAd.setImage(UIImage(named: "done_tick"), for: .normal)
        }
        else{
            
            expireAdBool = false
            btnExpireAd.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
        }
    }
    
    @IBAction func tap_wrongPriceBtn(_ sender: Any) {
        
        if wrongPriceBool == false{
            
            wrongPriceBool = true
            btnWrongPrice.setImage(UIImage(named: "done_tick"), for: .normal)
        }
        else{
            
            wrongPriceBool = false
            btnWrongPrice.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
        }
    }
    
}


extension ContactAdminController:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtview.text == "Enter Details"{
            
            txtview.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtview.text == ""{
            
            txtview.text = "Enter Details"
        }
    }
    
}

extension ContactAdminController{
    
    func checkValidation(){
        
        var mess = ""
        
        if wrongPriceBool == false && wrongLocationBool == false && impoliteResponseBool == false && expireAdBool == false && otherBool == false{
            
            mess = "Please select one or multiple reason."
        }
        else if txtview.text == "" || txtview.text == "Enter Details"{
            
            mess = "Please write some detail"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            var reasonStr = ""
            
            if wrongPriceBool == true{
                
                reasonStr = "Wrong price,"
            }
            
            if wrongLocationBool == true{
                
               reasonStr = reasonStr + "Wrong location,"
            }
            
            if impoliteResponseBool == true{
                
                reasonStr = reasonStr + "Impolite response,"
            }
            
            if expireAdBool == true{
                
                reasonStr = reasonStr + "Expired ad,"
            }
            
            if otherBool == true{
                
                reasonStr = reasonStr + "Other,"
            }
            
            reasonStr = reasonStr.trimmingCharacters(in: .whitespaces)
            reasonStr.remove(at: reasonStr.index(before: reasonStr.endIndex))
            
            self.apiCallForContactAdmin(reasonTxt:reasonStr)
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
    }
    
    func apiCallForContactAdmin(reasonTxt:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","reason":reasonTxt,"details":txtview.text!]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForContactAdmin as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
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
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
}
