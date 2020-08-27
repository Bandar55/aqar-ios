//
//  SearchProfessionalView.swift
//  Aqar55
//
//  Created by Callsoft on 12/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import Foundation

class SearchProfessionalView: UIView {

    @IBOutlet weak var locationView: UIView!

    @IBOutlet weak var txtSpecialities: UITextField!
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//    //    NotificationCenter.default.addObserver(self, selector: #selector(hideLocationView(not:)), name: NSNotification.Name(rawValue: "HideLocation"), object: nil)
//    //    NotificationCenter.default.addObserver(self, selector: #selector(showLocationView(not:)), name: NSNotification.Name(rawValue: "ShowLocation"), object: nil)
//
//    }
    
    @objc func hideLocationView(not:Notification){
        locationView.isHidden = true
    }
    
    @objc func showLocationView(not:Notification){
        locationView.isHidden = false
    }
    
    @IBAction func btnSearchAction(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "redirectToHome"), object: nil, userInfo: nil)
    }
    
}
