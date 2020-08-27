//
//  AddPriceController.swift
//  Aqar55
//
//  Created by Callsoft on 05/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class AddPriceController: UIViewController {

    
    @IBOutlet weak var txtSize: UITextField!
    
    @IBOutlet weak var txtTotalPrice: UITextField!
    
    @IBOutlet weak var txtPricePerMeter: UITextField!
    
    
    @IBOutlet weak var lblPricePerMeterSAR: UILabel!
    
    @IBOutlet weak var lblTotalPriceSAR: UILabel!
    
    
    //for edit
    
    var editItemDict = NSDictionary()
    var controllerPurpuse = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtTotalPrice.isUserInteractionEnabled = false
        txtSize.delegate = self
        txtPricePerMeter.delegate = self
        
        let currencyValue = UserDefaults.standard.value(forKey: "GlobalCurrency") as? String ?? ""
        
        lblPricePerMeterSAR.text = "Price per meter (\(currencyValue))"
        lblTotalPriceSAR.text = "Total Price (\(currencyValue))"
        
        if self.controllerPurpuse == "Edit"{
            
            self.setupDataForEdit()
        }
        
    }
    

    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSaveAction(_ sender: Any) {

//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddImageController") as! AddImageController
//        self.navigationController?.pushViewController(vc, animated: true)

        checkValidation()
    }

}


extension AddPriceController{
    
    func checkValidation(){
        
        var mess = ""
        
//        if txtSize.text == ""{
//
//            mess = "Please enter size in meter square"
//        }
//        else if txtPricePerMeter.text == ""{
//
//            mess = "Please enter price for per meter"
//        }
//        else if txtTotalPrice.text == ""{
//
//            mess = "Please enter total price"
//        }
//        else{
//
//            mess = ""
//        }
        
        if mess == ""{
            
            let priceDataDict = NSMutableDictionary()
            priceDataDict.removeAllObjects()
            
            priceDataDict.setValue(txtSize.text!, forKey: "SizeForPrice")
            priceDataDict.setValue(txtPricePerMeter.text!, forKey: "PricePerMeter")
            priceDataDict.setValue(txtTotalPrice.text!, forKey: "TotalPrice")
            
            
            UserDefaults.standard.set(priceDataDict, forKey: "PriceForSale")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddImageController") as! AddImageController
            
            vc.editItemDict = self.editItemDict
            vc.controllerPurpuse = self.controllerPurpuse
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
    }
}


extension AddPriceController{
    
    func setupDataForEdit(){
        
        self.txtSize.text = editItemDict.object(forKey: "sizem2") as? String ?? ""
        self.txtPricePerMeter.text = editItemDict.object(forKey: "pricePerMeter") as? String ?? ""
        self.txtTotalPrice.text = editItemDict.object(forKey: "totalPrice") as? String ?? ""
    }
}


extension AddPriceController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == txtSize{
            
            let textForSize = NSString(string: txtSize.text!).replacingCharacters(in: range, with: string)
            
            if textForSize.isNumeric == false{
                
                return false
            }
            
            let size = textForSize.trimmingCharacters(in: .whitespaces)
            
            var priceText = txtPricePerMeter.text!
            
            priceText = priceText.trimmingCharacters(in: .whitespaces)
            
            if size != "" && priceText != ""{
                
//                let sizeInInt = Int(size)!
//                let priceInInt = Int(priceText)!
                
                let priceInDouble = Double(priceText)!
                let sizeInDouble = Double(size)!
                let sizeInInt = Int(sizeInDouble)
                let priceInInt = Int(priceInDouble)
                
                let formaterPrice = sizeInInt*priceInInt
                txtTotalPrice.text = "\(formaterPrice.formattedWithSeparator)"
                
            }
            else{
                
                txtTotalPrice.text = ""
            }
            
        }
        else if textField == txtPricePerMeter{
            
            let textForPricePerMeter = NSString(string: txtPricePerMeter.text!).replacingCharacters(in: range, with: string)
            
            if textForPricePerMeter.isNumeric == false{
                
                return false
            }
            
            
            let price = textForPricePerMeter.trimmingCharacters(in: .whitespaces)
            
            var sizeText = txtSize.text!
            
            sizeText = sizeText.trimmingCharacters(in: .whitespaces)
            
            if price != "" && sizeText != ""{
                
//                let priceInInt = Int(price)!
//                let sizeInInt = Int(sizeText)!
                
                let priceInDouble = Double(price)!
                let sizeInDouble = Double(sizeText)!
                let priceInInt = Int(priceInDouble)
                let sizeInInt = Int(sizeInDouble)
                
                let formaterPrice = priceInInt*sizeInInt
                txtTotalPrice.text = "\(formaterPrice.formattedWithSeparator)"
                
            }
            else{
                
                txtTotalPrice.text = ""
            }
            
        }
        else{}
        
        return true
    }
}


//FORMATTER EXTENSION
extension Formatter {
    
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ","
    }
}


extension String {
    
    var isNumeric: Bool {
        guard self.count >= 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
        return Set(self).isSubset(of: nums)
    }
}
