//
//  MarketingPopupController.swift
//  Aqar55
//
//  Created by Amit Singh on 06/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import KYDrawerController

class MarketingPopupController: UIViewController {
    
    
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var objSignupOption = SignupOptionController()
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.apiCallForGetPopupContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpController") as! SignUpController
           // vc.isForSignup = true
            self.objSignupOption.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}


extension MarketingPopupController{
    
    func apiCallForGetPopupContent(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["type":"popup"]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForGetContentByType as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "data") as? NSDictionary{
                            
                            let contentHeadingTxt = data.object(forKey: "contentType") as? String ?? ""
                            
                            let desc = data.object(forKey: "description") as? String ?? ""
                            
                            self.lblHeading.text = contentHeadingTxt
                            self.lblTitle.text = desc
                            
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
