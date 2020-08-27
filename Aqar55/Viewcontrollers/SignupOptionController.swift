//
//  Sign_signUp_VC.swift
//  AQAR55
//
//  Created by lion on 27/02/19.
//  Copyright © 2019 lion. All rights reserved.
//

import UIKit
import KYDrawerController

class SignupOptionController: UIViewController {

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var drawerController = KYDrawerController.init(drawerDirection: .left, drawerWidth: 275)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSignInAction(_ sender: Any) {
        goToSignupController(isFrom: "signin")
    }
    
    @IBAction func btnSignupAction(_ sender: Any) {
        goToSignupController(isFrom: "signup")
    }
    
    
    @IBAction func btnSkipToExploreAction(_ sender: Any) {
        
        UserDefaults.standard.set(false, forKey: "ISLOGIN")
        UserDefaults.standard.set("", forKey: "UniqueUserId")
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        
        let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuController") as! MenuController
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        
        let nav = UINavigationController(rootViewController: menuVC)
        nav.isNavigationBarHidden = true
        
        let navigationController = UINavigationController(rootViewController: drawerController)
        
        let nav1 = UINavigationController(rootViewController: homeVC)
        nav1.isNavigationBarHidden = true
        
        self.drawerController.mainViewController = nav1
        self.drawerController.drawerViewController = nav
        navigationController.isNavigationBarHidden = true
        
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    
    func goToSignupController(isFrom:String){
        
        if isFrom == "signin"{
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllowLocationPresentController") as! AllowLocationPresentController
//            vc.objSignupOption = self
//            self.navigationController?.present(vc, animated: true, completion: nil)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarketingPopupController") as! MarketingPopupController
            vc.objSignupOption = self
            self.navigationController?.present(vc, animated: true, completion: nil)
            
            
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpController") as! SignUpController
            vc.isForSignup = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

        
    }
    
}
