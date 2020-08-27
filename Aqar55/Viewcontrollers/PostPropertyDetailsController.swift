//
//  PostPropertyDetailsController.swift
//  Aqar55
//
//  Created by Callsoft on 06/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import DropDown


class PostPropertyDetailsController: UIViewController {

    @IBOutlet var switchExtra: UISwitch!
    @IBOutlet var switchBalcony: UISwitch!
    @IBOutlet var switchGarden: UISwitch!
    @IBOutlet var swicthParking: UISwitch!
    @IBOutlet var swicthKitchen: UISwitch!
    
    
    @IBOutlet weak var txtBuiltSize: UITextField!
    
    @IBOutlet weak var lblBuiltUnit: UILabel!
    
    @IBOutlet weak var btnBuiltUnit: UIButton!
    
    @IBOutlet weak var txtPlotSize: UITextField!
    
    @IBOutlet weak var btnPlotSizeUnit: UIButton!
    
    @IBOutlet weak var lblPlotSizeUnit: UILabel!
    
    @IBOutlet weak var btnSelectYear: UIButton!
    
    @IBOutlet weak var lblSelectYear: UILabel!
    
    @IBOutlet weak var btnStreetView: UIButton!
    
    @IBOutlet weak var lblStreetView: UILabel!
    
    @IBOutlet weak var btnStreetWidthUnit: UIButton!
    
    @IBOutlet weak var lblStreetWidthUnit: UILabel!
    
    @IBOutlet weak var txtStreetWidth: UITextField!
    
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var btnNoOfBuilding: UIButton!
    
    @IBOutlet weak var lblNoOfBuilding: UILabel!
    
    @IBOutlet weak var btnNoOfShowroom: UIButton!
    
    @IBOutlet weak var lblNoOfShowroom: UILabel!
    
    @IBOutlet weak var btnRevenue: UIButton!
    
    @IBOutlet weak var lblRevenue: UILabel!
    
    
    @IBOutlet weak var txtRevenue: UITextField!
    
    
    @IBOutlet weak var txtMeasurementLength: UITextField!
    
    @IBOutlet weak var txtMeasurementWidth: UITextField!
    
    
    @IBOutlet weak var btnMeasurementLength: UIButton!
    
    @IBOutlet weak var btnMeasurementWidth: UIButton!
    
    @IBOutlet weak var lblMeasurementWidth: UILabel!
    
    @IBOutlet weak var lblMeasurementLength: UILabel!
    
    @IBOutlet weak var switchStore: UISwitch!
    
    @IBOutlet weak var switchLift: UISwitch!
    
    @IBOutlet weak var switchDuplex: UISwitch!
    
    @IBOutlet weak var switchFurnishing: UISwitch!
    
    @IBOutlet weak var switchAirConditioning: UISwitch!
    
    var dropdownTag = 0
    let dropDown = DropDown()
    
    var sizeUnitArr = ["M2","CM2","Inch","Feet","Yard"]
    
    var widthUnitArr = ["Meter","Feet","Yard"]
    
    var yearArr = NSMutableArray()
    
    var noOfBuildingArr = ["1","2","3","4","5","6","7","8","9","10"]
    
    var streetViewArr = ["North","South","East","West","North-East","North-West","South-East","South-West","3 Streets","4 Streets","Not Defined"]
    
    
    var measureLengthWidthArr = ["Meter","CM","Inch","Feet","Yard"]
    
    
    var yearSelected = false
    var streetViewSelected = true
    var numberOfBuildingSelected = false
    var numberOfShowroomSelected = false
    var revenueSelected = false
    
    
    //edit
    var editItemDict = NSDictionary()
    var controllerPurpuse = ""
    
    var buildingShowroomCombineArr = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switchExtra.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchBalcony.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchGarden.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        swicthParking.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        swicthKitchen.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchStore.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchLift.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchDuplex.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchFurnishing.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchAirConditioning.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        
        btnNoOfBuilding.isUserInteractionEnabled = false
        btnNoOfShowroom.isUserInteractionEnabled = false
        switchExtra.addTarget(self, action: #selector(self.switchingExtraBtn(sender:)), for: .valueChanged)
        
        self.yearSelected = true
        
        txtDescription.text = "Write here..."
        txtDescription.delegate = self
        
        for i in 0...100{
            
            buildingShowroomCombineArr.add("\(i)")
        }
        
        buildingShowroomCombineArr.add("100+")
        
        btnRevenue.isUserInteractionEnabled = false

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
        
        self.lblStreetView.text = "Not Defined"
        
        if self.controllerPurpuse == "Edit"{
            
            self.setDataForEdit()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            

            if self.dropdownTag == 0{
                
                self.lblBuiltUnit.text = "\(item)"
            }
            else if self.dropdownTag == 1{
                
                self.lblPlotSizeUnit.text = "\(item)"
            }
            else if self.dropdownTag == 2{
                
                self.yearSelected = true
                self.lblSelectYear.text = "\(item)"
            }
            else if self.dropdownTag == 3{
                
                self.streetViewSelected = true
                self.lblStreetView.text = "\(item)"
            }
            else if self.dropdownTag == 4{
                
                self.lblStreetWidthUnit.text = "\(item)"
            }
            else if self.dropdownTag == 5{
                
                self.numberOfBuildingSelected = true
                self.lblNoOfBuilding.text = "\(item)"
            }
            else if self.dropdownTag == 6{
                
                self.numberOfShowroomSelected = true
                self.lblNoOfShowroom.text = "\(item)"
            }
            else if self.dropdownTag == 7{
                
                self.revenueSelected = true
                self.lblRevenue.text = "\(item)"
            }
            else if self.dropdownTag == 8{
                
                self.lblMeasurementLength.text = "\(item)"
            }
            else if self.dropdownTag == 9{
                
                self.lblMeasurementWidth.text = "\(item)"
            }
            
        }
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddSpecificationsController") as! AddSpecificationsController
//        self.navigationController?.pushViewController(vc, animated: true)
        
        checkValidation()
    }
    
    
    @objc func switchingExtraBtn(sender:UISwitch){
        
        if switchExtra.isOn == true{
            
            btnNoOfShowroom.isUserInteractionEnabled = true
            btnNoOfBuilding.isUserInteractionEnabled = true
        }
        else{
            
            btnNoOfShowroom.isUserInteractionEnabled = false
            btnNoOfBuilding.isUserInteractionEnabled = false
            
            lblNoOfBuilding.text = "Apartment or Room"
            lblNoOfShowroom.text = "Select no of Showroom"
        }
    }
    
    
    @IBAction func tap_measurementLengthBtn(_ sender: Any) {
        
        dropdownTag = 8
        dropDown.anchorView = btnMeasurementLength
        dropDown.dataSource = measureLengthWidthArr
        dropDown.show()
    }
    
    @IBAction func tap_measurementWidthBtn(_ sender: Any) {
        
        dropdownTag = 9
        dropDown.anchorView = btnMeasurementWidth
        dropDown.dataSource = measureLengthWidthArr
        dropDown.show()
    }
    
    
    @IBAction func tap_btnBuiltUnit(_ sender: Any) {
        
        dropdownTag = 0
        dropDown.anchorView = btnBuiltUnit
        dropDown.dataSource = sizeUnitArr
        dropDown.show()
    }
    
    @IBAction func tap_plotSizeUnitBtn(_ sender: Any) {
        
        dropdownTag = 1
        dropDown.anchorView = btnPlotSizeUnit
        dropDown.dataSource = sizeUnitArr
        dropDown.show()
    }
    
    @IBAction func tap_SelectYearBtn(_ sender: Any) {
        
        dropdownTag = 2
        dropDown.anchorView = btnSelectYear
        dropDown.dataSource = yearArr as! [String]
        dropDown.show()
    }
    
    @IBAction func tap_streetViewBtn(_ sender: Any) {
        
        dropdownTag = 3
        dropDown.anchorView = btnStreetView
        dropDown.dataSource = streetViewArr
        dropDown.show()
    }
    
    @IBAction func tap_streetWidthUnitBtn(_ sender: Any) {
        
        dropdownTag = 4
        dropDown.anchorView = btnStreetWidthUnit
        dropDown.dataSource = widthUnitArr
        dropDown.show()
    }
    
    @IBAction func tap_revenueBtn(_ sender: Any) {
        
        dropdownTag = 7
        dropDown.anchorView = btnRevenue
        dropDown.dataSource = noOfBuildingArr
        dropDown.show()
    }
    
    @IBAction func tap_noOfShowroom(_ sender: Any) {
        
        dropdownTag = 6
        dropDown.anchorView = btnNoOfShowroom
        dropDown.dataSource = buildingShowroomCombineArr as! [String]
        dropDown.show()
    }
    
    @IBAction func tap_noOfBuilding(_ sender: Any) {
        
        dropdownTag = 5
        dropDown.anchorView = btnNoOfBuilding
        dropDown.dataSource = buildingShowroomCombineArr as! [String]
        dropDown.show()
    }
    
}


extension PostPropertyDetailsController:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtDescription.text == "Write here..."{
            
            txtDescription.text = ""
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtDescription.text == ""{
            
            txtDescription.text = "Write here..."
        }
    }
}



extension PostPropertyDetailsController{
    
    func checkValidation(){
        
        var mess = ""
        
//        if txtBuiltSize.text == ""{
//
//            mess = "Please enter built size"
//        }
        if txtPlotSize.text == ""{
            
            mess = "Please enter plot size"
        }
//        else if txtMeasurementLength.text == ""{
//
//            mess = "Please enter measurement length"
//        }
//        else if txtMeasurementWidth.text == ""{
//
//            mess = "Please enter measurement width"
//        }
        else if yearSelected == false{
            
            mess = "Please select year"
        }
        else if streetViewSelected == false{
            
            mess = "Please select street view"
        }
//        else if txtStreetWidth.text == ""{
//
//            mess = "Please enter width"
//        }
        else if numberOfBuildingSelected == false && switchExtra.isOn == true{
            
            mess = "Please select number of building"
        }
        else if numberOfShowroomSelected == false  && switchExtra.isOn == true{
            
            mess = "Please select number of showroom"
        }
        else if txtDescription.text == "Write here..." || txtDescription.text == ""{
            
            mess = "Please give some detail description"
        }
//        else if revenueSelected == false{
//
//            mess = "Please select the revenue"
//        }
            
//        else if txtRevenue.text == ""{
//
//            mess = "Please enter the revenue"
//        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            let secondPageData = NSMutableDictionary()
            
            secondPageData.removeAllObjects()
            
            var buildingTxt = ""
            var showroomTxt = ""
            
            if switchExtra.isOn == true{
                
                buildingTxt = lblNoOfBuilding.text!
                showroomTxt = lblNoOfShowroom.text!
                
            }else{
                
                buildingTxt = ""
                showroomTxt = ""
            }
            
            secondPageData.setValue(txtBuiltSize.text!, forKey: "BuiltSize")
            secondPageData.setValue(lblBuiltUnit.text!, forKey: "BuiltUnit")
            secondPageData.setValue(txtPlotSize.text!, forKey: "PlotSize")
            secondPageData.setValue(lblPlotSizeUnit.text!, forKey: "PlotSizeUnit")
            secondPageData.setValue(lblSelectYear.text!, forKey: "BuiltYear")
            secondPageData.setValue(lblStreetView.text!, forKey: "StreetView")
            secondPageData.setValue(txtStreetWidth.text!, forKey: "StreetWidth")
            secondPageData.setValue(lblStreetWidthUnit.text!, forKey: "StreetWidthUnit")
            secondPageData.setValue(buildingTxt, forKey: "NoOfBuilding")
            secondPageData.setValue(showroomTxt, forKey: "NoOfShowroom")
            secondPageData.setValue(txtRevenue.text!, forKey: "Revenue")
            
            secondPageData.setValue(txtMeasurementWidth.text!, forKey: "MeasurementWidth")
            secondPageData.setValue(txtMeasurementLength.text!, forKey: "MeasurementLength")
            secondPageData.setValue(lblMeasurementWidth.text!, forKey: "MeasurementWidthUnit")
            secondPageData.setValue(lblMeasurementLength.text!, forKey: "MeasurementLengthUnit")
            
            if txtDescription.text == "" || txtDescription.text == "Write here..."{
                
                secondPageData.setValue("", forKey: "PropertyDescription")
            }
            else{
                
                secondPageData.setValue(txtDescription.text!, forKey: "PropertyDescription")
            }
            
            
            if switchExtra.isOn == true{
                
                secondPageData.setValue("true", forKey: "ExtraSwitch")
            }
            else{
                
                secondPageData.setValue("false", forKey: "ExtraSwitch")
            }
            
            
            if switchBalcony.isOn == true{
                
                secondPageData.setValue("true", forKey: "BalconySwitch")
            }
            else{
                
                secondPageData.setValue("false", forKey: "BalconySwitch")
            }
            
            
            if switchGarden.isOn == true{
                
                secondPageData.setValue("true", forKey: "GardenSwitch")
            }
            else{
                
                secondPageData.setValue("false", forKey: "GardenSwitch")
            }
            
            
            if swicthParking.isOn == true{
                
                secondPageData.setValue("true", forKey: "ParkingSwitch")
            }
            else{
                
                secondPageData.setValue("false", forKey: "ParkingSwitch")
            }
            
            
            if swicthKitchen.isOn == true{
                
                secondPageData.setValue("true", forKey: "KitchenSwitch")
            }
            else{
                
                secondPageData.setValue("false", forKey: "KitchenSwitch")
            }
            
            if switchLift.isOn == true{
                
                secondPageData.setValue("true", forKey: "LiftSwitch")
            }
            else{
                
                secondPageData.setValue("false", forKey: "LiftSwitch")
            }
            
            if switchStore.isOn == true{
                
                secondPageData.setValue("true", forKey: "StoreSwitch")
            }
            else{
                
                secondPageData.setValue("false", forKey: "StoreSwitch")
            }
            
            if switchDuplex.isOn == true{
                
                secondPageData.setValue("true", forKey: "DuplexSwitch")
            }
            else{
                
                secondPageData.setValue("false", forKey: "DuplexSwitch")
            }
            
            if switchFurnishing.isOn == true{
                
                secondPageData.setValue("true", forKey: "FurnishingSwitch")
            }
            else{
                
                secondPageData.setValue("false", forKey: "FurnishingSwitch")
            }
            
            if switchAirConditioning.isOn == true{
                
                secondPageData.setValue("true", forKey: "AirConditioningSwitch")
            }
            else{
                
                secondPageData.setValue("false", forKey: "AirConditioningSwitch")
            }
            
            
            UserDefaults.standard.set(secondPageData, forKey: "PropertySecondPageData")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddSpecificationsController") as! AddSpecificationsController
            
            vc.editItemDict = self.editItemDict
            vc.controllerPurpuse = self.controllerPurpuse
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
}



extension PostPropertyDetailsController{
    
    func setDataForEdit(){
        
        self.txtBuiltSize.text = "\(editItemDict.object(forKey: "builtSize") as? String ?? "")"
        
        self.lblBuiltUnit.text = editItemDict.object(forKey: "builtSizeUnit") as? String ?? "M2"
        
        self.txtPlotSize.text = "\(editItemDict.object(forKey: "plotSize") as? String ?? "")"
        
        self.lblPlotSizeUnit.text = editItemDict.object(forKey: "plotSizeUnit") as? String ?? "M2"
        
        self.lblSelectYear.text = editItemDict.object(forKey: "yearBuilt") as? String ?? ""
        
        self.lblStreetView.text = editItemDict.object(forKey: "streetView") as? String ?? ""
        
        self.txtStreetWidth.text = editItemDict.object(forKey: "streetWidth") as? String ?? ""
        
        self.lblStreetWidthUnit.text = editItemDict.object(forKey: "streetWidthUnit") as? String ?? ""
        
        self.txtDescription.text = editItemDict.object(forKey: "description") as? String ?? ""
        
        if txtDescription.text == ""{
            
            txtDescription.text = "Write here..."
        }
        
        self.lblNoOfBuilding.text = editItemDict.object(forKey: "extrabuildingNo") as? String ?? ""
        self.lblNoOfShowroom.text = editItemDict.object(forKey: "extrashowroomNo") as? String ?? ""
        
        if lblNoOfBuilding.text == ""{
            
            lblNoOfBuilding.text = "Apartment or Room"
            numberOfBuildingSelected = false
            
            switchExtra.isOn = false
        }
        else{
            
            switchExtra.isOn = true
        }
        
        if lblNoOfShowroom.text == ""{
            
            lblNoOfShowroom.text = "Select no of Showroom"
            numberOfShowroomSelected = false
            
            switchExtra.isOn = false
        }
        else{
            
            switchExtra.isOn = true
        }
        
        if switchExtra.isOn == false{
            
            btnNoOfShowroom.isUserInteractionEnabled = false
            btnNoOfBuilding.isUserInteractionEnabled = false
        }
        else{
            
            btnNoOfShowroom.isUserInteractionEnabled = true
            btnNoOfBuilding.isUserInteractionEnabled = true
        }
        
        self.txtRevenue.text = editItemDict.object(forKey: "revenue") as? String ?? ""
        
        self.yearSelected = true
        self.streetViewSelected = true
        self.revenueSelected = true
        self.numberOfBuildingSelected = true
        self.numberOfShowroomSelected = true
        
        let balcony = editItemDict.object(forKey: "balcony") as? Bool ?? true
        let garden = editItemDict.object(forKey: "garden") as? Bool ?? true
        let parking = editItemDict.object(forKey: "parking") as? Bool ?? true
        let modulerKitchen = editItemDict.object(forKey: "modularKitchen") as? Bool ?? true
        
        let lift = editItemDict.object(forKey: "lift") as? Bool ?? true
        let duplex = editItemDict.object(forKey: "duplex") as? Bool ?? true
        let furnishing = editItemDict.object(forKey: "furnished") as? Bool ?? true
        let airCondition = editItemDict.object(forKey: "aircondition") as? Bool ?? true
        let store = editItemDict.object(forKey: "store") as? Bool ?? true
        
        let measureLength = editItemDict.object(forKey: "length") as? String ?? ""
        let measureWidth = editItemDict.object(forKey: "width") as? String ?? ""
        let measureLengthUnit = editItemDict.object(forKey: "lengthUnit") as? String ?? ""
        let measureWidthUnit = editItemDict.object(forKey: "widthUnit") as? String ?? ""
        
        self.txtMeasurementLength.text = measureLength
        self.txtMeasurementWidth.text = measureWidth
        self.lblMeasurementLength.text = measureLengthUnit
        self.lblMeasurementWidth.text = measureWidthUnit
        
        
        if balcony == true{
            
            switchBalcony.isOn = true
        }
        else{
            
            switchBalcony.isOn = false
        }
        
        if garden == true{
            
            switchGarden.isOn = true
        }
        else{
            
            switchGarden.isOn = false
        }
        
        if parking == true{
            
           swicthParking.isOn = true
        }
        else{
            
            swicthParking.isOn = false
        }
        
        if modulerKitchen == true{
            
            swicthKitchen.isOn = true
        }
        else{
            
            swicthKitchen.isOn = false
        }
        
        if store == true{
            
            switchStore.isOn = true
        }
        else{
            
            switchStore.isOn = false
        }
        
        if lift == true{
            
            switchLift.isOn = true
        }
        else{
            
            switchLift.isOn = false
        }
        
        if duplex == true{
            
            switchDuplex.isOn = true
        }
        else{
            
            switchDuplex.isOn = false
        }
        
        if furnishing == true{
            
            switchFurnishing.isOn = true
        }
        else{
            
            switchFurnishing.isOn = false
        }
        
        if airCondition == true{
            
            switchAirConditioning.isOn = true
        }
        else{
            
            switchAirConditioning.isOn = false
        }
        
    }
    
}
