//
//  BlockUserPresentController.swift
//  AQAR55
//
//  Created by lion on 01/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class BlockUserPresentController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOkAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnCancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
