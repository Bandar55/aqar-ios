//
//  WelcomePresentController.swift
//  AQAR55
//
//  Created by lion on 27/02/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit
import KYDrawerController
class WelcomePresentController: UIViewController {

    var objSignUpDetails = UIViewController()
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //last controller passed Name
    var userName = ""
    
    var timer = Timer()
    var counter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblUserName.text = "Hello \(userName)"
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string:  "Welcome to Aqar55")
        
        attributedString.setColorForText("Welcome to", with: UIColor.black)
        attributedString.setColorForText("Aqar55", with: UIColor(red: 15/255, green: 0/255, blue: 227/255, alpha: 1.0));
        lblText.attributedText = attributedString
        //self.perform(#selector(gotoHomeController), with: nil, afterDelay: 3.0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(gotoHomeController(gesture:)))
        popupView.addGestureRecognizer(tap)
        
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        timer.invalidate()
    }
    
    
    @objc func timerAction() {
        
        counter += 1
        
        if counter == 2{
            
            timer.invalidate()
            
            self.dismiss(animated: true) {
                
                self.appDelegate.initHome()
            }
            
        }
        else{
            
           //repeating again
        }
    }
    

    @objc func gotoHomeController(gesture:UIGestureRecognizer){
        
        self.dismiss(animated: true) {
            
            self.appDelegate.initHome()
        }
    }

}
