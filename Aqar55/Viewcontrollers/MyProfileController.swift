//
//  MyProfileController.swift
//  AQAR55
//
//  Created by lion on 27/02/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit
import DropDown

class MyProfileController: UIViewController {

    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var lblAccountStatus: UILabel!
    
    @IBOutlet weak var btnAccount: UIButton!
    
    @IBOutlet weak var txtMemberSince: UITextField!
    
    @IBOutlet weak var btnMemberSince: UIButton!
    
    @IBOutlet weak var txtProfessionalId: UITextField!
    
    @IBOutlet weak var txtFullname: UITextField!
    
    @IBOutlet weak var btnCategory: UIButton!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var btnSubcategory: UIButton!
    
    @IBOutlet weak var lblSubcategory: UILabel!
    
    @IBOutlet weak var btnGender: UIButton!
    
    @IBOutlet weak var lblGender: UILabel!
    
    @IBOutlet weak var btnCountry: UIButton!
    
    @IBOutlet weak var lblCountry: UILabel!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPhoneNo: UITextField!
    
    @IBOutlet weak var btnMeasurement: UIButton!
    
    @IBOutlet weak var lblMeasurement: UILabel!
    
    @IBOutlet weak var btnCurrency: UIButton!
    
    @IBOutlet weak var lblCurrency: UILabel!
    
    @IBOutlet weak var imgID1: UIImageView!
    
    @IBOutlet weak var btnId1: UIButton!
    
    @IBOutlet weak var txtId1: UITextField!
    
    @IBOutlet weak var txtIDNo1: UITextField!
    
    @IBOutlet weak var imgId2: UIImageView!
    
    @IBOutlet weak var btnId2: UIButton!
    
    @IBOutlet weak var txtId2: UITextField!
    
    @IBOutlet weak var txtIdNo2: UITextField!
    
    var globalUserData = NSDictionary()
    
    var type = String()
    var imageDataProfilePic = NSData()
    var imageDataGovID_1 = NSData()
    var imageDataGovID_2 = NSData()
    var imagePicker = UIImagePickerController()
    var btnTag = Int()
    
    let dropDown = DropDown()
    var dropDownTag = Int()
    let activeArr = ["Active","Inactive"]
    let governmentIDTypeArray = ["National Id","Passport","Driving Licence","Any Official ID","Commercial Certificate", "Govt Permission","Govt. id","Other"]
    
    let genderArr = ["Male","Female"]
    
    let currencyArr = ["USD","AED","SAR","Bond"]
    let measurementArr = ["Meter","CM","Inch","Feet","Yard"]
    
    var categoryIdArr = NSMutableArray()
    var categoryNameArr = NSMutableArray()
    
    var selectedCategoryId = ""
    
    var subcategoryNameArr = NSMutableArray()
    var subcategoryIdArr = NSMutableArray()
    var selectedSubcategoryId = ""
    
    let connection = webservices()
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        imagePicker.delegate = self
        btnDelete.isHidden = true
        
        userImg.layer.cornerRadius = userImg.frame.size.height/2
        userImg.clipsToBounds = true
        
        if self.globalUserData.count == 0{
            
            self.apiCallForGetUserDetail()
        }
        else{
            
            self.updateElement()
        }
        
        self.apiCallForFetchCategory()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if self.dropDownTag == 0{
                
                self.lblAccountStatus.text = "\(item)"
            }
            else if self.dropDownTag == 1{
                
                self.lblCategory.text = "\(item)"
                
                self.selectedCategoryId = self.categoryIdArr.object(at: index) as? String ?? ""
                
                self.subcategoryNameArr.removeAllObjects()
                self.subcategoryIdArr.removeAllObjects()
                self.selectedSubcategoryId = ""
                self.lblSubcategory.text = "Select"
                
                self.apiCallForGetSubcategoryList(categoryId: self.selectedCategoryId)
            }
            else if self.dropDownTag == 2{
                
                self.lblSubcategory.text = "\(item)"
                
                self.selectedSubcategoryId = self.subcategoryIdArr.object(at: index) as? String ?? ""
            }
            else if self.dropDownTag == 3{
                
                self.lblGender.text = "\(item)"
            }
            else if self.dropDownTag == 4{
                
                self.lblMeasurement.text = "\(item)"
            }
            else if self.dropDownTag == 5{
                
                self.lblCurrency.text = "\(item)"
            }
            else if self.dropDownTag == 6{
                
                self.txtId1.text = "\(item)"
            }
            else if self.dropDownTag == 7{
                
                self.txtId2.text = "\(item)"
            }
        }
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_deleteBtn(_ sender: Any) {
        
    }
    
    
    @IBAction func tap_cancelBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func btnSaveAction(_ sender: Any) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SocialHandlesController") as! SocialHandlesController
//        vc.headerTitle = "My Profile"
//        self.navigationController?.pushViewController(vc, animated: true)
        
        checkValidation()
    }
    
    
    @IBAction func tap_id2Btn(_ sender: Any) {
        
        dropDownTag = 7
        dropDown.dataSource = governmentIDTypeArray
        dropDown.anchorView = btnId2
        dropDown.show()
    }
    
    @IBAction func tap_Editid2Btn(_ sender: Any) {
        
        btnTag = 2
        showImagePicker()
    }
    
    @IBAction func tap_id1Bt(_ sender: Any) {
        
        dropDownTag = 6
        dropDown.dataSource = governmentIDTypeArray
        dropDown.anchorView = btnId1
        dropDown.show()
    }
    
    @IBAction func tap_editId1Btn(_ sender: Any) {
        
        btnTag = 1
        showImagePicker()
    }
    
    @IBAction func tap_currencyBtn(_ sender: Any) {
        
        dropDownTag = 5
        dropDown.dataSource = currencyArr
        dropDown.anchorView = btnCurrency
        dropDown.show()
    }
    
    @IBAction func tap_measurementBtn(_ sender: Any) {
        
        dropDownTag = 4
        dropDown.dataSource = measurementArr
        dropDown.anchorView = btnMeasurement
        dropDown.show()
    }
    
    @IBAction func tap_countryBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryCodeListVC") as! CountryCodeListVC
        vc.objeCountryListDelegate = self
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func tap_genderBtn(_ sender: Any) {
        
        dropDownTag = 3
        dropDown.dataSource = genderArr
        dropDown.anchorView = btnGender
        dropDown.show()
    }
    
    @IBAction func tap_subcategoryBtn(_ sender: Any) {
        
        if self.lblCategory.text != "Select"{
            
            if self.subcategoryIdArr.count != 0{
                
                dropDownTag = 2
                dropDown.dataSource = subcategoryNameArr as! [String]
                dropDown.anchorView = btnSubcategory
                dropDown.show()
            }
            else{
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Sub Category not found for selected category", controller: self)
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select Professional Category first.", controller: self)
        }
    }
    
    
    @IBAction func tap_categoryBtn(_ sender: Any) {
        
        if self.categoryNameArr.count != 0{
            
            dropDownTag = 1
            dropDown.dataSource = categoryNameArr as! [String]
            dropDown.anchorView = btnCategory
            dropDown.show()
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Data not found", controller: self)
        }
      
    }
    
    
    @IBAction func tap_memberSinceBtn(_ sender: Any) {
        
        ///openDatePicker()
    }
    
    @IBAction func tap_accountStatusBtn(_ sender: Any) {
        
        dropDownTag = 0
        dropDown.dataSource = activeArr
        dropDown.anchorView = btnAccount
        dropDown.show()
    }
    
    @IBAction func tap_cameraBtn(_ sender: Any) {
        
        btnTag = 0
        showImagePicker()
    }
    
}


extension MyProfileController:selectedCountry{
    
    func countryInformation(info: NSDictionary) {
        
        print(info)
        
        let countryName = info.object(forKey: "country_name") as? String ?? ""
        self.lblCountry.text = countryName
        
    }
    
}



//MARK:- Custom Method
//MARK:-
extension MyProfileController{
    
    func checkValidation(){
        
        var mess = ""
        
        if txtFullname.text == ""{
            
            mess = "Please enter full name"
        }
        else if txtEmail.text == ""{
            
            mess = "Please enter email"
        }
        else if txtPhoneNo.text == ""{
            
            mess = "Please enter phone number"
        }
        else if lblCategory.text == ""{
            
            mess = "Please select category"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            let dataForProceed = NSMutableDictionary()
            
            dataForProceed.setValue(lblAccountStatus.text!, forKey: "AcountStatus")
            dataForProceed.setValue(txtMemberSince.text!, forKey: "MemberSince")
            dataForProceed.setValue(txtProfessionalId.text!, forKey: "ProfessionalID")
            
            dataForProceed.setValue(txtFullname.text!, forKey: "Name")
            dataForProceed.setValue(txtEmail.text!, forKey: "Email")
            dataForProceed.setValue(txtPhoneNo.text!, forKey: "PhoneNo")
            
            if lblCategory.text == "Select"{
                
                dataForProceed.setValue("", forKey: "Category")
               
            }
            else{
                
                dataForProceed.setValue(lblCategory.text!, forKey: "Category")
            }
            
            if lblSubcategory.text == "Select"{
                
                dataForProceed.setValue("", forKey: "Subcategory")
            }
            else{
                
                dataForProceed.setValue(lblSubcategory.text!, forKey: "Subcategory")
            }
            
            var genderTxt = ""
            
            if self.lblGender.text == "Select"{
                
                genderTxt = ""
            }
            else{
                
                genderTxt = lblGender.text!
            }
            
            dataForProceed.setValue(genderTxt, forKey: "Gender")
            dataForProceed.setValue(lblCountry.text!, forKey: "Country")
            dataForProceed.setValue(lblMeasurement.text!, forKey: "Measurement")
            dataForProceed.setValue(lblCurrency.text!, forKey: "Currency")
            
            dataForProceed.setValue(txtId1.text!, forKey: "IdType1")
            dataForProceed.setValue(txtIDNo1.text!, forKey: "IdNo1")
            
            dataForProceed.setValue(txtId2.text!, forKey: "IdType2")
            dataForProceed.setValue(txtIdNo2.text!, forKey: "IdNo2")
           
            dataForProceed.setValue(imageDataProfilePic, forKey: "UserProfileData")
            dataForProceed.setValue(imageDataGovID_1, forKey: "GovId1Data")
            dataForProceed.setValue(imageDataGovID_2, forKey: "GovId2Data")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SocialHandlesController") as! SocialHandlesController
            vc.headerTitle = "My Profile"
            
            vc.profileDataDictionary = dataForProceed
            
            vc.mainDataDict = self.globalUserData
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
    
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
    
    
    func openDatePicker(){
        
        var baseview: UIView!
        baseview = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height-350, width: self.view.frame.size.width, height: 350))
        baseview.backgroundColor = UIColor(red:0.75, green:0.44, blue:0.99, alpha:1.0)
        baseview.tag = 668
        self.view.addSubview(baseview)
        self.view.bringSubviewToFront(baseview)
        self.view.endEditing(true)
        
        let doneButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.black, for: .normal)
        doneButton.backgroundColor = UIColor.clear
        doneButton.addTarget(self, action: #selector(doneButtonActionFordatePicker), for: .touchUpInside)
        baseview.addSubview(doneButton)
        
        
        let cancelButton: UIButton = UIButton(frame: CGRect(x: baseview.frame.size.width-100, y: 0, width: 100, height: 50))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.addTarget(self, action: #selector(cancelButtonActionFordatePicker), for: .touchUpInside)
        baseview.addSubview(cancelButton)
        
        let minDate = setMinAndMaxDateForDatePicker(maxYear: 0, minYear: 200).0
        let maxDate = setMinAndMaxDateForDatePicker(maxYear: 0, minYear: 200).1
        
        var datePickerView: UIDatePicker!
        datePickerView  = UIDatePicker(frame: CGRect(x:0, y: 50, width: baseview.frame.width, height:baseview.frame.height - 50))
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.backgroundColor = UIColor.white
        datePickerView.tag = 5454
        datePickerView.maximumDate = maxDate
        datePickerView.minimumDate = minDate
        baseview.addSubview(datePickerView)
        
        if(txtMemberSince.text!.count > 0)
        {
            let selectedDate = txtMemberSince.text!
            let dateFormatter = DateFormatter()
            //  dateFormatter.dateFormat = "dd MMM yyyy"
            
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let dateObj = dateFormatter.date(from: selectedDate)
            datePickerView.setDate(dateObj!, animated: false)
        }
    }
    
    func setMinAndMaxDateForDatePicker(maxYear: Int,minYear: Int) -> (Date , Date)
    {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -minYear
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = maxYear
        //let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        let maxDate: Date = NSDate() as Date
        return( minDate,maxDate)
    }
    
    @objc func doneButtonActionFordatePicker()
    {
        if let baseViewTag = self.view.viewWithTag(668)
        {
            if let datePicker = self.view.viewWithTag(5454) as? UIDatePicker
            {
                let dateFormatter = DateFormatter()
                //  dateFormatter.dateFormat = "dd MMM yyyy"
                
                dateFormatter.dateFormat = "dd/MM/yyyy"
                txtMemberSince.text = dateFormatter.string(from: datePicker.date)
                baseViewTag.removeFromSuperview()
            }
        }
    }
    
    @objc func cancelButtonActionFordatePicker()
    {
        if let baseViewTag = self.view.viewWithTag(668)
        {
            baseViewTag.removeFromSuperview()
        }
    }
    
}
//*****//

//MARK:- UiImage Picker Delegate
//MARK:-
extension MyProfileController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        if btnTag == 0{
            
            imageDataProfilePic = selectedImage.jpegData(compressionQuality: 0.5)! as NSData
            UserDefaults.standard.set(imageDataProfilePic, forKey: "PROFILE_PIC_User")
            userImg.image = UIImage(data: imageDataProfilePic as Data)
            
        }else if btnTag == 1{
            
            imageDataGovID_1 = selectedImage.jpegData(compressionQuality: 0.5)! as NSData
            imgID1.image = UIImage(data: imageDataGovID_1 as Data)
            UserDefaults.standard.set(imageDataGovID_1, forKey: "GOV_ID_1_user")
            
        }else{
            
            imageDataGovID_2 = selectedImage.jpegData(compressionQuality: 0.5)! as NSData
            imgId2.image = UIImage(data: imageDataGovID_2 as Data)
            UserDefaults.standard.set(imageDataGovID_2, forKey: "GOV_ID_2_user")
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension MyProfileController{
    
    func fetchData(dateToConvert:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let pendingDate = dateFormatter.date(from: dateToConvert)!
        let sendTime = self.dateFormatterForTime.string(from: pendingDate)
        let sendDate = self.dateFormatterForDate.string(from: pendingDate)
        
        return "\(sendDate) \(sendTime)"
    }
    
    func updateElement(){
        
        print(globalUserData)
        
        self.txtProfessionalId.isUserInteractionEnabled = false
        self.txtPhoneNo.isUserInteractionEnabled = false
        
        self.lblAccountStatus.text = globalUserData.object(forKey: "status") as? String ?? ""
        
        self.txtProfessionalId.text = globalUserData.object(forKey: "professionalId") as? String ?? ""
        
        self.txtFullname.text = globalUserData.object(forKey: "fullName") as? String ?? ""
        
        self.lblCategory.text = globalUserData.object(forKey: "category") as? String ?? ""
        
        self.lblSubcategory.text = globalUserData.object(forKey: "subCategory") as? String ?? ""
        
        self.lblGender.text = globalUserData.object(forKey: "gender") as? String ?? ""
        
        if self.lblGender.text == ""{
            
            self.lblGender.text = "Select"
        }
        
        self.lblCountry.text = globalUserData.object(forKey: "country") as? String ?? ""
        
        self.txtEmail.text = globalUserData.object(forKey: "email") as? String ?? ""
        
        self.txtPhoneNo.text = globalUserData.object(forKey: "mobileNumber") as? String ?? ""
        
        self.lblMeasurement.text = globalUserData.object(forKey: "measurement") as? String ?? ""
        
        self.lblCurrency.text = globalUserData.object(forKey: "currency") as? String ?? ""
        
      //  self.txtMemberSince.text = globalUserData.object(forKey: "memberSince") as? String ?? ""
        
        let createdDate = UserDefaults.standard.object(forKey: "ProfileCreatedTime") as? String ?? ""
        
        if createdDate != ""{
            
            self.txtMemberSince.text = self.fetchData(dateToConvert: createdDate)
        }
        
        self.txtMemberSince.isUserInteractionEnabled = false
        
        self.txtId1.text = globalUserData.object(forKey: "govtIdType1") as? String ?? ""
        self.txtId2.text = globalUserData.object(forKey: "govtIdType2") as? String ?? ""
        
        self.txtIDNo1.text = globalUserData.object(forKey: "govtIdNumber1") as? String ?? ""
        
        self.txtIdNo2.text = globalUserData.object(forKey: "govtIdNumber2") as? String ?? ""
        
        let userImgStr = globalUserData.object(forKey: "profileImage") as? String ?? ""
        
        if userImgStr != ""{
            
            let urlStr = URL(string: userImgStr)
            
            if urlStr != nil{
                
                 self.userImg.setImageWith(urlStr!, placeholderImage: UIImage(named: "user_icon"))
                
                DispatchQueue.global(qos: .background).async {
                    
                    if let data = try? Data(contentsOf: urlStr!)
                    {
                        self.imageDataProfilePic = data as NSData
                        
                    }
                    
                }
                
               
            }
          
        }
        
        let govId1Str = globalUserData.object(forKey: "govtIdImage1") as? String ?? ""
        
        if govId1Str != ""{
            
            let urlStr = URL(string: govId1Str)
            
            if urlStr != nil{
                
                self.imgID1.setImageWith(urlStr!, placeholderImage: UIImage(named: "defaultProperty"))
                
                DispatchQueue.global(qos: .background).async {
                    
                    if let data = try? Data(contentsOf: urlStr!)
                    {
                        self.imageDataGovID_1 = data as NSData
                        
                    }
                }
              
            }
        }
        
        let govId2Str = globalUserData.object(forKey: "govtIdImage2") as? String ?? ""
        
        if govId2Str != ""{
            
            let urlStr = URL(string: govId2Str)
            
            if urlStr != nil{
                
                self.imgId2.setImageWith(urlStr!, placeholderImage: UIImage(named: "defaultProperty"))
                
                DispatchQueue.global(qos: .background).async {
                    
                    if let data = try? Data(contentsOf: urlStr!)
                    {
                        self.imageDataGovID_2 = data as NSData
                        
                    }
                }
               
            }
        }
        
    }
    
}


extension MyProfileController{
    
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
                        
                        if let data = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            self.globalUserData = data
                            
                            self.updateElement()
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
    
    
    func apiCallForFetchCategory(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithStringGetType(getUrlString: App.URLs.apiCallForGetCategoryList as NSString) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        let dataArr = receivedData.object(forKey: "data") as? NSArray ?? []
                        
                        if dataArr.count != 0{
                            
                            for i in 0..<dataArr.count{
                                
                                let dict = dataArr.object(at: i) as? NSDictionary ?? [:]
                                let id = dict.object(forKey: "_id") as? String ?? ""
                                let name = dict.object(forKey: "name") as? String ?? ""
                                
                                self.categoryIdArr.add(id)
                                self.categoryNameArr.add(name)
                            }
                        }
                    }
                    else{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
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
    
    
    
    func apiCallForGetSubcategoryList(categoryId:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["categoryId":categoryId]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForGetSubCategoryList as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        let dataArr = receivedData.object(forKey: "data") as? NSArray ?? []
                        
                        if dataArr.count != 0{
                            
                            for i in 0..<dataArr.count{
                                
                                let dict = dataArr.object(at: i) as? NSDictionary ?? [:]
                                
                                let name = dict.object(forKey: "name") as? String ?? ""
                                let id = dict.object(forKey: "_id") as? String ?? ""
                                
                                self.subcategoryNameArr.add(name)
                                self.subcategoryIdArr.add(id)
                                
                            }
                        }
                    }
                    else{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
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
