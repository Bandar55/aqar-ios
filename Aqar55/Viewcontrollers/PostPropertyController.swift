//
//  PostPropertyController.swift
//  Aqar55
//
//  Created by Callsoft on 05/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import DropDown


class PostPropertyController: UIViewController {

    
    @IBOutlet weak var bottomViewSale: UIView!
    @IBOutlet weak var bottomViewRent: UIView!
    
    @IBOutlet weak var txtPropertyTitle: UITextField!
    
    @IBOutlet weak var btnPropertyCategory: UIButton!
    
    @IBOutlet weak var lblSelectCategory: UILabel!
    
    @IBOutlet weak var btnCommercial: UIButton!
    
    @IBOutlet weak var btnResidential: UIButton!
    
    @IBOutlet weak var btnBoth: UIButton!
    
    @IBOutlet weak var btnFamily: UIButton!
    
    @IBOutlet weak var btnSingle: UIButton!
    
    @IBOutlet weak var btnBothAvailable: UIButton!
    
    @IBOutlet weak var btnBedroom: UIButton!
    
    @IBOutlet weak var lblBedroom: UILabel!
    
    @IBOutlet weak var btnBathroom: UIButton!
    
    @IBOutlet weak var lblBathroom: UILabel!
    
    @IBOutlet weak var btnKitchen: UIButton!
    
    @IBOutlet weak var lblKitchen: UILabel!
    
    @IBOutlet weak var btnFloor: UIButton!
    
    @IBOutlet weak var lblFloor: UILabel!
    
    
    @IBOutlet weak var btnPropertyStatus: UIButton!
    
    @IBOutlet weak var lblPropertyStatus: UILabel!
    
    
    
//    var propertyCategoryArr = ["Real estate","Renting","Ownership society","Private property","Immovable property","Inalienable possessions","Indirect property","Intake (land)","Intermediate rent","Repossession","Landed property","Expropriation","Labor theory of property","Serviced office"]
    
    var propertyCategoryArr = NSMutableArray()
  
    var floorArr = ["Ground Floor","1 Floor","2 Floor","3 Floor","4 Floor","5 Floor"]
    
    var availableFor = ""
    var purpose = ""
    
    var dropdownTag = 0
    let dropDown = DropDown()
    
    var badRoomBathAndKitchenArr = ["1","2","3","4","5","6","7","8","9","10"]

    //for validation
    var categorySelected = false
    var bathroomSelected = true
    var bedroomSelected = true
    var kitchenSelected = true
    var floorSelected = true
    
    var propertyStatusSelected = false
    
    let connection = webservices()
    
    var controllerPurpuse = ""
    var editItemDict = NSDictionary()
    
    var floorDataArr = NSMutableArray()
    var bedroomBathroomKitchenCombineDataArr = NSMutableArray()
    
    var propertyStatusArr = ["active","inactive"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.set("Sale", forKey: "PropertyType")
        availableFor = "family"
        purpose = "commercial"
        
        floorDataArr.add("Ground Floor")
        
        for i in 0...100{
            
            if i <= 9{
                
                bedroomBathroomKitchenCombineDataArr.add("0\(i)")
            }
            else{
                
                bedroomBathroomKitchenCombineDataArr.add("\(i)")
            }
            
            floorDataArr.add("\(i) Floor")
        }
        
        bedroomBathroomKitchenCombineDataArr.add("100+")
        floorDataArr.add("100+")
        
        apiCallForGetCategoryList()
        
        self.lblFloor.text = "Ground Floor"
        
        if self.controllerPurpuse == "Edit"{
            
            self.setupForDataWillBeEdit()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if self.dropdownTag == 0{
                
                self.categorySelected = true
                self.lblSelectCategory.text = "\(item)"
            }
            else if self.dropdownTag == 1{
                
                self.bedroomSelected = true
                self.lblBedroom.text = "\(item)"
            }
            else if self.dropdownTag == 2{
                
                self.bathroomSelected = true
                self.lblBathroom.text = "\(item)"
            }
            else if self.dropdownTag == 3{
                
                self.kitchenSelected = true
                self.lblKitchen.text = "\(item)"
            }
            else if self.dropdownTag == 4{
                
                self.floorSelected = true
                self.lblFloor.text = "\(item)"
            }
            else if self.dropdownTag == 5{
                
                self.propertyStatusSelected = true
                self.lblPropertyStatus.text = "\(item)"
            }
        }
    }
    
    
    @IBAction func tap_propertyStatusBtn(_ sender: Any) {
        
        dropdownTag = 5
        dropDown.dataSource = propertyStatusArr
        dropDown.anchorView = btnPropertyStatus
        dropDown.show()
    }
    
    

    @IBAction func btnAddPriceAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPriceController") as! AddPriceController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostPropertyDetailsController") as! PostPropertyDetailsController
//        self.navigationController?.pushViewController(vc, animated: true)
        
        checkValidation()

    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSaleAction(_ sender: Any) {
        
        UserDefaults.standard.set("Sale", forKey: "PropertyType")
        
        UIView.animate(withDuration: 0.5) {
            
            self.bottomViewSale.isHidden = false
            self.bottomViewRent.isHidden = true
        }

    }
    
    
    @IBAction func btnrentAction(_ sender: Any) {
        
        UserDefaults.standard.set("Rent", forKey: "PropertyType")
        
        UIView.animate(withDuration: 0.5) {

            self.bottomViewSale.isHidden = true
            self.bottomViewRent.isHidden = false
        }
    }
    
    
    @IBAction func tap_floorBtn(_ sender: Any) {
        
        dropdownTag = 4
        dropDown.dataSource = floorDataArr as! [String]
        dropDown.anchorView = btnFloor
        dropDown.show()
    }
    
    @IBAction func tap_kitchenBtn(_ sender: Any) {
        
        dropdownTag = 3
        dropDown.dataSource = bedroomBathroomKitchenCombineDataArr as! [String]
        dropDown.anchorView = btnKitchen
        dropDown.show()
    }
    
    @IBAction func tap_bathroomsBtn(_ sender: Any) {
        
        dropdownTag = 2
        dropDown.dataSource = bedroomBathroomKitchenCombineDataArr as! [String]
        dropDown.anchorView = btnBathroom
        dropDown.show()
    }
    
    @IBAction func tap_bedroomsBtn(_ sender: Any) {
        
        dropdownTag = 1
        dropDown.dataSource = bedroomBathroomKitchenCombineDataArr as! [String]
        dropDown.anchorView = btnBedroom
        dropDown.show()
    }
    
    @IBAction func tap_familyBtn(_ sender: Any) {
        
        btnFamily.setImage(UIImage(named: "selected"), for: .normal)
        btnSingle.setImage(UIImage(named: "unselected"), for: .normal)
        btnBothAvailable.setImage(UIImage(named: "unselected"), for: .normal)
        
        availableFor = "family"
    }
    
    @IBAction func tap_singleBtn(_ sender: Any) {
        
        btnFamily.setImage(UIImage(named: "unselected"), for: .normal)
        btnSingle.setImage(UIImage(named: "selected"), for: .normal)
        btnBothAvailable.setImage(UIImage(named: "unselected"), for: .normal)
        
        availableFor = "single"
    }
    
    @IBAction func tap_bothAvailableBtn(_ sender: Any) {
        
        btnFamily.setImage(UIImage(named: "unselected"), for: .normal)
        btnSingle.setImage(UIImage(named: "unselected"), for: .normal)
        btnBothAvailable.setImage(UIImage(named: "selected"), for: .normal)
        
        availableFor = "both"
    }
    
    @IBAction func tap_commercialBtn(_ sender: Any) {
        
        btnCommercial.setImage(UIImage(named: "selected"), for: .normal)
        btnResidential.setImage(UIImage(named: "unselected"), for: .normal)
        btnBoth.setImage(UIImage(named: "unselected"), for: .normal)
        
        purpose = "commercial"
    }
    
    @IBAction func tap_residentialBtn(_ sender: Any) {
        
        btnResidential.setImage(UIImage(named: "selected"), for: .normal)
        btnCommercial.setImage(UIImage(named: "unselected"), for: .normal)
        btnBoth.setImage(UIImage(named: "unselected"), for: .normal)
        
        purpose = "residential"
    }
    
    @IBAction func tap_bothBtn(_ sender: Any) {
        
        btnBoth.setImage(UIImage(named: "selected"), for: .normal)
        btnResidential.setImage(UIImage(named: "unselected"), for: .normal)
        btnCommercial.setImage(UIImage(named: "unselected"), for: .normal)
        
        purpose = "both"
    }
    
    @IBAction func tap_categoryBtn(_ sender: Any) {
        
        dropdownTag = 0
        dropDown.dataSource = propertyCategoryArr as! [String]
        dropDown.anchorView = btnPropertyCategory
        dropDown.show()
    }
    
}


//MARK:- Custom Method
//MARK:-
extension PostPropertyController{
    
    func checkValidation(){
        
        var mess = ""
        
        if txtPropertyTitle.text == ""{
            
            mess = "Please enter property title"
        }
        else if categorySelected == false{
            
            mess = "Please select the property category"
        }
        else if propertyStatusSelected == false{
            
            mess = "Please select property status"
        }
        else if bedroomSelected == false{
            
            mess = "Please select the number of bedrooms"
        }
        else if bathroomSelected == false{
            
            mess = "Please select the number of bathrooms"
        }
        else if kitchenSelected == false{
            
            mess = "Please select the number of kitchens"
        }
        else if floorSelected == false{
            
            mess = "Please select the floor type"
        }
        else{
            
            mess = ""
        }
        
        
        if mess == ""{
            
            let initialPageData = NSMutableDictionary()
            
            initialPageData.removeAllObjects()
            
            initialPageData.setValue(txtPropertyTitle.text!, forKey: "PropertyTitle")
            initialPageData.setValue(lblSelectCategory.text!, forKey: "PropertyCategory")
            initialPageData.setValue(purpose, forKey: "Purpuse")
            initialPageData.setValue(availableFor, forKey: "AvailableFor")
            initialPageData.setValue(lblBedroom.text!, forKey: "NoOfBedrooms")
            initialPageData.setValue(lblBathroom.text!, forKey: "NoOfBathrooms")
            initialPageData.setValue(lblKitchen.text!, forKey: "NoOfKitchens")
            initialPageData.setValue(lblFloor.text!, forKey: "FloorType")
            
            initialPageData.setValue(lblPropertyStatus.text!, forKey: "PropertyStatus")
            
            UserDefaults.standard.setValue(initialPageData, forKey: "PropertyInitialDetail")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostPropertyDetailsController") as! PostPropertyDetailsController
            
            vc.editItemDict = self.editItemDict
            vc.controllerPurpuse = self.controllerPurpuse
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
}



//MARK:- Webservices
//MARK:-
extension PostPropertyController{
    
    func apiCallForGetCategoryList(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithStringGetType(getUrlString: App.URLs.apiCallForGetPropertyCategoryListing as NSString) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let data = receivedData.object(forKey: "data") as? NSArray{
                            
                            for i in 0..<data.count{
                                
                                let dict = data.object(at: i) as? NSDictionary ?? [:]
                                
                                let name = dict.object(forKey: "name") as? String ?? ""
                                
                                self.propertyCategoryArr.add(name)
                                
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
                        
                        self.navigationController?.popViewController(animated: true)
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



extension PostPropertyController{
    
    func setupForDataWillBeEdit(){
        
        let type = editItemDict.object(forKey: "Type") as? String ?? ""
        
        if type == "sale"{
            
            UserDefaults.standard.set("Sale", forKey: "PropertyType")
            
            UIView.animate(withDuration: 0.5) {
                
                self.bottomViewSale.isHidden = false
                self.bottomViewRent.isHidden = true
            }
        }
        else{
            
            UserDefaults.standard.set("Rent", forKey: "PropertyType")
            
            UIView.animate(withDuration: 0.5) {
                
                self.bottomViewSale.isHidden = true
                self.bottomViewRent.isHidden = false
            }
        }
        
        self.txtPropertyTitle.text = editItemDict.object(forKey: "title") as? String ?? ""
        
        self.lblSelectCategory.text = editItemDict.object(forKey: "category") as? String ?? ""
        
        self.lblPropertyStatus.text = editItemDict.object(forKey: "status") as? String ?? ""
        
        if self.lblPropertyStatus.text == ""{
            
            self.lblPropertyStatus.text = "Select Status"
            self.propertyStatusSelected = false
        }
        else{
            
            self.propertyStatusSelected = true
        }
        
        self.purpose = editItemDict.object(forKey: "purpose") as? String ?? ""
        
        if purpose == "commercial"{
            
            btnCommercial.setImage(UIImage(named: "selected"), for: .normal)
            btnResidential.setImage(UIImage(named: "unselected"), for: .normal)
            btnBoth.setImage(UIImage(named: "unselected"), for: .normal)
            
        }
        else if purpose == "residential"{
            
            btnResidential.setImage(UIImage(named: "selected"), for: .normal)
            btnCommercial.setImage(UIImage(named: "unselected"), for: .normal)
            btnBoth.setImage(UIImage(named: "unselected"), for: .normal)
        }
        else{
            
            btnBoth.setImage(UIImage(named: "selected"), for: .normal)
            btnResidential.setImage(UIImage(named: "unselected"), for: .normal)
            btnCommercial.setImage(UIImage(named: "unselected"), for: .normal)
        }
        
        self.availableFor = editItemDict.object(forKey: "available") as? String ?? ""
        
        if self.availableFor == "family"{
            
            btnFamily.setImage(UIImage(named: "selected"), for: .normal)
            btnSingle.setImage(UIImage(named: "unselected"), for: .normal)
            btnBothAvailable.setImage(UIImage(named: "unselected"), for: .normal)
            
            
        }
        else if self.availableFor == "single"{
            
            btnFamily.setImage(UIImage(named: "unselected"), for: .normal)
            btnSingle.setImage(UIImage(named: "selected"), for: .normal)
            btnBothAvailable.setImage(UIImage(named: "unselected"), for: .normal)
            
        }
        else{
            
            btnFamily.setImage(UIImage(named: "unselected"), for: .normal)
            btnSingle.setImage(UIImage(named: "unselected"), for: .normal)
            btnBothAvailable.setImage(UIImage(named: "selected"), for: .normal)
        }
        
        self.lblKitchen.text = "\(editItemDict.object(forKey: "kitchens") as? String ?? "0")"
        self.lblBedroom.text = "\(editItemDict.object(forKey: "bedrooms") as? String ?? "0")"
        self.lblBathroom.text = "\(editItemDict.object(forKey: "bathrooms") as? String ?? "0")"
        self.lblFloor.text = "\(editItemDict.object(forKey: "floor") as? String ?? "Ground Floor")"
        
        
        self.categorySelected = true
        self.bedroomSelected = true
        self.bathroomSelected = true
        self.kitchenSelected = true
        self.floorSelected = true
        
//        if self.lblFloor.text == "Select"{
//
//            self.floorSelected = false
//        }
//        else{
//
//            self.floorSelected = true
//        }
        
    }
    
}
