//
//  PropertyTitleController.swift
//  Aqar55
//
//  Created by Callsoft on 13/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps

class PropertyTitleController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet var viewHeader: UIView!
    
    @IBOutlet var viewFooter: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imgDefault: UIImageView!
    
    
    @IBOutlet weak var imgCount_Lbl: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBOutlet weak var mapview: GMSMapView!
    
    @IBOutlet weak var lblPropertyFor: UILabel!
    
    @IBOutlet weak var lblPropertyCategory: UILabel!
    
    @IBOutlet weak var lblPropertyId: UILabel!
    
    @IBOutlet weak var lblPropertyPurpuse: UILabel!
    
    @IBOutlet weak var lblAvailabilityFor: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblPricePerMeter: UILabel!
    
    @IBOutlet weak var lblPriceCrossPlotSize: UILabel!
    
    @IBOutlet weak var lblPlotSize: UILabel!
    
    @IBOutlet weak var lblDailyRentTime: UILabel!
    
    @IBOutlet weak var lblYearlyRentTime: UILabel!
    
    @IBOutlet weak var lblWeeklyRentTime: UILabel!
    
    @IBOutlet weak var lblMonthlyRentTime: UILabel!
    
    @IBOutlet weak var lblPlotSizeInView: UILabel!
    
    @IBOutlet weak var lblBuiltInSize: UILabel!
    
    @IBOutlet weak var lblYearBuilt: UILabel!
    
    @IBOutlet weak var lblStreetView: UILabel!
    
    @IBOutlet weak var lblStreetWidth: UILabel!
    
    @IBOutlet weak var lblBedrooms: UILabel!
    
    @IBOutlet weak var lblBathrooms: UILabel!
    
    @IBOutlet weak var lblKitchen: UILabel!
    
    @IBOutlet weak var lblLivingRoom: UILabel!
    
    @IBOutlet weak var lblKitchenInstalled: UILabel!
    
    @IBOutlet weak var lblAirConditionerInstalled: UILabel!
    
    @IBOutlet weak var lblBuildingApartment: UILabel!
    
    @IBOutlet weak var lblBuildingStore: UILabel!
    
    @IBOutlet weak var lblDriverRoom: UILabel!
    
    @IBOutlet weak var lblMaidRoom: UILabel!
    
    @IBOutlet weak var lblBuildingRoom: UILabel!
    
    @IBOutlet weak var lblRevenue: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblPropertyPostedDate: UILabel!
    
    @IBOutlet weak var lblUpdatePropertyTime: UILabel!
    
    @IBOutlet weak var lblPropertyViews: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblProfessionalCategory: UILabel!
    
    @IBOutlet weak var lblProfessionalSubCategory: UILabel!
    
    @IBOutlet weak var lblProfessionalId: UILabel!
    
    @IBOutlet weak var lblProfessionalDetail: UILabel!
    
    @IBOutlet weak var lblContact1: UILabel!
    
    @IBOutlet weak var lblContact2: UILabel!
    
    @IBOutlet weak var btnPlayVideo: UIButton!
    
    @IBOutlet weak var imgVideo: UIImageView!
    
    @IBOutlet weak var viewRent: UIView!
    
    @IBOutlet weak var lineViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var viewProfessionalInfo: UIView!
    
    @IBOutlet weak var btnLikeProfile: UIButton!
    
    @IBOutlet weak var btnLikeProperty: UIButton!
    
    @IBOutlet weak var lblStore: UILabel!
    
    @IBOutlet weak var lblDuplex: UILabel!
    
    @IBOutlet weak var lblAirConditioning: UILabel!
    
    @IBOutlet weak var lblLift: UILabel!
    
    @IBOutlet weak var lblFurnishing: UILabel!
    
    @IBOutlet weak var lblMeasureLengthWidth: UILabel!
    
    @IBOutlet weak var btnRequestForMoreInfo: UIButton!
    
    @IBOutlet weak var btnTotalPropertiesListed: UIButton!
    
    @IBOutlet weak var btnReport: UIButton!
    
    
    
    var restrictCallChat = false
    
    var propertyId = ""
    var propertyType = ""
    
    var arrOfImages = NSArray()
    
    let connection = webservices()
    
    var indoorArr = NSMutableArray()
    var outdoorArr = NSMutableArray()
    var parkingOptionArr = NSMutableArray()
    var furnishArr = NSMutableArray()
    var viewsArr = NSMutableArray()
    
    var specificationArr = NSMutableArray()
    var globalDataDict = NSDictionary()
    
    var dateFormatterForDate = DateFormatter()
    
    var profUserID = ""
    
    var controllerPurpuseFor = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapview.delegate = self
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.pageControl.numberOfPages = arrOfImages.count
        
        if self.controllerPurpuseFor == "ToSeenMySelfProperty"{
            
            self.btnRequestForMoreInfo.isHidden = true
            
            self.btnReport.isHidden = true
        }
        else{
            
            self.btnRequestForMoreInfo.isHidden = false
            
            self.btnReport.isHidden = false
        }
        
        lblContact2.isHidden = true
        
        //initialSetup()
        
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        tableView.rowHeight = 96.0
        
        self.apiCallForGetProprtyDetail(propertyId: propertyId)
    }
    

    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_reportBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactAdminController") as! ContactAdminController
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            self.makeRootToLoginSignup()
        }
    }
    
    
    
    @IBAction func tap_playVideoBtn(_ sender: Any) {
        
        if self.globalDataDict.count != 0{
            
            let videosFile = globalDataDict.object(forKey: "videosFile") as? NSArray ?? []
            
            if videosFile.count != 0{
                
                let dict = videosFile.object(at: 0) as? NSDictionary
                
                guard let url = URL(string: dict?.object(forKey: "video") as? String ?? "") else { return }
                UIApplication.shared.open(url)
                
            }
            else{
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "No Videos available", controller: self)
            }
        }
        
    }
    
    
    
    @IBAction func tap_moreInfoProperty(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            if globalDataDict.count != 0{
                
                if restrictCallChat == true{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not chat with your own property", controller: self)
                }
                else{
                    
                    let propertyId = globalDataDict.object(forKey: "_id") as? String ?? ""
                    
                    var receiverId = ""
                    
                    let headerName = globalDataDict.object(forKey: "title") as? String ?? ""
                    
                    let descTxt = globalDataDict.object(forKey: "description") as? String ?? ""
                    
                    if self.profUserID == ""{
                        
                        receiverId = self.globalDataDict.object(forKey: "userId") as? String ?? ""
                    }
                    else{
                        
                        let userData = self.globalDataDict.object(forKey: "userData") as? NSDictionary ?? [:]
                        
                        receiverId = userData.object(forKey: "userId") as? String ?? ""
                    }
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatWithUserController") as! ChatWithUserController
                    
                    vc.receiverID = receiverId
                    
                    vc.propertyID = propertyId
                    
                    vc.headerName = headerName
                    
                    vc.descriptionStr = descTxt
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        }
        else{
            
            makeRootToLoginSignup()
        }
    }
    
    
    @IBAction func tap_totalPropertiesCountBtn(_ sender: Any) {
        
        if self.globalDataDict.count != 0{
            
            let dict = self.globalDataDict.object(forKey: "userData") as? NSDictionary ?? [:]
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfessionalPropertyListingController") as! ProfessionalPropertyListingController
            
            let id = dict.object(forKey: "_id") as? String ?? ""
            
            let type = dict.object(forKey: "Type") as? String ?? ""
            
            if type == "professional"{
                
                vc.typeOfUser = "professional"
                vc.professionalUserId = id
            }
            else{
                
                vc.typeOfUser = "normal"
                vc.normalUserId = id
            }
            
            vc.restrictCallChat = self.restrictCallChat
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            
        }
      
    }
    
    
    
    @IBAction func tap_professionalAdditionalInfoBtn(_ sender: Any) {
        
        if globalDataDict.count != 0{
            
            let dict = globalDataDict.object(forKey: "userData") as? NSDictionary ?? [:]
            
            let userType = dict.object(forKey: "Type") as? String ?? ""
            
            let userId = dict.object(forKey: "userId") as? String ?? ""
            
            if userType == "professional"{
                
               // let userId = dict.object(forKey: "userId") as? String ?? ""
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfessionalNameController") as! ProfessionalNameController
                
                vc.headerTitle = "Professional Name"
                    
                vc.userType = "Professional"
                
                vc.dataDict = dict
                
                vc.restrictCallChat = self.restrictCallChat
                
                vc.IdAsNormal = userId
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else{
                
                let dict = globalDataDict.object(forKey: "userData") as? NSDictionary ?? [:]
                
                let fullName = dict.object(forKey: "fullName") as? String ?? ""
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "\(fullName) didn't publish the professional profile", controller: self)
            }
        }
        
    }
    
    
    
    
    
    @IBAction func tap_shareProfileBtn(_ sender: Any) {
        
        if self.globalDataDict.count != 0{
            
            let type = globalDataDict.object(forKey: "Type") as? String ?? ""
            let fullName = globalDataDict.object(forKey: "fullName") as? String ?? ""
            
            self.shareProfile(userName: fullName, profileType: type)
        }
    }
    
    @IBAction func tap_sharePropertyBtn(_ sender: Any) {
        
        if self.globalDataDict.count != 0{
            
            let title = globalDataDict.object(forKey: "title") as? String ?? ""
            let type = globalDataDict.object(forKey: "Type") as? String ?? ""
            
            self.shareProperty(propertyTitle: title, propertyType: type)
        }
        
    }
 
    
    @IBAction func tap_chatBtnUser(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            if globalDataDict.count != 0{
                
                if restrictCallChat == true{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not chat with your own profile", controller: self)
                }
                else{
                    
                    let propertyId = globalDataDict.object(forKey: "_id") as? String ?? ""
                    
                    var receiverId = ""
                    
                    var headerName = ""
                    
                    let descTxt = globalDataDict.object(forKey: "description") as? String ?? ""
                    
                    if self.profUserID == ""{
                        
                        receiverId = self.globalDataDict.object(forKey: "userId") as? String ?? ""
                    }
                    else{
                        
                        let userData = self.globalDataDict.object(forKey: "userData") as? NSDictionary ?? [:]
                        
                        receiverId = userData.object(forKey: "userId") as? String ?? ""
                        
                        headerName = userData.object(forKey: "fullName") as? String ?? ""
                    }
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatWithUserController") as! ChatWithUserController
                    
                    vc.receiverID = receiverId
                    
                    vc.propertyID = propertyId
                    
                    vc.headerName = headerName
                    
                    vc.descriptionStr = descTxt
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        }
        else{
            
            makeRootToLoginSignup()
        }
    }
    
    
    @IBAction func tap_chatBtnProperty(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            if globalDataDict.count != 0{
                
                if restrictCallChat == true{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not chat with your own property", controller: self)
                }
                else{
                    
                    let propertyId = globalDataDict.object(forKey: "_id") as? String ?? ""
                    
                    var receiverId = ""
                    
                    let headerName = globalDataDict.object(forKey: "title") as? String ?? ""
                    
                    let descTxt = globalDataDict.object(forKey: "description") as? String ?? ""
                    
                    if self.profUserID == ""{
                        
                        receiverId = self.globalDataDict.object(forKey: "userId") as? String ?? ""
                    }
                    else{
                        
                        let userData = self.globalDataDict.object(forKey: "userData") as? NSDictionary ?? [:]
                        
                        receiverId = userData.object(forKey: "userId") as? String ?? ""
                    }
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatWithUserController") as! ChatWithUserController
                    
                    vc.receiverID = receiverId
                    
                    vc.propertyID = propertyId
                    
                    vc.headerName = headerName
                    
                    vc.descriptionStr = descTxt
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        }
        else{
            
            makeRootToLoginSignup()
        }
    }
    
    
    @IBAction func tap_likeProfileBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            if globalDataDict.count != 0{
                
                if restrictCallChat == true{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not like your own profile", controller: self)
                }
                else{
                    
                    let dict = globalDataDict.object(forKey: "userData") as? NSDictionary ?? [:]
                    
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
                    
                    self.apiCallForLikeDislike(type: type, status: sendLikeDislikeStatus, propertyId: "", profileId: id, seprationType: "UserProfile")
                }
              
            }
        }
        else{
            
            makeRootToLoginSignup()
        }

    }
    
    
    @IBAction func tap_callOnPropertyNo(_ sender: Any) {
        
        if globalDataDict.count != 0{
            
            if restrictCallChat == true{
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not make call to your own profile", controller: self)
            }
            else{
                
                let contactNo = globalDataDict.object(forKey: "mobileNumber") as? String ?? ""
                
                let countryCode = globalDataDict.object(forKey: "countryCode") as? String ?? ""
                
                if let url = URL(string: "tel://\(countryCode)\(contactNo)"), UIApplication.shared.canOpenURL(url) {
                    
                    if #available(iOS 10, *) {
                        
                        UIApplication.shared.open(url)
                        
                    } else {
                        
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            
        }
    }
    
    
    @IBAction func tap_callOnUserNo(_ sender: Any) {
        
        if self.globalDataDict.count != 0{
            
            if restrictCallChat == true{
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not make call to your own profile", controller: self)
            }
            else{
                
                let userDataDict = globalDataDict.object(forKey: "userData") as? NSDictionary ?? [:]
                
                let countryCode = userDataDict.object(forKey: "countryCode") as? String ?? ""
                
                let professionalContactNo = userDataDict.object(forKey: "mobileNumber") as? String ?? ""
                
                if let url = URL(string: "tel://\(countryCode)\(professionalContactNo)"), UIApplication.shared.canOpenURL(url) {
                    
                    if #available(iOS 10, *) {
                        
                        UIApplication.shared.open(url)
                        
                    } else {
                        
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            
        }
      
    }
 
    
    @IBAction func tap_likePropertyBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            if globalDataDict.count != 0{
                
                if restrictCallChat == true{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not like your property", controller: self)
                }
                else{
                    
                    let type = globalDataDict.object(forKey: "Type") as? String ?? ""
                    let id = globalDataDict.object(forKey: "_id") as? String ?? ""
                    let likeStatus = globalDataDict.object(forKey: "likedStatus") as? String ?? ""
                    
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
        }
        else{
            
            makeRootToLoginSignup()
        }
       
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
        
        //let title = "I just used the Aqar55 App and saw the property \(propertyTitle) for \(propertyType). Highly recommend that you try it too."
        
        let title = "Aqar is the right app if you are looking for apartments for rent or villas for sale or rent  or land for sale in Saudi Arabia. Aqar displays all Saudi real estates ads on Google Maps; navigate in the area you like and find your next home!\nYou can directly contact the owner and make the deal. \n \n App Store : https://apps.apple.com/us/app/aqar55/id1472194209?ls=1 \n \n Play store : https://play.google.com/store/apps/details?id=com.aqar55&amp;hl=en_US"
        
        let textToShare = [title] as [Any]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = []
        activityViewController.setValue("Aqar55", forKey: "subject")
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func shareProfile(userName:String,profileType:String){
        
        //let title = "I just used the Aqar55 App and saw the profile of \(userName) as \(profileType) user. Highly recommend that you try it too."
        
        let title = "Aqar is the right app if you are looking for apartments for rent or villas for sale or rent  or land for sale in Saudi Arabia. Aqar displays all Saudi real estates ads on Google Maps; navigate in the area you like and find your next home!\nYou can directly contact the owner and make the deal. \n \n App Store : https://apps.apple.com/us/app/aqar55/id1472194209?ls=1 \n \n Play store : https://play.google.com/store/apps/details?id=com.aqar55&amp;hl=en_US"
        
        let textToShare = [title] as [Any]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = []
        activityViewController.setValue("Aqar55", forKey: "subject")
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}


extension PropertyTitleController:GMSMapViewDelegate{
    
    func configureMap(){}
    
    func fetchData(dateToConvert:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let pendingDate = dateFormatter.date(from: dateToConvert)!
        let sendDate = self.dateFormatterForDate.string(from: pendingDate)
        
        return "\(sendDate)"
    }
    
}



extension PropertyTitleController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return specificationArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.tableView.register(UINib(nibName: "DetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailsTableViewCell")
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath) as! DetailsTableViewCell
        
        cell.lblHEading.text = specificationArr.object(at: indexPath.row) as? String ?? ""
        
        if specificationArr.object(at: indexPath.row) as? String ?? "" == "Indoor"{
            
            for i in 0..<indoorArr.count{
                
                if i == 0{
                    
                    cell.lblOption1.text = indoorArr.object(at: i) as? String ?? ""
                }
                else if i == 1{
                    
                    cell.lblOption2.text = indoorArr.object(at: i) as? String ?? ""
                }
                else if i == 2{
                    
                    cell.lblOption3.text = indoorArr.object(at: i) as? String ?? ""
                }
                else if i == 3{
                    
                    cell.lblOption4.text = indoorArr.object(at: i) as? String ?? ""
                }
            }
        }
        else if specificationArr.object(at: indexPath.row) as? String ?? "" == "Outdoor"{
            
            for i in 0..<outdoorArr.count{
                
                if i == 0{
                    
                    cell.lblOption1.text = outdoorArr.object(at: i) as? String ?? ""
                }
                else if i == 1{
                    
                    cell.lblOption2.text = outdoorArr.object(at: i) as? String ?? ""
                }
                else if i == 2{
                    
                    cell.lblOption3.text = outdoorArr.object(at: i) as? String ?? ""
                }
                else if i == 3{
                    
                    cell.lblOption4.text = outdoorArr.object(at: i) as? String ?? ""
                }
            }
        }
        else if specificationArr.object(at: indexPath.row) as? String ?? "" == "Parking"{
            
            for i in 0..<parkingOptionArr.count{
                
                if i == 0{
                    
                    cell.lblOption1.text = parkingOptionArr.object(at: i) as? String ?? ""
                }
                else if i == 1{
                    
                    cell.lblOption2.text = parkingOptionArr.object(at: i) as? String ?? ""
                }
                else if i == 2{
                    
                    cell.lblOption3.text = parkingOptionArr.object(at: i) as? String ?? ""
                }
                else if i == 3{
                    
                    cell.lblOption4.text = parkingOptionArr.object(at: i) as? String ?? ""
                }
            }
        }
        else if specificationArr.object(at: indexPath.row) as? String ?? "" == "Furnishing"{
            
            for i in 0..<furnishArr.count{
                
                if i == 0{
                    
                    cell.lblOption1.text = furnishArr.object(at: i) as? String ?? ""
                }
                else if i == 1{
                    
                    cell.lblOption2.text = furnishArr.object(at: i) as? String ?? ""
                }
                else if i == 2{
                    
                    cell.lblOption3.text = furnishArr.object(at: i) as? String ?? ""
                }
                else if i == 3{
                    
                    cell.lblOption4.text = furnishArr.object(at: i) as? String ?? ""
                }
            }
        }
        else if specificationArr.object(at: indexPath.row) as? String ?? "" == "Views"{
            
            for i in 0..<viewsArr.count{
                
                if i == 0{
                    
                    cell.lblOption1.text = viewsArr.object(at: i) as? String ?? ""
                }
                else if i == 1{
                    
                    cell.lblOption2.text = viewsArr.object(at: i) as? String ?? ""
                }
                else if i == 2{
                    
                    cell.lblOption3.text = viewsArr.object(at: i) as? String ?? ""
                }
                else if i == 3{
                    
                    cell.lblOption4.text = viewsArr.object(at: i) as? String ?? ""
                }
            }
        }
        else{
            
            
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 96.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 96.0
    }
    
}

extension PropertyTitleController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyCollectionCell", for: indexPath) as! PropertyCollectionCell
        
        let dict = arrOfImages.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let imgStr = dict.object(forKey: "image") as? String ?? ""
        
        if imgStr != ""{
            
            let urlStr = URL(string: imgStr)
            
            cell.imgBanner.setImageWith(urlStr!, placeholderImage: UIImage(named: "bluehousered"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let currentPage = indexPath.row + 1
        
            self.pageControl.currentPage = indexPath.row
        
            self.imgCount_Lbl.text = "\(Int(currentPage)) Of \(self.arrOfImages.count)"
        
    }
    
}


extension PropertyTitleController : UIScrollViewDelegate
{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.collectionView {
            
            let pageWidth:CGFloat = scrollView.frame.width
            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
            
            print(currentPage)
            
            if currentPage == 0.0{
                
            }
            else if currentPage == 1.0{
                
            }
            else if currentPage == 2.0{
                
            }
            
            self.imgCount_Lbl.text = "\(Int(currentPage) + 1) Of \(self.arrOfImages.count)"
            
            self.pageControl.currentPage = Int(currentPage)
            
        }
    }
    
}

extension PropertyTitleController{
    
    
    func initialSetup(){
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
    }
    //TODO: Method for timer
    @objc func startTimer(){
        
        if let coll  = self.collectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < self.arrOfImages.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                    
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
    }
    
}



extension PropertyTitleController{
    
    func updateElement(dataDict:NSDictionary){
        
        self.lblNav.text = dataDict.object(forKey: "title") as? String ?? ""
        
        self.arrOfImages = dataDict.object(forKey: "imagesFile") as? NSArray ?? []
        
        self.pageControl.numberOfPages = arrOfImages.count
        
        initialSetup()
        
        self.collectionView.reloadData()
        
        if arrOfImages.count == 0{
            
            self.collectionView.isHidden = true
            self.imgCount_Lbl.isHidden = true
        }
        
        self.lblPropertyFor.text = "Property for \(dataDict.object(forKey: "Type") as? String ?? "")"
        
        self.lblPropertyCategory.text = "Property Category:\(dataDict.object(forKey: "category") as? String ?? "")"
        
        lblPropertyId.text = dataDict.object(forKey: "_id") as? String ?? ""
        
        let propertyViews = dataDict.object(forKey: "counter") as? Int ?? 0
        lblPropertyViews.text = "Viewed \(propertyViews) time"
        
        let propertyPurpuse = dataDict.object(forKey: "purpose") as? String ?? ""
        let availability = dataDict.object(forKey: "available") as? String ?? ""
        
        if propertyPurpuse == "both"{
            
            lblPropertyPurpuse.text = "Property Purpose : commercial and residential"
        }
        else{
            
            lblPropertyPurpuse.text = "Property Purpose : \(dataDict.object(forKey: "purpose") as? String ?? "")"
        }
        
        if availability == "both"{
            
            lblAvailabilityFor.text = "Availability for family and single"
        }
        else{
            
            lblAvailabilityFor.text = "Availability for \(dataDict.object(forKey: "available") as? String ?? "")"
        }
  
        
        let plotSize = dataDict.object(forKey: "plotSize") as? String ?? ""
        let plotSizeUnit = dataDict.object(forKey: "plotSizeUnit") as? String ?? ""
        
        let type = dataDict.object(forKey: "Type") as? String ?? ""
        if type == "sale"{
            
            let currency = dataDict.object(forKey: "currency") as? String ?? ""
            
            if dataDict.object(forKey: "totalPriceSale") as? String ?? "" == ""{
                
                lblPrice.text = "Not Defined"
            }
            else{
                
                lblPrice.text = "\(currency) \(dataDict.object(forKey: "totalPriceSale") as? String ?? "")"
            }
            
            if dataDict.object(forKey: "pricePerMeter") as? String ?? "" == ""{
                
                lblPricePerMeter.text = "Price per Meter : Not Defined"
            }
            else{
                
                lblPricePerMeter.text = "Price per Meter : \(currency) \(dataDict.object(forKey: "pricePerMeter") as? String ?? "")"
            }
            
            
//            lblPriceCrossPlotSize.text = "Price X Plot Size : \(currency) \(dataDict.object(forKey: "totalPriceSale") as? String ?? "") X \(plotSize)\(plotSizeUnit)"
            
            let sizeMeterSquare = dataDict.object(forKey: "sizem2") as? String ?? ""
            
           // lblPriceCrossPlotSize.text = "Price per Meter X Size M2 : \(currency) \(dataDict.object(forKey: "pricePerMeter") as? String ?? "") X \(sizeMeterSquare) M2"
            
            lblPriceCrossPlotSize.text = ""
            
            lblPlotSize.text = "\(plotSize)\(plotSizeUnit)"
            
            self.viewRent.isHidden = true
            self.lineViewTopConstraint.constant = 109
            
            self.viewHeader.frame.size.height = 1270
            
        }
        else{
            
            self.viewHeader.frame.size.height = 1370
            
            let rentTime = dataDict.object(forKey: "rentTime") as? String ?? ""
            
            let currency = dataDict.object(forKey: "currency") as? String ?? ""
            
            lblPrice.text = "\(currency) \(dataDict.object(forKey: "totalPriceRent") as? String ?? "") \(rentTime)"
            
            lblPricePerMeter.text = "Price per Meter : Not available for rent"
            
            lblPlotSize.text = "\(plotSize)\(plotSizeUnit)"
            
           // let totalPrice = dataDict.object(forKey: "totalPriceRent") as? String ?? ""
            
          //  lblPriceCrossPlotSize.text = "Price X Plot Size : \(currency) \(totalPrice) X \(plotSize)\(plotSizeUnit)"
            
            lblPriceCrossPlotSize.text = ""
            
            let defaultDailyPrice = dataDict.object(forKey: "defaultDailyPrice") as? String ?? ""
            let defaultWeeklyPrice = dataDict.object(forKey: "defaultWeeklyPrice") as? String ?? ""
            let defaultMonthlyPrice = dataDict.object(forKey: "defaultMonthlyPrice") as? String ?? ""
            let defaultYearlyPrice = dataDict.object(forKey: "defaultyearlyPrice") as? String ?? ""
            
            lblDailyRentTime.text = defaultDailyPrice
            lblWeeklyRentTime.text = defaultWeeklyPrice
            lblMonthlyRentTime.text = defaultMonthlyPrice
            lblYearlyRentTime.text = defaultYearlyPrice
            
            if defaultDailyPrice == ""{
                
                lblDailyRentTime.text = "NA"
            }
            
            if defaultWeeklyPrice == ""{
                
                lblWeeklyRentTime.text = "NA"
            }
            
            if defaultMonthlyPrice == ""{
                
                lblMonthlyRentTime.text = "NA"
            }
            
            if defaultYearlyPrice == ""{
                
                lblYearlyRentTime.text = "NA"
            }
            
            
        }
        
        lblPlotSizeInView.text = "\(plotSize) \(plotSizeUnit)"
        
        if dataDict.object(forKey: "builtSize") as? String ?? "" == ""{
            
            lblBuiltInSize.text = "NA"
        }
        else{
            
            lblBuiltInSize.text = "\(dataDict.object(forKey: "builtSize") as? String ?? "") \(dataDict.object(forKey: "builtSizeUnit") as? String ?? "")"
        }
      
        
        lblYearBuilt.text = dataDict.object(forKey: "yearBuilt") as? String ?? ""
        
        lblStreetView.text = dataDict.object(forKey: "streetView") as? String ?? ""
        
        if dataDict.object(forKey: "streetWidth") as? String ?? "" == ""{
            
            lblStreetWidth.text = "NA"
        }
        else{
            
            lblStreetWidth.text = "\(dataDict.object(forKey: "streetWidth") as? String ?? "") \(dataDict.object(forKey: "streetWidthUnit") as? String ?? "")"
        }
        
        lblBedrooms.text = dataDict.object(forKey: "bedrooms") as? String ?? ""
        lblBathrooms.text = dataDict.object(forKey: "bathrooms") as? String ?? ""
        lblKitchen.text = dataDict.object(forKey: "kitchens") as? String ?? ""
        lblLivingRoom.text = dataDict.object(forKey: "floor") as? String ?? ""
        
        
        var measureWidth = dataDict.object(forKey: "width") as? String ?? ""
        var measureLength = dataDict.object(forKey: "length") as? String ?? ""
        let measureWidthUnit = dataDict.object(forKey: "widthUnit") as? String ?? ""
        let measureLengthUnit = dataDict.object(forKey: "lengthUnit") as? String ?? ""
        
        if measureWidth == ""{
            
            measureWidth = "NA"
        }
        
        if measureLength == ""{
            
            measureLength = "NA"
        }
        
        self.lblMeasureLengthWidth.text = "\(measureLength) \(measureLengthUnit) X \(measureWidth) \(measureWidthUnit)"
        
        let desc = dataDict.object(forKey: "description") as? String ?? ""
        
        
        if desc == ""{
            
            lblDescription.text = "No description found"
        }
        else{
            
            lblDescription.text = desc
            
            // lblDescription.text = ""
        }
        
        lblDescription.numberOfLines = 3
        
        lblLocation.text = dataDict.object(forKey: "address") as? String ?? ""
        
        var lat = dataDict.object(forKey: "lat") as? String ?? ""
        var long = dataDict.object(forKey: "long") as? String ?? ""
        
        lat = lat.trimmingCharacters(in: .whitespaces)
        long = long.trimmingCharacters(in: .whitespaces)
        
        let lati = Double(lat)!
        let longi = Double(long)!
       
        let position = CLLocationCoordinate2DMake(lati,longi)
        let marker = GMSMarker(position: position)
        
        marker.icon = UIImage(named: "map_loc")
        
        marker.map = mapview
        
        let camera = GMSCameraPosition.camera(withLatitude: lati, longitude: longi, zoom: 7.0)
        mapview.camera = camera
        mapview.animate(to: camera)
        
        let videosFile = dataDict.object(forKey: "videosFile") as? NSArray ?? []
        
        if videosFile.count == 0{
            
            imgVideo.image = UIImage(named: "defaultProperty")
        }
        else{
            
        }
        
        let modulerKitchenBool = dataDict.object(forKey: "modularKitchen") as? Bool ?? false
        
        let balcony = dataDict.object(forKey: "balcony") as? Bool ?? false
        
        let garden = dataDict.object(forKey: "garden") as? Bool ?? false
        
        let parking = dataDict.object(forKey: "parking") as? Bool ?? false
        
        let airConditioner = dataDict.object(forKey: "aircondition") as? Bool ?? false
        
        let duplex = dataDict.object(forKey: "duplex") as? Bool ?? false
        
        let furnishing = dataDict.object(forKey: "furnished") as? Bool ?? false
        
        let lift = dataDict.object(forKey: "lift") as? Bool ?? false
        
        let store = dataDict.object(forKey: "store") as? Bool ?? false
        
        
        if store{
            
            lblStore.text = "Store : Installed"
        }
        else{
            
            lblStore.text = "Store : Uninstalled"
        }
        
        if lift{
            
            lblLift.text = "Lift : Installed"
        }
        else{
            
            lblLift.text = "Lift : Uninstalled"
        }
        
        if furnishing{
            
            lblFurnishing.text = "Furnished : Installed"
        }
        else{
            
            lblFurnishing.text = "Furnished : Uninstalled"
        }
        
        if duplex{
            
            lblDuplex.text = "Duplex : Installed"
        }
        else{
            
            lblDuplex.text = "Duplex : Uninstalled"
        }
        
        if airConditioner{
            
            lblAirConditioning.text = "AirCondition : Installed"
        }
        else{
            
            lblAirConditioning.text = "AirCondition : Uninstalled"
        }
        
        
        if modulerKitchenBool == false{
            
            lblKitchenInstalled.text = "Moduler Kitchen : Uninstalled"
        }
        else{
           
            lblKitchenInstalled.text = "Moduler Kitchen : Installed"
        }
        
        if balcony == false{
            
            lblAirConditionerInstalled.text = "Balcony : Uninstalled"
        }
        else{
            
            lblAirConditionerInstalled.text = "Balcony : Installed"
        }
        
        if garden == false{
            
            lblBuildingApartment.text = "Garden : Uninstalled"
        }
        else{
            
            lblBuildingApartment.text = "Garden : Installed"
        }
        
        if parking == false{
            
            lblBuildingStore.text = "Parking : Uninstalled"
        }
        else{
            
            lblBuildingStore.text = "Parking : Installed"
        }
        
        let noOfBuilding = dataDict.object(forKey: "extrabuildingNo") as? String ?? ""
        let noOfShowroom = dataDict.object(forKey: "extrashowroomNo") as? String ?? ""
        let revenue = dataDict.object(forKey: "revenue") as? String ?? ""
        
        if noOfBuilding == ""{
            
            lblDriverRoom.text = "Apartment : NA"
        }
        else{
            
            lblDriverRoom.text = "Apartment : \(noOfBuilding)"
        }
        
        if noOfShowroom == ""{
            
            lblMaidRoom.text = "Showroom : NA"
        }
        else{
            
            lblMaidRoom.text = "Showroom : \(noOfShowroom)"
        }
        
               
        if revenue == ""{
            
            lblBuildingRoom.text = "Revenue : NA"
        }
        else{
            
            lblBuildingRoom.text = "Revenue : \(revenue)"
        }
        
        lblRevenue.isHidden = true
        
        let indoorStr = dataDict.object(forKey: "indoor") as? String ?? ""
        let outdoorStr = dataDict.object(forKey: "outdoor") as? String ?? ""
        let parkingOption = dataDict.object(forKey: "parkingOption") as? String ?? ""
        let furishingOption = dataDict.object(forKey: "furnish") as? String ?? ""
        let viewsOption = dataDict.object(forKey: "views") as? String ?? ""
        
        self.specificationArr.removeAllObjects()
        indoorArr.removeAllObjects()
        outdoorArr.removeAllObjects()
        furnishArr.removeAllObjects()
        viewsArr.removeAllObjects()
        parkingOptionArr.removeAllObjects()
        
        
        if indoorStr != ""{
            
            specificationArr.add("Indoor")
            
            let indArr = indoorStr.components(separatedBy: ",") as? NSArray ?? []
            
            for i in 0..<indArr.count{
                
                indoorArr.add(indArr.object(at: i) as? String ?? "")
            }
            
        }
        
        if outdoorStr != ""{
            
            specificationArr.add("Outdoor")
            
            let outArr = outdoorStr.components(separatedBy: ",") as? NSArray ?? []
            
            for i in 0..<outArr.count{
                
                outdoorArr.add(outArr.object(at: i) as? String ?? "")
            }
        }
        
        if parkingOption != ""{
            
            specificationArr.add("Parking")
            
            let parkArr = parkingOption.components(separatedBy: ",") as? NSArray ?? []
            
            for i in 0..<parkArr.count{
                
                parkingOptionArr.add(parkArr.object(at: i) as? String ?? "")
            }
        }
        
        if furishingOption != ""{
            
            specificationArr.add("Furnishing")
            
            let furnArr = furishingOption.components(separatedBy: ",") as? NSArray ?? []
            
            for i in 0..<furnArr.count{
                
                furnishArr.add(furnArr.object(at: i) as? String ?? "")
            }
        }
        
        if viewsOption != ""{
            
            specificationArr.add("Views")
            
            let vwArr = viewsOption.components(separatedBy: ",") as? NSArray ?? []
            
            for i in 0..<vwArr.count{
                
                viewsArr.add(vwArr.object(at: i) as? String ?? "")
            }
        }
        
        let propertyLikedStatus = dataDict.object(forKey: "likedStatus") as? String ?? ""
        
        if propertyLikedStatus == "yes"{
            
            btnLikeProperty.setImage(UIImage(named: "like_icon_new"), for: .normal)
        }
        else{
            
            btnLikeProperty.setImage(UIImage(named: "unselectedHeart"), for: .normal)
        }
        
        
        let createdDate = dataDict.object(forKey: "created") as? String ?? ""
        lblPropertyPostedDate.text = "Posted on \(self.fetchData(dateToConvert: createdDate))"
        
        let userDataDict = dataDict.object(forKey: "userData") as? NSDictionary ?? [:]
        lblName.text = userDataDict.object(forKey: "fullName") as? String ?? ""
        
        let countryCode = userDataDict.object(forKey: "countryCode") as? String ?? ""
        
        let phoneNo = userDataDict.object(forKey: "mobileNumber") as? String ?? ""
        
        lblContact1.text = "\(countryCode)\(phoneNo)"
        
        lblProfessionalCategory.text = "\(userDataDict.object(forKey: "category") as? String ?? "")"
        lblProfessionalSubCategory.text = "\(userDataDict.object(forKey: "subCategory") as? String ?? "")"
        lblProfessionalId.text = "id-\(userDataDict.object(forKey: "professionalId") as? String ?? "")"
        
        let totalPropertyCount = dataDict.object(forKey: "totalPropertyCreated") as? Int ?? 0
        
        if totalPropertyCount == 0 || totalPropertyCount == 1{
            
            self.btnTotalPropertiesListed.setTitle("\(totalPropertyCount) Property Listed", for: UIControl.State.normal)
        }
        else{
            
            self.btnTotalPropertiesListed.setTitle("\(totalPropertyCount) Properties Listed", for: UIControl.State.normal)
        }
        
        
        let dict = dataDict.object(forKey: "userData") as? NSDictionary ?? [:]
        
      //  let userType = dict.object(forKey: "Type") as? String ?? ""
        
      //  if userType == "professional"{
            
        //    self.viewProfessionalInfo.isHidden = false
            
            let likedStatusOfProfile = dict.object(forKey: "likedStatus") as? String ?? ""
            
            if likedStatusOfProfile == "yes"{
                
                btnLikeProfile.setImage(UIImage(named: "like_icon_new"), for: .normal)
            }
            else{
                
               btnLikeProfile.setImage(UIImage(named: "unselectedHeart"), for: .normal)
            }
            
//        }
//        else{
//
//            self.viewProfessionalInfo.isHidden = true
//        }
        
         let imgStr = dict.object(forKey: "profileImage") as? String ?? ""
        
        if imgStr != ""{
            
            let urlStr = URL(string: imgStr)
            
            self.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "userPlaceholder"))
        }
        
        
         tableView.tableHeaderView = viewHeader
         tableView.tableFooterView = viewFooter
        
         tableView.dataSource = self
         tableView.delegate = self
         self.tableView.reloadData()
        
    }
    
    
    func apiCallForGetProprtyDetail(propertyId:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            var profIdExist = ""
            
            if self.profUserID == ""{
                
                profIdExist = "normal"
            }
            else{
                
                profIdExist = "professional"
            }
            
            let param = ["propertyId":propertyId,"type":profIdExist,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForGetPropertyDetails as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
            
                print(receivedData)
            
                if self.connection.responseCode == 1{
                
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            self.updateElement(dataDict: data)
                            
                            self.globalDataDict = data
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
                    
                   // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
                
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
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
                        
                        self.apiCallForGetProprtyDetail(propertyId: self.propertyId)
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
                    
                   // self.navigationController?.popViewController(animated: true)
                    
                   // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
}
