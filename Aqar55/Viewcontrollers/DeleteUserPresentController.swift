//
//  DeleteUserPresentController.swift
//  AQAR55
//
//  Created by lion on 01/03/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit

class DeleteUserPresentController: UIViewController {

    
    var objChat = ChatWithUserController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnOkAction(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
         //   let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatListingController") as! ChatListingController
         //   self.objChat.navigationController?.pushViewController(vc, animated: true)
            self.objChat.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func btnCancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
