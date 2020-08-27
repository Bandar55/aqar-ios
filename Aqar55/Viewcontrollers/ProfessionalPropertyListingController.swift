//
//  ProfessionalPropertyListingController.swift
//  Aqar55
//
//  Created by Callsoft on 05/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class ProfessionalPropertyListingController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewSortMap: UIView!
    
    @IBOutlet weak var lblHeader: UILabel!
    
    var restrictCallChat = false
    
    var professionalUserId = ""
    var normalUserId = ""
    var typeOfUser = ""
    
    let connection = webservices()
    
    var propertyDataArr = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSortMap.isHidden = true
        
        self.tableView.register(UINib(nibName: "CellForProfessionalAndBusiness", bundle: nil), forCellReuseIdentifier: "CellForProfessionalAndBusiness")
        self.tableView.register(UINib(nibName: "CellForRentAndSale", bundle: nil), forCellReuseIdentifier: "CellForRentAndSale")

        tableView.tableFooterView = UIView()
        
        if typeOfUser == "professional"{
            
            self.lblHeader.text = "Professional Property Listing"
        }
        else{
            
            self.lblHeader.text = "Property Listing"
        }
        
        self.apiCallForGetProfessionalPropertyListing()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMapAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfessionalPropertyMapController") as! ProfessionalPropertyMapController
        
        vc.propertyDataArr = self.propertyDataArr
        
        vc.userType = self.typeOfUser
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tap_sortByBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SortByController") as! SortByController
        
        vc.delegate = self
        
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
  
    
    func makeRootToLoginSignup(){
        
        UserDefaults.standard.set(false, forKey: "ISLOGIN")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignupOptionController") as! SignupOptionController
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
        print("Logout Tapped")
        
    }
    
    func shareProperty(propertyTitle:String,propertyType:String){
        
       // let title = "I just used the Aqar55 App and saw the property \(propertyTitle) for \(propertyType). Highly recommend that you try it too."
        
        let title = "Aqar is the right app if you are looking for apartments for rent or villas for sale or rent  or land for sale in Saudi Arabia. Aqar displays all Saudi real estates ads on Google Maps; navigate in the area you like and find your next home!\nYou can directly contact the owner and make the deal. \n \n App Store : https://apps.apple.com/us/app/aqar55/id1472194209?ls=1 \n \n Play store : https://play.google.com/store/apps/details?id=com.aqar55&amp;hl=en_US"
        
        let textToShare = [title] as [Any]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = []
        activityViewController.setValue("Aqar55", forKey: "subject")
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}


extension ProfessionalPropertyListingController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return propertyDataArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        ////*****************
        ////write here the code for sale and rent
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellForRentAndSale", for: indexPath) as! CellForRentAndSale
        
        
        cell.btnLikeDislike.tag = indexPath.row
        cell.btnLikeDislike.addTarget(self, action: #selector(self.tapSaleAndRentLikeBtn(sender:)), for: UIControl.Event.touchUpInside)
        
        cell.btnShare.tag = indexPath.row
        cell.btnShare.addTarget(self, action: #selector(self.tap_shareBtn(sender:)), for: UIControl.Event.touchUpInside)
        
        cell.btnCall.tag = indexPath.row
        cell.btnCall.addTarget(self, action: #selector(self.callOnNumber(sender:)), for: UIControl.Event.touchUpInside)
        
        cell.btnChat.tag = indexPath.row
        cell.btnChat.addTarget(self, action: #selector(self.btnChatAction(sender:)), for: UIControl.Event.touchUpInside)
       
        cell.btnDelete.isHidden = true
        
        let dict = propertyDataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        let type = dict.object(forKey: "Type") as? String ?? ""
        
        let likeStatus = dict.object(forKey: "likedStatus") as? String ?? ""
        
        if likeStatus == "yes"{
            
            cell.btnLikeDislike.setImage(UIImage(named: "like_icon_new"), for: .normal)
        }
        else{
            
            cell.btnLikeDislike.setImage(UIImage(named: "unselectedHeart"), for: .normal)
        }
        
        cell.lblTitle.text = dict.object(forKey: "title") as? String ?? ""
        cell.lblPropertyType.text = dict.object(forKey: "category") as? String ?? ""
        
        let plotSize = dict.object(forKey: "plotSize") as? String ?? ""
        let plotSizeUnit = dict.object(forKey: "plotSizeUnit") as? String ?? ""
        
        cell.lblPricePerMeter.text = "\(plotSize)\(plotSizeUnit)"
        
        if type == "sale"{
            
            let totalPrice = dict.object(forKey: "totalPriceSale") as? String ?? ""
            
            let currency = dict.object(forKey: "currency") as? String ?? ""
            
            cell.lblPrice.text = "\(currency) \(totalPrice)"
            
            let pricePerMeter = dict.object(forKey: "pricePerMeter") as? String ?? ""
            
            cell.lblSquareMeter.text = "\(currency) \(pricePerMeter) M2"
        }
        else{
            
            let totalPrice = dict.object(forKey: "totalPriceRent") as? String ?? ""
            
            let currency = dict.object(forKey: "currency") as? String ?? ""
            
            let rentTime = dict.object(forKey: "rentTime") as? String ?? ""
            
            cell.lblPrice.text = "\(currency) \(totalPrice) \(rentTime)"
            
            cell.lblSquareMeter.text = "     "
        }
        
        let imageArr = dict.object(forKey: "imagesFile") as? NSArray ?? []
        if imageArr.count == 0{
            
            cell.imgProperty.image = UIImage(named: "defaultProperty")
        }
        else{
            
            let dict = imageArr.object(at: 0) as? NSDictionary ?? [:]
            let imageStr = dict.object(forKey: "image") as? String ?? ""
            
            if imageStr != ""{
                
                let urlStr = URL(string: imageStr)
                cell.imgProperty.setImageWith(urlStr, placeholderImage: UIImage(named: "defaultProperty"))
            }
            else{
                
                cell.imgProperty.image = UIImage(named: "defaultProperty")
            }
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = propertyDataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        let type = dict.object(forKey: "Type") as? String ?? ""
        
        if type == "sale" || type == "rent"{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PropertyTitleController") as! PropertyTitleController
            
            let propertyId = dict.object(forKey: "_id") as? String ?? ""
            
            let profId = dict.object(forKey: "professionalUserId") as? String ?? ""
            
            vc.propertyType = type
            vc.propertyId = propertyId
            
            vc.profUserID = profId
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
//    @objc func btnChatAction(sender:UIButton){
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatWithUserController") as! ChatWithUserController
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    @objc func btnChatAction(sender:UIButton){
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            if restrictCallChat == true{
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not chat with your own property", controller: self)
            }
            else{
                
                let dict = propertyDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
                
                let receiverId = dict.object(forKey: "userId") as? String ?? ""
                
                let propertyId = dict.object(forKey: "_id") as? String ?? ""
                
                let descTxt = dict.object(forKey: "description") as? String ?? ""
                
                var headerName = ""
                
                let type = dict.object(forKey: "Type") as? String ?? ""
                
                if type == "sale" || type == "rent"{
                    
                    headerName = dict.object(forKey: "title") as? String ?? ""
                    
                }
                else{
                    
                    headerName = dict.object(forKey: "fullName") as? String ?? ""
                }
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatWithUserController") as! ChatWithUserController
                
                vc.receiverID = receiverId
                
                vc.propertyID = propertyId
                
                vc.headerName = headerName
                
                vc.descriptionStr = descTxt
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else{
            
            makeRootToLoginSignup()
        }
    }
    
    
    @objc func tap_shareBtn(sender:UIButton){
        
        let dict = propertyDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
        let type = dict.object(forKey: "Type") as? String ?? ""
            
        let propertyTitle = dict.object(forKey: "title") as? String ?? ""
            
        self.shareProperty(propertyTitle: propertyTitle, propertyType: type)
       
    }
    
    @objc func tapSaleAndRentLikeBtn(sender:UIButton){
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            if restrictCallChat == true{
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not like your own property", controller: self)
            }
            else{
                
                let dict = propertyDataArr.object(at:sender.tag) as? NSDictionary ?? [:]
                let type = dict.object(forKey: "Type") as? String ?? ""
                let id = dict.object(forKey: "_id") as? String ?? ""
                let likeStatus = dict.object(forKey: "likedStatus") as? String ?? ""
                
                var sendLikeDislikeStatus = false
                
                if likeStatus == "yes"{
                    
                    sendLikeDislikeStatus = false
                }
                else{
                    
                    sendLikeDislikeStatus = true
                }
                
                self.apiCallForLikeDislike(type: type, status: sendLikeDislikeStatus, propertyId: id, profileId: "", seprationType: "Property")
            }
            
        }
        else{
            
            self.makeRootToLoginSignup()
        }
        
    }
    
    @objc func callOnNumber(sender:UIButton){
        
        if restrictCallChat == true{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not make call for your own profile", controller: self)
        }
        else{
            
            let dict = propertyDataArr.object(at: sender.tag) as? NSDictionary ?? [:]
            
            // let moreInfoDict = dict.object(forKey: "professionalUserId") as? NSDictionary ?? [:]
            
            let phoneNo = dict.object(forKey: "mobileNumber") as? String ?? ""
            
            let countryCode = dict.object(forKey: "countryCode") as? String ?? ""
            
            if let url = URL(string: "tel://\(countryCode)\(phoneNo)"), UIApplication.shared.canOpenURL(url) {
                
                if #available(iOS 10, *) {
                    
                    UIApplication.shared.open(url)
                    
                } else {
                    
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
    }
    
}


extension ProfessionalPropertyListingController{
    
    func apiCallForGetProfessionalPropertyListing(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            //normalId
            
            var param:[String:String] = [:]
            
            if typeOfUser == "professional"{
                
                param = ["userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","professionalId":professionalUserId,"normalId":""]
            }
            else{
                
                param = ["userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","professionalId":"","normalId":normalUserId]
            }
            
            //let param = ["userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","professionalId":professionalUserId]
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetProfessionalPropertyListing as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        self.propertyDataArr = receivedData.object(forKey: "Data") as? NSArray ?? []
                        
                        if self.propertyDataArr.count == 0{
                            
                            self.viewSortMap.isHidden = true
                        }
                        else{
                            
                            self.viewSortMap.isHidden = false
                        }
                        
                        self.tableView.reloadData()
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
                    
                   // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    //*******************
    
    func apiCallForLikeDislike(type:String,status:Bool,propertyId:String,profileId:String,seprationType:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            var param:[String:Any] = [:]
            
            param = ["type":type,"propertyId":propertyId,"liked":status,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
         
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForLikeDislike as NSString, method_type: methodType.post, params: param as! [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                      self.apiCallForGetProfessionalPropertyListing()
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
    
    
    func apiCallForSortData(sortedType:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            var param:[String:Any] = [:]
            
            if typeOfUser == "professional"{
                
                param = ["\(sortedType)":true,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","professionalUserId":self.professionalUserId]
            }
            else{
                
                param = ["\(sortedType)":true,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","normalUserId":self.normalUserId]
            }
            
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForSortProfessionalPropertyListing as NSString, method_type: methodType.post, params: param as! [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "Data") as? NSArray{
                            
                            self.propertyDataArr = data
                            
                            self.tableView.reloadData()
                            
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
                    
                   // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
}



extension ProfessionalPropertyListingController:SortControllerDelegate{
    
    func sortedParameter(singleParamStr: String) {
        
        print(singleParamStr)
        
        self.apiCallForSortData(sortedType: singleParamStr)
    }

}
