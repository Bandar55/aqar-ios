//
//  SocialHandlesController.swift
//  AQAR55
//
//  Created by lion on 28/02/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class SocialHandlesController: UIViewController {
    
    @IBOutlet var lblHeading: UILabel!
    
    @IBOutlet weak var lblImage: UILabel!
    @IBOutlet weak var lblVideo: UILabel!
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var videoView: UIView!
    
    //Outlets
    @IBOutlet weak var txtFieldFBURL: UITextField!
    
    @IBOutlet weak var txtFieldGmailURL: UITextField!
    
    @IBOutlet weak var txtFieldTwitterURL: UITextField!
    
    @IBOutlet weak var txtFieldSnapChatURL: UITextField!
    
    @IBOutlet weak var txtFieldLinkedInURL: UITextField!
    
    @IBOutlet weak var txtViewDescription: UITextView!
    
    @IBOutlet weak var txtViewProjectAchieved: UITextView!
    
    @IBOutlet weak var txtViewSpecialities: UITextView!
    
    @IBOutlet weak var txtViewAreaCovered: UITextView!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var imgThumbnailRef: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userInfoModelItem = UserInfoDataModel()
    var headerTitle = ""
    var dataDict = NSMutableDictionary()
    let connection = webservices()
    
    var updateUIFuncWillCalled = false
    var apiUrl = ""
    
    //for my profile
    var profileDataDictionary = NSMutableDictionary()
    var mainDataDict = NSDictionary()
    
    var arrImages = NSMutableArray()
    var arrContent = NSMutableArray()
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    var videoData = NSData()
    var mediaTag = Int()
    
    var arrOfAdditionalImage = NSMutableArray()
    
    var userInfoDict = NSDictionary()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.isHidden = true
        
        if headerTitle == "My Professional Profile"{
            
            lblHeading.text = "My Professional Profile"
        }
        
        if headerTitle == "My Profile"{
            
            imagePicker.delegate = self
            
            lblHeading.text = "My Profile"
            
            collectionView.isHidden = false
            
            collectionView.dataSource = self
            collectionView.delegate = self
            
            self.btnDelete.isHidden = true
            
            setAdditionalDataForMyProfile()
        }
        
        if headerTitle != "My Profile"{
            
            if self.updateUIFuncWillCalled == true{
                
                apiUrl = App.URLs.apiCallForUpdateBusinessAndProfessional
                
                updateUI()
                
                self.btnDelete.isHidden = false
            }
            else{
                
                apiUrl = App.URLs.apiCallForCreateBusinessOrProfessional
                
                self.btnDelete.isHidden = true
                
                ///here we are setting data from normal profile of user
                
                setDataFromNormalProfile()
                
            }
            
        }
        
       
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_deleteBtn(_ sender: Any) {
        
        if headerTitle != "My Profile"{
            
            let alertController = UIAlertController(title: "", message: "Are you sure? You want to delete your profile", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                self.apiCallForDeleteProfile()
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
  
        }
       
    }
    
    
    @IBAction func btnPublishAction(_ sender: Any) {
        
        checkValidation()
    }
    
    
    @IBAction func tap_uploadImgBtn(_ sender: Any) {
        
        if self.arrImages.count >= 2{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can upload maximum two images.", controller: self)
        }
        else{
            
            mediaTag = 1
            
            showImagePicker()
        }
      
    }
    
    @IBAction func tap_uploadVideoBtn(_ sender: Any) {
        
        mediaTag = 2
        
        showVideoPicker()
    }
    
    
    func verifyUrl (urlString: String?) -> Bool {
        
        if let urlString = urlString {
            
            if let url = NSURL(string: urlString) {
                
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func validateUrl (urlString: NSString) -> Bool {
        
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
    
    
    func checkValidation(){
        
        var mess = ""
        
        if txtFieldFBURL.text != "" && !verifyUrl(urlString: txtFieldFBURL.text!){
            
            mess = "Please enter valid facebook url. Kindly Use https:// as prefix."
        }
        else if txtFieldGmailURL.text != "" && !verifyUrl(urlString: txtFieldGmailURL.text!){
            
            mess = "Please enter valid YouTube url. Kindly Use https:// as prefix."
        }
        else if txtFieldTwitterURL.text != "" && !verifyUrl(urlString: txtFieldTwitterURL.text!){
            
            mess = "Please enter valid twitter url. Kindly Use https:// as prefix."
        }
        else if txtFieldSnapChatURL.text != "" && !verifyUrl(urlString: txtFieldSnapChatURL.text!){
            
            mess = "Please enter valid snapchat url. Kindly Use https:// as prefix."
        }
        else if txtFieldLinkedInURL.text != "" && !verifyUrl(urlString: txtFieldLinkedInURL.text!){
            
            mess = "Please enter valid linkedin url. Kindly Use https:// as prefix."
        }
        else if txtViewDescription.text == ""{
            
            mess = "Please enter description"
        }
        else if txtViewProjectAchieved.text == ""{
            
            mess = "Please enter project achieved"
        }
        else if txtViewSpecialities.text == ""{
            
            mess = "Please enter specialities"
        }
        else if txtViewAreaCovered.text == ""{
            
            mess = "Please enter area covered"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            if headerTitle == "My Profile"{
                
                self.apiCallForUpdateProfileNormalUser()
                
            }
            else{
                
                if self.updateUIFuncWillCalled == true{
                    
                    let professionalBussinessId = userInfoModelItem.user_id
                    
                    dataDict.addEntries(from: ["profbusId":"\(professionalBussinessId)"])
                    dataDict.addEntries(from: ["facebookUrl":txtFieldFBURL.text!])
                    dataDict.addEntries(from: ["googleplusUrl":txtFieldGmailURL.text!])
                    dataDict.addEntries(from: ["twitterUrl":txtFieldTwitterURL.text!])
                    dataDict.addEntries(from: ["snapchatUrl":txtFieldSnapChatURL.text!])
                    dataDict.addEntries(from: ["linkedinUrl":txtFieldLinkedInURL.text!])
                    dataDict.addEntries(from: ["description":txtViewDescription.text!])
                    dataDict.addEntries(from: ["projectAchieved":txtViewProjectAchieved.text!])
                    dataDict.addEntries(from: ["specialities":txtViewSpecialities.text!])
                    dataDict.addEntries(from: ["areaCovered":txtViewAreaCovered.text!])
                    print(dataDict)
                    
                    uploadData()
                    
                }
                else{
                    
                    let userId = UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""
                    
                    dataDict.addEntries(from: ["userId":userId])
                    dataDict.addEntries(from: ["facebookUrl":txtFieldFBURL.text!])
                    dataDict.addEntries(from: ["googleplusUrl":txtFieldGmailURL.text!])
                    dataDict.addEntries(from: ["twitterUrl":txtFieldTwitterURL.text!])
                    dataDict.addEntries(from: ["snapchatUrl":txtFieldSnapChatURL.text!])
                    dataDict.addEntries(from: ["linkedinUrl":txtFieldLinkedInURL.text!])
                    dataDict.addEntries(from: ["description":txtViewDescription.text!])
                    dataDict.addEntries(from: ["projectAchieved":txtViewProjectAchieved.text!])
                    dataDict.addEntries(from: ["specialities":txtViewSpecialities.text!])
                    dataDict.addEntries(from: ["areaCovered":txtViewAreaCovered.text!])
                    print(dataDict)
                    
                    uploadData()
                    
                }
                
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
    
    
    func uploadData(){
      
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            var profileImageData = NSData()
            if let imageDataProfile = UserDefaults.standard.value(forKey: "PROFILE_PIC") as? NSData{
                profileImageData = imageDataProfile
            }
            
            var GOV_ID_1 = NSData()
            if let GOV_ID_1Img = UserDefaults.standard.value(forKey: "GOV_ID_1") as? NSData{
                GOV_ID_1 = GOV_ID_1Img
            }
            
            var GOV_ID_2 = NSData()
            if let GOV_ID_2Img = UserDefaults.standard.value(forKey: "GOV_ID_2") as? NSData{
                GOV_ID_2 = GOV_ID_2Img
            }
            var VIDEO_DATA = NSData()
            if let VIDEO_DATAVid = UserDefaults.standard.value(forKey: "VIDEO_DATA") as? NSData{
                
                VIDEO_DATA = VIDEO_DATAVid
            }
            
            var IMAGEDATA_ARR = NSMutableArray()
            
//            if let VIDEO_DATAVid = UserDefaults.standard.value(forKey: "IMAGEDATA_ARR") as? NSMutableArray{
//
//                IMAGEDATA_ARR = VIDEO_DATAVid
//
//                print(IMAGEDATA_ARR.count)
//            }
            
           // IMAGEDATA_ARR = UserDefaults.standard.value(forKey: "IMAGEDATA_ARR") as? NSMutableArray ?? []
            
            IMAGEDATA_ARR = self.arrOfAdditionalImage
            
            print(IMAGEDATA_ARR.count)
            
            print(dataDict)
            
            
            IJProgressView.shared.showProgressView(view: self.view)
            connection.startConnectionWithProfileDataWithArray2(imageDataProfile: profileImageData, fileNameProfile: "profileImage", imageparmProfile: "profileImage", imageDataGovID1: GOV_ID_1, fileNameGovID1: "govtIdImage1", imageparmGovID1: "govtIdImage1", imageDataGovID2: GOV_ID_2, fileNameGovID2: "govtIdImage2", imageparmGovID2: "govtIdImage2", videoData: VIDEO_DATA, videoName: "videosFile", videoparm: "videosFile", getUrlString: apiUrl as NSString, fileArr: IMAGEDATA_ARR, ArrayParam: "imagesFile", method_type: methodType.post, params: dataDict as! [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    IJProgressView.shared.hideProgressView()
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        IJProgressView.shared.hideProgressView()
                       
                        let alertController = UIAlertController(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            
                           self.navigationController?.popToRootViewController(animated: true)
                        }
                        
                        alertController.addAction(okAction)
                       
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    else{
                        
                        IJProgressView.shared.hideProgressView()
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                    }
                }
                else{
                    
                    IJProgressView.shared.hideProgressView()
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }else{
            
            IJProgressView.shared.hideProgressView()
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
    
    func updateUI(){
        
        txtFieldFBURL.text = userInfoModelItem.facebookUrl
        txtFieldGmailURL.text = userInfoModelItem.googleplusUrl
        txtFieldTwitterURL.text = userInfoModelItem.twitterUrl
        txtFieldSnapChatURL.text = userInfoModelItem.snapchatUrl
        txtFieldLinkedInURL.text = userInfoModelItem.linkedinUrl
        txtViewDescription.text = userInfoModelItem.description
        txtViewProjectAchieved.text = userInfoModelItem.projectAchieved
        txtViewSpecialities.text = userInfoModelItem.specialities
        txtViewAreaCovered.text = userInfoModelItem.areaCovered
        
    }
    
    
    func setAdditionalDataForMyProfile(){
        
        print(mainDataDict)
        
        self.txtFieldFBURL.text = mainDataDict.object(forKey: "facebookUrl") as? String ?? ""
        
        self.txtFieldGmailURL.text = mainDataDict.object(forKey: "googleplusUrl") as? String ?? ""
        
        self.txtFieldTwitterURL.text = mainDataDict.object(forKey: "twitterUrl") as? String ?? ""
        
        self.txtFieldSnapChatURL.text = mainDataDict.object(forKey: "snapchatUrl") as? String ?? ""
        
        self.txtFieldLinkedInURL.text = mainDataDict.object(forKey: "linkedinUrl") as? String ?? ""
        
        self.txtViewDescription.text = mainDataDict.object(forKey: "description") as? String ?? ""
        
        self.txtViewProjectAchieved.text = mainDataDict.object(forKey: "projectAchieved") as? String ?? ""
        
        self.txtViewAreaCovered.text = mainDataDict.object(forKey: "areaCovered") as? String ?? ""
        
        self.txtViewSpecialities.text = mainDataDict.object(forKey: "specialities") as? String ?? ""
        
        let imagesArr = mainDataDict.object(forKey: "imagesFile") as? NSArray ?? []
        
        if imagesArr.count != 0{
            
            for i in 0..<imagesArr.count{
                
                let dict = imagesArr.object(at: i) as? NSDictionary ?? [:]
                
                let image = dict.object(forKey: "image") as? String ?? ""
                
                if let imageURLString = image as? String{
                    do {
                        let imageData = try Data(contentsOf: URL(string: imageURLString) as! URL)
                        self.arrImages.add(imageData)
                        self.collectionView.reloadData()
                        
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
                
            }
            
        }
        
    }
    
    
    func setDataFromNormalProfile(){
        
        if self.userInfoDict.count != 0 && headerTitle == "My Professional Profile"{
            
            self.txtFieldFBURL.text = userInfoDict.object(forKey: "facebookUrl") as? String ?? ""
            self.txtFieldGmailURL.text = userInfoDict.object(forKey: "googleplusUrl") as? String ?? ""
            self.txtFieldTwitterURL.text = userInfoDict.object(forKey: "twitterUrl") as? String ?? ""
            self.txtFieldSnapChatURL.text = userInfoDict.object(forKey: "snapchatUrl") as? String ?? ""
            self.txtFieldLinkedInURL.text = userInfoDict.object(forKey: "linkedinUrl") as? String ?? ""
            
            self.txtViewDescription.text = userInfoDict.object(forKey: "description") as? String ?? ""
            
            self.txtViewAreaCovered.text = userInfoDict.object(forKey: "areaCovered") as? String ?? ""
            self.txtViewSpecialities.text = userInfoDict.object(forKey: "specialities") as? String ?? ""
            
            self.txtViewProjectAchieved.text = userInfoDict.object(forKey: "projectAchieved") as? String ?? ""
            
        }
        
    }
 
}


extension SocialHandlesController{
    
    func apiCallForDeleteProfile(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["_id":userInfoModelItem.user_id,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForDeleteProfiles as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        
                        let alertController = UIAlertController(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        
                        alertController.addAction(okAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
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


//for my profile only
extension SocialHandlesController{
    
    func camera(){
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func photoLibrary() {
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showImagePicker(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.camera()
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.photoLibrary()
                
            }))
            
        }else {
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.photoLibrary()
                
            }))
            
        }
        
        actionSheet.addAction(UIAlertAction(title:"Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            
            let popup = UIPopoverController(contentViewController: actionSheet)
            
            popup.present(from: CGRect(), in: self.view!, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            
        }else{
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
}


//MARK:- Custom Method
//MARK:-
extension SocialHandlesController{
    
    func videoLibrary() {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.movie"]
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showVideoPicker(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            
            self.videoLibrary()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title:"Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            
            let popup = UIPopoverController(contentViewController: actionSheet)
            
            popup.present(from: CGRect(), in: self.view!, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            
        }else{
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
}



//MARK:- UiImage Picker Delegate
//MARK:-
extension SocialHandlesController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if mediaTag == 1{
            
            guard let selectedImage = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            
            imageData = selectedImage.jpegData(compressionQuality: 1.0)! as NSData
            self.arrImages.add(imageData)
            self.collectionView.reloadData()
            
        }else{
            
            guard let videoURL = info[.mediaURL] as? NSURL else {
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Video file can not be picked", controller: self)
                
                dismiss(animated: true, completion: nil)
                
                fatalError("Expected a dictionary containing an video file, but was provided the following: \(info)")
                
            }
            
            do {
                
                let imageData = try Data(contentsOf: videoURL as URL)
               // UserDefaults.standard.set(imageData, forKey: "VIDEO_DATA")
                // self.videoDataArr.add(imageData)
                
                self.videoData = imageData as NSData
                
            } catch {
                
                print("Unable to load data: \(error)")
            }
            
            if getThumbnailImage(forUrl: videoURL as URL) != nil {
                
                print("success")
                let image = getThumbnailImage(forUrl: videoURL as URL) as! UIImage
                self.imgThumbnailRef.image = image
                
            }
            else{
                print("Thumbnail nahi mila...")
                
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}


extension SocialHandlesController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib(nibName: "ManageProfileCollectionViewCellAndXib", bundle: nil), forCellWithReuseIdentifier: "ManageProfileCollectionViewCellAndXib")
        let cell : ManageProfileCollectionViewCellAndXib = collectionView.dequeueReusableCell(withReuseIdentifier: "ManageProfileCollectionViewCellAndXib", for: indexPath) as! ManageProfileCollectionViewCellAndXib
        cell.property_img.image = UIImage(data: arrImages.object(at: indexPath.item) as! Data)
        cell.btnDeleteRef.tag = indexPath.row
        cell.btnDeleteRef.addTarget(self, action: #selector(buttonDelClicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 78, height: 78)
    }
    
    
    @objc func buttonDelClicked(sender:UIButton){
        
        self.arrImages.removeObject(at: sender.tag)
        collectionView.reloadData()
    }
    
}


extension SocialHandlesController{
    
    func apiCallForUpdateProfileNormalUser(){
        
        let accountStatus = profileDataDictionary.object(forKey: "AcountStatus") as? String ?? ""
        let memberSince = profileDataDictionary.object(forKey: "MemberSince") as? String ?? ""
        let professionalId = profileDataDictionary.object(forKey: "ProfessionalID") as? String ?? ""
        let name = profileDataDictionary.object(forKey: "Name") as? String ?? ""
        let email = profileDataDictionary.object(forKey: "Email") as? String ?? ""
        let phoneNo = profileDataDictionary.object(forKey: "PhoneNo") as? String ?? ""
        
        let category = profileDataDictionary.object(forKey: "Category") as? String ?? ""
        let subCategory = profileDataDictionary.object(forKey: "Subcategory") as? String ?? ""
        
        let gender = profileDataDictionary.object(forKey: "Gender") as? String ?? ""
        let measurement = profileDataDictionary.object(forKey: "Measurement") as? String ?? ""
        let currency = profileDataDictionary.object(forKey: "Currency") as? String ?? ""
        let country = profileDataDictionary.object(forKey: "Country") as? String ?? ""
        
        let idType1 = profileDataDictionary.object(forKey: "IdType1") as? String ?? ""
        let idNo1 = profileDataDictionary.object(forKey: "IdNo1") as? String ?? ""
        
        let idType2 = profileDataDictionary.object(forKey: "IdType2") as? String ?? ""
        let idNo2 = profileDataDictionary.object(forKey: "IdNo2") as? String ?? ""
        
        var imageData = NSData()
        
        if let profileData = profileDataDictionary.object(forKey: "UserProfileData") as? NSData{
            
            imageData = profileData
        }
        
        var id1Data = NSData()
        
        if let id1 = profileDataDictionary.object(forKey: "GovId1Data") as? NSData{
            
            id1Data = id1
        }
        
        var id2Data = NSData()
        
        if let id2 = profileDataDictionary.object(forKey: "GovId2Data") as? NSData{
            
            id2Data = id2
        }
        
        
        let appLang = mainDataDict.object(forKey: "appLanguage") as? String ?? ""
        let speakLang = mainDataDict.object(forKey: "speakLanguage") as? String ?? ""
        
        let param:[String:String] = ["status":accountStatus,"fullName":name,"gender":gender,"memberSince":memberSince,"country":country,"email":email,"govtIdType1":idType1,"govtIdNumber1":idNo1,"professionalId":professionalId,"category":category,"subCategory":subCategory,"mobileNumber":phoneNo,"facebookUrl":txtFieldFBURL.text!,"googleplusUrl":txtFieldGmailURL.text!,"twitterUrl":txtFieldTwitterURL.text!,"snapchatUrl":txtFieldSnapChatURL.text!,"linkedinUrl":txtFieldLinkedInURL.text!,"description":txtViewDescription.text!,"projectAchieved":txtViewProjectAchieved.text!,"specialities":txtViewSpecialities.text!,"areaCovered":txtViewAreaCovered.text!,"govtIdType2":idType2,"govtIdNumber2":idNo2,"userId":UserDefaults.standard.value(forKey: "UniqueUserId") as? String ?? "","measurement":measurement,"currency":currency,"appLanguage":appLang,"speakLanguage":speakLang]
        
        
        print(param)
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithProfileDataWithArray2(imageDataProfile: imageData, fileNameProfile: "profileImage", imageparmProfile: "profileImage", imageDataGovID1: id1Data, fileNameGovID1: "govtIdImage1", imageparmGovID1: "govtIdImage1", imageDataGovID2: id2Data, fileNameGovID2: "govtIdImage2", imageparmGovID2: "govtIdImage2", videoData: videoData, videoName: "videosFile", videoparm: "videosFile", getUrlString: App.URLs.apiCallForUpdateProfileNormalUser as NSString, fileArr: arrImages, ArrayParam: "imagesFile", method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        let data = receivedData.object(forKey: "Data") as? NSDictionary ?? [:]
                        
                        let currency = data.object(forKey: "currency") as? String ?? ""
                        
                        UserDefaults.standard.set("\(currency)", forKey: "GlobalCurrency")
                        
                        let alertController = UIAlertController(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        
                        alertController.addAction(okAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
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
