//
//  CommonClass.swift
//  Aqar55
//
//  Created by Dacall soft on 08/04/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import KYDrawerController


class CommonClass{
    
    static let sharedInstance = CommonClass()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var drawerController = KYDrawerController.init(drawerDirection: .left, drawerWidth: 275)
    
    var chatScreenIsOpen = false
    
    private init() {}
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
        
    }
    
    func checkRegexForName(name:String)->Bool{
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
            if regex.firstMatch(in: name, options: [], range: NSMakeRange(0, name.characters.count)) != nil {
                return false
                
            } else {
                return true
            }
        }
        catch {
            return false
        }
    }
    
    
    func callNativeAlert(title:String,message:String,controller:UIViewController){
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    
    func setAsSkipInitial(){
        
        UserDefaults.standard.set(false, forKey: "ISLOGIN")
        
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
    
    
    func setHomeInitialForExpireToken(){
        
        UserDefaults.standard.set(false, forKey: "ISLOGIN")
        
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
    
    
    func redirectToLoginForExpiredToken(){
        
        UserDefaults.standard.set("", forKey: "UniqueUserId")
        
        UserDefaults.standard.set(false, forKey: "ISLOGIN")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignupOptionController") as! SignupOptionController
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
        print("Logout Tapped")
        
    }
    
}
