//
//  MenuController.swift
//  Aqar55
//
//  Created by Callsoft on 04/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import KYDrawerController
class MenuController: UIViewController {
    
    @IBOutlet var headerView: UIView!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var lblProfessionalID: UILabel!
    
    @IBOutlet weak var lblBusinessID: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var viewUserInfo: UIView!
    
    let textArray = ["Home/Map","Liked","Recent","Sell/Rent","Post a Property","Manage posted properties","My Profile","Post & Manage My Professional Profile","Post & Manage My Business Profile","Settings","Rate this App","Share this App","Contact Admin"]
    
    let imageArray = ["home_icon_latest","like_icon","recent_open","sell_offer","bank_icon","share_market","men_new_user","usernew_icon","user_icon_png","settings_icon","star_icon","share","call"]
    
    let connection = webservices()
    
    var totalPropertyCount = 0
    
    var professionalProfileActivated = false
    var businessProfileActivated = false
    
    var userInfoModelItem = UserInfoDataModel()
    
    var globalBusinessId = ""
    var globalProfessionalId = ""
    
    var professionalRemainingDays = 0
    var businessRemainingDays = 0
    
    var professionalIdToUpdate = ""
    var businessIdToUpdate = ""
    
    var globalUserDataDict = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = headerView
        
        tableView.register(UINib(nibName: "CellForProfile", bundle: nil), forCellReuseIdentifier: "CellForProfile")
        tableView.register(UINib(nibName: "CellForPost_ManageProfile", bundle: nil), forCellReuseIdentifier: "CellForPost_ManageProfile")
        tableView.register(UINib(nibName: "CellForFollowUs", bundle: nil), forCellReuseIdentifier: "CellForFollowUs")
        
        let attrStringProfessional : NSMutableAttributedString = NSMutableAttributedString(string:  "Professional ID 1256458")
        let attrStringBusiness : NSMutableAttributedString = NSMutableAttributedString(string:  "Business ID 1256458")
        
        attrStringProfessional.setColorForText("Professional ID", with: UIColor.black)
        attrStringProfessional.setColorForText("1256458", with: UIColor(red: 15/255, green: 0/255, blue: 227/255, alpha: 1.0))
        
        attrStringBusiness.setColorForText("Business ID", with: UIColor.black)
        attrStringBusiness.setColorForText("1256458", with: UIColor(red: 15/255, green: 0/255, blue: 227/255, alpha: 1.0))
        lblProfessionalID.attributedText = attrStringProfessional
        lblBusinessID.attributedText = attrStringBusiness
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            btnLogin.isHidden = true
            viewUserInfo.isHidden = false
            
            self.apiCallForGetUserDetail()
        }
        else{
            
            btnLogin.isHidden = false
            viewUserInfo.isHidden = true
        }
    }
    
    
    @IBAction func btnCloseAction(_ sender: Any) {
        
        if let drawerController = navigationController?.parent as? KYDrawerController{
            
            drawerController.setDrawerState(.closed, animated: true)
        }
    }
    
    @IBAction func tap_loginBtn(_ sender: Any) {
        
        self.makeRootToLoginSignup()
    }
    
}

extension MenuController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row >= 0 && indexPath.row < 7) || (indexPath.row >= 9 && indexPath.row <= 12){
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellForProfile", for: indexPath) as! CellForProfile
            
            if indexPath.row == 0{
                
                cell.backgroundColor = UIColor(red: 229/255, green: 228/255, blue: 255/255, alpha: 1.0)
                cell.imgArrow.isHidden = false
                cell.lblPost.isHidden = true
                cell.lblProperties.isHidden = true
                
            }else if indexPath.row == 3{
                
                cell.backgroundColor = UIColor(red: 17/255, green: 0/255, blue: 254/255, alpha: 1.0)
                cell.lblText.textColor = UIColor.white
                cell.imgArrow.isHidden = true
                cell.lblPost.isHidden = true
                cell.lblProperties.isHidden = true
                
            }else{
                
                if indexPath.row == 4{
                    cell.lblPost.isHidden = false
                    cell.imgArrow.isHidden = true
                    cell.lblProperties.isHidden = true
                }
                if indexPath.row == 5{
                    
                    cell.imgArrow.isHidden = true
                    cell.lblProperties.isHidden = false
                    
                    cell.lblProperties.text = "\(totalPropertyCount)"
                    
                    cell.lblPost.isHidden = true
                }
                cell.backgroundColor = UIColor.white
                cell.imgArrow.isHidden = true
                
            }
            
            cell.imgView.image = UIImage(named: imageArray[indexPath.row])
            cell.lblText.text = textArray[indexPath.row]
            return cell
            
        }else if indexPath.row == 7 || indexPath.row == 8{
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellForPost_ManageProfile", for: indexPath) as! CellForPost_ManageProfile
            
            cell.btnUpdate.tag = indexPath.row
            cell.btnUpdate.addTarget(self, action: #selector(self.tapUpdateBussinessAndprofessionalBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.lblText.text = textArray[indexPath.row]
            
            if indexPath.row == 7{
                
                if professionalProfileActivated == true{
                    
                    cell.lblText.text = "Post & Manage My Professional Profile"
                    
                    cell.lblUpdateDays.isHidden = false
                    
                    cell.lblUpdateDays.text = "Update \(professionalRemainingDays)/120 days"
                    
                }
                else{
                    
                    cell.lblText.text = "Post My Professional Profile"
                    
                    cell.lblUpdateDays.isHidden = true
                }
                
            }
            else{
                
                if businessProfileActivated == true{
                    
                    cell.lblText.text = "Post & Manage My Business Profile"
                    
                    cell.lblUpdateDays.isHidden = false
                    
                    cell.lblUpdateDays.text = "Update \(businessRemainingDays)/120 days"
                }
                else{
                    
                    cell.lblText.text = "Post My Business Profile"
                    
                    cell.lblUpdateDays.isHidden = true
                }
            }
            
            cell.imgView.image = UIImage(named: imageArray[indexPath.row])
            
            return cell
            
        }else if indexPath.row == 13{
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellForFollowUs", for: indexPath) as! CellForFollowUs
            
            cell.btnFacebook.addTarget(self, action: #selector(self.tapFbBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.btnGoogle.addTarget(self, action: #selector(self.tapGooglePlusBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.btnTwitter.addTarget(self, action: #selector(self.tapTwitterBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            return cell
            
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 7 || indexPath.row == 8{
            
            return UITableView.automaticDimension
            
        }else if indexPath.row == 13{
            
            return 60.0
            
        } else{
            
            return 41.0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 7 || indexPath.row == 8{
            
            return UITableView.automaticDimension
            
        }else{
            
            return 41.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let drawerController = navigationController?.parent as? KYDrawerController{
            drawerController.setDrawerState(.closed, animated: true)
            if let mainNavVC = drawerController.mainViewController as? UINavigationController{
                
                if indexPath.row == 0{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") as! HomeController
                    mainNavVC.pushViewController(vc, animated: true)
                }
                
                if indexPath.row == 1{
                    
                    if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LikedController") as! LikedController
                        vc.headerTitle = "Liked"
                        
                        mainNavVC.pushViewController(vc, animated: true)
                    }
                    else{
                        
                        self.makeRootToLoginSignup()
                    }
                    
                }
                
                if indexPath.row == 2{
                    
                    if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LikedController") as! LikedController
                        vc.headerTitle = "Recent"
                        mainNavVC.pushViewController(vc, animated: true)
                    }
                    else{
                        
                        self.makeRootToLoginSignup()
                        
                    }
                    
                }
                
                if indexPath.row == 4{
                    
                    if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostPropertyController") as! PostPropertyController
                        mainNavVC.pushViewController(vc, animated: true)
                        
                    }
                    else{
                        
                        self.makeRootToLoginSignup()
                    }
                    
                }
                
                if indexPath.row == 5{
                    
                    if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageMyPropertyController") as! ManageMyPropertyController
                        mainNavVC.pushViewController(vc, animated: true)
                    }
                    else{
                        
                        self.makeRootToLoginSignup()
                    }
                    
                }
                
                if indexPath.row == 6{
                    
                    if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileController") as! MyProfileController
                        
                        vc.globalUserData = self.globalUserDataDict
                        
                        mainNavVC.pushViewController(vc, animated: true)
                    }
                    else{
                        
                        self.makeRootToLoginSignup()
                    }
                    
                }
                
                if indexPath.row == 7{
                    
                    if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                        
                        if self.professionalProfileActivated == true{
                            apiCallFor_getBusinessOrProfessionalProfile(mainNavVC:mainNavVC, index: 7)
                            
                        }
                        else{
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyBusinessProfileController") as! MyBusinessProfileController
                            vc.headerTitle = "My Professional Profile"
                            vc.userInfoModelItem = userInfoModelItem
                            
                            vc.updateUIFuncWillCalled = false
                            
                            vc.idToBeFilled = self.globalProfessionalId
                            
                            vc.userInfoDict = self.globalUserDataDict
                            
                            mainNavVC.pushViewController(vc, animated: true)
                        }
                        
                        
                    }
                    else{
                        
                        self.makeRootToLoginSignup()
                    }
                    
                }
                
                if indexPath.row == 8{
                    
                    if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                        
                        if self.businessProfileActivated == true{
                            
                            //edit
                            apiCallFor_getBusinessOrProfessionalProfile(mainNavVC: mainNavVC, index: 8)
                            
                        }
                        else{
                            
                            //create
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyBusinessProfileController") as! MyBusinessProfileController
                            
                            vc.headerTitle = "My Business Profile"
                            
                            vc.updateUIFuncWillCalled = false
                            
                            vc.idToBeFilled = self.globalBusinessId
                            
                            vc.userInfoDict = self.globalUserDataDict
                            
                            mainNavVC.pushViewController(vc, animated: true)
                        }
                    }
                    else{
                        
                        self.makeRootToLoginSignup()
                    }
                    
                }
                
                if indexPath.row == 9{
                    
                    if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingController") as! SettingController
                        mainNavVC.pushViewController(vc, animated: true)
                        
                    }
                    else{
                        
                        self.makeRootToLoginSignup()
                        
                    }
                }
                
                if indexPath.row == 10{
                    
                    self.openSocialUrl(urlData: "https://apps.apple.com/us/app/aqar55/id1472194209?ls=1")
                }
                
                if indexPath.row == 11{
                    
                    self.shareApp()
                }
                
                if indexPath.row == 12{
                    
                    if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactAdminController") as! ContactAdminController
                        mainNavVC.pushViewController(vc, animated: true)
                    }
                    else{
                        
                        self.makeRootToLoginSignup()
                    }
                    
                }
                
            }
            
        }
    }
    
    
    @objc func tapUpdateBussinessAndprofessionalBtn(sender:UIButton){
        
        print(sender.tag)
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            if sender.tag == 7{
                
                if professionalProfileActivated == true{
                    
                    ///hit api for update
                    
                    self.apiCallForUpdateProfile(type: "Professional", ID: self.professionalIdToUpdate)
                    
                }
                else{
                    
                    if let drawerController = navigationController?.parent as? KYDrawerController{
                        drawerController.setDrawerState(.closed, animated: true)
                        if let mainNavVC = drawerController.mainViewController as? UINavigationController{
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyBusinessProfileController") as! MyBusinessProfileController
                            vc.headerTitle = "My Professional Profile"
                            vc.userInfoModelItem = userInfoModelItem
                            
                            vc.updateUIFuncWillCalled = false
                            
                            vc.idToBeFilled = self.globalProfessionalId
                            
                            vc.userInfoDict = self.globalUserDataDict
                            
                            mainNavVC.pushViewController(vc, animated: true)
                            
                        }
                        
                    }
                    
                }
            }
            else if sender.tag == 8{
                
                if businessProfileActivated == true{
                    
                    ///hit api for update
                    
                    self.apiCallForUpdateProfile(type: "Business", ID: self.businessIdToUpdate)
                    
                }
                else{
                    
                    if let drawerController = navigationController?.parent as? KYDrawerController{
                        drawerController.setDrawerState(.closed, animated: true)
                        if let mainNavVC = drawerController.mainViewController as? UINavigationController{
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyBusinessProfileController") as! MyBusinessProfileController
                            
                            vc.headerTitle = "My Business Profile"
                            
                            vc.updateUIFuncWillCalled = false
                            
                            vc.idToBeFilled = self.globalBusinessId
                            
                            vc.userInfoDict = self.globalUserDataDict
                            
                            mainNavVC.pushViewController(vc, animated: true)
                            
                        }
                    }
                }
            }
            
        }
        else{
            
            self.makeRootToLoginSignup()
        }
        
    }
    
    
    @objc func tapGooglePlusBtn(sender:UIButton){
        
        openSocialUrl(urlData: "https://www.youtube.com/channel/UCV6X789T18rxbagDuxAS92Q")
    }
    
    @objc func tapFbBtn(sender:UIButton){
        
        openSocialUrl(urlData: "https://www.facebook.com/")
    }
    
    @objc func tapTwitterBtn(sender:UIButton){
        
        openSocialUrl(urlData: "https://twitter.com/")
    }
    
    func openSocialUrl(urlData:String){
        
        guard let url = URL(string: urlData) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    func shareApp(){
        
      //  let title = "I just used the Aqar55 App and it helps in real state business to sale and rent for your property. Highly recommend that you try it too."
        
        let title = "Aqar is the right app if you are looking for apartments for rent or villas for sale or rent  or land for sale in Saudi Arabia. Aqar displays all Saudi real estates ads on Google Maps; navigate in the area you like and find your next home!\nYou can directly contact the owner and make the deal. \n \n App Store : https://apps.apple.com/us/app/aqar55/id1472194209?ls=1 \n \n Play store : https://play.google.com/store/apps/details?id=com.aqar55&amp;hl=en_US"
        
        let textToShare = [title] as [Any]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = []
        activityViewController.setValue("Aqar55", forKey: "subject")
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}



extension MenuController{
    
    func alertWithAction(){
        
        let alertController = UIAlertController(title: "", message: "You are not logged in. Please login/signup before proceeding further.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            self.makeRootToLoginSignup()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
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
    
}


//MARK:- Webservices
//MARK:-
extension MenuController{
    
    func apiCallForGetUserDetail(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetUserDetail as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        self.apiCallForCountPropertiesOfUser()
                        
                        if let data = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            self.globalUserDataDict = data
                            
                            let fullname = data.object(forKey: "fullName") as? String ?? ""
                            
                            self.lblUserName.text = fullname
                            
                            self.businessIdToUpdate = data.object(forKey: "business_id") as? String ?? ""
                            
                            self.professionalIdToUpdate = data.object(forKey: "professional_id") as? String ?? ""
                            
                            let imgStr = data.object(forKey: "profileImage") as? String ?? ""
                            
                            if imgStr == ""{
                                
                                 self.imgUser.image = UIImage(named: "userPlaceholder")
                            }
                            else{
                                
                                DispatchQueue.global(qos: .background).async {
                                    
                                    let urlStr = URL(string: imgStr)
                                    
                                    if urlStr != nil{
                                        
                                         self.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "userPlaceholder"))
                                    }
                                   
                                }
                               
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
                    
                    self.navigationController?.popViewController(animated: true)
                    
                    //CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    func apiCallForCountPropertiesOfUser(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            //5cb99a383d94371d95807c6f
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
           //  let param = ["userId":"5cb9801220d2e30f8b88e5d5"]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForCountProperties as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        self.totalPropertyCount = receivedData.object(forKey: "property") as? Int ?? 0
                        
                        guard let userInfo = receivedData.object(forKey: "user") as? NSDictionary else{
                            print("No userInfo")
                            return
                        }
                        
                        self.businessProfileActivated = userInfo.object(forKey: "businessProfile") as? Bool ?? false
                        
                        self.professionalProfileActivated = userInfo.object(forKey: "professionalProfile") as? Bool ?? false
                        
                        
                        if self.businessProfileActivated == true{
                            
                            let daysDict = receivedData.object(forKey: "days") as? NSDictionary ?? [:]
                            
                            self.businessRemainingDays = daysDict.object(forKey: "businessRemainingDays") as? Int ?? 0
                        }
                        
                        if self.professionalProfileActivated == true{
                            
                            let daysDict = receivedData.object(forKey: "days") as? NSDictionary ?? [:]
                            
                            self.professionalRemainingDays = daysDict.object(forKey: "profRemainingDays") as? Int ?? 0
                        }
                        
                        
                        self.userInfoModelItem.professionalProfile = userInfo.object(forKey: "professionalId") as? String ?? ""
                        
                        self.userInfoModelItem.businessProfile = userInfo.object(forKey: "businessId") as? String ?? ""
                        
                        self.lblBusinessID.text = "Business ID \(userInfo.object(forKey: "businessId") as? String ?? "")"
                        
                        self.lblProfessionalID.text = "Professional ID \(userInfo.object(forKey: "professionalId") as? String ?? "")"
                       
                        self.globalProfessionalId = userInfo.object(forKey: "professionalId") as? String ?? ""
                        
                        self.globalBusinessId = userInfo.object(forKey: "businessId") as? String ?? ""
                        
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
    
    
    //***************Api for update profile
    
    
    func apiCallForUpdateProfile(type:String,ID:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["profOrBusId":ID]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForUpdateParticularProfile as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if type == "Professional"{
                            
                            self.professionalRemainingDays = 0
                        }
                        else{
                            
                            self.businessRemainingDays = 0
                        }
                        
                        self.tableView.reloadData()
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
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
    
        
    //TODO: API for adit
    
    func apiCallFor_getBusinessOrProfessionalProfile(mainNavVC:UINavigationController,index:Int){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
                        
            let param = ["userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.getBusinessOrProfessionalProfile as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let dataArray = receivedData.object(forKey: "Data") as? NSArray{
                            
                            if dataArray.count != 0{
                            
                            if index == 7{
                                if dataArray.count > 1{
                                    if let dataDict0 = dataArray.object(at: 0) as? NSDictionary{
                                        if let type = dataDict0.value(forKey: "Type") as? String{
                                            if type == "professional"{
                                                self.parseProfessionalData(dataDict:dataDict0, mainNavVC: mainNavVC)
                                                
                                            }
                                        }
                                    }
                                    
                                    if let dataDict1 = dataArray.object(at: 1) as? NSDictionary{
                                        if let type = dataDict1.value(forKey: "Type") as? String{
                                            if type == "professional"{
                                                self.parseProfessionalData(dataDict:dataDict1, mainNavVC: mainNavVC)
                                                
                                            }
                                        }
                                    }
                                    
                                }else{
                                    if let dataDict = dataArray.object(at: 0) as? NSDictionary{
                                        if let type = dataDict.value(forKey: "Type") as? String{
                                            if type == "professional"{
                                                self.parseProfessionalData(dataDict:dataDict, mainNavVC: mainNavVC)
                                                
                                            }
                                        }
                                    }
                                }
                            }else{
                                if dataArray.count > 1{
                                    if let dataDict0 = dataArray.object(at: 0) as? NSDictionary{
                                        if let type = dataDict0.value(forKey: "Type") as? String{
                                            if type == "business"{
                                                self.parseProfessionalData(dataDict:dataDict0, mainNavVC: mainNavVC)
                                                
                                            }
                                        }
                                    }
                                    
                                    if let dataDict1 = dataArray.object(at: 1) as? NSDictionary{
                                        if let type = dataDict1.value(forKey: "Type") as? String{
                                            if type == "business"{
                                                self.parseProfessionalData(dataDict:dataDict1, mainNavVC: mainNavVC)
                                                
                                            }
                                        }
                                    }
                                    
                                }else{
                                    if let dataDict = dataArray.object(at: 0) as? NSDictionary{
                                        if let type = dataDict.value(forKey: "Type") as? String{
                                            if type == "business"{
                                                self.parseProfessionalData(dataDict:dataDict, mainNavVC: mainNavVC)
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            
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
                    
                    self.navigationController?.popViewController(animated: true)
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    func parseProfessionalData(dataDict:NSDictionary,mainNavVC:UINavigationController){
        
        let Type = dataDict.value(forKey: "Type") as? String ?? ""
        
        let id = dataDict.value(forKey: "_id") as? String ?? ""
        
        let area = dataDict.value(forKey: "area") as? String ?? ""
        
        let areaCovered = dataDict.value(forKey: "areaCovered") as? String ?? ""
        
        let businessId = dataDict.value(forKey: "businessId") as? String ?? ""
        
        let businessProfile = dataDict.value(forKey: "businessProfile") as? Int ?? 0
        
        let category = dataDict.value(forKey: "category") as? String ?? ""
        
        
        let city = dataDict.value(forKey: "city") as? String ?? ""
        
        
        let created = dataDict.value(forKey: "created") as? String ?? ""
        
        let description = dataDict.value(forKey: "description") as? String ?? ""
        
        let email = dataDict.value(forKey: "email") as? String ?? ""
        
        let facebookUrl = dataDict.value(forKey: "facebookUrl") as? String ?? ""
        
        let fullName = dataDict.value(forKey: "fullName") as? String ?? ""
        
        let googleplusUrl = dataDict.value(forKey: "googleplusUrl") as? String ?? ""
        
        let govtIdImage1 = dataDict.value(forKey: "govtIdImage1") as? String ?? ""
        
        let govtIdImage2 = dataDict.value(forKey: "govtIdImage2") as? String ?? ""
        
        let govtIdNumber1 = dataDict.value(forKey: "govtIdNumber1") as? String ?? ""
        
        let govtIdNumber2 = dataDict.value(forKey: "govtIdNumber2") as? String ?? ""
        
        
        let govtIdType1 = dataDict.value(forKey: "govtIdType1") as? String ?? ""
        
        let govtIdType2 = dataDict.value(forKey: "govtIdType2") as? String ?? ""
        
        let imagesFile = dataDict.value(forKey: "imagesFile") as? NSArray ?? []
        
        let lat = dataDict.value(forKey: "lat") as? String ?? ""
        
        let linkedinUrl = dataDict.value(forKey: "linkedinUrl") as? String ?? ""
        
        let long = dataDict.value(forKey: "long") as? String ?? ""
        
        let memberSince = dataDict.value(forKey: "memberSince") as? String ?? ""
        
        let mobileNumber = dataDict.value(forKey: "mobileNumber") as? String ?? ""
        
        let modified = dataDict.value(forKey: "modified") as? String ?? ""
        
        let professionalId = dataDict.value(forKey: "professionalId") as? String ?? ""
        
        let professionalProfile = dataDict.value(forKey: "professionalProfile") as? Int ?? 0
        
        let projectAchieved = dataDict.value(forKey: "projectAchieved") as? String ?? ""
        
        let snapchatUrl = dataDict.value(forKey: "snapchatUrl") as? String ?? ""
        
        let specialities = dataDict.value(forKey: "specialities") as? String ?? ""
        
        let state = dataDict.value(forKey: "state") as? String ?? ""
        
        let status = dataDict.value(forKey: "status") as? String ?? ""
        
        let subCategory = dataDict.value(forKey: "subCategory") as? String ?? ""
        
        let totalDays = dataDict.value(forKey: "totalDays") as? String ?? ""
        
        let twitterUrl = dataDict.value(forKey: "twitterUrl") as? String ?? ""
        
        let userId = dataDict.value(forKey: "userId") as? String ?? ""
        
        let videosFile = dataDict.value(forKey: "videosFile") as? NSArray ?? []
        
        let website = dataDict.value(forKey: "website") as? String ?? ""
        
        let zipcode = dataDict.value(forKey: "zipcode") as? String ?? ""
        
        let profileImg = dataDict.value(forKey: "profileImage") as? String ?? ""
        
        userInfoModelItem.user_Type = Type
        userInfoModelItem.user_id = id
        userInfoModelItem.area = area
        userInfoModelItem.areaCovered = areaCovered
        userInfoModelItem.businessId = businessId
//        userInfoModelItem.businessProfile = String(businessProfile)
        userInfoModelItem.category = category
        userInfoModelItem.city = city
        userInfoModelItem.created = created
        userInfoModelItem.description = description
        userInfoModelItem.email = email
        userInfoModelItem.facebookUrl = facebookUrl
        userInfoModelItem.fullName = fullName
        userInfoModelItem.googleplusUrl = googleplusUrl
        userInfoModelItem.govtIdImage1 = govtIdImage1
        userInfoModelItem.govtIdImage2 = govtIdImage2
        userInfoModelItem.govtIdNumber1 = govtIdNumber1
        userInfoModelItem.govtIdNumber2 = govtIdNumber2
        userInfoModelItem.govtIdType1 = govtIdType1
        userInfoModelItem.govtIdType2 = govtIdType2
        userInfoModelItem.imagesFile =  imagesFile
        userInfoModelItem.lat = lat
        userInfoModelItem.linkedinUrl = linkedinUrl
        userInfoModelItem.long = long
        userInfoModelItem.memberSince = memberSince
        userInfoModelItem.mobileNumber = mobileNumber
        userInfoModelItem.modified = modified
        userInfoModelItem.professionalId = professionalId
//        userInfoModelItem.professionalProfile = String(professionalProfile)
        userInfoModelItem.projectAchieved = projectAchieved
        userInfoModelItem.snapchatUrl = snapchatUrl
        userInfoModelItem.specialities = specialities
        userInfoModelItem.state = state
        userInfoModelItem.status = status
        userInfoModelItem.subCategory = subCategory
        userInfoModelItem.termsCondition = ""
        userInfoModelItem.totalDays = totalDays
        userInfoModelItem.twitterUrl = twitterUrl
        userInfoModelItem.userId = userId
        userInfoModelItem.videosFile = videosFile
        userInfoModelItem.website = website
        userInfoModelItem.zipcode = zipcode
        userInfoModelItem.profileImage = profileImg
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyBusinessProfileController") as! MyBusinessProfileController
        
        if userInfoModelItem.user_Type == "professional"{
            
            vc.headerTitle = "My Professional Profile"
            
            vc.idToBeFilled = self.globalProfessionalId
            
        }else{
            
            vc.headerTitle = "My Business Profile"
            
            vc.idToBeFilled = self.globalBusinessId
        }
        
        vc.userInfoModelItem = userInfoModelItem
        
        vc.updateUIFuncWillCalled = true
        
        mainNavVC.pushViewController(vc, animated: true)
        
    }
    
}
