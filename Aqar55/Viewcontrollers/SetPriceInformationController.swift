//
//  SetPriceInformationController.swift
//  AQAR55
//
//  Created by lion on 28/02/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class SetPriceInformationController: UIViewController {

    
    @IBOutlet weak var btnYearly: UIButton!
    
    @IBOutlet weak var btnMonthly: UIButton!
    
    @IBOutlet weak var btnWeekly: UIButton!
    
    @IBOutlet weak var btnDaily: UIButton!
    
    @IBOutlet weak var lblDaily: UILabel!
    
    @IBOutlet weak var lblWeekly: UILabel!
    
    @IBOutlet weak var lblMonthly: UILabel!
    
    
    @IBOutlet weak var lblYearly: UILabel!
    
    
    var selectedCategory = "daily"
    
    
    ////back controller passed data
    var dailyPrice = ""
    var weeklyPrice = ""
    var monthlyPrice = ""
    var yearlyPrice = ""
    
    var sendPrice = ""
    
    var editItemDict = NSDictionary()
    var controllerPurpuse = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let currencyValue = UserDefaults.standard.value(forKey: "GlobalCurrency") as? String ?? ""
        
        dailyPrice = dailyPrice.trimmingCharacters(in: .whitespaces)
        weeklyPrice = weeklyPrice.trimmingCharacters(in: .whitespaces)
        monthlyPrice = monthlyPrice.trimmingCharacters(in: .whitespaces)
        yearlyPrice = yearlyPrice.trimmingCharacters(in: .whitespaces)
        
        if dailyPrice == ""{
            
            self.lblDaily.text = "NA"
            
            btnDaily.isUserInteractionEnabled = false
            
        }
        else{
            
            self.lblDaily.text = "\(currencyValue) \(dailyPrice)"
            
            btnDaily.isUserInteractionEnabled = true
        }
        
        if weeklyPrice == ""{
            
            self.lblWeekly.text = "NA"
            
            btnWeekly.isUserInteractionEnabled = false
        }
        else{
            
            self.lblWeekly.text = "\(currencyValue) \(weeklyPrice)"
            
            btnWeekly.isUserInteractionEnabled = true
        }
        
        if monthlyPrice == ""{
            
            self.lblMonthly.text = "NA"
            
            btnMonthly.isUserInteractionEnabled = false
        }
        else{
            
            self.lblMonthly.text = "\(currencyValue) \(monthlyPrice)"
            
            btnMonthly.isUserInteractionEnabled = true
        }
        
        if yearlyPrice == ""{
            
            self.lblYearly.text = "NA"
            
            btnYearly.isUserInteractionEnabled = false
        }
        else{
            
            self.lblYearly.text = "\(currencyValue) \(yearlyPrice)"
            
            btnYearly.isUserInteractionEnabled = true
        }
        
       // sendPrice = dailyPrice
        
        if self.controllerPurpuse == "Edit"{
            
           //setEditedData()
        }
        
    }

    @IBAction func tap_saveBtn(_ sender: Any) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddImageController") as! AddImageController
//        self.navigationController?.pushViewController(vc, animated: true)
        
        checkValidation()
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_dailyBtn(_ sender: Any) {
        
        selectedCategory = "daily"
        
        btnDaily.setImage(UIImage(named: "selected"), for: .normal)
        btnWeekly.setImage(UIImage(named: "unselected"), for: .normal)
        btnMonthly.setImage(UIImage(named: "unselected"), for: .normal)
        btnYearly.setImage(UIImage(named: "unselected"), for: .normal)
        
        sendPrice = dailyPrice
        
    }
    
    @IBAction func tap_weeklyBtn(_ sender: Any) {
        
        selectedCategory = "weekly"
        
        btnDaily.setImage(UIImage(named: "unselected"), for: .normal)
        btnWeekly.setImage(UIImage(named: "selected"), for: .normal)
        btnMonthly.setImage(UIImage(named: "unselected"), for: .normal)
        btnYearly.setImage(UIImage(named: "unselected"), for: .normal)
        
        sendPrice = weeklyPrice
    }
    
    @IBAction func tap_monthlyBtn(_ sender: Any) {
        
        selectedCategory = "monthly"
        
        btnDaily.setImage(UIImage(named: "unselected"), for: .normal)
        btnWeekly.setImage(UIImage(named: "unselected"), for: .normal)
        btnMonthly.setImage(UIImage(named: "selected"), for: .normal)
        btnYearly.setImage(UIImage(named: "unselected"), for: .normal)
        
        sendPrice = monthlyPrice
    }
    
    @IBAction func tap_yearlyBtn(_ sender: Any) {
        
        selectedCategory = "yearly"
        
        btnDaily.setImage(UIImage(named: "unselected"), for: .normal)
        btnWeekly.setImage(UIImage(named: "unselected"), for: .normal)
        btnMonthly.setImage(UIImage(named: "unselected"), for: .normal)
        btnYearly.setImage(UIImage(named: "selected"), for: .normal)
        
        sendPrice = yearlyPrice
    }
    
}


extension SetPriceInformationController{
    
    func checkValidation(){
        
        if sendPrice != ""{
            
            let priceDataDict = NSMutableDictionary()
            priceDataDict.removeAllObjects()
            
            priceDataDict.setValue(selectedCategory, forKey: "PaymentPlanTime")
            priceDataDict.setValue("\(sendPrice)", forKey: "PriceForTime")
            
            priceDataDict.setValue(dailyPrice, forKey: "DefaultDailyPrice")
            priceDataDict.setValue(weeklyPrice, forKey: "DefaultWeeklyPrice")
            priceDataDict.setValue(monthlyPrice, forKey: "DefaultMonthlyPrice")
            priceDataDict.setValue(yearlyPrice, forKey: "DefalutYearlyPrice")
            
            UserDefaults.standard.set(priceDataDict, forKey: "PriceForRent")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddImageController") as! AddImageController
            
            vc.controllerPurpuse = self.controllerPurpuse
            vc.editItemDict = self.editItemDict
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select rent time.", controller: self)
        }
 
    }
    
}


extension SetPriceInformationController{
    
    func setEditedData(){
        
        let rentTime = editItemDict.object(forKey: "rentTime") as? String ?? ""
        
        if rentTime == "daily"{
        
            selectedCategory = "daily"
            
            btnDaily.setImage(UIImage(named: "selected"), for: .normal)
            btnWeekly.setImage(UIImage(named: "unselected"), for: .normal)
            btnMonthly.setImage(UIImage(named: "unselected"), for: .normal)
            btnYearly.setImage(UIImage(named: "unselected"), for: .normal)
            
            sendPrice = dailyPrice
        
        }
        else if rentTime == "weekly"{
        
            selectedCategory = "weekly"
            
            btnDaily.setImage(UIImage(named: "unselected"), for: .normal)
            btnWeekly.setImage(UIImage(named: "selected"), for: .normal)
            btnMonthly.setImage(UIImage(named: "unselected"), for: .normal)
            btnYearly.setImage(UIImage(named: "unselected"), for: .normal)
            
            sendPrice = weeklyPrice
        }
        else if rentTime == "monthly"{
        
            selectedCategory = "monthly"
            
            btnDaily.setImage(UIImage(named: "unselected"), for: .normal)
            btnWeekly.setImage(UIImage(named: "unselected"), for: .normal)
            btnMonthly.setImage(UIImage(named: "selected"), for: .normal)
            btnYearly.setImage(UIImage(named: "unselected"), for: .normal)
            
            sendPrice = monthlyPrice
        }
        else if rentTime == "yearly"{
        
            selectedCategory = "yearly"
            
            btnDaily.setImage(UIImage(named: "unselected"), for: .normal)
            btnWeekly.setImage(UIImage(named: "unselected"), for: .normal)
            btnMonthly.setImage(UIImage(named: "unselected"), for: .normal)
            btnYearly.setImage(UIImage(named: "selected"), for: .normal)
            
            sendPrice = yearlyPrice
        }
        else{
        
        
        }
    }
    
}
