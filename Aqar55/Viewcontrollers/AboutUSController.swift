//
//  AboutUSController.swift
//  AQAR55
//
//  Created by lion on 01/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

//0698f50de25324d54ecbb6f95251c09b863d1336
// 

import UIKit

class AboutUSController: UIViewController {
    
    @IBOutlet weak var txtView: UITextView!
    
    let connection = webservices()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.apiCallForAboutUs()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }

}


extension AboutUSController{
    
    func apiCallForAboutUs(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["type":"AboutUs"]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForGetContentByType as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "data") as? NSDictionary{
                            
                            let desc = data.object(forKey: "description") as? String ?? ""
                            self.txtView.text = desc
                            
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
