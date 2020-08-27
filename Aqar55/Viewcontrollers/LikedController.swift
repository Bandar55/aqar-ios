//
//  LikedController.swift
//  Aqar55
//
//  Created by Callsoft on 05/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class LikedController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet var btnCategory: [UIButton]!
    
    let textArr = ["Sale","Rent","Professional","Business"]
    
    let colorArr = [
                    UIColor(red: 244/255, green: 0/255, blue: 13/255, alpha: 1.0),
                    UIColor(red: 0/255, green: 166/255, blue: 0/255, alpha: 1.0),
                    UIColor(red: 239/255, green: 105/255, blue: 0/255, alpha: 1.0),
                    UIColor(red: 141/255, green: 0/255, blue: 242/255, alpha: 1.0)]
    
    
    var finalArray = [HomeModel]()
    
    var selectedIndexTab = 0
    var headerTitle = ""
    
    let connection = webservices()
    var dataArr = NSArray()
    
    var selectedGlobalType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "CellForRentAndSale", bundle: nil), forCellReuseIdentifier: "CellForRentAndSale")
        self.tableView.register(UINib(nibName: "CellForProfessionalAndBusiness", bundle: nil), forCellReuseIdentifier: "CellForProfessionalAndBusiness")
        
        tableView.tableFooterView = UIView()
        
        lblTitle.text = headerTitle
        
        if finalArray.count > 0{
            finalArray.removeAll()
        }
        for i in 0 ..< textArr.count{
            if i == 0{
                self.finalArray.append(HomeModel(text: textArr[i], color: colorArr[i], isBottomViewHidden:false, bottomViewColor: colorArr[i]))
            }else{
                self.finalArray.append(HomeModel(text: textArr[i], color: colorArr[i], isBottomViewHidden:true, bottomViewColor: colorArr[i]))
            }
        }
        self.collectionView.reloadData()
        
        self.selectedGlobalType = "sale"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        if self.selectedIndexTab == 0{
            
            selectedGlobalType = "sale"
        }
        else if self.selectedIndexTab == 1{
            
            selectedGlobalType = "rent"
        }
        else if self.selectedIndexTab == 2{
            
            selectedGlobalType = "professional"
        }
        else if self.selectedIndexTab == 3{
            
            selectedGlobalType = "business"
        }
        
        if headerTitle == "Liked"{
        
            self.apiCallForLikedList(type: selectedGlobalType)
        }
        else{
        
            self.apiCallForRecentList(type: selectedGlobalType)
        }
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnUpperOptionAction(_ sender: UIButton) {
        
        selectedIndexTab = sender.tag
        UIView.animate(withDuration: 0.3) {
            self.bottomView.frame.origin.x = self.btnCategory[sender.tag].frame.origin.x
            self.bottomView.backgroundColor = self.btnCategory[sender.tag].titleLabel?.textColor
        }

        
        self.tableView.reloadData()
    }
    
    
    @IBAction func btnSearchAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchController") as! SearchController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension LikedController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if selectedIndexTab == 0 || selectedIndexTab == 1{
            
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
            
         //   cell.btnChat.addTarget(self, action: #selector(btnChatAction(sender:)), for: .touchUpInside)
            cell.btnDelete.isHidden = true
            
            let dict = dataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
            let type = dict.object(forKey: "Type") as? String ?? ""
            
            if self.headerTitle == "Recent"{
                
                let likeStatus = dict.object(forKey: "likedStatus") as? String ?? ""
                
                if likeStatus == "yes"{
                    
                    cell.btnLikeDislike.setImage(UIImage(named: "like_icon_new"), for: .normal)
                }
                else{
                    
                    cell.btnLikeDislike.setImage(UIImage(named: "unselectedHeart"), for: .normal)
                }
            }
            else{
                
                cell.btnLikeDislike.setImage(UIImage(named: "like_icon_new"), for: .normal)
                
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
                
                cell.lblSquareMeter.text = "      "
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
        else{
            
            ////*****************
            ////write here the code for professional and business
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellForProfessionalAndBusiness", for: indexPath) as! CellForProfessionalAndBusiness
            
            cell.btnLikeDislike.tag = indexPath.row
            cell.btnLikeDislike.addTarget(self, action: #selector(self.tapProfessionalAndBussinessLikeBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.btnShare.tag = indexPath.row
            cell.btnShare.addTarget(self, action: #selector(self.tap_shareBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.btnCall.tag = indexPath.row
            cell.btnCall.addTarget(self, action: #selector(self.callOnNumber(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.btnDelete.isHidden = true
            
            cell.btnChat.tag = indexPath.row
            cell.btnChat.addTarget(self, action: #selector(self.btnChatAction(sender:)), for: UIControl.Event.touchUpInside)
            
           // cell.btnChat.addTarget(self, action: #selector(btnChatAction(sender:)), for: .touchUpInside)
            
            let dict = dataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
            
            if self.headerTitle == "Recent"{
                
                let likeStatus = dict.object(forKey: "likedStatus") as? String ?? ""
                
                if likeStatus == "yes"{
                    
                    cell.btnLikeDislike.setImage(UIImage(named: "like_icon_new"), for: .normal)
                }
                else{
                    
                    cell.btnLikeDislike.setImage(UIImage(named: "unselectedHeart"), for: .normal)
                }
            }
            else{
                
                 cell.btnLikeDislike.setImage(UIImage(named: "like_icon_new"), for: .normal)
                
            }
            
            let imgStr = dict.object(forKey: "profileImage") as? String ?? ""
            
            if imgStr == ""{
                
                cell.imgUser.image = UIImage(named: "userPlaceholder")
            }
            else{
                
                let urlStr = URL(string: imgStr)
                cell.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "userPlaceholder"))
            }
            
            
            if selectedIndexTab == 2{
                
                cell.lblName.text = dict.object(forKey: "fullName") as? String ?? ""
                cell.lblCategory.text = "Category:\(dict.object(forKey: "category") as? String ?? "")"
                cell.lblIDs.text = "Professional ID:\(dict.object(forKey: "professionalId") as? String ?? "")"
                
                cell.lblDetails.text = "Details:\(dict.object(forKey: "description") as? String ?? "No Description found")"
                
            }
            
            if selectedIndexTab == 3{
                
                cell.lblName.text = dict.object(forKey: "fullName") as? String ?? ""
                cell.lblCategory.text = "Category:\(dict.object(forKey: "category") as? String ?? "")"
                cell.lblIDs.text = "Business ID:\(dict.object(forKey: "businessId") as? String ?? "")"
                
                cell.lblDetails.text = "Details:\(dict.object(forKey: "description") as? String ?? "No Description found")"
                
            }
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = dataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
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
        else{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfessionalNameController") as! ProfessionalNameController
            
            let idOfUserAsNormal = dict.object(forKey: "userId") as? String ?? ""
            
            if type == "professional"{
                
                vc.headerTitle = "Professional Name"
                
                vc.userType = "Professional"
            }
            else{
                
                vc.headerTitle = "Business Name"
                
                vc.userType = "Business"
            }
            
            vc.IdAsNormal = idOfUserAsNormal
            vc.dataDict = dict
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    
    @objc func tapSaleAndRentLikeBtn(sender:UIButton){
        
        let dict = dataArr.object(at:sender.tag) as? NSDictionary ?? [:]
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
        
        if self.headerTitle == "Recent"{
            
            self.apiCallForLikeDislike(type: type, status: sendLikeDislikeStatus, propertyId: id, profileId: "", seprationType: "Property")
        }
        else{
            
            self.apiCallForLikeDislike(type: type, status: false, propertyId: id, profileId: "", seprationType: "Property")
        }
        
    }
    
    
    @objc func tapProfessionalAndBussinessLikeBtn(sender:UIButton){
        
        let dict = dataArr.object(at: sender.tag) as? NSDictionary ?? [:]
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
        
        
        if self.headerTitle == "Recent"{
            
            self.apiCallForLikeDislike(type: type, status: sendLikeDislikeStatus, propertyId: "", profileId: id, seprationType: "UserProfile")
        }
        else{
            
            self.apiCallForLikeDislike(type: type, status: false, propertyId: "", profileId: id, seprationType: "UserProfile")
        }
        
    }
    
    
    @objc func tap_shareBtn(sender:UIButton){
        
        let dict = dataArr.object(at: sender.tag) as? NSDictionary ?? [:]
        let type = dict.object(forKey: "Type") as? String ?? ""
        
        if type == "sale" || type == "rent"{
            
            let propertyTitle = dict.object(forKey: "title") as? String ?? ""
            
            self.shareProperty(propertyTitle: propertyTitle, propertyType: type)
        }
        else{
            
            let name = dict.object(forKey: "fullName") as? String ?? ""
            
            self.shareProfile(userName: name, profileType: type)
        }
    }
    
    @objc func callOnNumber(sender:UIButton){
        
        let dict = dataArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
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
    
    func shareProfile(userName:String,profileType:String){
        
       // let title = "I just used the Aqar55 App and saw the profile of \(userName) as \(profileType) user. Highly recommend that you try it too."
        
        let title = "Aqar is the right app if you are looking for apartments for rent or villas for sale or rent  or land for sale in Saudi Arabia. Aqar displays all Saudi real estates ads on Google Maps; navigate in the area you like and find your next home!\nYou can directly contact the owner and make the deal. \n \n App Store : https://apps.apple.com/us/app/aqar55/id1472194209?ls=1 \n \n Play store : https://play.google.com/store/apps/details?id=com.aqar55&amp;hl=en_US"
        
        let textToShare = [title] as [Any]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = []
        activityViewController.setValue("Aqar55", forKey: "subject")
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @objc func btnChatAction(sender:UIButton){
        
        let dict = dataArr.object(at: sender.tag) as? NSDictionary ?? [:]
            
        let receiverId = dict.object(forKey: "userId") as? String ?? ""
            
        let propertyId = dict.object(forKey: "_id") as? String ?? ""
        
        var headerName = ""
        
        let type = dict.object(forKey: "Type") as? String ?? ""
        
        let descTxt = dict.object(forKey: "description") as? String ?? ""
        
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


extension LikedController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.finalArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CellForUpperOption
        
        cell.lblTitle.textColor = finalArray[indexPath.row].color
        
        cell.lblTitle.text = finalArray[indexPath.item].text
        
        cell.bottomView.backgroundColor = finalArray[indexPath.row].bottomViewColor
        
        cell.bottomView.isHidden = finalArray[indexPath.row].isBottomViewHidden
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndexTab = indexPath.row
        
        for i in 0 ..< textArr.count{
            
            if i == indexPath.row {
                
                self.finalArray[indexPath.row].bottomViewColor = colorArr[indexPath.row]
                self.finalArray[indexPath.row].isBottomViewHidden = false
                
            }else{
                
                self.finalArray[i].bottomViewColor = colorArr[indexPath.row]
                self.finalArray[i].isBottomViewHidden = true
            }
        }
        
        self.collectionView.reloadData()
        
        var type = ""
        
        if self.selectedIndexTab == 0{
            
            type = "sale"
        }
        else if self.selectedIndexTab == 1{
            
            type = "rent"
        }
        else if self.selectedIndexTab == 2{
            
            type = "professional"
        }
        else if self.selectedIndexTab == 3{
            
            type = "business"
        }
        else{}
        
        if self.headerTitle == "Liked"{
            
            self.apiCallForLikedList(type: type)
        }
        else{
            
            self.apiCallForRecentList(type: type)
        }
        
        //self.tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 90.0, height: 40.0)
    }
    
}


//MARK:- Webservices
//MARK:-
extension LikedController{
    
    func apiCallForLikedList(type:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["type":type,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForFetchLikeDislikeList as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        self.dataArr = receivedData.object(forKey: "Data") as? NSArray ?? []
                        
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
    
    
    func apiCallForRecentList(type:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["type":type,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForFetchRecentList as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        self.dataArr = receivedData.object(forKey: "Data") as? NSArray ?? []
                        
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
                  //  CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
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
            
            if type == "sale" || type == "rent"{
                
                param = ["type":type,"propertyId":propertyId,"liked":status,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
                
            }
            else{
                
                param = ["type":type,"profbusinessId":profileId,"liked":status,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            }
            
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForLikeDislike as NSString, method_type: methodType.post, params: param as! [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        var propertyType = ""
                        
                        if self.selectedIndexTab == 0{
                            
                            propertyType = "sale"
                        }
                        else if self.selectedIndexTab == 1{
                            
                            propertyType = "rent"
                        }
                        else if self.selectedIndexTab == 2{
                            
                            propertyType = "professional"
                        }
                        else if self.selectedIndexTab == 3{
                            
                            propertyType = "business"
                        }
                        
                        if self.headerTitle == "Recent"{
                            
                            self.apiCallForRecentList(type: propertyType)
                        }
                        else{
                            
                            self.apiCallForLikedList(type: propertyType)
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
                    
                    //self.navigationController?.popViewController(animated: true)
                    
                   // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
    
}
