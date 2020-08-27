//
//  PostPropertyPopupController.swift
//  Aqar55
//
//  Created by Callsoft on 05/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class PostPropertyPopupController: UIViewController {

    var objAddLocationByMap = AddLocationByMapController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    
    
    @IBAction func btnMyPostedPropertyAction(_ sender: Any) {
        
        self.dismiss(animated: true) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageMyPropertyController") as! ManageMyPropertyController
            vc.isFromCompletedPost = true
            self.objAddLocationByMap.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
