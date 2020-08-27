//
//  AddSpecificationsController.swift
//  AQAR55
//
//  Created by lion on 28/02/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class AddSpecificationsController: UIViewController {

    
    @IBOutlet weak var btnIndoorOption1: UIButton!
    
    @IBOutlet weak var btnIndoorOption3: UIButton!
    
    @IBOutlet weak var btnIndoorOption2: UIButton!
    
    @IBOutlet weak var btnIndoorOption4: UIButton!
    
    @IBOutlet weak var btnOutdoorOption1: UIButton!
    
    @IBOutlet weak var btnOutdoorOption3: UIButton!
    
    @IBOutlet weak var btnOutdoorOption2: UIButton!
    
    @IBOutlet weak var btnOutdoorOption4: UIButton!
    
    @IBOutlet weak var btnFurnishingOption1: UIButton!
    
    @IBOutlet weak var btnFurninshingOption3: UIButton!
    
    @IBOutlet weak var btnFurnishingOption2: UIButton!
    
    @IBOutlet weak var btnFurnishingOption4: UIButton!
    
    @IBOutlet weak var btnParkingOption1: UIButton!
    
    @IBOutlet weak var btnParkingOption3: UIButton!
    
    @IBOutlet weak var btnParkingOption2: UIButton!
    
    @IBOutlet weak var btnParkingOption4: UIButton!
    
    @IBOutlet weak var btnViewsOption1: UIButton!
    
    @IBOutlet weak var btnViewsOption3: UIButton!
    
    @IBOutlet weak var btnViewsOption2: UIButton!
    
    @IBOutlet weak var btnViewsOption4: UIButton!
    
    
    var indoorOption1Selected = false
    var indoorOption2Selected = false
    var indoorOption3Selected = false
    var indoorOption4Selected = false
    
    var outdoorOption1Selected = false
    var outdoorOption2Selected = false
    var outdoorOption3Selected = false
    var outdoorOption4Selected = false
    
    var furnishingOption1Selected = false
    var furnishingOption2Selected = false
    var furnishingOption3Selected = false
    var furnishingOption4Selected = false
    
    var parkingOption1Selected = false
    var parkingOption2Selected = false
    var parkingOption3Selected = false
    var parkingOption4Selected = false
    
    var viewsOption1Selected = false
    var viewsOption2Selected = false
    var viewsOption3Selected = false
    var viewsOption4Selected = false
    
    
    //for edit
    
    var editItemDict = NSDictionary()
    var controllerPurpuse = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.controllerPurpuse == "Edit"{
            
            self.setDataForEdit()
        }
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSkipAction(_ sender: Any) {
        
        let specificationData = NSMutableDictionary()
        specificationData.removeAllObjects()
        
        specificationData.setValue("", forKey: "IndoorStr")
        specificationData.setValue("", forKey: "OutdoorStr")
        specificationData.setValue("", forKey: "FurnishingStr")
        specificationData.setValue("", forKey: "ParkingStr")
        specificationData.setValue("", forKey: "ViewsStr")
        
        UserDefaults.standard.setValue(specificationData, forKey: "SpecificationPageData")
        
        if UserDefaults.standard.value(forKey: "PropertyType") as? String ?? "" == "Sale"{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPriceController" ) as! AddPriceController
            
            vc.editItemDict = self.editItemDict
            vc.controllerPurpuse = self.controllerPurpuse
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InputRentPriceVC" ) as! InputRentPriceVC
            
            vc.editItemDict = self.editItemDict
            vc.controllerPurpuse = self.controllerPurpuse
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
       
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        
//        if UserDefaults.standard.value(forKey: "PropertyType") as? String ?? "" == "Sale"{
//
//            dataConfigure()
//        }
//        else{
//
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InputRentPriceVC" ) as! InputRentPriceVC
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
        
        dataConfigure()
        
    }
    
    
    @IBAction func tap_indoorOption1(_ sender: Any) {
        
        if indoorOption1Selected == false{
            
            indoorOption1Selected = true
            btnIndoorOption1.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            indoorOption1Selected = false
            btnIndoorOption1.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
        
    }
    
    @IBAction func tap_indoorOption3(_ sender: Any) {
        
        if indoorOption3Selected == false{
            
            indoorOption3Selected = true
            btnIndoorOption3.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            indoorOption3Selected = false
            btnIndoorOption3.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_indoorOption2(_ sender: Any) {
        
        if indoorOption2Selected == false{
            
            indoorOption2Selected = true
            btnIndoorOption2.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            indoorOption2Selected = false
            btnIndoorOption2.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_indoorOption4(_ sender: Any) {
        
        if indoorOption4Selected == false{
            
            indoorOption4Selected = true
            btnIndoorOption4.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            indoorOption4Selected = false
            btnIndoorOption4.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    
    @IBAction func tap_outdoorOption1(_ sender: Any) {
        
        if outdoorOption1Selected == false{
            
            outdoorOption1Selected = true
            btnOutdoorOption1.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            outdoorOption1Selected = false
            btnOutdoorOption1.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_outdoorOption3(_ sender: Any) {
        
        if outdoorOption3Selected == false{
            
            outdoorOption3Selected = true
            btnOutdoorOption3.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            outdoorOption3Selected = false
            btnOutdoorOption3.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_outdoorOption2(_ sender: Any) {
        
        if outdoorOption2Selected == false{
            
            outdoorOption2Selected = true
            btnOutdoorOption2.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            outdoorOption2Selected = false
            btnOutdoorOption2.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_outdoorOption4(_ sender: Any) {
        
        if outdoorOption4Selected == false{
            
            outdoorOption4Selected = true
            btnOutdoorOption4.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            outdoorOption4Selected = false
            btnOutdoorOption4.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_furnishingOption1(_ sender: Any) {
        
        if furnishingOption1Selected == false{
            
            furnishingOption1Selected = true
            btnFurnishingOption1.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            furnishingOption1Selected = false
            btnFurnishingOption1.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_furnishingOption3(_ sender: Any) {
        
        if furnishingOption3Selected == false{
            
            furnishingOption3Selected = true
            btnFurninshingOption3.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            furnishingOption3Selected = false
            btnFurninshingOption3.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_furnishingOption2(_ sender: Any) {
        
        if furnishingOption2Selected == false{
            
            furnishingOption2Selected = true
            btnFurnishingOption2.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            furnishingOption2Selected = false
            btnFurnishingOption2.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_furnishingOption4(_ sender: Any) {
        
        if furnishingOption4Selected == false{
            
            furnishingOption4Selected = true
            btnFurnishingOption4.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            furnishingOption4Selected = false
            btnFurnishingOption4.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_parkingOption1(_ sender: Any) {
        
        if parkingOption1Selected == false{
            
            parkingOption1Selected = true
            btnParkingOption1.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            parkingOption1Selected = false
            btnParkingOption1.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_parkingOption3(_ sender: Any) {
        
        if parkingOption3Selected == false{
            
            parkingOption3Selected = true
            btnParkingOption3.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            parkingOption3Selected = false
            btnParkingOption3.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_parkingOption2(_ sender: Any) {
        
        if parkingOption2Selected == false{
            
            parkingOption2Selected = true
            btnParkingOption2.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            parkingOption2Selected = false
            btnParkingOption2.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_parkingOption4(_ sender: Any) {
        
        if parkingOption4Selected == false{
            
            parkingOption4Selected = true
            btnParkingOption4.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            parkingOption4Selected = false
            btnParkingOption4.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_viewsOption1(_ sender: Any) {
        
        if viewsOption1Selected == false{
            
            viewsOption1Selected = true
            btnViewsOption1.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            viewsOption1Selected = false
            btnViewsOption1.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_viewsOption3(_ sender: Any) {
        
        if viewsOption3Selected == false{
            
            viewsOption3Selected = true
            btnViewsOption3.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            viewsOption3Selected = false
            btnViewsOption3.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_viewsOption2(_ sender: Any) {
        
        if viewsOption2Selected == false{
            
            viewsOption2Selected = true
            btnViewsOption2.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            viewsOption2Selected = false
            btnViewsOption2.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    @IBAction func tap_viewsOption4(_ sender: Any) {
        
        if viewsOption4Selected == false{
            
            viewsOption4Selected = true
            btnViewsOption4.setImage(UIImage(named: "selected_area_new"), for: .normal)
        }
        else{
            
            viewsOption4Selected = false
            btnViewsOption4.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
    }
    
    
}



extension AddSpecificationsController{
    
    func dataConfigure(){
        
        var indoorDataStr = ""
        var outdoorDataStr = ""
        var furnishingStr = ""
        var parkingStr = ""
        var viewsStr = ""
        
        
        if indoorOption1Selected == true{
            
            indoorDataStr = "Maid Room,"
        }
        
        if indoorOption2Selected == true{
            
            indoorDataStr = indoorDataStr+"Pool,"
        }
        
        if indoorOption3Selected == true{
            
            indoorDataStr = indoorDataStr+"Basement,"
        }
        
        if indoorOption4Selected == true{
            
            indoorDataStr = indoorDataStr+"Internal Stair,"
        }
        
        /////////outdoor////////
        
        if outdoorOption1Selected == true{
            
            outdoorDataStr = "Driver Room,"
        }
        
        if outdoorOption2Selected == true{
            
            outdoorDataStr = outdoorDataStr+"Pool,"
        }
        
        if outdoorOption3Selected == true{
            
            outdoorDataStr = outdoorDataStr+"Extra Room,"
        }
        
        if outdoorOption4Selected == true{
            
            outdoorDataStr = outdoorDataStr+"Playground,"
        }
        
        ////////furnishing////////
        
        if furnishingOption1Selected == true{
            
            furnishingStr = "Security Alarm,"
        }
        
        if furnishingOption2Selected == true{
            
            furnishingStr = furnishingStr+"Fire Alarm,"
        }
        
        if furnishingOption3Selected == true{
            
            furnishingStr = furnishingStr+"Maintenance Covered,"
        }
        
        if furnishingOption4Selected == true{
            
            furnishingStr = furnishingStr+"Housekeeping,"
        }
        
        ///////parking///////
        
        if parkingOption1Selected == true{
            
            parkingStr = "Extra Parking,"
        }
        
        if parkingOption2Selected == true{
            
            parkingStr = parkingStr+"Security Man,"
        }
        
        if parkingOption3Selected == true{
            
            parkingStr = parkingStr+"Gym,"
        }
        
        if parkingOption4Selected == true{
            
            parkingStr = parkingStr+"In Compound,"
        }
        
        //////views///////////
        
        if viewsOption1Selected == true{
            
            viewsStr = "See View,"
        }
        
        if viewsOption2Selected == true{
            
           viewsStr = viewsStr+"Garden View,"
        }
        
        if viewsOption3Selected == true{
            
           viewsStr = viewsStr+"High City View,"
        }
        
        if viewsOption4Selected == true{
            
            viewsStr = viewsStr+"Unique View,"
        }
        
        
        if indoorDataStr != ""{
            
             indoorDataStr = indoorDataStr.trimmingCharacters(in: .whitespaces)
             indoorDataStr.remove(at: indoorDataStr.index(before: indoorDataStr.endIndex))
        }
        
        if outdoorDataStr != ""{
            
             outdoorDataStr = outdoorDataStr.trimmingCharacters(in: .whitespaces)
             outdoorDataStr.remove(at: outdoorDataStr.index(before: outdoorDataStr.endIndex))
        }
        
        if parkingStr != ""{
            
             parkingStr = parkingStr.trimmingCharacters(in: .whitespaces)
             parkingStr.remove(at: parkingStr.index(before: parkingStr.endIndex))
        }
        
        if furnishingStr != ""{
            
             furnishingStr = furnishingStr.trimmingCharacters(in: .whitespaces)
             furnishingStr.remove(at: furnishingStr.index(before: furnishingStr.endIndex))
        }
        
        if viewsStr != ""{
            
            viewsStr = viewsStr.trimmingCharacters(in: .whitespaces)
            viewsStr.remove(at: viewsStr.index(before: viewsStr.endIndex))
        }
        
        
        let specificationData = NSMutableDictionary()
        specificationData.removeAllObjects()
        
        specificationData.setValue(indoorDataStr, forKey: "IndoorStr")
        specificationData.setValue(outdoorDataStr, forKey: "OutdoorStr")
        specificationData.setValue(furnishingStr, forKey: "FurnishingStr")
        specificationData.setValue(parkingStr, forKey: "ParkingStr")
        specificationData.setValue(viewsStr, forKey: "ViewsStr")
        
        UserDefaults.standard.setValue(specificationData, forKey: "SpecificationPageData")
        
        
        if UserDefaults.standard.value(forKey: "PropertyType") as? String ?? "" == "Sale"{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPriceController" ) as! AddPriceController
            
            vc.editItemDict = self.editItemDict
            vc.controllerPurpuse = self.controllerPurpuse
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InputRentPriceVC" ) as! InputRentPriceVC
            
            vc.editItemDict = self.editItemDict
            vc.controllerPurpuse = self.controllerPurpuse
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
       
        
    }
    
}



extension AddSpecificationsController{
    
    func setDataForEdit(){
        
        let indoor = editItemDict.object(forKey: "indoor") as? String ?? ""
        let outdoor = editItemDict.object(forKey: "outdoor") as? String ?? ""
        let furnishing = editItemDict.object(forKey: "furnish") as? String ?? ""
        let parking = editItemDict.object(forKey: "parkingOption") as? String ?? ""
        let views = editItemDict.object(forKey: "views") as? String ?? ""
        
        
        if indoor == ""{
            
            indoorOption1Selected = false
            indoorOption2Selected = false
            indoorOption3Selected = false
            indoorOption4Selected = false
            
             btnIndoorOption1.setImage(UIImage(named: "rectangle_new"), for: .normal)
             btnIndoorOption2.setImage(UIImage(named: "rectangle_new"), for: .normal)
             btnIndoorOption3.setImage(UIImage(named: "rectangle_new"), for: .normal)
             btnIndoorOption4.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
        else{
            
            let indoorArr = indoor.components(separatedBy: ",") as? NSArray ?? []
            
            print(indoorArr)
            
            if indoorArr.contains("Maid Room"){
                
                indoorOption1Selected = true
                btnIndoorOption1.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if indoorArr.contains("Pool"){
                
                indoorOption2Selected = true
                btnIndoorOption2.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if indoorArr.contains("Basement"){
                
                indoorOption3Selected = true
                btnIndoorOption3.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if indoorArr.contains("Internal Stair"){
                
                indoorOption4Selected = true
                btnIndoorOption4.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            
        }
        
        
        ///
        
        if outdoor == ""{
            
            outdoorOption1Selected = false
            outdoorOption2Selected = false
            outdoorOption3Selected = false
            outdoorOption4Selected = false
            
            btnOutdoorOption1.setImage(UIImage(named: "rectangle_new"), for: .normal)
            btnOutdoorOption2.setImage(UIImage(named: "rectangle_new"), for: .normal)
            btnOutdoorOption3.setImage(UIImage(named: "rectangle_new"), for: .normal)
            btnOutdoorOption4.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
        else{
            
            let outdoorArr = outdoor.components(separatedBy: ",") as? NSArray ?? []
            
            
            if outdoorArr.contains("Driver Room"){
                
                outdoorOption1Selected = true
                btnOutdoorOption1.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if outdoorArr.contains("Pool"){
                
                outdoorOption2Selected = true
                btnOutdoorOption2.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if outdoorArr.contains("Extra Room"){
                
                outdoorOption3Selected = true
                btnOutdoorOption3.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if outdoorArr.contains("Playground"){
                
                outdoorOption4Selected = true
                btnOutdoorOption4.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
        }
        
        //
        
        
        if furnishing == ""{
            
            furnishingOption1Selected = false
            furnishingOption2Selected = false
            furnishingOption3Selected = false
            furnishingOption4Selected = false
            
            btnFurnishingOption1.setImage(UIImage(named: "rectangle_new"), for: .normal)
            btnFurnishingOption2.setImage(UIImage(named: "rectangle_new"), for: .normal)
            btnFurninshingOption3.setImage(UIImage(named: "rectangle_new"), for: .normal)
            btnFurnishingOption4.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
        else{
            
            let furnishingArr = furnishing.components(separatedBy: ",") as? NSArray ?? []
            
            
            if furnishingArr.contains("Security Alarm"){
                
                furnishingOption1Selected = true
                btnFurnishingOption1.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if furnishingArr.contains("Fire Alarm"){
                
                furnishingOption2Selected = true
                btnFurnishingOption2.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if furnishingArr.contains("Maintenance Covered"){
                
                furnishingOption3Selected = true
                btnFurninshingOption3.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if furnishingArr.contains("Housekeeping"){
                
                furnishingOption4Selected = true
                btnFurnishingOption4.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
        }
        
        //
        
        if parking == ""{
            
            parkingOption1Selected = false
            parkingOption2Selected = false
            parkingOption3Selected = false
            parkingOption4Selected = false
            
            btnParkingOption1.setImage(UIImage(named: "rectangle_new"), for: .normal)
            btnParkingOption2.setImage(UIImage(named: "rectangle_new"), for: .normal)
            btnParkingOption3.setImage(UIImage(named: "rectangle_new"), for: .normal)
            btnParkingOption4.setImage(UIImage(named: "rectangle_new"), for: .normal)
        }
        else{
            
            let parkingArr = parking.components(separatedBy: ",") as? NSArray ?? []
            
            if parkingArr.contains("Extra Parking"){
                
                parkingOption1Selected = true
                btnParkingOption1.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if parkingArr.contains("Security Man"){
                
                parkingOption2Selected = true
                btnParkingOption2.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if parkingArr.contains("Gym"){
                
                parkingOption3Selected = true
                btnParkingOption3.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if parkingArr.contains("In Compound"){
                
                parkingOption4Selected = true
                btnParkingOption4.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
        }
        
        //
        
        if views == ""{
            
            viewsOption1Selected = false
            viewsOption2Selected = false
            viewsOption3Selected = false
            viewsOption4Selected = false
            
            btnViewsOption1.setImage(UIImage(named: "rectangle_new"), for: .normal)
            btnViewsOption2.setImage(UIImage(named: "rectangle_new"), for: .normal)
            btnViewsOption3.setImage(UIImage(named: "rectangle_new"), for: .normal)
            btnViewsOption4.setImage(UIImage(named: "rectangle_new"), for: .normal)
            
        }
        else{
            
            let viewsArr = views.components(separatedBy: ",") as? NSArray ?? []
            
            if viewsArr.contains("See View"){
                
                viewsOption1Selected = true
                btnViewsOption1.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if viewsArr.contains("Garden View"){
                
                viewsOption2Selected = true
                btnViewsOption2.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if viewsArr.contains("High City View"){
                
                viewsOption3Selected = true
                btnViewsOption3.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
            
            if viewsArr.contains("Unique View"){
                
                viewsOption4Selected = true
                btnViewsOption4.setImage(UIImage(named: "selected_area_new"), for: .normal)
            }
        }
    }
}
