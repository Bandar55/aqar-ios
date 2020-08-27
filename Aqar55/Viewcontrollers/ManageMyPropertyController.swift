//
//  ManageMyPropertyController.swift
//  AQAR55
//
//  Created by lion on 01/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class ManageMyPropertyController: UIViewController {

    @IBOutlet weak var tableView_myProperty: UITableView!
    
    @IBOutlet weak var bottomActiveView: UIView!
    @IBOutlet weak var bottomInactiveView: UIView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    
    
    var imageArr = ["image_silicing","image_silicing","image_silicing"]
    var titleArr = ["Title","Title","Title"]
    var costArr = ["$10,00,000","$10,00,000","$10,00,000"]
    var categoryArr = ["Category","Category","Category"]
    
    var isFromCompletedPost = false
    
    let connection = webservices()
    
    var managedDataArr = NSArray()
    
    var typeSelected = "Inactive"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblPlaceholder.isHidden = true
        
        let apiUrl = App.URLs.apiCallForInactiveList
        self.apiCallForGetManageMyProperty(type: apiUrl)
        
        tableView_myProperty.reloadData()
        tableView_myProperty.tableFooterView = UIView()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        if !isFromCompletedPost{
            self.navigationController?.popViewController(animated: true)
        }else{
            
            for controller in navigationController!.viewControllers{
                
                if controller.isKind(of: HomeController.self){
                    self.navigationController?.popToViewController(controller, animated: true)
                }
            }
            
        }
    }
    
    @IBAction func btnPostPropertyAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostPropertyController") as! PostPropertyController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnActiveAction(_ sender: Any) {
        
        typeSelected = "Active"
        
        bottomActiveView.isHidden = false
        bottomInactiveView.isHidden = true
        
        let apiUrl = App.URLs.apiCallForActiveList
        self.apiCallForGetManageMyProperty(type: apiUrl)
        
    }
    
    @IBAction func btnInactiveAction(_ sender: Any) {
        
        typeSelected = "Inactive"
        
        bottomActiveView.isHidden = true
        bottomInactiveView.isHidden = false
        
        let apiUrl = App.URLs.apiCallForInactiveList
        
        self.apiCallForGetManageMyProperty(type: apiUrl)
    }
}

//MARK: - Extension TableView Delegates
extension ManageMyPropertyController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return managedDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView_myProperty.register(UINib(nibName: "ManageMyPropertyCell", bundle: nil), forCellReuseIdentifier: "ManageMyPropertyCell")
       
        let cell = tableView_myProperty.dequeueReusableCell(withIdentifier: "ManageMyPropertyCell", for: indexPath) as! ManageMyPropertyCell
        
//        cell.imgView_property.image = UIImage(named: imageArr[indexPath.row])
//        cell.lbl_Title.text = titleArr[indexPath.row]
//        cell.lbl_Cost.text = costArr[indexPath.row]
        
        let dataDict = managedDataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let type = dataDict.object(forKey: "Type") as? String ?? ""
        
        let plotSize = dataDict.object(forKey: "plotSize") as? String ?? ""
        let plotSizeUnit = dataDict.object(forKey: "plotSizeUnit") as? String ?? ""
        
        cell.lblPricePerSqareMeter.text = "\(plotSize) \(plotSizeUnit)"
        
        if type == "sale"{
            
            let price = dataDict.object(forKey: "totalPriceSale") as? String ?? ""
            
            let currency = dataDict.object(forKey: "currency") as? String ?? ""
            
            cell.lbl_Cost.text = "\(currency) \(price)"
            
        }
        else{
            
            let price = dataDict.object(forKey: "totalPriceRent") as? String ?? ""
            
            let currency = dataDict.object(forKey: "currency") as? String ?? ""
            
            cell.lbl_Cost.text = "\(currency) \(price)"
        }
        
        cell.lbl_Title.text = dataDict.object(forKey: "title") as? String ?? ""
        
        cell.lbl_PricePerSqr.text = dataDict.object(forKey: "category") as? String ?? ""
        
        let totalDays = dataDict.object(forKey: "totalDays") as? String ?? ""
        let remainingDays = dataDict.object(forKey: "remainingDays") as? String ?? ""
        
        let imageArr = dataDict.object(forKey: "imagesFile") as? NSArray ?? []
        if imageArr.count == 0{
            
            cell.imgView_property.image = UIImage(named: "defaultProperty")
        }
        else{
            
            let dict = imageArr.object(at: 0) as? NSDictionary ?? [:]
            let imageStr = dict.object(forKey: "image") as? String ?? ""
            
            if imageStr != ""{
                
                let urlStr = URL(string: imageStr)
                cell.imgView_property.setImageWith(urlStr, placeholderImage: UIImage(named: "defaultProperty"))
            }
            else{
                
                cell.imgView_property.image = UIImage(named: "defaultProperty")
            }
        }
        
        cell.btnUpdateProperty.setTitle("Update \(remainingDays)/\(totalDays) days", for: .normal)
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(btnEditAction(sender:)), for: .touchUpInside)
        
        cell.btn_chat.tag = indexPath.row
        cell.btn_chat.addTarget(self, action: #selector(btnChatAction(sender:)), for: .touchUpInside)

        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(ManageMyPropertyController.tapDeleteBtn(sender:)), for: UIControl.Event.touchUpInside)
        
        cell.btnUpdateProperty.tag = indexPath.row
        cell.btnUpdateProperty.addTarget(self, action: #selector(self.tapUpdateBtn(sender:)), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PropertyTitleController") as! PropertyTitleController
        
        let dict = managedDataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let type = dict.object(forKey: "Type") as? String ?? ""
        let propertyId = dict.object(forKey: "_id") as? String ?? ""
        
        let profId = dict.object(forKey: "professionalUserId") as? String ?? ""
        
        vc.propertyType = type
        vc.propertyId = propertyId
        
        vc.profUserID = profId
        
        vc.controllerPurpuseFor = "ToSeenMySelfProperty"
        
        vc.restrictCallChat = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
      //  return 140.0
        
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }
    
    @objc func btnEditAction(sender:UIButton){
        
        let dict = managedDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostPropertyController") as! PostPropertyController
        
        vc.editItemDict = dict
        vc.controllerPurpuse = "Edit"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func btnChatAction(sender:UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatListingController") as! ChatListingController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapDeleteBtn(sender:UIButton){
        
        let alertController = UIAlertController(title: "", message: "Are you sure? You want to delete this property", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            let dict = self.managedDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
            
            let id = dict.object(forKey: "_id") as? String ?? ""
            
            self.apiCallForDeleteProperty(deletedId: id)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func tapUpdateBtn(sender:UIButton){
        
        let alertController = UIAlertController(title: "", message: "Are you sure? You want to update this property", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            let dict = self.managedDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
            
            let id = dict.object(forKey: "_id") as? String ?? ""
            
            self.apiCallForUpdateProperty(updateId: id)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
  
    
    
}


//MARK:- Webservices
//MARK:-
extension ManageMyPropertyController{
    
    func apiCallForGetManageMyProperty(type:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(type as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let dataArr = receivedData.object(forKey: "Data") as? NSArray{
                            
                            self.managedDataArr = dataArr
                            
                            if self.managedDataArr.count != 0{
                                
                                self.lblPlaceholder.isHidden = true
                                self.tableView_myProperty.reloadData()
                            }
                            else{
                                
                                self.lblPlaceholder.isHidden = false
                                self.tableView_myProperty.reloadData()
                            }
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
                    
                     CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
             CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    func apiCallForDeleteProperty(deletedId:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["propertyId":deletedId]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForDeleteProperty as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        var apiUrl = ""
                        
                        if self.typeSelected == "Inactive"{
                            
                            apiUrl = App.URLs.apiCallForInactiveList
                        }
                        else{
                            
                            apiUrl = App.URLs.apiCallForActiveList
                        }
                        
                        self.apiCallForGetManageMyProperty(type: apiUrl)
                        
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
    
    
    /////
    
    func apiCallForUpdateProperty(updateId:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["propertyId":updateId]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForUpdateParticularProperty as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        var apiUrl = ""
                        
                        if self.typeSelected == "Inactive"{
                            
                            apiUrl = App.URLs.apiCallForInactiveList
                        }
                        else{
                            
                            apiUrl = App.URLs.apiCallForActiveList
                        }
                        
                        self.apiCallForGetManageMyProperty(type: apiUrl)
                        
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
    
    ////
    
    
}
