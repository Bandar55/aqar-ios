//
//  MyBusinessProfileController.swift
//  AQAR55
//
//  Created by lion on 27/02/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit
import DropDown

class MyBusinessProfileController: UIViewController {

    var headerTitle = ""
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var lblIDs: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblBusinessCategory: UILabel!
    @IBOutlet var lblSubCategory: UILabel!
    @IBOutlet var btnSaveNext: UIButton!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var imgFirstGovernmentID: UIImageView!
    @IBOutlet weak var imgSecondGovernmentID: UIImageView!
    
    @IBOutlet weak var txtFieldActive: UILabel!
    @IBOutlet weak var btnActivationRef: UIButton!
    @IBOutlet weak var txtFieldMembershipDate: UITextField!
    
    @IBOutlet weak var btnProfessionalCategory: UIButton!
    @IBOutlet weak var txtCategory: UILabel!
    
    
    @IBOutlet weak var btnSubCategory: UIButton!
    @IBOutlet weak var txtSubCategory: UILabel!
    
    
    @IBOutlet weak var btngovernmentID_1: UIButton!
    @IBOutlet weak var txtgovernmentID_1: UILabel!
    
    @IBOutlet weak var btngovernmentID_2: UIButton!
    @IBOutlet weak var txtgovernmentID_2: UILabel!
    
    @IBOutlet weak var txtFieldProfessionalName: UITextField!
    
    @IBOutlet weak var txtFieldBusinessID: UITextField!
    
    @IBOutlet weak var txtFieldGOVID1: UITextField!
    
    @IBOutlet weak var txtFieldGOVID2: UITextField!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    
    //Code by aman: - Variables
    //*****//
    var type = String()
    var imageDataProfilePic = NSData()
    var imageDataGovID_1 = NSData()
    var imageDataGovID_2 = NSData()
    var imagePicker = UIImagePickerController()
    var btnTag = Int()
    
    let dropDown = DropDown()
    var dropDownTag = Int()
    let activeArr = ["active","inactive"]
    let governmentIDTypeArray = ["National Id","Passport","Driving Licence","Any Official ID","Commercial Certificate", "Govt Permission","Govt. id","Other"]
    
    let connection = webservices()
   
    var categoryIdArr = NSMutableArray()
    var categoryNameArr = NSMutableArray()
    
    var selectedCategoryId = ""
    
    var subcategoryNameArr = NSMutableArray()
    var subcategoryIdArr = NSMutableArray()
    var selectedSubcategoryId = ""
    var userInfoModelItem = UserInfoDataModel()
    //*****//
    
    var updateUIFuncWillCalled = false
    
    var idToBeFilled = ""
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    var userInfoDict = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = headerTitle
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        if updateUIFuncWillCalled == true{
            
            updateUI()
            
            self.btnDelete.isHidden = false
        }
        else{
            
            self.btnDelete.isHidden = true
            
            //we are setting data in case of creating profile of business and professional user and getting data from default profile of user
            
            setInfoOnFields()
        }
      
        imagePicker.delegate = self
        
        self.txtFieldBusinessID.text = idToBeFilled
        
        if headerTitle == "My Professional Profile"{
            
            type = "professional"
            lblIDs.text = "Professional ID"
            lblName.text = "Professional Name"
            btnSaveNext.isHidden = true
            btnSave.isHidden = false
            btnCancel.isHidden = false
            
            userInfoModelItem.professionalId = idToBeFilled
            
        }else{
            
            type = "business"
            btnSaveNext.isHidden = false
            btnSave.isHidden = true
            btnCancel.isHidden = true
            
            userInfoModelItem.businessId = idToBeFilled
            
        }
        
        self.apiCallForFetchCategory()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let createdDate = UserDefaults.standard.object(forKey: "ProfileCreatedTime") as? String ?? ""
        
        if createdDate != ""{
            
            self.txtFieldMembershipDate.text = self.fetchData(dateToConvert: createdDate)
        }
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if self.dropDownTag == 1{
                
                 self.txtFieldActive.text = "\(item)"
            }
            
            else if self.dropDownTag == 2{

                self.txtCategory.text = "\(item)"

                self.selectedCategoryId = self.categoryIdArr.object(at: index) as? String ?? ""

                self.subcategoryNameArr.removeAllObjects()
                self.subcategoryIdArr.removeAllObjects()
                self.selectedSubcategoryId = ""
                self.txtSubCategory.text = ""

                self.apiCallForGetSubcategoryList(categoryId: self.selectedCategoryId)
            }
            else if self.dropDownTag == 3{

                self.txtSubCategory.text = "\(item)"

                self.selectedSubcategoryId = self.subcategoryIdArr.object(at: index) as? String ?? ""

            }
            else if self.dropDownTag == 4{

                self.txtgovernmentID_1.text = "\(item)"
                
            }else{
                
                self.txtgovernmentID_2.text = "\(item)"
                
            }
            
        }
    }
    

    @IBAction func tap_deleteBtn(_ sender: Any) {
        
        let alertController = UIAlertController(title: "", message: "Are you sure? You want to delete your \(self.type) profile", preferredStyle: .alert)
        
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
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        
//        UserDefaults.standard.removeObject(forKey: "PROFILE_PIC")
//        UserDefaults.standard.removeObject(forKey: "GOV_ID_1")
//        UserDefaults.standard.removeObject(forKey: "GOV_ID_2")
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileController") as! BusinessProfileController
//
//        vc.headerTitle = headerTitle
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
        checkValidation()
    }
    
    
    @IBAction func btnSaveAction(_ sender: Any) {
        
        checkValidation()
    }
    
    
    @IBAction func btnCancelAction(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "PROFILE_PIC")
        UserDefaults.standard.removeObject(forKey: "GOV_ID_1")
        UserDefaults.standard.removeObject(forKey: "GOV_ID_2")
        
    }
    
    
    //Code by aman: - Action for open camera
    //*****//
    @IBAction func btnChooseImageTapped(_ sender: UIButton) {
        
        btnTag = sender.tag
        showImagePicker()
    }
    
    
    
    @IBAction func btnChooseIDTapped(_ sender: UIButton) {
        
        btnTag = sender.tag
        showImagePicker()
    }
    
    
    @IBAction func btnActivationTapped(_ sender: UIButton) {
        
        dropDownTag = sender.tag
        dropDown.dataSource = activeArr
        dropDown.anchorView = btnActivationRef
        dropDown.show()
    }
    
    
    @IBAction func btnSelectMembershipDateTapped(_ sender: UIButton) {
        
        self.txtFieldMembershipDate.isUserInteractionEnabled = false
       // openDatePicker()
    }
    
    
    
    @IBAction func tap_subCategoryBtn(_ sender: Any) {
        
        if self.txtCategory.text != ""{
            
            if self.subcategoryIdArr.count != 0{
                
                dropDownTag = (sender as AnyObject).tag
                dropDown.dataSource = self.subcategoryNameArr as! [String]
                dropDown.anchorView = btnSubCategory
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
    
    @IBAction func tap_professionalCategoryBtn(_ sender: Any) {
        
        if self.categoryNameArr.count != 0{
            
            dropDownTag = (sender as AnyObject).tag
            dropDown.dataSource = categoryNameArr as! [String]
            dropDown.anchorView = btnProfessionalCategory
            dropDown.show()
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Data not found", controller: self)
        }
        
    }
    
    
    @IBAction func btnSelectGovernmentIDTapped(_ sender: UIButton) {
        
        dropDownTag = sender.tag
        if dropDownTag == 4{
            dropDown.dataSource = governmentIDTypeArray
            dropDown.anchorView = btngovernmentID_1
            dropDown.show()
        }else{
            dropDown.dataSource = governmentIDTypeArray
            dropDown.anchorView = btngovernmentID_2
            dropDown.show()
        }
        
    }
    
    
    //*****//
    
}


//Code by aman: - Adding UIImagePicker Delegates
//*****//

//MARK:- UiImage Picker Delegate
//MARK:-
extension MyBusinessProfileController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        if btnTag == 0{
        imageDataProfilePic = selectedImage.jpegData(compressionQuality: 0.5)! as NSData
            UserDefaults.standard.set(imageDataProfilePic, forKey: "PROFILE_PIC")
        imgProfilePic.image = UIImage(data: imageDataProfilePic as Data)
        
        }else if btnTag == 1{
            imageDataGovID_1 = selectedImage.jpegData(compressionQuality: 0.5)! as NSData
            imgFirstGovernmentID.image = UIImage(data: imageDataGovID_1 as Data)
            UserDefaults.standard.set(imageDataGovID_1, forKey: "GOV_ID_1")
           
        }else{
            imageDataGovID_2 = selectedImage.jpegData(compressionQuality: 0.5)! as NSData
            imgSecondGovernmentID.image = UIImage(data: imageDataGovID_2 as Data)
            UserDefaults.standard.set(imageDataGovID_2, forKey: "GOV_ID_2")
        }
        
//        self.arrImages.add(imageData)
//        self.arrContent.add(self.txtAddCaption.text!)
//        
//        self.txtAddCaption.text = ""
//        
//        self.collectionView_addImage.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
}



//MARK:- Custom Method
//MARK:-
extension MyBusinessProfileController{
    
    func setInfoOnFields(){
        
        if userInfoDict.count != 0 && headerTitle == "My Professional Profile"{
            
            self.txtFieldProfessionalName.text = userInfoDict.object(forKey: "fullName") as? String ?? ""
            
            self.txtCategory.text = userInfoDict.object(forKey: "category") as? String ?? ""
            
            self.txtSubCategory.text = userInfoDict.object(forKey: "subCategory") as? String ?? ""
            
            txtgovernmentID_1.text = userInfoDict.object(forKey: "govtIdType1") as? String ?? ""
            
            txtgovernmentID_2.text = userInfoDict.object(forKey: "govtIdType2") as? String ?? ""
            
            if userInfoDict.object(forKey: "govtIdType1") as? String ?? "" == ""{
                
                txtgovernmentID_1.text = "Select Id type"
            }
            
            if userInfoDict.object(forKey: "govtIdType2") as? String ?? "" == ""{
                
                txtgovernmentID_2.text = "Select Id type"
            }
            
            txtFieldGOVID1.text = userInfoDict.object(forKey: "govtIdNumber1") as? String ?? ""
            txtFieldGOVID2.text = userInfoDict.object(forKey: "govtIdNumber2") as? String ?? ""
            
            let imgStr = userInfoDict.object(forKey: "profileImage") as? String ?? ""
            
            if imgStr != ""{
                
                let urlStr = URL(string: imgStr)
                
                imgProfilePic.setImageWith(urlStr!, placeholderImage:UIImage(named: "user_icon"))
                
                DispatchQueue.global(qos: .background).async {
                    
                    do {
                        
                        let imageData = try Data(contentsOf:urlStr as! URL)
                            
                        UserDefaults.standard.set(imageData, forKey: "PROFILE_PIC")
                            
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
                
            }
            
            //////getting id 1 image
            
            let id1Str = userInfoDict.object(forKey: "govtIdImage1") as? String ?? ""
            
            if id1Str != ""{
                
                let urlStr = URL(string: id1Str)
                
                imgFirstGovernmentID.setImageWith(urlStr!, placeholderImage: UIImage(named: "defaultProperty"))
                
                DispatchQueue.global(qos: .background).async {
                    
                    do {
                        
                        let imageData = try Data(contentsOf: urlStr as! URL)
                        UserDefaults.standard.set(imageData, forKey: "GOV_ID_1")
                      
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
                
            }
            
            //////getting id 2 image
            
            let id2Str = userInfoDict.object(forKey: "govtIdImage2") as? String ?? ""
            
            if id2Str != ""{
                
                let urlStr = URL(string: id2Str)
                
                imgSecondGovernmentID.setImageWith(urlStr!, placeholderImage: UIImage(named: "defaultProperty"))
                
                
                DispatchQueue.global(qos: .background).async {
                    
                    do {
                        
                        let imageData = try Data(contentsOf: urlStr as! URL)
                        
                        UserDefaults.standard.set(imageData, forKey: "GOV_ID_2")
                    
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                    
                }
                
            }
            
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
    
    
    func fetchData(dateToConvert:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let pendingDate = dateFormatter.date(from: dateToConvert)!
        let sendTime = self.dateFormatterForTime.string(from: pendingDate)
        let sendDate = self.dateFormatterForDate.string(from: pendingDate)
        
        return "\(sendDate) \(sendTime)"
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
        
        if(txtFieldMembershipDate.text!.count > 0)
        {
            let selectedDate = txtFieldMembershipDate.text!
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
                txtFieldMembershipDate.text = dateFormatter.string(from: datePicker.date)
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



extension MyBusinessProfileController{
    
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
    
    
    func checkValidation(){
        
        var mess = ""
        
        if txtFieldActive.text == "Choose status"{
            
            mess = "Please select account status"
        }
            
//        else if txtFieldBusinessID.text == ""{
//
//            mess = "Please select professional ID"
//        }
//        else if txtFieldBusinessID.text == ""{
//
//            mess = "Please enter professional ID"
//        }
        else if txtFieldMembershipDate.text == ""{
            
            mess = "Please select the membership date"
        }
        else if txtFieldProfessionalName.text == ""{
            
            if  type == "professional"{
                
                mess = "Please enter your professional name"
            }
            else{
                
                mess = "Please enter your business name"
            }
            
        }
        else if txtCategory.text == "Select"{
            
            mess = "Please select category"
        }
        else if txtSubCategory.text == "Select"{
            
            mess = "Please select sub-category"
        }
        else if UserDefaults.standard.value(forKey: "GOV_ID_1") == nil{
            
            mess = "Please select government ID 1"
        }
        else if UserDefaults.standard.value(forKey: "GOV_ID_2") == nil{
            
            mess = "Please select government ID 2"
        }
        else if txtgovernmentID_1.text == "Select Id type"{
            mess = "Please select government ID 1 type"
        }
        else if txtgovernmentID_2.text == "Select Id type"{
            mess = "Please select government ID 2 type"
        }
            
        else if txtFieldGOVID1.text == ""{
            mess = "Please enter government ID 1 number"
        }
        else if txtFieldGOVID2.text == ""{
            mess = "Please select government ID 2 number"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileController") as! BusinessProfileController
            vc.headerTitle = headerTitle
            
            vc.dataDict = dataSaveForProceed(type:self.type,status:txtFieldActive.text!,memberSince:txtFieldMembershipDate.text!,fullName:txtFieldProfessionalName.text!,category:self.txtCategory.text!,subCategory:self.txtSubCategory.text!,govtIdType1:txtgovernmentID_1.text!,govtIdType2:txtgovernmentID_2.text!,govtIdNumber1:txtFieldGOVID1.text!,govtIdNumber2:txtFieldGOVID2.text!)
            
            vc.userInfoModelItem = userInfoModelItem
            
            vc.updateUIFuncWillCalled = self.updateUIFuncWillCalled
            
            vc.userInfoDict = self.userInfoDict
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    

    
    func updateUI(){
        
        self.txtFieldActive.text = self.userInfoModelItem.status
        
        imgProfilePic.setImageWith(URL(string: self.userInfoModelItem.profileImage), placeholderImage: UIImage(named: "user_icon"))
  
        DispatchQueue.global(qos: .background).async {
            
            do {
                
                let profileImg = self.userInfoModelItem.profileImage
                
                if profileImg != ""{
                    
                    let imageData = try Data(contentsOf: URL(string: self.userInfoModelItem.profileImage) as! URL)
                    
                     UserDefaults.standard.set(imageData, forKey: "PROFILE_PIC")
                    
                }
                else{
                    
                }
                
            } catch {
                print("Unable to load data: \(error)")
            }
        }
        
        
        
        if headerTitle == "My Professional Profile"{
            
            txtFieldActive.text = self.userInfoModelItem.status
          //  txtFieldBusinessID.text = self.userInfoModelItem.professionalProfile
           // txtFieldMembershipDate.text = self.userInfoModelItem.memberSince
            txtFieldProfessionalName.text = self.userInfoModelItem.fullName
            txtCategory.text = self.userInfoModelItem.category
            txtSubCategory.text = self.userInfoModelItem.subCategory
            
            imgFirstGovernmentID.setImageWith(URL(string: self.userInfoModelItem.govtIdImage1), placeholderImage: UIImage(named: "defaultProperty"))
            
            DispatchQueue.global(qos: .background).async {
                
                do {
                    
                    let govIdImg1 = self.userInfoModelItem.govtIdImage1
                    
                    if govIdImg1 != ""{
                        
                        let imageData = try Data(contentsOf: URL(string: self.userInfoModelItem.govtIdImage1) as! URL)
                        UserDefaults.standard.set(imageData, forKey: "GOV_ID_1")
                        
                    }
                    else{
                        
                    }
                    
                } catch {
                    print("Unable to load data: \(error)")
                }
            }
            
            imgSecondGovernmentID.setImageWith(URL(string: self.userInfoModelItem.govtIdImage2), placeholderImage:UIImage(named: "defaultProperty"))
            
            DispatchQueue.global(qos: .background).async {
                
                do {
                    
                    let govIdImg2 = self.userInfoModelItem.govtIdImage2
                    
                    if govIdImg2 != ""{
                        
                        let imageData = try Data(contentsOf: URL(string: self.userInfoModelItem.govtIdImage2) as! URL)
                        UserDefaults.standard.set(imageData, forKey: "GOV_ID_2")
                        
                    }
                    else{
                        
                        
                    }
                    
                } catch {
                    print("Unable to load data: \(error)")
                }
                
            }
            
            txtgovernmentID_1.text = self.userInfoModelItem.govtIdType1
            txtgovernmentID_2.text = self.userInfoModelItem.govtIdType2
            txtFieldGOVID1.text = self.userInfoModelItem.govtIdNumber1
            txtFieldGOVID2.text = self.userInfoModelItem.govtIdNumber2
            
        }else{
            
            txtFieldActive.text = self.userInfoModelItem.status
          //  txtFieldBusinessID.text = self.userInfoModelItem.businessProfile
          //  txtFieldMembershipDate.text = self.userInfoModelItem.memberSince
            txtFieldProfessionalName.text = self.userInfoModelItem.fullName
            txtCategory.text = self.userInfoModelItem.category
            txtSubCategory.text = self.userInfoModelItem.subCategory
            
            imgFirstGovernmentID.setImageWith(URL(string: self.userInfoModelItem.govtIdImage1), placeholderImage: UIImage(named: "defaultProperty"))
            
            DispatchQueue.global(qos: .background).async {
                
                do {
                    
                    if self.userInfoModelItem.govtIdImage1 != ""{
                        
                        let imageData = try Data(contentsOf: URL(string: self.userInfoModelItem.govtIdImage1) as! URL)
                        UserDefaults.standard.set(imageData, forKey: "GOV_ID_1")
                        
                    }
                    
                    
                } catch {
                    print("Unable to load data: \(error)")
                }
                
            }
            
            imgSecondGovernmentID.setImageWith(URL(string: self.userInfoModelItem.govtIdImage2), placeholderImage: UIImage(named: "defaultProperty"))
            
            
            DispatchQueue.global(qos: .background).async {
                
                do {
                    
                    if self.userInfoModelItem.govtIdImage2 != ""{
                        
                        let imageData = try Data(contentsOf: URL(string: self.userInfoModelItem.govtIdImage2) as! URL)
                        UserDefaults.standard.set(imageData, forKey: "GOV_ID_2")
                    }
                    
                } catch {
                    print("Unable to load data: \(error)")
                }
                
            }
            
            txtgovernmentID_1.text = self.userInfoModelItem.govtIdType1
            txtgovernmentID_2.text = self.userInfoModelItem.govtIdType2
            txtFieldGOVID1.text = self.userInfoModelItem.govtIdNumber1
            txtFieldGOVID2.text = self.userInfoModelItem.govtIdNumber2
            
        }
    }
    
    
    func dataSaveForProceed(type:String,status:String,memberSince:String,fullName:String,category:String,subCategory:String,govtIdType1:String,govtIdType2:String,govtIdNumber1:String,govtIdNumber2:String)->NSMutableDictionary{

        var keyName = ""
        if type == "professional"{
            
            keyName = "professionalId"
        }
        else{
            
            keyName = "businessId"
        }
        
        let dataDict:NSMutableDictionary = ["type":type,
                                            "status":status,
                                            "memberSince":memberSince,
                                            "fullName":fullName,
                                            "category":category,
                                            "subCategory":subCategory,
                                            "govtIdType1":govtIdType1,
                                            "govtIdType2":govtIdType2,
                                            "govtIdNumber1":govtIdNumber1,
                                            "govtIdNumber2":govtIdNumber1,
                                            "\(keyName)":idToBeFilled]

            return dataDict
    }
    
}


extension MyBusinessProfileController{
    
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
