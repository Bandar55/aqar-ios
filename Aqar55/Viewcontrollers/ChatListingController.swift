//
//  ChatListingController.swift
//  AQAR55
//
//  Created by lion on 01/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class ChatListingController: UIViewController {
    
    //MAKR: - Outlets
    @IBOutlet weak var tableView_Chat: UITableView!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    
    //MAKR: - Variables
    var timeArr = ["4:09 pm","5:00 pm","4:09 pm","7:26 pm","7:05 pm"]
    var dpArr = ["businessman", "doctors","young_girl","young_man","businessman"]
  
    var chatArr = NSArray()
    
    let connection = webservices()
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnDelete.isHidden = true
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        tableView_Chat.addGestureRecognizer(longPress)
        
        initialSetup()
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.apiCallForGetChatListing()
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func initialSetup(){
        
        tableView_Chat.register(UINib(nibName: "ChatListingCell", bundle: nil), forCellReuseIdentifier: "ChatListingCell")
        tableView_Chat.tableFooterView = UIView()
    }
    
    
    @IBAction func tap_deleteBtn(_ sender: Any) {
    }
    
    
}

//MARK: - Extension TableView Delegates
extension ChatListingController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView_Chat.dequeueReusableCell(withIdentifier: "ChatListingCell", for: indexPath)  as! ChatListingCell
        
        cell.imgView_useImage.layer.cornerRadius =  cell.imgView_useImage.frame.size.height/2
        cell.imgView_useImage.clipsToBounds = true
        
        let dict = chatArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        cell.lbl_UserTitle.text = dict.object(forKey: "fullName") as? String ?? ""
        
        cell.lbl_deatil.text = dict.object(forKey: "lastmessage") as? String ?? ""
        
        let createdDate = dict.object(forKey: "modified") as? String ?? ""
        
        if createdDate != ""{
            
            cell.lbl_time.text = self.fetchData(dateToConvert: createdDate)
        }
        else{
            
             cell.lbl_time.text = ""
        }
        
        let imgStr = dict.object(forKey: "profileImage") as? String ?? ""
        
        if imgStr == ""{
            
            cell.imgView_useImage.image = UIImage(named: "user_icon")
        }
        else{
            
            let urlStr = URL(string: imgStr)
            
            if urlStr != nil{
                
                cell.imgView_useImage.setImageWith(urlStr!, placeholderImage: UIImage(named: "user_icon"))
            }
            
        }
        
        cell.selectionStyle = .none
        
        return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = chatArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let receiverId = dict.object(forKey: "receiver_id") as? String ?? ""
        let propertyId = dict.object(forKey: "property_id") as? String ?? ""
        let name = dict.object(forKey: "fullName") as? String ?? ""
        
        let descTxt = dict.object(forKey: "description") as? String ?? ""
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatWithUserController") as! ChatWithUserController
        
        vc.propertyID =  propertyId
        vc.receiverID = receiverId
        vc.headerName = name
        
        vc.descriptionStr = descTxt
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension ChatListingController{
    
    func apiCallForGetChatListing(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForChatList as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        self.chatArr = receivedData.object(forKey: "Data") as? NSArray ?? []
                        
                        self.tableView_Chat.reloadData()
                       
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
    
    
    func apiCallForDeleteChat(roomID:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["room_id":roomID]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForDeleteChat as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                       self.apiCallForGetChatListing()
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

extension ChatListingController{
    
    /////to handle long press method
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: tableView_Chat)
            
            if tableView_Chat.indexPathForRow(at: touchPoint) != nil {
                
                print(tableView_Chat.indexPathForRow(at: touchPoint)!)
                
                let indexArr = tableView_Chat.indexPathForRow(at: touchPoint)!
                
              //  let tableSection = indexArr[0]
                let tableRow = indexArr[1]
                
                let alertController = UIAlertController(title: "", message: "Do you want to delete this chat?", preferredStyle: .alert)
                        
                let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                    
                    let dict = self.chatArr.object(at: tableRow) as? NSDictionary ?? [:]
                    
                    let roomId = dict.object(forKey: "room_id") as? String ?? ""
                    
                    self.apiCallForDeleteChat(roomID: roomId)
                    
                }
                let cancelAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel) {
                            UIAlertAction in
                            
                }
                        
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                        
                self.present(alertController, animated: true, completion: nil)
               
            }
        }
    }
    
}


