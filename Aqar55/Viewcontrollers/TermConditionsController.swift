//
//  TermConditionsController.swift
//  AQAR55
//
//  Created by lion on 01/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class TermConditionsController: UIViewController,UIWebViewDelegate{

    
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var webview: UIWebView!
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.apiCallForTermsCondition()
        
        IJProgressView.shared.showProgressView(view: self.view)
        
        let url = URL(string: "http://18.217.0.63/realstate/terms.html")
        let req = NSURLRequest(url: url!)
        webview.loadRequest(req as URLRequest)
        
        webview.delegate = self
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        IJProgressView.shared.showProgressView(view: self.view)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        IJProgressView.shared.hideProgressView()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        IJProgressView.shared.hideProgressView()
    }

}



extension TermConditionsController{
    
    func apiCallForTermsCondition(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["type":"TermCondition"]
            
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
