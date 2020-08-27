//
//  ViewBusinessProfessionalProfileVC.swift
//  Aqar55
//
//  Created by Dacall soft on 25/06/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewBusinessProfessionalProfileVC: UIViewController {

    var headerTitle = ""
    //MARK: - Outlets
    
    @IBOutlet weak var lblHeaderTilte: UILabel!
    @IBOutlet weak var tableView_ProfessionaName: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imgCount_Lbl: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet var viewFooter: UIView!
    
    @IBOutlet var viewHeader: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var lblSubcategory: UILabel!
    
    @IBOutlet weak var lblGovId1: UILabel!
    
    @IBOutlet weak var lblGovId2: UILabel!
    
    @IBOutlet weak var lblBusinessAndProfessionalId: UILabel!
    
    @IBOutlet weak var lblIdValue: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblProjectAchieved: UILabel!
    
    @IBOutlet weak var lblSpecialities: UILabel!
    
    @IBOutlet weak var mapview: GMSMapView!
    
    @IBOutlet weak var lblMemberSince: UILabel!
    
    @IBOutlet weak var lblViewedTimes: UILabel!
    
    @IBOutlet weak var lblUpdatedTime: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblTypeUserName: UILabel!
    
    @IBOutlet weak var lblProfessionalCategory: UILabel!
    
    @IBOutlet weak var lblProfessionalSubCategory: UILabel!
    
    @IBOutlet weak var lblProfessionalID: UILabel!
    
    @IBOutlet weak var lblProfessionalDetail: UILabel!
    
    @IBOutlet weak var lblPhoneNo: UILabel!
    
    @IBOutlet weak var btnLikeProfile: UIButton!
    
    @IBOutlet weak var btnLikeProfessionalProfile: UIButton!
    
    @IBOutlet weak var lblAreaCovered: UILabel!
    
    @IBOutlet weak var btnViewProfessionalProfile: UIButton!
    
    @IBOutlet weak var btnPropertyListed: UIButton!
    
    @IBOutlet weak var btnReport: UIButton!
    
    
    var restrictCallChat = false
    
    let connection = webservices()
    
    var userType = ""
    
    var dataDict = NSDictionary()
    
    var dateFormatterForDate = DateFormatter()
    
    var arrOfImages = NSArray()
    
    var globalLikeStatus = ""
    
    var typeToSendInApi = ""
    var IdAsNormal = ""
    
    var globalDictGetFromViewInfo = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        tableView_ProfessionaName.tableHeaderView = viewHeader
        tableView_ProfessionaName.tableFooterView = viewFooter
        
        if userType == "Professional"{
            
            btnViewProfessionalProfile.setTitle("View Professional Profile", for: .normal)
            
            typeToSendInApi = "professional"
        }
        else{
            
            btnViewProfessionalProfile.setTitle("View Business Profile", for: .normal)
            
            typeToSendInApi = "business"
        }
        
        if restrictCallChat == true{
            
            self.btnReport.isHidden = true
        }
        else{
            
            self.btnReport.isHidden = false
        }
        
        initialSetup()
        
        lblHeaderTilte.text = headerTitle
        
        self.globalDictGetFromViewInfo = self.dataDict
        
        updateElement()
        
       // self.apiCallForCountViews()
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_propertyListedBtn(_ sender: Any) {
        
        if globalDictGetFromViewInfo.count != 0{
            
            let propertyCount = globalDictGetFromViewInfo.object(forKey: "totalPropertyCreated") as? Int ?? 0
            
            if propertyCount == 0{
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "No properties listed.", controller: self)
            }
            else{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfessionalPropertyListingController") as! ProfessionalPropertyListingController
                
                let id = globalDictGetFromViewInfo.object(forKey: "_id") as? String ?? ""
                
                let type = globalDictGetFromViewInfo.object(forKey: "Type") as? String ?? ""
                
                if type == "professional"{
                    
                    vc.typeOfUser = "professional"
                    vc.professionalUserId = id
                }
                else{
                    
                    let userID = globalDictGetFromViewInfo.object(forKey: "userId") as? String ?? ""
                    
                    vc.typeOfUser = "normal"
                    vc.normalUserId = userID
                }
                
                vc.restrictCallChat = self.restrictCallChat
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    
    @IBAction func tap_btnViewProfessionalProfile(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_chatBtnUser(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            if dataDict.count != 0{
                
                if restrictCallChat == true{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not chat with your own profile", controller: self)
                }
                else{
                    
                    let propertyId = dataDict.object(forKey: "_id") as? String ?? ""
                    let receiverId = dataDict.object(forKey: "userId") as? String ?? ""
                    let headerName = dataDict.object(forKey: "fullName") as? String ?? ""
                    
                    let descTxt = dataDict.object(forKey: "description") as? String ?? ""
                    
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
            
            self.makeRootToLoginSignup()
        }
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
    
    
    @IBAction func tap_chatBtnProperty(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            if dataDict.count != 0{
                
                if restrictCallChat == true{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not chat with your own profile", controller: self)
                }
                else{
                    
                    let propertyId = dataDict.object(forKey: "_id") as? String ?? ""
                    let receiverId = dataDict.object(forKey: "userId") as? String ?? ""
                    let headerName = dataDict.object(forKey: "fullName") as? String ?? ""
                    
                    let descTxt = dataDict.object(forKey: "description") as? String ?? ""
                    
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
            
            self.makeRootToLoginSignup()
        }
    }
    
    
    @IBAction func tap_shareProfileBtn(_ sender: Any) {
        
        if self.dataDict.count != 0{
            
            let name = dataDict.object(forKey: "fullName") as? String ?? ""
            let type = dataDict.object(forKey: "Type") as? String ?? ""
            
            self.shareProfile(userName: name, profileType: type)
        }
    }
    
    
    @IBAction func tap_shareIconOnTop(_ sender: Any) {
        
        if self.dataDict.count != 0{
            
            let name = dataDict.object(forKey: "fullName") as? String ?? ""
            let type = dataDict.object(forKey: "Type") as? String ?? ""
            
            self.shareProfile(userName: name, profileType: type)
        }
    }
    
    
    @IBAction func tap_callOnUserNo(_ sender: Any) {
        
        if dataDict.count != 0{
            
            if restrictCallChat == true{
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not make call to your own profile", controller: self)
            }
            else{
                
                let contactNo = dataDict.object(forKey: "mobileNumber") as? String ?? ""
                
                let countryCode = dataDict.object(forKey: "countryCode") as? String ?? ""
                
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
    
    @IBAction func tap_callOnProfessionalPropertyNo(_ sender: Any) {
        
        if dataDict.count != 0{
            
            if restrictCallChat == true{
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not make call to your own profile", controller: self)
            }
            else{
                
                let contactNo = dataDict.object(forKey: "mobileNumber") as? String ?? ""
                
                let countryCode = dataDict.object(forKey: "countryCode") as? String ?? ""
                
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
    
    @IBAction func btnRequestMoreInfoAction(_ sender: Any) {
        
        if headerTitle == "Professional Name"{
            
            if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                
                if dataDict.count != 0{
                    
                    if restrictCallChat == true{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not chat with your own profile", controller: self)
                    }
                    else{
                        
                        let propertyId = dataDict.object(forKey: "_id") as? String ?? ""
                        let receiverId = dataDict.object(forKey: "userId") as? String ?? ""
                        
                        let headerName = dataDict.object(forKey: "fullName") as? String ?? ""
                        
                        let descTxt = dataDict.object(forKey: "description") as? String ?? ""
                        
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
                
                self.makeRootToLoginSignup()
            }
            
        }else{
            
            if UserDefaults.standard.bool(forKey: "ISLOGIN"){
                
                if dataDict.count != 0{
                    
                    if restrictCallChat == true{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not chat with your own profile", controller: self)
                    }
                    else{
                        
                        let propertyId = dataDict.object(forKey: "_id") as? String ?? ""
                        let receiverId = dataDict.object(forKey: "userId") as? String ?? ""
                        
                        let headerName = dataDict.object(forKey: "fullName") as? String ?? ""
                        
                        let descTxt = dataDict.object(forKey: "description") as? String ?? ""
                        
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
                
                self.makeRootToLoginSignup()
            }
            
        }
    }
    
    
    @IBAction func tap_videoBtn(_ sender: Any) {
        
        if self.dataDict.count != 0{
            
            let videosFile = dataDict.object(forKey: "videosFile") as? NSArray ?? []
            
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
    
    
    @IBAction func tap_likeBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            if dataDict.count != 0{
                
                if restrictCallChat == true{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not like your own profile", controller: self)
                }
                else{
                    
                    let type = dataDict.object(forKey: "Type") as? String ?? ""
                    let id = dataDict.object(forKey: "_id") as? String ?? ""
                    let likeStatus = globalLikeStatus
                    
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
            
            self.makeRootToLoginSignup()
        }
    }
    
    
    @IBAction func tap_professionalLikeBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "ISLOGIN"){
            
            if dataDict.count != 0{
                
                if restrictCallChat == true{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not like your own profile", controller: self)
                }
                else{
                    
                    let type = dataDict.object(forKey: "Type") as? String ?? ""
                    let id = dataDict.object(forKey: "_id") as? String ?? ""
                    let likeStatus = globalLikeStatus
                    
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
            
            self.makeRootToLoginSignup()
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
    
    func shareProfile(userName:String,profileType:String){
        
        let title = "I just used the Aqar55 App and saw the profile of \(userName) as \(profileType) user. Highly recommend that you try it too."
        
        let textToShare = [title] as [Any]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = []
        activityViewController.setValue("Aqar55", forKey: "subject")
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}


extension ViewBusinessProfessionalProfileVC{
    
    
    func initialSetup1(){
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



//MARK : Collection view Delegates and Datasource
extension ViewBusinessProfessionalProfileVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
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
        
        cell.imgBanner.contentMode = .scaleAspectFit
        cell.imgBanner.backgroundColor = UIColor.black
        
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


extension ViewBusinessProfessionalProfileVC : UIScrollViewDelegate{
    
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



//MARK: - Extension TableView Delegates
extension ViewBusinessProfessionalProfileVC:UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView_ProfessionaName.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        
        if dataDict.count != 0{
            
            cell.lblOfficeAddress.text = "\(dataDict.object(forKey: "area") as? String ?? "") \(dataDict.object(forKey: "city") as? String ?? "")"
            
            let countryCode = dataDict.object(forKey: "countryCode") as? String ?? ""
            let phoneNo = dataDict.object(forKey: "mobileNumber") as? String ?? ""
            
            cell.lblOfficeNo.text = "\(countryCode)\(phoneNo)"
            
            cell.lblEmail.text = dataDict.object(forKey: "email") as? String ?? ""
            cell.lblWebsite.text = dataDict.object(forKey: "website") as? String ?? ""
            
        }
        
        cell.btnFacebook.tag = indexPath.row
        cell.btnGmail.tag = indexPath.row
        cell.btnTwitter.tag = indexPath.row
        cell.btnOther.tag = indexPath.row
        cell.btnLinkedIn.tag = indexPath.row
        
        cell.btnFacebook.addTarget(self, action: #selector(self.tapFbBtn(sender:)), for: UIControl.Event.touchUpInside)
        
        cell.btnGmail.addTarget(self, action: #selector(self.tapGmailBtn(sender:)), for: UIControl.Event.touchUpInside)
        
        cell.btnTwitter.addTarget(self, action: #selector(self.tapTwitterBtn(sender:)), for: UIControl.Event.touchUpInside)
        
        cell.btnOther.addTarget(self, action: #selector(self.tapSnapchatBtn(sender:)), for: UIControl.Event.touchUpInside)
        
        cell.btnLinkedIn.addTarget(self, action: #selector(self.tapLinkedinBtn(sender:)), for: UIControl.Event.touchUpInside)
        
        return cell
        
    }
    
    @objc func btnChatAction(sender:UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatWithUserController") as! ChatWithUserController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapFbBtn(sender:UIButton){
        
        let fbUrl = dataDict.object(forKey: "facebookUrl") as? String ?? ""
        
        if fbUrl == ""{
            
            let name = dataDict.object(forKey: "fullName") as? String ?? ""
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "\(name) didn't submit Facebook profile but \(name) has been verified by Aqar55", controller: self)
        }
        else{
            
            if verifyUrl(urlString: fbUrl){
                
                openSocialUrl(urlData: fbUrl)
            }
            else{
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Browser can't open this url", controller: self)
            }
        }
        
    }
    
    @objc func tapGmailBtn(sender:UIButton){
        
        let gmailUrl = dataDict.object(forKey: "googleplusUrl") as? String ?? ""
        
        if gmailUrl == ""{
            
            let name = dataDict.object(forKey: "fullName") as? String ?? ""
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "\(name) didn't submit YouTube profile but \(name) has been verified by Aqar55", controller: self)
        }
        else{
            
            if verifyUrl(urlString: gmailUrl){
                
                openSocialUrl(urlData: gmailUrl)
            }
            else{
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Browser can't open this url", controller: self)
            }
        }
    }
    
    @objc func tapTwitterBtn(sender:UIButton){
        
        let twitterUrl = dataDict.object(forKey: "twitterUrl") as? String ?? ""
        
        if twitterUrl == ""{
            
            let name = dataDict.object(forKey: "fullName") as? String ?? ""
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "\(name) didn't submit twitter profile but \(name) has been verified by Aqar55", controller: self)
        }
        else{
            
            if verifyUrl(urlString: twitterUrl){
                
                openSocialUrl(urlData: twitterUrl)
            }
            else{
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Browser can't open this url", controller: self)
            }
        }
    }
    
    @objc func tapSnapchatBtn(sender:UIButton){
        
        let snapChatUrl = dataDict.object(forKey: "snapchatUrl") as? String ?? ""
        
        if snapChatUrl == ""{
            
            let name = dataDict.object(forKey: "fullName") as? String ?? ""
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "\(name) didn't submit snapchat profile but \(name) has been verified by Aqar55", controller: self)
        }
        else{
            
            if verifyUrl(urlString: snapChatUrl){
                
                openSocialUrl(urlData: snapChatUrl)
            }
            else{
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Browser can't open this url", controller: self)
            }
        }
    }
    
    @objc func tapLinkedinBtn(sender:UIButton){
        
        let linkedInUrl = dataDict.object(forKey: "linkedinUrl") as? String ?? ""
        
        if linkedInUrl == ""{
            
            let name = dataDict.object(forKey: "fullName") as? String ?? ""
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "\(name) didn't submit linkedin profile but \(name) has been verified by Aqar55", controller: self)
        }
        else{
            
            if verifyUrl(urlString: linkedInUrl){
                
                openSocialUrl(urlData: linkedInUrl)
            }
            else{
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Browser can't open this url", controller: self)
            }
        }
    }
    
    
    func verifyUrl (urlString: String?) -> Bool {
        
        if let urlString = urlString {
            
            if let url = NSURL(string: urlString) {
                
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
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
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 277.0
    }
    
}

extension ViewBusinessProfessionalProfileVC{
    
    func initialSetup(){
        
        tableView_ProfessionaName.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: "AddressCell")
        
    }
}



extension ViewBusinessProfessionalProfileVC{
    
    func updateElement(){
        
        if dataDict.count != 0{
            
            print(dataDict)
            
            self.lblHeaderTilte.text = dataDict.object(forKey: "fullName") as? String ?? ""
            
            self.lblName.text = dataDict.object(forKey: "fullName") as? String ?? ""
            self.lblCategory.text = dataDict.object(forKey: "category") as? String ?? ""
            self.lblSubcategory.text = dataDict.object(forKey: "subCategory") as? String ?? ""
            
            lblAreaCovered.text = dataDict.object(forKey: "areaCovered") as? String ?? ""
            
            let type = dataDict.object(forKey: "Type") as? String ?? ""
            
            if type == "professional"{
                
                lblIdValue.text = dataDict.object(forKey: "professionalId") as? String ?? ""
                lblBusinessAndProfessionalId.text = "Professional ID"
                
                lblProfessionalID.text = "ID:\(dataDict.object(forKey: "professionalId") as? String ?? "")"
            }
            else{
                
                lblIdValue.text = dataDict.object(forKey: "businessId") as? String ?? ""
                lblBusinessAndProfessionalId.text = "Business ID"
                
                lblProfessionalID.text = "ID:\(dataDict.object(forKey: "businessId") as? String ?? "")"
            }
            
            let govIDType1 = dataDict.object(forKey: "govtIdType1") as? String ?? ""
            let govIDType2 = dataDict.object(forKey: "govtIdType2") as? String ?? ""
            let govIdNo1 = dataDict.object(forKey: "govtIdNumber1") as? String ?? ""
            let govIdNo2 = dataDict.object(forKey: "govtIdNumber2") as? String ?? ""
            
            //            lblGovId1.text = "\(govIDType1) : \(govIdNo1)"
            //            lblGovId2.text = "\(govIDType2) : \(govIdNo2)"
            
            lblGovId1.text = "\(govIDType1) : 00000000000"
            lblGovId2.text = "\(govIDType2) : 00000000000"
            
            lblDescription.text = dataDict.object(forKey: "description") as? String ?? ""
            if lblDescription.text == ""{
                
                lblDescription.text = "No description found"
            }
            
            lblProjectAchieved.text = dataDict.object(forKey: "projectAchieved") as? String ?? ""
            if lblProjectAchieved.text == ""{
                
                lblProjectAchieved.text = "No project detail found"
            }
            
            lblSpecialities.text = dataDict.object(forKey: "specialities") as? String ?? ""
            if lblSpecialities.text == ""{
                
                lblSpecialities.text = "No specialities found"
            }
            
            var lat = dataDict.object(forKey: "lat") as? String ?? ""
            var long = dataDict.object(forKey: "long") as? String ?? ""
            lat = lat.trimmingCharacters(in: .whitespaces)
            long = long.trimmingCharacters(in: .whitespaces)
            
            if lat != "" && long != ""{
                
                let lati = Double(lat)!
                let longi = Double(long)!
                
                let position = CLLocationCoordinate2DMake(lati,longi)
                let marker = GMSMarker(position: position)
                
                if type == "professional"{
                    
                    marker.icon = UIImage(named: "map_loc")
                }
                else{
                    
                    marker.icon = UIImage(named: "location_two")
                }
                
                marker.map = mapview
                
                let camera = GMSCameraPosition.camera(withLatitude: lati, longitude: longi, zoom: 7.0)
                mapview.camera = camera
                mapview.animate(to: camera)
                
            }
            
            lblMemberSince.text = "Member Since \(dataDict.object(forKey: "memberSince") as? String ?? "")"
            
            let updatedTime = dataDict.object(forKey: "modified") as? String ?? ""
            
            self.lblUpdatedTime.text = "Updated \(fetchData(dateToConvert: updatedTime))"
            
            lblTypeUserName.text = dataDict.object(forKey: "fullName") as? String ?? ""
            lblProfessionalCategory.text = dataDict.object(forKey: "category") as? String ?? ""
            lblProfessionalSubCategory.text = dataDict.object(forKey: "subCategory") as? String ?? ""
            lblProfessionalDetail.text = dataDict.object(forKey: "description") as? String ?? ""
            
            let countryCode = dataDict.object(forKey: "countryCode") as? String ?? ""
            let phoneNo = dataDict.object(forKey: "mobileNumber") as? String ?? ""
            
            lblPhoneNo.text = "\(countryCode)\(phoneNo)"
            
            
            /////setting total property count on button
            
            let totalViews = dataDict.object(forKey: "counter") as? Int ?? 0
            
            self.lblViewedTimes.text = "Viewed \(totalViews) time"
            
            let totalPropertiesCount = dataDict.object(forKey: "totalPropertyCreated") as? Int ?? 0
            
            self.btnPropertyListed.setTitle("\(totalPropertiesCount) Property listed", for: .normal)
            
            /////
            
            
            let imgStr = dataDict.object(forKey: "profileImage") as? String ?? ""
            
            if imgStr == ""{
                
                imgUser.image = UIImage(named: "userPlaceholder")
            }
            else{
                
                let urlStr = URL(string: imgStr)
                imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "userPlaceholder"))
            }
            
            let arr = dataDict.object(forKey: "imagesFile") as? NSArray ?? []
            
            if arr.count == 0{
                
                collectionView.isHidden = true
                
            }
            else{
                
                collectionView.isHidden = false
            }
            
            self.arrOfImages = arr
            
            self.pageControl.numberOfPages = arr.count
            
            initialSetup1()
            
            collectionView.reloadData()
            
            let likedStatus = dataDict.object(forKey: "likedStatus") as? String ?? ""
            self.globalLikeStatus = likedStatus
            self.updateLikeDislikeStatus(statusStr: likedStatus)
            
        }
        
    }
    
    
    func updateLikeDislikeStatus(statusStr:String){
        
        if statusStr == "yes"{
            
            btnLikeProfile.setImage(UIImage(named: "like_icon_new"), for: .normal)
            btnLikeProfessionalProfile.setImage(UIImage(named: "like_icon_new"), for: .normal)
        }
        else{
            
            btnLikeProfile.setImage(UIImage(named: "unselectedHeart"), for: .normal)
            btnLikeProfessionalProfile.setImage(UIImage(named: "unselectedHeart"), for: .normal)
        }
    }
    
    
    func fetchData(dateToConvert:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let pendingDate = dateFormatter.date(from: dateToConvert)!
        let sendDate = self.dateFormatterForDate.string(from: pendingDate)
        
        return "\(sendDate)"
    }
    
}



extension ViewBusinessProfessionalProfileVC{
    
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
                        
                        if self.globalLikeStatus == "yes"{
                            
                            self.globalLikeStatus = "no"
                        }
                        else{
                            
                            self.globalLikeStatus = "yes"
                        }
                        
                        self.updateLikeDislikeStatus(statusStr: self.globalLikeStatus)
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
    
    
    ////get count of profile views
    
    func apiCallForCountViews(){
        
        let id = dataDict.object(forKey: "_id") as? String ?? ""
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["profbusId":id,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","type":typeToSendInApi,"businessUserId":IdAsNormal]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetViewsCount as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            let totalViews = data.object(forKey: "counter") as? Int ?? 0
                            
                            self.lblViewedTimes.text = "Viewed \(totalViews) time"
                            
                            let totalPropertiesCount = data.object(forKey: "totalPropertyCreated") as? Int ?? 0
                            
                            self.btnPropertyListed.setTitle("\(totalPropertiesCount) Property listed", for: .normal)
                            
                            self.globalDictGetFromViewInfo = data
                        }
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToLoginForExpiredToken()
                        }
                        else{
                            
                            // CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                    }
                }
                else{
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
}
