//
//  ChatWithUserController.swift
//  Aqar55
//
//  Created by Callsoft on 05/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import SocketIO
import DropDown
import IQKeyboardManager
import RSKKeyboardAnimationObserver
import RSKPlaceholderTextView


class ChatWithUserController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate{

   // @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView_Chat: UITableView!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    @IBOutlet weak var btnBlockDelete: UIButton!
    
    @IBOutlet weak var messageTextField: RSKPlaceholderTextView!
    
    @IBOutlet weak var sendMessageBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sendMessageView: UIView!
    
    @IBOutlet weak var descTxtView: UITextView!
    
    
    
    //MARK: - VARIABLES
    let socketManager = SocketManager(socketURL: URL(string: "http://18.217.0.63:3004")!, config: ["log": true])
    
    var socket: SocketIOClient!
    var imageName = ""
    
    var imageData = NSData()
    var imagePicker = UIImagePickerController()
    
    
    var headerName = ""
    var receiverID = ""
    var descriptionStr = ""
    var roomID = ""
    var propertyID = ""
    var forFirstTimeOnly = true
    var chatingArr = NSMutableArray()
    
    let connection = webservices()
    
    var dropDownArr = ["Block","Delete"]
    let dropDown = DropDown()
    
    private var isVisibleKeyboard = true
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblHeaderTitle.text = headerName
        
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        initialSetup()
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        self.imagePicker.delegate = self
        
        self.socketHandling()
        
        tableView_Chat.reloadData()
        
        self.messageTextField.text = "Enter message"
        self.messageTextField.delegate = self
        
        if descriptionStr == ""{
            
            descTxtView.text = ""
        }
        else{
            
            descTxtView.text = descriptionStr
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.registerForKeyboardNotifications()
       
        descTxtView.isScrollEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        CommonClass.sharedInstance.chatScreenIsOpen = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        
    }
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
       
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification){
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.keyboardDismissle))
        
        view.removeGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    @objc func keyboardDismissle(){
        
        view.endEditing(false)
    }
    
    
    private func adjustContent(for keyboardRect: CGRect) {
        
        let keyboardHeight = keyboardRect.height
        let keyboardYPosition = self.isVisibleKeyboard ? keyboardHeight : 0.0;
        self.sendMessageBottomConstraint.constant = keyboardYPosition
        
        self.view.layoutIfNeeded()
    }
    
    private func registerForKeyboardNotifications() {
        
        self.rsk_subscribeKeyboardWith(beforeWillShowOrHideAnimation: nil,
                                       willShowOrHideAnimation: { [unowned self] (keyboardRectEnd, duration, isShowing) -> Void in
                                        self.isVisibleKeyboard = isShowing
                                        self.adjustContent(for: keyboardRectEnd)
            }, onComplete: { (finished, isShown) -> Void in
                self.isVisibleKeyboard = isShown
        }
        )
        
        self.rsk_subscribeKeyboard(willChangeFrameAnimation: { [unowned self] (keyboardRectEnd, duration) -> Void in
            self.adjustContent(for: keyboardRectEnd)
            }, onComplete: nil)
    }
    
    private func unregisterForKeyboardNotifications() {
        
        self.unregisterForKeyboardNotifications()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        CommonClass.sharedInstance.chatScreenIsOpen = true
        
        descTxtView.isScrollEnabled = false
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if index == 0{
                
               //block
                self.forBlock()
            }
            else{
                
               //delete
                self.forDelete()
            }
        }
    }
    
 
    
    //MARK:- Socket Handling
    
    func socketHandling() {
        
        socket = socketManager.defaultSocket
        
        let socketConnectionStatus = socket.status
        
        switch socketConnectionStatus {
        case SocketIOStatus.connected:
            print("socket connected")
        case SocketIOStatus.connecting:
            print("socket connecting")
        case SocketIOStatus.disconnected:
            socket.connect()
            print("socket disconnected")
        case SocketIOStatus.notConnected:
            socket.connect()
            print("socket not connected")
        }
                
        //On Event
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            //Emit Event
           // self.socket.emit("room join", ["room_id": 12])
            
            if self.forFirstTimeOnly{
                
                self.forFirstTimeOnly = false
                
                print(self.receiverID)
                print(UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "")
                
                 self.socket.emit("getRoomId", ["sender_id":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","receiver_id":self.receiverID])
                
                
            }
          
        }
        
        socket.on("room join") { (data, ack) in
            
            print("Room Joined")
        }
        
        socket.on("message") { (data, ack) in
            
            print(data)
        }
        
        
        socket.on("getRoomId") { (data, ack) in
            
            print(data)
            
            let arrayForRoomId = data as? NSArray ?? []
            
            if arrayForRoomId.count != 0{
                
                let dict = arrayForRoomId.object(at: 0) as? NSDictionary ?? [:]
                
                let infoDict = dict.object(forKey: "Data") as? NSDictionary ?? [:]
                
                if infoDict.count > 2{
                    
                    self.roomID = infoDict.object(forKey: "room_id") as? String ?? ""
                    
                    self.dropDownArr = ["Block","Delete"]
                    
                    //call api here for history
                    
                    self.apiCallForGetHistoryOfChat(roomId: self.roomID)
                }
                else{
                    
                    self.dropDownArr = ["Block"]
                    print("no room id found")
                }
            }
            else{
                
                self.dropDownArr = ["Block"]
            }
            
        }
        
        socket.on("initialChat") { (data, ack) in
            
            self.messageTextField.text = ""
            
            print(data)
            
            let newMsgArr = data as? NSArray ?? []
            
            if newMsgArr.count != 0{
                
                let dict = newMsgArr.object(at: 0) as? NSDictionary ?? [:]
                
                let msg = dict.object(forKey: "msg") as? String ?? ""
                
                if msg == "User is blocked either by sender or receiver"{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Blocked user can not send or receive message.", controller: self)
                    
                    return
                }
                
                if dict.count == 2{
                    
                    let successResponse = dict.object(forKey: "IsSuccess") as? Bool ?? false
                    
                    if successResponse{
                        
                        let msgDict = dict.object(forKey: "message") as? NSDictionary ?? [:]
                        
                        print(msgDict)
                        
                        self.roomID = msgDict.object(forKey: "room_id") as? String ?? ""
                        
                       // self.chatingArr.add(msgDict)
                        
                    }
                    
                }
                else{
                    
                    self.roomID = dict.object(forKey: "room_id") as? String ?? ""
                    
                    if self.chatingArr.contains(dict){
                        
                        print("Do nothing, Getting callback multiple times in app in case of images")
                    }
                    else{
                        
                        self.chatingArr.add(dict)
                    }
                    
                }
                
                self.tableView_Chat.reloadData()
                self.setscrollPosition()
            }
        }
        
        
        self.socket.on("uploadFileMoreDataReq") { ( dataArray, ack) -> Void in
            
            print(dataArray, ack)
            
            let uniqueCode = self.getUniqueCode()
            
            //            String(describing: ((dataArray.first as! NSDictionary).value(forKey: "Percent"))!)
            
//            var messageDict =   [["Name" : self.imageName,
//                                  "Data" : self.imageData.base64EncodedString(options: .endLineWithLineFeed),
//                                  "attachment_type" : self.imageName.contains(".m4a") ? "AUDIO" : "MEDIA",
//                                  "chunkSize" : self.imageData.length,
//                                  "check_status" : "send",
//                                  "message" : "Read Attachment",
//                                  "room_id" : 12,
//                                  "unique_code" : "\(uniqueCode)"]] as [[String : Any]]
            
            
            var messageDict =   [["Name" : self.imageName,
                                  "Data" : self.imageData.base64EncodedString(options: .endLineWithLineFeed),
                                  "attachment_type" : self.imageName.contains(".m4a") ? "AUDIO" : "MEDIA",
                                  "chunkSize" : self.imageData.length,
                                  "check_status" : "send",
                                  "message" : "Read Attachment",
                                  "room_id" : self.roomID,
                                  "unique_code" : "\(uniqueCode)",
                                  "sender_id":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "",
                                  "receiver_id":self.receiverID,
                                  "property_id":self.propertyID,
                                  "description":self.descriptionStr]] as [[String : Any]]
            
            self.socket.emitWithAck("uploadFileChuncks", messageDict).timingOut(after: 0) {data in
                
                print(data)
                
            }
            
            self.socket.on("uploadFileCompleteRes") { ( dataArray, ack) -> Void in
                
                IJProgressView.shared.hideProgressView()
                
                print(dataArray, ack)
                
                let mediaArray = dataArray as NSArray ?? []
                
                print(mediaArray)
                
                if mediaArray.count != 0{
                    
                    let dict = mediaArray.object(at: 0) as? NSDictionary ?? [:]
                    
                    print(dict)
                    
                    let successResponse = dict.object(forKey: "IsSuccess") as? Bool ?? false
                    
                    if successResponse{
                        
                        let msgDict = dict.object(forKey: "message") as? NSDictionary ?? [:]
                        
                        print(msgDict)
                        
                        self.roomID = msgDict.object(forKey: "room_id") as? String ?? ""
                        
                        if self.chatingArr.contains(msgDict){
                            
                            print("Do nothing, Getting callback multiple times in app in case of images")
                        }
                        else{
                            
                            self.chatingArr.add(msgDict)
                            
                            self.tableView_Chat.reloadData()
                            
                            self.setscrollPosition()
                        }
                        
                    }
                }
                
            }
        }
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnBlockAction(_ sender: Any) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteUserPresentController") as! DeleteUserPresentController
//        vc.objChat = self
//        self.navigationController?.present(vc, animated: true, completion: nil)
        
        dropDown.dataSource = dropDownArr
        dropDown.anchorView = btnBlockDelete
        dropDown.show()
    }
    
    @IBAction func mikeButtonTapped(_ sender: UIButton) {
        
       // self.socket.emit("message", ["message": self.messageTextField.text!,"room_id":12])
        
        if self.messageTextField.text != "" && self.messageTextField.text != "Enter message"{
            
            print(UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "")
            print(self.receiverID)
            
            self.socket.emit("initialChat", ["sender_id":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","receiver_id":receiverID,"message":self.messageTextField.text!,"room_id":self.roomID,"property_id":self.propertyID,"attachment_type":"Text","description":descriptionStr])
        }
        
    }
    
    @IBAction func attachmentPicButtonTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "Pickup Photo", preferredStyle: UIAlertController.Style.actionSheet)
        
        let gallery = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default) { (gallery) in
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        alert.addAction(gallery)
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.destructive) { (camera) in
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        alert.addAction(camera)
        
        let cancel = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel) { (cancel) in
        }
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Image Picker Delegate Function
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        if let selectedImage = info[.originalImage] as? UIImage {
            
            self.imageData = selectedImage.jpegData(compressionQuality: 0.5)! as NSData
            
            self.imageName = generateUniqueImageName()
            
//            let messageDict =   [["Name" : self.imageName,
//                                  "Size" : self.imageData.length,
//                                  "room_id" : 12]] as [[String : Any]]
            
            let messageDict = [["Name" : self.imageName,
                                "Size" : self.imageData.length,
                                "room_id" : self.roomID,
                                "sender_id":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "",
                                "receiver_id":receiverID,
                                "property_id":self.propertyID,
                                "description":descriptionStr]] as [[String : Any]]
            
            self.socket.emitWithAck("uploadFileStart", messageDict).timingOut(after: 0) {data in
                
                IJProgressView.shared.showProgressView(view: self.view)
                
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func generateUniqueImageName() -> String {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        //print("Butterfly_" + formatter.string(from: Date()) + ".jpeg")
        
        return ("sdfdsf" + formatter.string(from: Date()) + ".jpeg")
        
    }
    
    func getUniqueCode() -> String {
        
        let randomNum:UInt32 = arc4random_uniform(10000000)
        
        let uniqueCode = "\(randomNum)\(randomNum)"
        
        print(uniqueCode)
        
        return uniqueCode
    }
}

extension ChatWithUserController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatingArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = chatingArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let senderId = dict.object(forKey: "sender_id") as? String ?? ""
        
        let attachmentType = dict.object(forKey: "attachment_type") as? String ?? ""
        
        let time = dict.object(forKey: "created") as? String ?? ""
        
        if senderId == UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""{
            
            if attachmentType == "MEDIA" || attachmentType == "AUDIO"{
                
                tableView_Chat.register(UINib(nibName: "ChatWithMediaSenderTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatWithMediaSenderTableViewCell")
                
                let cell = tableView_Chat.dequeueReusableCell(withIdentifier: "ChatWithMediaSenderTableViewCell", for: indexPath) as! ChatWithMediaSenderTableViewCell
                
                let attachment = dict.object(forKey: "attachment") as? String ?? ""
                
                cell.senderImg.layer.cornerRadius = 5.0
                cell.senderImg.clipsToBounds = true
                
                //let imgStr = "http://18.217.0.63:3005/chats/"+"\(attachment)"
                
                let imgStr = "\(attachment)"
                
                let urlStr = URL(string: imgStr)
                
                if urlStr != nil{
                    
                    cell.senderImg.setImageWith(urlStr!, placeholderImage: UIImage(named: "defaultProperty"))
                }
                
                cell.lblTime.text = self.fetchData(dateToConvert: time)
                
                cell.selectionStyle = .none
                
                return cell
            }
            else{
                
                tableView_Chat.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
                
                let cell = tableView_Chat.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
                cell.lbl_senderMsg.text = dict.object(forKey: "message") as? String ?? ""
                
                cell.lblTime.text = self.fetchData(dateToConvert: time)
                
                cell.selectionStyle = .none
                
                return cell
            }
         
        }
        else{
            
            if attachmentType == "MEDIA" ||  attachmentType == "AUDIO"{
                
                tableView_Chat.register(UINib(nibName: "ChatWithMediaReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatWithMediaReceiverTableViewCell")
                
                let cell = tableView_Chat.dequeueReusableCell(withIdentifier: "ChatWithMediaReceiverTableViewCell", for: indexPath) as! ChatWithMediaReceiverTableViewCell
                
                cell.receiverImg.layer.cornerRadius = 5.0
                cell.receiverImg.clipsToBounds = true
                
                let attachment = dict.object(forKey: "attachment") as? String ?? ""
                
                let imgStr = "\(attachment)"
                
                let urlStr = URL(string: imgStr)
                
                if urlStr != nil{
                    
                    cell.receiverImg.setImageWith(urlStr!, placeholderImage: UIImage(named: "defaultProperty"))
                }
                
                cell.lblTime.text = self.fetchData(dateToConvert: time)
                
                cell.selectionStyle = .none
                
                return cell
            }
            else{
                
                tableView_Chat.register(UINib(nibName: "ReceiverCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
                
                let cell = tableView_Chat.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
                cell.lbl_ReceiverMsg.text = dict.object(forKey: "message") as? String ?? ""
                
                cell.lblTime.text = self.fetchData(dateToConvert: time)
                
                cell.selectionStyle = .none
                
                return cell
            }
          
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = chatingArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let attachmentType = dict.object(forKey: "attachment_type") as? String ?? ""
        
        if attachmentType == "MEDIA"{
            
            let attachment = dict.object(forKey: "attachment") as? String ?? ""
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewerVC") as! ImageViewerVC
            
            vc.imgStr = attachment
            
            self.present(vc, animated: true, completion: nil)
        }
       
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

extension ChatWithUserController{
    
    func initialSetup(){
        
        tableView_Chat.register(UINib(nibName: "ReceiverCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
        tableView_Chat.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        
        tableView_Chat.register(UINib(nibName: "ChatWithMediaSenderTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatWithMediaSenderTableViewCell")
        
        tableView_Chat.register(UINib(nibName: "ChatWithMediaReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatWithMediaReceiverTableViewCell")
        
        tableView_Chat.dataSource = self
        tableView_Chat.delegate = self
        
    }
    
    func forBlock(){
        
        let alertController = UIAlertController(title: "", message: "Do you want to block this user?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            self.apiCallForBlockUser()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func forDelete(){
        
        let alertController = UIAlertController(title: "", message: "Do you want to delete this chat?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            self.apiCallForDeleteChat()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}



extension ChatWithUserController{
    
    func apiCallForGetHistoryOfChat(roomId:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["sender_id":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","room_id":roomID]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForChatDetails as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        let chatArr = receivedData.object(forKey: "Data") as? NSArray ?? []
                        
                        self.chatingArr = chatArr.mutableCopy() as! NSMutableArray
                        
                        self.tableView_Chat.reloadData()
                        
                        self.setscrollPosition()
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
    
    
    func setscrollPosition(){
        
        if self.chatingArr.count != 0{
            
            let numberOfSections = self.tableView_Chat.numberOfSections
            
            let numberOfRows = self.tableView_Chat.numberOfRows(inSection: numberOfSections-1)
     
            let indexPath = NSIndexPath(row: numberOfRows-1, section: numberOfSections-1)
            
            self.tableView_Chat.scrollToRow(at: indexPath as IndexPath,at: UITableView.ScrollPosition.bottom, animated: true)
            
        }
        
    }
    
    
    func apiCallForDeleteChat(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["room_id":roomID]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForDeleteChat as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                       self.navigationController?.popViewController(animated: true)
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
    
    
    func apiCallForBlockUser(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["block_from":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","block_to":receiverID]
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForBlockUser as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        self.navigationController?.popViewController(animated: true)
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


extension ChatWithUserController:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if messageTextField.text == "Enter message"{
            
            self.messageTextField.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if messageTextField.text == ""{
            
            self.messageTextField.text = "Enter message"
        }
    }
}


//media response

//[{
//    IsSuccess = 1;
//    message =     {
//        Data = "sdfdsf20190530155032.jpeg";
//        Name = "sdfdsf20190530155032.jpeg";
//        attachment = "http://18.217.0.63/realstate/public/sdfdsf20190530155032.jpeg";
//        "attachment_type" = MEDIA;
//        "check_status" = send;
//        chunkSize = 110996;
//        created = "2019-05-30T10:20:35.512Z";
//        message = "Read Attachment";
//        "property_id" = 5cdbd88b558e606e267878cc;
//        "receiver_id" = 5cdbd60d558e606e267878c8;
//        "room_id" = 5cdbbf1e7172d0648d8b90ff5cdbd60d558e606e267878c8;
//        "sender_id" = 5cdbbf1e7172d0648d8b90ff;
//        "unique_code" = 589684589684;
//    };
//    }]



//[{
//    "__v" = 0;
//    "_id" = 5cefaf550a96ce2cebd49a9c;
//    created = "2019-05-30T10:24:21.390Z";
//    message = Again;
//    modified = "2019-05-30T10:24:21.390Z";
//    "receiver_id" = 5cdbd60d558e606e267878c8;
//    "room_id" = 5cdbbf1e7172d0648d8b90ff5cdbd60d558e606e267878c8;
//    "sender_id" = 5cdbbf1e7172d0648d8b90ff;
//    }]
