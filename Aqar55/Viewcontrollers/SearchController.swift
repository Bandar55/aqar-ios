//
//  SearchController.swift
//  Aqar55
//
//  Created by Callsoft on 05/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import DropDown


protocol FilterDataDelegate {
    
    func dataForFilter(id:String,category:String,purpuse:String,availabilty:String,bedroom:String,bathroom:String,kitchen:String,buildMin:String,buildMax:String,budgetMin:String,budgetMax:String,year:String,hasPhoto:Bool,hasvideo:Bool,switchBalcony:Bool,switchGarden:Bool,switchParking:Bool,switchKitchen:Bool,selectedType:String,switchLift:Bool,switchDuplex:Bool,switchStore:Bool,switchAirConditioning:Bool,switchFurnitured:Bool)
}


protocol FilterBussinessAndProfessionalDelegate{
    
    func professionalBusinessData(name:String,id:String,professionalCategory:String,professionalSubcategory:String,location:String,lat:String,long:String,specalities:String,areaCovered:String,spokenLanguage:String,selectedType:String)
}



class SearchController: UIViewController{

    @IBOutlet weak var professionalView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet var bottomView: [UIView]!
    @IBOutlet weak var lowerStack: UIStackView!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var resetView: UIStackView!
    @IBOutlet weak var lblBuildSize: UILabel!
    @IBOutlet weak var lblFurnished: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblTextBuildSize: UILabel!
    @IBOutlet weak var lblTextFurnished: UILabel!
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var moreView: UIView!
    
    @IBOutlet var saleRentView: UIView!
    
    @IBOutlet weak var txtIdNo: UITextField!
    
    @IBOutlet weak var txtSelectCategory: UITextField!
    
    @IBOutlet weak var btnSelectCategory: UIButton!
    
    @IBOutlet weak var btnCommercial: UIButton!
    
    @IBOutlet weak var btnResidential: UIButton!
    
    @IBOutlet weak var btnBoth: UIButton!
    
    @IBOutlet weak var btnFamily: UIButton!
    
    @IBOutlet weak var btnSingle: UIButton!
    
    @IBOutlet weak var btnAvailabilityBoth: UIButton!
    
    @IBOutlet weak var txtNoOfBedroom: UITextField!
    
    @IBOutlet weak var btnNoOfBedRoom: UIButton!
    
    @IBOutlet weak var txtNoOfBathroom: UITextField!
    
    @IBOutlet weak var btnBathroom: UIButton!
    
    @IBOutlet weak var txtKitchen: UITextField!
    
    @IBOutlet weak var btnKitchen: UIButton!
    
    @IBOutlet weak var txtBuildSizeMin: UITextField!
    
    @IBOutlet weak var btnBuildSizeMax: UIButton!
    
    @IBOutlet weak var btnBuildSizeMin: UIButton!
    
    @IBOutlet weak var txtBuildSizeMax: UITextField!
    
    @IBOutlet weak var txtBudgetMin: UITextField!
    
    @IBOutlet weak var btnBudgetMin: UIButton!
    
    @IBOutlet weak var txtBuildingNo: UITextField!
    
    @IBOutlet weak var btnBudgetMax: UIButton!
    
    
    @IBOutlet weak var btnPropertyId: UIButton!
    
    @IBOutlet var viewHeader: UIView!
    
    //outlet for professional
    
    
    @IBOutlet weak var txtProfessionalName: UITextField!
    
    @IBOutlet weak var btnProfessionalID: UIButton!
    
    @IBOutlet weak var txtProfessionalId: UITextField!
    
    @IBOutlet weak var btnProfessionalCategory: UIButton!
    
    @IBOutlet weak var txtProfessionalCategory: UITextField!
    
    @IBOutlet weak var btnProfessionalSubcategory: UIButton!
    
    @IBOutlet weak var txtProfessionalSubcategory: UITextField!
    
    @IBOutlet weak var btnProfessionalLocation: UIButton!
    
    
    @IBOutlet weak var txtProfessionalLocation: UITextField!
    
    @IBOutlet weak var txtProfessionalSpecialities: UITextField!
    
    @IBOutlet weak var txtAreaCovered: UITextField!
    
    @IBOutlet weak var btnSpokenLanguage: UIButton!
    
    @IBOutlet weak var txtSpokenLanguage: UITextField!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    
    @IBOutlet weak var viewBuildSizeMax: UIView!
    
    
    
    var langArr = ["English","Arabic"]
    
    var categoryIdArr = NSMutableArray()
    var categoryNameArr = NSMutableArray()
    
    var selectedCategoryId = ""
    
    var subcategoryNameArr = NSMutableArray()
    var subcategoryIdArr = NSMutableArray()
    var selectedSubcategoryId = ""
    
    var latCordinate = ""
    var longCordinate = ""
    
    var professionalDelegate:FilterBussinessAndProfessionalDelegate?
    
    ///////////////
    
    var propertyCategoryArr = NSMutableArray()
    
    var availableFor = ""
    var purpose = ""
    
    var dropdownTag = 0
    let dropDown = DropDown()
    
    var badRoomBathAndKitchenArr = ["1","2","3","4","5","6","7","8","9","10"]
    
    var buildSizeMin = ["daily","weekly","monthly","yearly"]
    
    var buildSizeMax = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"]
    
    var minBudgetArr = ["100","200","300","400","500"]
    var maxBudgetArr = ["600","800","1000","1200","1400","1600"]
    
    var yearArr = NSMutableArray()
    
    let connection = webservices()
    
    let windoww = Bundle.main.loadNibNamed("SearchMoreView", owner: self, options: nil)?[0] as! SearchMoreView
    
    var delegate:FilterDataDelegate?
    
    var hasPhotoSelected = false
    var hasVideoSelected = false
    
    var selectedType = ""
    
    var combinedIDArr = NSMutableArray()
    
    var bedroomBathroomKitchenCombineDataArr = NSMutableArray()
    
    
    let customInfoWindow = Bundle.main.loadNibNamed("SearchProfessionalView", owner: self, options: nil)?[0] as! SearchProfessionalView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableview.register(UINib(nibName: "CellForProfile", bundle: nil), forCellReuseIdentifier: "CellForProfile")
        
        tableview.tableHeaderView = viewHeader
        tableview.tableFooterView = UIView()
        
        tableview.isHidden = true
        
      //  availableFor = "family"
     //   purpose = "commercial"
        
        btnFamily.setImage(UIImage(named: "unselected"), for: .normal)
        btnCommercial.setImage(UIImage(named: "unselected"), for: .normal)
        
        selectedType = "sale"
        
        for i in stride(from: 2019, to: 0, by: -1) {
            
            let yearStr = "\(i)"
            var actualYearAppendStr = ""
            
            if yearStr.length == 1{
                
                actualYearAppendStr = "000"+yearStr
            }
            else if yearStr.length == 2{
                
                actualYearAppendStr = "00"+yearStr
            }
            else if yearStr.length == 3{
                
                actualYearAppendStr = "0"+yearStr
            }
            else{
                
                actualYearAppendStr = yearStr
            }
            
            self.yearArr.add(actualYearAppendStr)
        }
        
        
        for i in 0...100{
            
            if i <= 9{
                
                bedroomBathroomKitchenCombineDataArr.add("0\(i)")
            }
            else{
                
                bedroomBathroomKitchenCombineDataArr.add("\(i)")
            }
          
        }
        
        bedroomBathroomKitchenCombineDataArr.add("100+")
        
       // let windoww = Bundle.main.loadNibNamed("SearchMoreView", owner: self, options: nil)?[0] as! SearchMoreView
       
        windoww.btnSelectYear.addTarget(self, action: #selector(self.tapYearBtn(sender:)), for: UIControl.Event.touchUpInside)
        
        windoww.btnHasPhotos.addTarget(self, action: #selector(self.tapHasPhotosBtn(sender:)), for: UIControl.Event.touchUpInside)
        
        windoww.btnHasVideos.addTarget(self, action: #selector(self.tapHasVideosBtn(sender:)), for: UIControl.Event.touchUpInside)
        
        viewHeight.constant = 990.0
        moreView.addSubview(windoww)
        
        moreView.isHidden = true
        
        CommonMethod.paddingTextfield(txtField: txtSearch)
        
        txtSearch.leftView = UIImageView(image: UIImage(named: "search_button"))
        txtSearch.leftViewMode = .always
        
        professionalView.addSubview(customInfoWindow)
        
        professionalView.isHidden = true

        NotificationCenter.default.addObserver(self, selector: #selector(redirectToHome(notification:)), name: NSNotification.Name(rawValue: "redirectToHome"), object: nil)
        
        self.apiCallForGetCategoryList()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if self.dropdownTag == 0{
                
               self.txtSelectCategory.text = "\(item)"
            }
            else if self.dropdownTag == 1{
                
                self.txtNoOfBedroom.text = "\(item)"
            }
            else if self.dropdownTag == 2{
                
               self.txtNoOfBathroom.text = "\(item)"
            }
            else if self.dropdownTag == 3{
                
               self.txtKitchen.text = "\(item)"
            }
            else if self.dropdownTag == 4{
                
               self.txtBuildSizeMin.text = "\(item)"
            }
            else if self.dropdownTag == 5{
                
                self.txtBuildSizeMax.text = "\(item)"
            }
            else if self.dropdownTag == 6{
                
                self.txtBudgetMin.text = "\(item)"
            }
            else if self.dropdownTag == 7{
                
                self.txtBuildingNo.text = "\(item)"
            }
            else if self.dropdownTag == 8{
                
                self.windoww.txtYearBuild.text = "\(item)"
            }
            else if self.dropdownTag == 9{
                
                self.txtIdNo.text = "\(item)"
            }
            else if self.dropdownTag == 10{
                
                self.txtProfessionalCategory.text = "\(item)"
                
                self.selectedCategoryId = self.categoryIdArr.object(at: index) as? String ?? ""
                
                self.subcategoryNameArr.removeAllObjects()
                self.subcategoryIdArr.removeAllObjects()
                self.selectedSubcategoryId = ""
                self.txtProfessionalSubcategory.text = ""
                
               // self.apiCallForGetSubcategoryList(categoryId: self.selectedCategoryId)
                
            }
            else if self.dropdownTag == 11{
                
                self.txtProfessionalSubcategory.text = "\(item)"
                
                self.selectedSubcategoryId = self.subcategoryIdArr.object(at: index) as? String ?? ""
            }
            else if self.dropdownTag == 12{
                
                self.txtSpokenLanguage.text = "\(item)"
                
            }
        }
    }
    
    
    @IBAction func tap_propertyIDBtn(_ sender: Any) {
        
        self.apiCallForGetAllIds()
    }
    
    
    @objc func tapYearBtn(sender:UIButton){
    
        dropdownTag = 8
        dropDown.dataSource = yearArr as! [String]
        dropDown.anchorView = self.windoww.btnSelectYear
        dropDown.show()
    }
    
    @objc func tapHasPhotosBtn(sender:UIButton){
        
        if hasPhotoSelected == false{
            
            hasPhotoSelected = true
            windoww.btnHasPhotos.setImage(UIImage(named: "done_tick"), for: .normal)
        }
        else{
            
            hasPhotoSelected = false
            windoww.btnHasPhotos.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
        }
    }
    
    
    @objc func tapHasVideosBtn(sender:UIButton){
        
        if hasVideoSelected == false{
            
            hasVideoSelected = true
            windoww.btnHasVideos.setImage(UIImage(named: "done_tick"), for: .normal)
        }
        else{
            
            hasVideoSelected = false
            windoww.btnHasVideos.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
        }
    }
    

    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_budgetMin(_ sender: Any) {
        
        dropdownTag = 6
        dropDown.dataSource = minBudgetArr
        dropDown.anchorView = btnBudgetMin
        dropDown.show()
    }
    
    
    @IBAction func tap_budgetMax(_ sender: Any) {
        
        dropdownTag = 7
        dropDown.dataSource = maxBudgetArr
        dropDown.anchorView = btnBudgetMax
        dropDown.show()
    }
    
    
    @IBAction func tap_furnishedMax(_ sender: Any) {
        
        dropdownTag = 5
        dropDown.dataSource = buildSizeMax
        dropDown.anchorView = btnBuildSizeMax
        dropDown.show()
    }
    
    @IBAction func tap_buildSizeMin(_ sender: Any) {
        
        dropdownTag = 4
        dropDown.dataSource = buildSizeMin
        dropDown.anchorView = btnBuildSizeMin
        dropDown.show()
        
    }
    
    @IBAction func tap_btnKitchen(_ sender: Any) {
        
        dropdownTag = 3
        dropDown.dataSource = bedroomBathroomKitchenCombineDataArr as! [String]
        dropDown.anchorView = btnKitchen
        dropDown.show()
    }
    
    @IBAction func tap_bedroomBtn(_ sender: Any) {
        
        dropdownTag = 1
        dropDown.dataSource = bedroomBathroomKitchenCombineDataArr as! [String]
        dropDown.anchorView = btnNoOfBedRoom
        dropDown.show()
    }
    
    @IBAction func tap_bathroomBtn(_ sender: Any) {
        
        dropdownTag = 2
        dropDown.dataSource = bedroomBathroomKitchenCombineDataArr as! [String]
        dropDown.anchorView = btnBathroom
        dropDown.show()
    }
    
    @IBAction func tap_familyBtn(_ sender: Any) {
        
        btnFamily.setImage(UIImage(named: "selected"), for: .normal)
        btnSingle.setImage(UIImage(named: "unselected"), for: .normal)
        btnAvailabilityBoth.setImage(UIImage(named: "unselected"), for: .normal)
        
        availableFor = "family"
    }
    
    @IBAction func tap_singleBtn(_ sender: Any) {
        
        btnFamily.setImage(UIImage(named: "unselected"), for: .normal)
        btnSingle.setImage(UIImage(named: "selected"), for: .normal)
        btnAvailabilityBoth.setImage(UIImage(named: "unselected"), for: .normal)
        
        availableFor = "single"
    }
    
    @IBAction func tap_availabilityBoth(_ sender: Any) {
        
        btnFamily.setImage(UIImage(named: "unselected"), for: .normal)
        btnSingle.setImage(UIImage(named: "unselected"), for: .normal)
        btnAvailabilityBoth.setImage(UIImage(named: "selected"), for: .normal)
        
        availableFor = "both"
    }
    
    @IBAction func tap_btnCommercial(_ sender: Any) {
        
        btnCommercial.setImage(UIImage(named: "selected"), for: .normal)
        btnResidential.setImage(UIImage(named: "unselected"), for: .normal)
        btnBoth.setImage(UIImage(named: "unselected"), for: .normal)
        
        purpose = "commercial"
    }
    
    @IBAction func tap_residential(_ sender: Any) {
        
        btnResidential.setImage(UIImage(named: "selected"), for: .normal)
        btnCommercial.setImage(UIImage(named: "unselected"), for: .normal)
        btnBoth.setImage(UIImage(named: "unselected"), for: .normal)
        
        purpose = "residential"
    }
    
    @IBAction func tap_both(_ sender: Any) {
        
        btnBoth.setImage(UIImage(named: "selected"), for: .normal)
        btnResidential.setImage(UIImage(named: "unselected"), for: .normal)
        btnCommercial.setImage(UIImage(named: "unselected"), for: .normal)
        
        purpose = "both"
        
    }
    
    @IBAction func tap_selectCategory(_ sender: Any) {
        
        dropdownTag = 0
        dropDown.dataSource = propertyCategoryArr as! [String]
        dropDown.anchorView = btnSelectCategory
        dropDown.show()
    }
    
 
    @IBAction func btnMoreAction(_ sender: Any) {
        
        btnMore.isHidden = true
        viewHeight.constant = 1933.0
        moreView.isHidden = false
        
    }
    
    @IBAction func btnSearchAction(_ sender: Any) {
        
        if selectedType == "sale" || selectedType == "rent"{
            
            var gardenSwitch = Bool()
            var parkingSwitch = Bool()
            var balconySwitch = Bool()
            var modulerKitchenSwitch = Bool()
            
            var liftSwitch = Bool()
            var duplexSwitch = Bool()
            var airConditioningSwitch = Bool()
            var furnishedSwitch = Bool()
            var storeSwitch = Bool()
            
            if windoww.switch_Garden.isOn == true{
                
                gardenSwitch = true
            }
            else{
                
                gardenSwitch = false
            }
            
            if windoww.switch_Balcony.isOn == true{
                
                balconySwitch = true
            }
            else{
                
                balconySwitch = false
            }
            
            if windoww.switch_Parking.isOn == true{
                
                parkingSwitch = true
            }
            else{
                
                parkingSwitch = false
            }
            
            if windoww.switch_ModularKitchen.isOn == true{
                
                modulerKitchenSwitch = true
            }
            else{
                
                modulerKitchenSwitch = false
            }
            
            if windoww.switch_Lift.isOn == true{
                
                liftSwitch = true
            }
            else{
                
                liftSwitch = false
            }
            
            if windoww.switch_Duplex.isOn == true{
                
                duplexSwitch = true
            }
            else{
                
                duplexSwitch = false
            }
            
            if windoww.switch_airConditioning.isOn == true{
                
                airConditioningSwitch = true
            }
            else{
                
                airConditioningSwitch = false
            }
            
            if windoww.switch_furnished.isOn == true{
                
                furnishedSwitch = true
            }
            else{
                
                furnishedSwitch = false
            }
            
            if windoww.switch_Store.isOn == true{
                
                storeSwitch = true
            }
            else{
                
                storeSwitch = false
            }
            
            self.delegate?.dataForFilter(id: txtIdNo.text!, category: self.txtSelectCategory.text!, purpuse: purpose, availabilty: availableFor, bedroom: txtNoOfBedroom.text!, bathroom: txtNoOfBathroom.text!, kitchen: txtKitchen.text!, buildMin: txtBuildSizeMin.text!, buildMax: txtBuildSizeMax.text!, budgetMin: txtBudgetMin.text!, budgetMax: txtBuildingNo.text!, year: self.windoww.txtYearBuild.text!, hasPhoto: hasPhotoSelected, hasvideo: hasVideoSelected, switchBalcony: balconySwitch, switchGarden: gardenSwitch, switchParking: parkingSwitch, switchKitchen: modulerKitchenSwitch, selectedType: selectedType, switchLift: liftSwitch, switchDuplex: duplexSwitch, switchStore: storeSwitch, switchAirConditioning: airConditioningSwitch, switchFurnitured: furnishedSwitch)
            
            self.navigationController?.popViewController(animated: true)
        }
        else{
            
          //  self.professionalDelegate?.professionalBusinessData(name: txtProfessionalName.text!, id: txtProfessionalId.text!, professionalCategory: self.txtProfessionalCategory.text!, professionalSubcategory: self.txtProfessionalSubcategory.text!, location: self.txtProfessionalLocation.text!, lat: self.latCordinate, long: self.longCordinate, specalities: self.txtProfessionalSpecialities.text!, areaCovered: self.txtAreaCovered.text!, spokenLanguage: self.txtSpokenLanguage.text!, selectedType: selectedType)
            
            self.navigationController?.popViewController(animated: true)
        }
      
    }
    
    @IBAction func btnResetACtion(_ sender: Any) {
        
        clearAllData()
        
        viewHeight.constant = 990.0
        btnMore.isHidden = false
        moreView.isHidden = true
    }
    
    @objc func redirectToHome(notification:Notification){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_professionalReset(_ sender: Any) {
        
        clearAllDataForProfessionalAndBusiness()
    }
    
    @IBAction func tap_professionalSearch(_ sender: Any) {
        
        self.professionalDelegate?.professionalBusinessData(name: txtProfessionalName.text!, id: txtProfessionalId.text!, professionalCategory: self.txtProfessionalCategory.text!, professionalSubcategory: self.txtProfessionalSubcategory.text!, location: self.txtProfessionalLocation.text!, lat: self.latCordinate, long: self.longCordinate, specalities: self.txtProfessionalSpecialities.text!, areaCovered: self.txtAreaCovered.text!, spokenLanguage: self.txtSpokenLanguage.text!, selectedType: selectedType)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_spokenLanguageBtn(_ sender: Any) {
        
        dropdownTag = 12
        dropDown.dataSource = langArr
        dropDown.anchorView = btnSpokenLanguage
        dropDown.show()
    }
    
    @IBAction func tap_locationBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationController") as! AddLocationController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tap_ProfessionalSubcategory(_ sender: Any) {
        
        if self.txtProfessionalCategory.text == ""{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select professional category first", controller: self)
        }
        else{
            
            self.dropdownTag = 11
            
            if self.subcategoryNameArr.count != 0{
                
                self.dropDown.dataSource = self.subcategoryNameArr as! [String]
                self.dropDown.anchorView = self.btnProfessionalSubcategory
                self.dropDown.show()
            }
            else{
                
                self.apiCallForGetSubcategoryList(categoryId: self.selectedCategoryId)
            }
           
        }
    }
    
    
    @IBAction func tap_profBussinessCategory(_ sender: Any) {
        
        self.apiCallForFetchCategory()
    }
    
    
    @IBAction func tap_professionalBusinessId(_ sender: Any) {
        
        
    }
    

    
    @IBAction func btnUpperOption(_ sender: UIButton) {
        
        viewHeight.constant = 990.0
        btnMore.isHidden = false
        moreView.isHidden = true
        
        for i in 0 ..< bottomView.count{
            if i == sender.tag {
                bottomView[i].isHidden = false
            }else{
                bottomView[i].isHidden = true
            }
        }
        
        if sender.tag == 0 || sender.tag == 1{
            
            
            
          //  professionalView.isHidden = true
            
            ////tarun
            
            tableview.isHidden = true
            ///
            
            viewHeight.constant = 990.0
            if viewHeight.constant == 1933.0{
                btnMore.isHidden = true
            }else{
                btnMore.isHidden = false
            }
            lowerStack.isHidden = false
            resetView.isHidden = false
            saleRentView.isHidden = false
        }
        
        if sender.tag == 2 || sender.tag == 3{
            
           tableview.isScrollEnabled = false
            
            
          //  professionalView.isHidden = false
            
            ////tarun
            
            tableview.isHidden = false
            ///
            
            lowerStack.isHidden = true
            resetView.isHidden = true
            btnMore.isHidden = true
            moreView.isHidden = true
            saleRentView.isHidden = true
            
        }
        if sender.tag == 0{
            
            lblBuildSize.text = "Plot Size"
            lblTextBuildSize.text = "Min"
            lblTextFurnished.text = "Max"
            lblFurnished.isHidden = true
            
            selectedType = "sale"
            
            viewBuildSizeMax.isHidden = false
            txtBuildSizeMin.placeholder = "Min"
            txtBuildSizeMin.text = ""
            txtBuildSizeMin.isUserInteractionEnabled = true
            btnBuildSizeMin.isUserInteractionEnabled = false
        }
        if sender.tag == 1{
            
            lblBuildSize.text = "Rent Time"
            lblTextBuildSize.text = "Show All"
            lblTextFurnished.text = "Show All"
            lblFurnished.isHidden = false
            
            selectedType = "rent"
            
            viewBuildSizeMax.isHidden = true
            txtBuildSizeMin.placeholder = "Rent Time"
            txtBuildSizeMin.text = ""
            txtBuildSizeMin.isUserInteractionEnabled = false
            btnBuildSizeMin.isUserInteractionEnabled = true
        }
        if sender.tag == 2{
          //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideLocation"), object: nil, userInfo: nil)
            
            selectedType = "professional"
        }
        if sender.tag == 3{
            
          //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowLocation"), object: nil, userInfo: nil)
            
            selectedType = "business"
        }
    }
    
    
    func clearAllData(){
        
        txtIdNo.text = ""
        txtSelectCategory.text = ""
        availableFor = ""
        purpose = ""
        
        btnCommercial.setImage(UIImage(named: "unselected"), for: .normal)
        btnResidential.setImage(UIImage(named: "unselected"), for: .normal)
        btnBoth.setImage(UIImage(named: "unselected"), for: .normal)
        
        btnFamily.setImage(UIImage(named: "unselected"), for: .normal)
        btnSingle.setImage(UIImage(named: "unselected"), for: .normal)
        btnAvailabilityBoth.setImage(UIImage(named: "unselected"), for: .normal)
        
        txtNoOfBedroom.text = ""
        txtNoOfBathroom.text = ""
        txtKitchen.text = ""
        txtBuildSizeMin.text = ""
        txtBuildSizeMax.text = ""
        txtBudgetMin.text = ""
        txtBuildingNo.text = ""
        windoww.txtYearBuild.text = ""
        
        hasPhotoSelected = false
        hasVideoSelected = false
        
        windoww.btnHasVideos.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
        
        windoww.btnHasPhotos.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
        
        windoww.switch_Balcony.isOn = true
        windoww.switch_Garden.isOn = true
        windoww.switch_Parking.isOn = true
        windoww.switch_ModularKitchen.isOn = true
        windoww.switch_Store.isOn = true
        windoww.switch_Lift.isOn = true
        windoww.switch_Duplex.isOn = true
        
    }
    
}



extension SearchController{
    
 
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
    
    
    func apiCallForGetAllIds(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithStringGetType(getUrlString: App.URLs.apiCallForGetAllIds as NSString) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "response_code") as? Int ?? 0
                    if status == 200{
                        
                        if let arr = receivedData.object(forKey: "Data") as? NSArray{
                            
                            if arr.count == 0{
                                
                                CommonClass.sharedInstance.callNativeAlert(title: "", message: "No ID found", controller: self)
                                
                            }
                            else{
                                
                                self.combinedIDArr.removeAllObjects()
                                
                                for i in 0..<arr.count{
                                    
                                    let dict = arr.object(at: i) as? NSDictionary ?? [:]
                                    
                                    let id = dict.object(forKey: "_id") as? String ?? ""
                                    
                                    self.combinedIDArr.add(id)
                                    
                                }
                                
                                self.openDropDownForID()
                            }
                        }
                    }
                    else{
                        
                         CommonClass.sharedInstance.callNativeAlert(title: "", message: "No ID found", controller: self)
                    }
                }
                else{
                    
                       CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong. Please try again", controller: self)
                }
            }
        }
        else{
            
             CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    func openDropDownForID(){
        
        self.dropdownTag = 9
        self.dropDown.dataSource = combinedIDArr as! [String]
        self.dropDown.anchorView = btnPropertyId
        self.dropDown.show()
        
    }
    
}



extension SearchController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "CellForProfile", for: indexPath) as! CellForProfile
        
        return cell
    }
    
}



//MARK:- API's for professional and business
//MARK:-
extension SearchController{
    
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
                            
                            self.categoryIdArr.removeAllObjects()
                            self.categoryNameArr.removeAllObjects()
                            
                            for i in 0..<dataArr.count{
                                
                                let dict = dataArr.object(at: i) as? NSDictionary ?? [:]
                                let id = dict.object(forKey: "_id") as? String ?? ""
                                let name = dict.object(forKey: "name") as? String ?? ""
                                
                                self.categoryIdArr.add(id)
                                self.categoryNameArr.add(name)
                            }
                            
                            self.showDropdownForProfessionalCategory()
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
    
    
    func showDropdownForProfessionalCategory(){
        
        dropdownTag = 10
        dropDown.dataSource = categoryNameArr as! [String]
        dropDown.anchorView = btnProfessionalCategory
        dropDown.show()
        
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
                        
                        self.subcategoryNameArr.removeAllObjects()
                        self.subcategoryIdArr.removeAllObjects()
                        
                        if dataArr.count != 0{
                            
                            for i in 0..<dataArr.count{
                                
                                let dict = dataArr.object(at: i) as? NSDictionary ?? [:]
                                
                                let name = dict.object(forKey: "name") as? String ?? ""
                                let id = dict.object(forKey: "_id") as? String ?? ""
                                
                                self.subcategoryNameArr.add(name)
                                self.subcategoryIdArr.add(id)
                                
                                
                            }
                            
                            self.dropDown.dataSource = self.subcategoryNameArr as! [String]
                            self.dropDown.anchorView = self.btnProfessionalSubcategory
                            self.dropDown.show()
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
    
    
    func showDropdownForProfessionalSubcategory(){
        
        dropdownTag = 11
        dropDown.dataSource = subcategoryNameArr as! [String]
        dropDown.anchorView = btnProfessionalSubcategory
        dropDown.show()
        
    }
    
    
    func clearAllDataForProfessionalAndBusiness(){
        
        self.txtProfessionalName.text = ""
        self.txtProfessionalId.text = ""
        self.txtProfessionalCategory.text = ""
        self.txtProfessionalSubcategory.text = ""
        self.latCordinate = ""
        self.longCordinate = ""
        self.txtProfessionalLocation.text = ""
        self.txtProfessionalSpecialities.text = ""
        self.txtAreaCovered.text = ""
        self.txtSpokenLanguage.text = ""
       
    }
    
}


extension SearchController:SavedAddressDelegate{
    
    func savedAddress(country: String, state: String, city: String, locality: String, zipCode: String, address: String, lat: String, long: String) {
        
        self.latCordinate = lat
        self.longCordinate = long
        
        self.txtProfessionalLocation.text = "\(address)"
    }
    
}
