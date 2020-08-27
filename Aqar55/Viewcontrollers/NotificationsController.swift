//
//  NotificationsController.swift
//  AQAR55
//
//  Created by lion on 01/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class NotificationsController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView_Notifications: UITableView!
    
    @IBOutlet weak var placeholderLbl: UILabel!
    
    
    //MARK: - Variables
    let connection = webservices()
    var notificationDataArr = NSArray()
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placeholderLbl.isHidden = true
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.apiCallForGetNotificationList()
        
        tableView_Notifications.tableFooterView = UIView()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK: - Extension TableView Delegates
extension NotificationsController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notificationDataArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView_Notifications.register(UINib(nibName: "NotificationsCell", bundle: nil), forCellReuseIdentifier: "NotificationsCell")
        let cell = tableView_Notifications.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsCell
        
        let dict = notificationDataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        cell.lbl_NotificationContent.text = dict.object(forKey: "title") as? String ?? ""
        
        let dateAndTime = dict.object(forKey: "created") as? String ?? ""
        
        if dateAndTime != ""{
            
            cell.lblDateAndTime.text = self.fetchData(dateToConvert: dateAndTime)
        }
        else{
            
            cell.lblDateAndTime.text = ""
        }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = notificationDataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let notiType = dict.object(forKey: "notificationType") as? String ?? ""
        
        if notiType == "property"{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PropertyTitleController") as! PropertyTitleController
            
            let type = dict.object(forKey: "propOrUserType") as? String ?? ""
            let propertyId = dict.object(forKey: "propOrRoomOrUserId") as? String ?? ""
            
            let profId = dict.object(forKey: "profUserId") as? String ?? ""
            
            vc.propertyType = type
            vc.propertyId = propertyId
            
            vc.profUserID = profId
            
            vc.controllerPurpuseFor = "ToSeenMySelfProperty"
            
            vc.restrictCallChat = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if notiType == "profile"{
            
            let subType = dict.object(forKey: "propOrUserType") as? String ?? ""
            
            let businessUserId = dict.object(forKey: "userId") as? String ?? ""
            
            let professionalOrBusinessId = dict.object(forKey: "propOrRoomOrUserId") as? String ?? ""
            
           self.apiCallForGetParticularProfileInfo(profBusID: professionalOrBusinessId, type: subType, idAsNormal: businessUserId)
            
        }
        else if notiType == "chat"{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatWithUserController") as! ChatWithUserController
            
            let receiverId = dict.object(forKey: "notificationSender") as? String ?? ""
            
            let title = dict.object(forKey: "title") as? String ?? ""
            
            let descTxt = dict.object(forKey: "description") as? String ?? ""
            
            var name = ""
            
            if let first = title.components(separatedBy: " ").first {
               
                name = first
            }
            
            vc.receiverID = receiverId
            vc.headerName = name
            
            vc.descriptionStr = descTxt
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func fetchData(dateToConvert:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let pendingDate = dateFormatter.date(from: dateToConvert)!
        let sendTime = self.dateFormatterForTime.string(from: pendingDate)
        let sendDate = self.dateFormatterForDate.string(from: pendingDate)
        
        return "\(sendDate) \(sendTime)"
    }
    
}

extension NotificationsController{
    
    func apiCallForGetNotificationList(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetNotificationList as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        self.notificationDataArr = receivedData.object(forKey: "Data") as? NSArray ?? []
                        
                        if self.notificationDataArr.count == 0{
                            
                            self.tableView_Notifications.isHidden = true
                            self.placeholderLbl.isHidden = false
                            
                        }
                        else{
                            
                            self.tableView_Notifications.isHidden = false
                            self.placeholderLbl.isHidden = true
                        }
                        
                        self.tableView_Notifications.reloadData()
                        
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
    
    
    //****************
    
    ////********fetch detail to send on next screen for vice versa user
    
    func apiCallForGetParticularProfileInfo(profBusID:String,type:String,idAsNormal:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["profbusId":profBusID,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","type":type,"businessUserId":idAsNormal]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetViewsCount as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfessionalNameController") as! ProfessionalNameController
                            
                            if type == "professional"{
                                
                                vc.headerTitle = "Professional Name"
                                
                                vc.userType = "Professional"
                            }
                            else{
                                
                                vc.headerTitle = "Business Name"
                                
                                vc.userType = "Business"
                            }
                            
                            vc.IdAsNormal = idAsNormal
                            vc.dataDict = data
                            
                            vc.restrictCallChat = true
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                            
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
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Network Error. Please try again.", controller: self)
                    
                }
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    //////
}
