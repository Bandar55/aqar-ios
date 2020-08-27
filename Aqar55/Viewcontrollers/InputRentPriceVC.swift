//
//  InputRentPriceVC.swift
//  Aqar55
//
//  Created by Dacall soft on 18/04/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class InputRentPriceVC: UIViewController {

    
    @IBOutlet weak var btnDaily: UIButton!
    
    @IBOutlet weak var btnWeekly: UIButton!
    
    @IBOutlet weak var btnMonthly: UIButton!
    
    @IBOutlet weak var btnYearly: UIButton!
    
    @IBOutlet weak var txtDaily: UITextField!
    
    @IBOutlet weak var txtweekly: UITextField!
    
    @IBOutlet weak var txtMonthly: UITextField!
    
    @IBOutlet weak var txtYearly: UITextField!
    
    
    var dailySelected = false
    var weeklySelected = false
    var monthlySelected = false
    var yearlySelected = false
    
    //for edit
    
    var editItemDict = NSDictionary()
    var controllerPurpuse = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtDaily.delegate = self
        txtweekly.delegate = self
        txtMonthly.delegate = self
        txtYearly.delegate = self
        
        txtDaily.addTarget(self, action: #selector(self.editingInDaily(_:)), for: .editingChanged)
        txtweekly.addTarget(self, action: #selector(self.editingInWeekly(_:)), for: .editingChanged)
        txtMonthly.addTarget(self, action: #selector(self.editingInMonthly(_:)), for: .editingChanged)
        txtYearly.addTarget(self, action: #selector(self.editingInYearly(_:)), for: .editingChanged)
        
        txtDaily.isUserInteractionEnabled = false
        txtweekly.isUserInteractionEnabled = false
        txtMonthly.isUserInteractionEnabled = false
        txtYearly.isUserInteractionEnabled = false
        
        if self.controllerPurpuse == "Edit"{
            
            setDataForEditItem()
        }
        
    }
    
    @IBAction func tap_dailyBtn(_ sender: Any) {
        
        if dailySelected == false{
            
            dailySelected = true
            btnDaily.setImage(UIImage(named: "done_tick"), for: .normal)
            
            txtDaily.isUserInteractionEnabled = true
        }
        else{
            
            dailySelected = false
            btnDaily.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
            
            txtDaily.isUserInteractionEnabled = false
            txtDaily.text = ""
        }
        
    }
    
    @IBAction func tap_weeklyBtn(_ sender: Any) {
        
        if weeklySelected == false{
            
            weeklySelected = true
            btnWeekly.setImage(UIImage(named: "done_tick"), for: .normal)
            
            txtweekly.isUserInteractionEnabled = true
        }
        else{
            
            weeklySelected = false
            btnWeekly.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
            
            txtweekly.isUserInteractionEnabled = false
            txtweekly.text = ""
        }
    }
    
    @IBAction func tap_monthlyBtn(_ sender: Any) {
        
        if monthlySelected == false{
            
            monthlySelected = true
            btnMonthly.setImage(UIImage(named: "done_tick"), for: .normal)
            
            txtMonthly.isUserInteractionEnabled = true
        }
        else{
            
            monthlySelected = false
            btnMonthly.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
            
            txtMonthly.isUserInteractionEnabled = false
            txtMonthly.text = ""
        }
    }
    
    @IBAction func tap_yearlyBtn(_ sender: Any) {
        
        if yearlySelected == false{
            
            yearlySelected = true
            btnYearly.setImage(UIImage(named: "done_tick"), for: .normal)
            
            txtYearly.isUserInteractionEnabled = true
        }
        else{
            
            yearlySelected = false
            btnYearly.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
            
            txtYearly.isUserInteractionEnabled = false
            txtYearly.text = ""
        }
    }
    
    @IBAction func tap_backbtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_saveBtn(_ sender: Any) {
        
       checkValidation()
        
    }
    
    
}


extension InputRentPriceVC{
    
    func checkValidation(){
        
        var mess = ""
        
        if dailySelected == false && weeklySelected == false && monthlySelected == false && yearlySelected == false{
            
            mess = "Please select atleast one Price Box"
        }
        else if dailySelected == true && txtDaily.text! == ""{
            
            mess = "Please enter daily price"
        }
        else if weeklySelected == true && txtweekly.text! == ""{
            
             mess = "Please enter weekly price"
        }
        else if monthlySelected == true && txtMonthly.text! == ""{
            
            mess = "Please enter monthly price"
        }
        else if yearlySelected == true && txtYearly.text! == ""{
            
            mess = "Please enter yearly price"
        }
        else{
            
            mess = ""
        }
        
        
        if mess == ""{
            
            redirectToSetPriceInformationController()
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
    
    func redirectToSetPriceInformationController(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetPriceInformationController" ) as! SetPriceInformationController
        
        vc.dailyPrice = txtDaily.text!
        vc.weeklyPrice = txtweekly.text!
        vc.monthlyPrice = txtMonthly.text!
        vc.yearlyPrice = txtYearly.text!
        
        vc.editItemDict = self.editItemDict
        vc.controllerPurpuse = self.controllerPurpuse
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension InputRentPriceVC{
    
    func setDataForEditItem(){
        
//        self.dailySelected = true
//        self.weeklySelected = true
//        self.monthlySelected = true
//        self.yearlySelected = true
//
//        btnYearly.setImage(UIImage(named: "done_tick"), for: .normal)
//        btnMonthly.setImage(UIImage(named: "done_tick"), for: .normal)
//        btnWeekly.setImage(UIImage(named: "done_tick"), for: .normal)
//        btnDaily.setImage(UIImage(named: "done_tick"), for: .normal)
        
        txtDaily.text = editItemDict.object(forKey: "defaultDailyPrice") as? String ?? ""
        txtweekly.text = editItemDict.object(forKey: "defaultWeeklyPrice") as? String ?? ""
        txtMonthly.text = editItemDict.object(forKey: "defaultMonthlyPrice") as? String ?? ""
        txtYearly.text = editItemDict.object(forKey: "defaultyearlyPrice") as? String ?? ""
        
        var daily = editItemDict.object(forKey: "defaultDailyPrice") as? String ?? ""
        var weekly = editItemDict.object(forKey: "defaultWeeklyPrice") as? String ?? ""
        var monthly = editItemDict.object(forKey: "defaultMonthlyPrice") as? String ?? ""
        var yearly = editItemDict.object(forKey: "defaultyearlyPrice") as? String ?? ""
        
        daily = daily.trimmingCharacters(in: .whitespaces)
        weekly = weekly.trimmingCharacters(in: .whitespaces)
        monthly = monthly.trimmingCharacters(in: .whitespaces)
        yearly = yearly.trimmingCharacters(in: .whitespaces)
        
        if daily == ""{
            
            self.dailySelected = false
            txtDaily.text = ""
            txtDaily.isUserInteractionEnabled = false
            btnDaily.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
        }
        else{
            
            self.dailySelected = true
            self.txtDaily.isUserInteractionEnabled = true
            btnDaily.setImage(UIImage(named: "done_tick"), for: .normal)
        }
        
        if weekly == ""{
            
            self.weeklySelected = false
            txtweekly.text = ""
            txtweekly.isUserInteractionEnabled = false
            btnWeekly.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
        }
        else{
            
            self.weeklySelected = true
            txtweekly.isUserInteractionEnabled = true
            btnWeekly.setImage(UIImage(named: "done_tick"), for: .normal)
        }
        
        if monthly == ""{
            
            self.monthlySelected = false
            txtMonthly.text = ""
            txtMonthly.isUserInteractionEnabled = false
            btnMonthly.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
        }
        else{
            
            self.monthlySelected = true
            self.txtMonthly.isUserInteractionEnabled = true
            btnMonthly.setImage(UIImage(named: "done_tick"), for: .normal)
        }
        
        if yearly == ""{
            
            self.yearlySelected = false
            txtYearly.text = ""
            txtYearly.isUserInteractionEnabled = false
            btnYearly.setImage(UIImage(named: "unselectedCheckbox"), for: .normal)
        }
        else{
            
            self.yearlySelected = true
            self.txtYearly.isUserInteractionEnabled = true
            btnYearly.setImage(UIImage(named: "done_tick"), for: .normal)
        }
        
    }
}


//MARK:- UIText Field Delegate
//MARK:-
extension InputRentPriceVC{
    
    @objc func editingInDaily(_ textField: UITextField){
        
        var dailyTxt = txtDaily.text!
        
        dailyTxt = dailyTxt.trimmingCharacters(in: .whitespaces)
        
        dailyTxt = dailyTxt.replacingOccurrences(of: ",", with: "")
        dailyTxt = dailyTxt.trimmingCharacters(in: .whitespaces)
        
        if dailyTxt == "" || dailyTxt == "."{
            
            txtDaily.text = ""
        }
        else{
            
            let txtInDouble = Double(dailyTxt)!
            
            let priceInInt = Int(txtInDouble)
            
           // let priceInInt = Int(dailyTxt)!
            
            txtDaily.text = App.currencyConverterInComma(priceInInt)
           
        }
        
    }
    
    @objc func editingInWeekly(_ textField: UITextField){
        
        var weeklyTxt = txtweekly.text!
        
        weeklyTxt = weeklyTxt.trimmingCharacters(in: .whitespaces)
        
        weeklyTxt = weeklyTxt.replacingOccurrences(of: ",", with: "")
        weeklyTxt = weeklyTxt.trimmingCharacters(in: .whitespaces)
        
        if weeklyTxt == "" || weeklyTxt == "."{
            
            txtweekly.text = ""
        }
        else{
            
            let txtInDouble = Double(weeklyTxt)!
            
            let priceInInt = Int(txtInDouble)
            
           // let priceInInt = Int(weeklyTxt)!
            
            txtweekly.text = App.currencyConverterInComma(priceInInt)
            
        }
    }
    
    @objc func editingInMonthly(_ textField: UITextField){
        
        var monthlyTxt = txtMonthly.text!
        
        monthlyTxt = monthlyTxt.trimmingCharacters(in: .whitespaces)
        
        monthlyTxt = monthlyTxt.replacingOccurrences(of: ",", with: "")
        monthlyTxt = monthlyTxt.trimmingCharacters(in: .whitespaces)
        
        if monthlyTxt == "" || monthlyTxt == "."{
            
            txtMonthly.text = ""
        }
        else{
            
            let txtInDouble = Double(monthlyTxt)!
            let priceInInt = Int(txtInDouble)
            
           // let priceInInt = Int(monthlyTxt)!
            
            txtMonthly.text = App.currencyConverterInComma(priceInInt)
            
        }
    }
    
    @objc func editingInYearly(_ textField: UITextField){
        
        var yearlyTxt = txtYearly.text!
        
        yearlyTxt = yearlyTxt.trimmingCharacters(in: .whitespaces)
        
        yearlyTxt = yearlyTxt.replacingOccurrences(of: ",", with: "")
        yearlyTxt = yearlyTxt.trimmingCharacters(in: .whitespaces)
        
        if yearlyTxt == "" || yearlyTxt == "."{
            
            txtYearly.text = ""
        }
        else{
            
            let txtInDouble = Double(yearlyTxt)!
            
            let priceInInt = Int(txtInDouble)
            
            //let priceInInt = Int(yearlyTxt)!
            
            txtYearly.text = App.currencyConverterInComma(priceInInt)
            
        }
    }

}


extension InputRentPriceVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtDaily{
            
            let textForDaily = NSString(string: txtDaily.text!).replacingCharacters(in: range, with: string)
            
            if textForDaily.isNumericCheck == false{
                
                return false
            }
            
        }
        else if textField == txtweekly{
            
            let textForWeekly = NSString(string: txtweekly.text!).replacingCharacters(in: range, with: string)
            
            if textForWeekly.isNumericCheck == false{
                
                return false
            }
        }
        else if textField == txtMonthly{
            
            let textForMonthly = NSString(string: txtMonthly.text!).replacingCharacters(in: range, with: string)
            
            if textForMonthly.isNumericCheck == false{
                
                return false
            }
        }
        else if textField == txtYearly{
            
            let textForYearly = NSString(string: txtYearly.text!).replacingCharacters(in: range, with: string)
            
            if textForYearly.isNumericCheck == false{
                
                return false
            }
        }
        else{
            
            
        }
        
        return true
    }
}


extension String {
    
    var isNumericCheck: Bool {
        guard self.count >= 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".",","]
        return Set(self).isSubset(of: nums)
    }
}

