//
//  ProfessionalPropertyMapController.swift
//  Aqar55
//
//  Created by Callsoft on 05/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps

class ProfessionalPropertyMapController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var lblHeader: UILabel!
    
    var propertyDataArr = NSArray()
    
    var userType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if userType == "professional"{
            
            self.lblHeader.text = "Professional Property Listing"
        }
        else{
            
            self.lblHeader.text = "Property Listing"
        }
        
        self.showMarker()
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
 
}

extension ProfessionalPropertyMapController{
    
    func showMarker(){
        
        mapView.clear()
        
        for i in 0..<self.propertyDataArr.count{
            
            let dict = propertyDataArr.object(at: i) as? NSDictionary ?? [:]
            
            var latCordinate = dict.object(forKey: "lat") as? String ?? ""
            var longCordinate = dict.object(forKey: "long") as? String ?? ""
            
            latCordinate = latCordinate.trimmingCharacters(in: .whitespaces)
            longCordinate = longCordinate.trimmingCharacters(in: .whitespaces)
            
            print(latCordinate)
            print(longCordinate)
            
            if latCordinate != "" && longCordinate != ""{
                
                let latiDouble = Double(latCordinate)!
                let longiDouble = Double(longCordinate)!
                
                if i == 0{
                    
                    let camera = GMSCameraPosition.camera(withLatitude: latiDouble, longitude: longiDouble, zoom: 7.0)
                    mapView.camera = camera
                    mapView.animate(to: camera)
                }
                
                let position = CLLocationCoordinate2DMake(latiDouble,longiDouble)
                
                let marker = GMSMarker(position: position)
                
                marker.userData = i
                
                let propertyType = dict.object(forKey: "Type") as? String ?? ""
                    
                    if propertyType == "sale"{
                        
                        let viewData = Bundle.main.loadNibNamed("MarkerCategorised", owner: self, options: nil)?.first as! MarkerCategorised
                        
                        viewData.imgViewMarker.image = UIImage(named: "redBlank")
                        
                        viewData.lblContent.textColor = UIColor(red:0.96, green:0.30, blue:0.32, alpha:1.0)
                        
                        let totalPriceSale = dict.object(forKey: "totalPriceSale") as? String ?? ""
                        
                        let currency = dict.object(forKey: "currency") as? String ?? ""
                        
                        viewData.lblContent.text = "\(currency) \(totalPriceSale)"
                        
                        marker.iconView = viewData
                        
                        marker.map = mapView
                        
                    }
                    else if propertyType == "rent"{
                        
                        let viewData = Bundle.main.loadNibNamed("MarkerCategorised", owner: self, options: nil)?.first as! MarkerCategorised
                        
                        let totalPriceRent = dict.object(forKey: "totalPriceRent") as? String ?? ""
                        
                        let rentTime = dict.object(forKey: "rentTime") as? String ?? ""
                        
                        let currency = dict.object(forKey: "currency") as? String ?? ""
                        
                        viewData.lblContent.text = "\(currency) \(totalPriceRent) \(rentTime)"
                        
                        if rentTime == "daily"{
                            
                            viewData.imgViewMarker.image = UIImage(named: "greenBblank")
                            
                            viewData.lblContent.textColor = UIColor(red:0.53, green:0.90, blue:0.70, alpha:1.0)
                            
                        }
                        else if rentTime == "weekly"{
                            
                            viewData.imgViewMarker.image = UIImage(named: "greenBblank")
                            
                            viewData.lblContent.textColor = UIColor(red:0.53, green:0.90, blue:0.70, alpha:1.0)
                            
                        }
                        else if rentTime == "monthly"{
                            
                            viewData.imgViewMarker.image = UIImage(named: "greenBblank")
                            
                            viewData.lblContent.textColor = UIColor(red:0.53, green:0.90, blue:0.70, alpha:1.0)
                            
                        }
                        else if rentTime == "yearly"{
                            
                            viewData.imgViewMarker.image = UIImage(named: "greenBblank")
                            
                            viewData.lblContent.textColor = UIColor(red:0.53, green:0.90, blue:0.70, alpha:1.0)
                            
                        }
                        
                        marker.iconView = viewData
                        
                        marker.map = mapView
                        
                    }
               
            }
            
        }
 
    }
    
}
