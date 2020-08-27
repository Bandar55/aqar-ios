//
//  SignUpDetailController.swift
//  Aqar55
//
//  Created by Amit Singh on 05/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import DropDown

class SignUpDetailController: UIViewController {

    
    @IBOutlet weak var txtFullName: UITextField!
    
    @IBOutlet weak var txtCategory: UITextField!
    
    @IBOutlet weak var btnProfessionalCategory: UIButton!
    
    @IBOutlet weak var txtSubCategory: UITextField!
    
    @IBOutlet weak var btnSubCategory: UIButton!
    
    @IBOutlet weak var btnGender: UIButton!
    
    @IBOutlet weak var txtGender: UITextField!
    
    @IBOutlet weak var txtBirthYear: UITextField!
    
    @IBOutlet weak var btnBirthYear: UIButton!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    
    //last controller passed variables
    var phoneNumber = ""
    var countryCode = ""
    
    var dropDownTag = 0
    let validation:Validation = Validation.validationManager() as! Validation
    let dropDown = DropDown()
    let connection = webservices()
    let genderArr = ["Male","Female"]

    var categoryIdArr = NSMutableArray()
    var categoryNameArr = NSMutableArray()
    
    var selectedCategoryId = ""
    
    var subcategoryNameArr = NSMutableArray()
    var subcategoryIdArr = NSMutableArray()
    var selectedSubcategoryId = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.apiCallForFetchCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if self.dropDownTag == 0{
                
                self.txtCategory.text = "\(item)"
                
                self.selectedCategoryId = self.categoryIdArr.object(at: index) as? String ?? ""
                
                self.subcategoryNameArr.removeAllObjects()
                self.subcategoryIdArr.removeAllObjects()
                self.selectedSubcategoryId = ""
                self.txtSubCategory.text = ""
                
                self.apiCallForGetSubcategoryList(categoryId: self.selectedCategoryId)
            }
            else if self.dropDownTag == 1{
                
                self.txtSubCategory.text = "\(item)"
                
                self.selectedSubcategoryId = self.subcategoryIdArr.object(at: index) as? String ?? ""
                
            }
            else if self.dropDownTag == 2{
                
                self.txtGender.text = "\(item)"
                
                
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func btnOkAction(_ sender: Any) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SingUpMoreDetailsController") as! SingUpMoreDetailsController
//        self.navigationController?.pushViewController(vc, animated: true)
        
        checkValidation()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
       // self.navigationController?.popViewController(animated: true)
        
        for controller in self.navigationController!.viewControllers as Array {
            
            if controller is SignUpController{
                
                self.navigationController!.popToViewController(controller, animated: true)
                
                break
            }
        }
    }
    
    
    @IBAction func tap_birthYearBtn(_ sender: Any) {
        
        openDatePicker()
    }
    
    @IBAction func tap_genderBtn(_ sender: Any) {
        
        dropDownTag = 2
        dropDown.dataSource = genderArr
        dropDown.anchorView = btnGender
        dropDown.show()
    }
    
    @IBAction func tap_subCategoryBtn(_ sender: Any) {
        
        if self.txtCategory.text != ""{
            
            if self.subcategoryIdArr.count != 0{
                
                dropDownTag = 1
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
            
            dropDownTag = 0
            dropDown.dataSource = categoryNameArr as! [String]
            dropDown.anchorView = btnProfessionalCategory
            dropDown.show()
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Data not found", controller: self)
        }
        
      
    }
    
}


extension SignUpDetailController{
    
    func checkValidation(){
        
        var mess = ""
        
        if txtFullName.text == ""{
            
            mess = "Please enter your name"
        }
//        else if txtCategory.text == ""{
//
//            mess = "Please select the professional category"
//        }
//        else if txtGender.text == ""{
//
//            mess = "Please select your gender"
//        }
//        else if txtBirthYear.text == ""{
//
//            mess = "Please select your birth year"
//        }
        else if txtEmail.text == ""{
            
            mess = "Please enter your email"
        }
        else if !validation.validateEmail(txtEmail.text!){
            
            mess = "Please enter valid email"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            self.redirectToNextSignupProcess()
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
    
    func redirectToNextSignupProcess(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SingUpMoreDetailsController") as! SingUpMoreDetailsController
        
        vc.name = txtFullName.text!
        vc.email = txtEmail.text!
        vc.birthYear = txtBirthYear.text!
        vc.category = self.txtCategory.text!
        vc.subCategory = txtSubCategory.text!
        vc.gender = txtGender.text!
        
        vc.countryCode = countryCode
        vc.phoneNo = phoneNumber
        
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        if(txtBirthYear.text!.count > 0)
        {
            let selectedDate = txtBirthYear.text!
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
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
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
                txtBirthYear.text = dateFormatter.string(from: datePicker.date)
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


extension SignUpDetailController{
    
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
