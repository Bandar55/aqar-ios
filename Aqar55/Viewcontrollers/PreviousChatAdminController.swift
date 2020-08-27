//
//  PreviousChatAdminController.swift
//  AQAR55
//
//  Created by lion on 01/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class PreviousChatAdminController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    let connection = webservices()
    
    var chatDataArr = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.isHidden = true
        
        initialSetup()
        
        self.apiCallForListContactAdmin()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func initialSetup(){
        
        let cellNib = UINib(nibName: "PreviousChatWithAdminTableViewCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "Cell")
        tableview.tableFooterView = UIView()
    }

}

extension PreviousChatAdminController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PreviousChatWithAdminTableViewCell
        
        let dict = chatDataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let type = dict.object(forKey: "Type") as? String ?? ""
        
        if type == "User"{
            
            let reason = dict.object(forKey: "reason") as? String ?? ""
            let detail = dict.object(forKey: "details") as? String ?? ""
            
            cell.lblReason.text = "\(reason)\n\n\(detail)"
        }
        else{
            
            let reply = dict.object(forKey: "reply") as? String ?? ""
            
            cell.lblReason.text = "Reply by Admin : \(reply)"
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}


extension PreviousChatAdminController{
    
    func apiCallForListContactAdmin(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForContactAdminDetail as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        let arr = receivedData.object(forKey: "Data") as? NSArray ?? []
                        
                        self.chatDataArr = arr
                        
                        if self.chatDataArr.count == 0{
                            
                            self.tableview.isHidden = true
                        }
                        else{
                            
                            self.tableview.isHidden = false
                        }
                        
                        self.tableview.reloadData()
                        
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
