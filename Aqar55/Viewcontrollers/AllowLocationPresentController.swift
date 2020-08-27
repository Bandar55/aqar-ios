//
//  AllowLocationPresentController.swift
//  AQAR55
//
//  Created by lion on 27/02/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class AllowLocationPresentController: UIViewController {

    var objSignupOption = SignupOptionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnDontAllowAction(_ sender: Any) {
        gotoMarketingPopupController()
    }
    

    @IBAction func btnAllowAction(_ sender: Any) {
        gotoMarketingPopupController()
    }
    
    
    func gotoMarketingPopupController(){
        
        self.dismiss(animated: true) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketingPopupController") as! MarketingPopupController
            vc.objSignupOption = self.objSignupOption
            self.objSignupOption.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
}
